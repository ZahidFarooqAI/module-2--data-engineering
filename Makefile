TERRAFORM_VERSION ?= 1.8.5
TF_RUNNER_IMAGE := local/terraform-runner:$(TERRAFORM_VERSION)
TF_WORKDIR := /workspace/terraform
TF_DOCKER := docker run --rm -e TF_VAR_compose_project_name=$(notdir $(CURDIR)) -v /var/run/docker.sock:/var/run/docker.sock -v "$(CURDIR):/workspace" -w $(TF_WORKDIR) $(TF_RUNNER_IMAGE)

.PHONY: tf-help tf-image tf-init tf-plan tf-apply tf-destroy tf-fmt

tf-help:
	@echo "Terraform (Docker) shortcuts:"
	@echo "  make tf-image     # build terraform runner image"
	@echo "  make tf-init      # terraform init"
	@echo "  make tf-plan      # terraform plan"
	@echo "  make tf-apply     # terraform apply"
	@echo "  make tf-destroy   # terraform destroy"
	@echo "  make tf-fmt       # terraform fmt"
	@echo "  make TERRAFORM_VERSION=1.9.0 tf-init"

tf-image:
	docker build --build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) -f docker/terraform-runner.Dockerfile -t $(TF_RUNNER_IMAGE) .

tf-init: tf-image
	$(TF_DOCKER) init

tf-plan: tf-image
	$(TF_DOCKER) plan -input=false

tf-apply: tf-image
	$(TF_DOCKER) apply -input=false -auto-approve

tf-destroy: tf-image
	$(TF_DOCKER) destroy -input=false -auto-approve

tf-fmt: tf-image
	$(TF_DOCKER) fmt
