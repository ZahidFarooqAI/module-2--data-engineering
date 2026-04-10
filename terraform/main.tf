terraform {
  required_version = ">= 1.5.0"
}

locals {
  project_root = abspath("${path.module}/..")
  compose_file = "${local.project_root}/docker-compose.yml"
  env_file     = "${local.project_root}/.env"
  env_hash     = fileexists(local.env_file) ? filesha256(local.env_file) : "missing-env"
}

resource "terraform_data" "infrastructure" {
  input = {
    project_root         = local.project_root
    compose_project_name = var.compose_project_name
  }

  triggers_replace = {
    compose_hash    = filesha256(local.compose_file)
    dockerfile_hash = filesha256("${local.project_root}/docker/Dockerfile")
    env_hash        = local.env_hash
  }

  provisioner "local-exec" {
    command = "cd ${self.input.project_root} && docker compose -p ${lookup(self.input, "compose_project_name", "module-2--data-engineering")} up -d --build postgres pgadmin"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "cd ${self.input.project_root} && docker compose -p ${lookup(self.input, "compose_project_name", "module-2--data-engineering")} down"
  }
}

resource "terraform_data" "ingestion" {
  count = var.run_ingestion_on_apply ? 1 : 0

  triggers_replace = {
    infra_id       = terraform_data.infrastructure.id
    script_hash    = filesha256("${local.project_root}/ingestion/ingest_data.py")
    requirements   = filesha256("${local.project_root}/ingestion/requirements.txt")
    sample_data    = filesha256("${local.project_root}/data/raw/processed/sample_data.csv")
  }

  provisioner "local-exec" {
    command = "cd ${local.project_root} && docker compose -p ${var.compose_project_name} run --rm ingestion"
  }
}

output "postgres_host" {
  description = "Host for local PostgreSQL"
  value       = "localhost"
}

output "postgres_port" {
  description = "Port for local PostgreSQL"
  value       = 5432
}

output "pgadmin_url" {
  description = "pgAdmin UI URL"
  value       = "http://localhost:8080"
}
