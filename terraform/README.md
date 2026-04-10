# Local Terraform Integration (No AWS Required)

This Terraform setup orchestrates your existing local Docker pipeline:
- Starts `postgres` and `pgadmin` using `docker compose`
- Optionally runs `ingestion` during `terraform apply`

## Prerequisites

- Docker + Docker Compose
- Terraform CLI (>= 1.5)

## Usage

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform apply
```

Or from project root (recommended):

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
make tf-init
make tf-apply
```

Note:
- `make` commands run Terraform inside Docker.
- The Compose project name is auto-set from your repo folder name to avoid container name conflicts.

What happens on apply:
- `postgres` and `pgadmin` are started/rebuilt
- `ingestion` runs once (if `run_ingestion_on_apply = true`)

## Access

- PostgreSQL: `localhost:5432`
- pgAdmin: `http://localhost:8080`

## Re-run ingestion manually

From project root:

```bash
docker compose run --rm ingestion
```

Or from `terraform/` force Terraform to re-run ingestion resource:

```bash
terraform apply -replace=terraform_data.ingestion
```

## Stop everything

```bash
terraform destroy
```

Or:

```bash
make tf-destroy
```
