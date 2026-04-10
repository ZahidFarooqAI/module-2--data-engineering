ARG TERRAFORM_VERSION=1.8.5
FROM hashicorp/terraform:${TERRAFORM_VERSION}

RUN apk add --no-cache docker-cli docker-cli-compose
