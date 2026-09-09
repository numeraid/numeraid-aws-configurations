# Numeraid AWS Terraform — EKS Project Documentation

**Overview**:

- **Purpose**: Deploy an AWS VPC, NAT/IGW, ALB, and an EKS cluster (`numeraid-dev`) for the `numeraid` project (dev environment).
- **Location**: Terraform code lives in the `terraform/` folder of the repository.

**Repository Structure**:

- **Root Terraform**: `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `terraform.tfvars`, `locals.tf`
- **Modules**: `modules/bastion`, `modules/compute`, `modules/eks`, `modules/ingress`, `modules/networking`, `modules/security`

**Quick Status (from run)**:

- Terraform validated and applied successfully.
- EKS cluster created: `numeraid-dev` (status: `ACTIVE`).
- ALB DNS: `numeraiddev-alb-1186937735.af-south-1.elb.amazonaws.com`
- VPC: `vpc-0c48126f3139b48e9` (CIDR `10.0.0.0/16`)
- Public subnets: `subnet-0c080fe5a01672f04`, `subnet-06758d2658698be16`
- Private subnets: `subnet-048088e4bd5073cbd`, `subnet-0349143f27353e0c8`

**Prerequisites**:

- AWS CLI configured with credentials and default region (e.g. `af-south-1`).
- Terraform installed (compatible version defined in `versions.tf`).
- `kubectl` (user installed with `snap install kubectl --classic`).
- Optional: SSH key / bastion access if cluster endpoint is private.

**Terraform workflow**:

- Format and validate:
  - `terraform fmt --recursive`
  - `terraform validate`
- Plan and save plan file:
  - `terraform plan -out=tfplan`
- Apply saved plan:
  - `terraform apply "tfplan"`
- To destroy everything:
  - `terraform destroy -auto-approve`

**Notable outputs** (examples from apply):

- `alb_dns_name` — public DNS name for the ALB.
- `alb_zone_id` — hosted zone ID for ALB.
- `cluster_name` — EKS cluster name (`numeraid-dev`).
- `vpc_id` / `vpc_cidr_block` — VPC details.
- `public_subnet_ids` / `private_subnet_ids` — subnet lists used for worker nodes, NATs, ALB.
- `nat_public_ip` / `nat_gateway_id` — NAT gateway details.

**Modules (high level)**:

- `bastion` — (optional) SSH bastion to access private resources.
- `compute` — EC2 instances / autoscaling groups if used outside managed node groups.
- `eks` — EKS control plane, node groups, OIDC provider, IAM roles, KMS encryption key.
- `ingress` — Application Load Balancer, listeners and target groups.
- `networking` — VPC, subnets, route tables, NAT gateways, internet gateway.
- `security` — Security groups, IAM-related fine-grained rules.

**Kubeconfig / kubectl**:

- Populate kubeconfig:
  - `aws eks update-kubeconfig --region af-south-1 --name numeraid-dev`
- Test:
  - `kubectl get nodes`

Common issue seen: `kubectl` I/O timeouts when the cluster endpoint is private.

**Troubleshooting — kubectl I/O timeout (observed)**:

- Symptom: `couldn't get current server API group list: Get "https://<endpoint>/api?timeout=32s": dial tcp <private-ip>:443: i/o timeout`
- Likely cause: EKS cluster API endpoint is private (cluster `vpc_config.endpoint_private_access = true` and `endpoint_public_access = false`), so your local machine cannot reach the control plane through the internet.

Options to access the cluster API:

- Use the bastion host inside the VPC:
  1. SSH to bastion (or use Session Manager).
  2. Run kubectl from the bastion (ensure `~/.kube/config` is present there or copy kubeconfig).
  3. Or create an SSH tunnel/port-forward to the API server:
     - `ssh -i ~/.ssh/id_rsa ec2-user@<bastion_public_ip> -L 6443:<cluster_endpoint_host>:443`
     - Then on your local machine: `KUBECONFIG=~/.kube/config kubectl --server=https://127.0.0.1:6443 get nodes`
- Enable a public endpoint (less secure):
  - Set `endpoint_public_access = true` in the EKS module and reapply (requires plan/apply and IAM/security review).
- Use AWS Systems Manager Session Manager port forwarding (if SSM agent and IAM permissions are configured).
- Ensure security groups allow control-plane communication from the bastion / caller IP.

**Next steps / recommendations**:

- Add a short README at repository root linking to this document and the `terraform/` folder.
- Add a short `README.md` inside `terraform/` with the minimal commands and prerequisites.
- Consider adding a small `Makefile` (or `scripts/`) to centralize `terraform` and `kubectl` commands.
- If you want, I can:
  - Create a `README.md` in `terraform/` linking to this file and adding quick commands.
  - Add a small diagram (Mermaid) showing VPC, subnets, ALB, EKS nodes.

**References**:

- Terraform module locations: see `terraform/modules/`.

---
