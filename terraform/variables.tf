variable "run_ingestion_on_apply" {
  description = "Run ingestion container during terraform apply when source/data changes"
  type        = bool
  default     = true
}

variable "compose_project_name" {
  description = "Docker Compose project name used by Terraform local-exec commands"
  type        = string
  default     = "module-2--data-engineering"
}
