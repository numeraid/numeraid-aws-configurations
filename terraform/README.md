# Terraform — numeraid EKS (terraform/)

Short guide for working with the Terraform configuration that provisions the VPC, NAT/IGW, ALB and EKS cluster for `numeraid-dev`.

## Prerequisites

- AWS CLI configured with credentials and default region (e.g. `af-south-1`).
- Terraform installed (use version constraint in `versions.tf`).
- kubectl installed locally (or access via bastion) if you need to interact with the cluster.

## Quick commands

### Format and validate

```bash
terraform fmt --recursive
terraform validate
```

### Plan and save plan file

```bash
terraform plan -out=tfplan
```

### Apply saved plan

```bash
terraform apply "tfplan"
```

### Destroy everything

```bash
terraform destroy -auto-approve
```

### Kubeconfig

After applying, populate your kubeconfig for the created cluster:

```bash
aws eks update-kubeconfig --region af-south-1 --name numeraid-dev
```

If the cluster endpoint is private, `kubectl` run from your local workstation may time out. See the project documentation at `documentation/aws/terraform-eks-project.md` for access options (bastion, SSH tunnel, SSM port-forward, or enabling public endpoint).
