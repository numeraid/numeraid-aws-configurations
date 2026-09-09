# numeraid-aws-configurations

## Repository purpose

This repository contains Terraform configurations and modules used to provision the AWS infrastructure for the `numeraid` project. The main Terraform workspace is in the `terraform/` directory and includes modules for networking, EKS, ingress (ALB), security and compute.

## Quick links

- Terraform root and execution: `terraform/` — see `terraform/README.md` for commands and kubeconfig notes.
- Detailed project notes: `documentation/aws/terraform-eks-project.md`

## Getting started

1. Install and configure the AWS CLI.
2. Install Terraform and confirm the version in `terraform/versions.tf`.
3. Change into the Terraform directory and run the usual workflow:

    ```bash
    cd terraform
    terraform fmt --recursive
    terraform validate
    terraform plan -out=tfplan
    terraform apply "tfplan"
    ```

4. Populate kubeconfig and use `kubectl` (see `terraform/README.md`).
