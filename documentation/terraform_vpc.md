# Initializing an AWS VPC Using Terraform

Infrastructure should be reproducible, version-controlled, and disposable. In this lab, we provisioned a basic AWS networking foundation using Terraform, verified the deployment, and then destroyed everything to validate Infrastructure as Code (IaC) principles.

## Objective

Provision the following AWS resources in the **af-south-1 (Cape Town)** region:

- VPC (`10.0.0.0/16`)
- Public Subnet (`10.0.1.0/24`)
- Internet Gateway
- Route Table
- Route Table Association

After successful deployment, we tore everything down using `terraform destroy` to ensure the infrastructure lifecycle is fully automated.

---

## Deployment Preview

Preview (note: autoplay may be blocked by some browsers):

<video src="./videos/terraform_vpc_aws.mp4" controls autoplay muted playsinline loop style="max-width:100%;height:auto;">
  Your browser does not support the video tag. Download: <a href="./videos/terraform_vpc_aws.mp4">terraform_vpc_aws.mp4</a>
</video>

If autoplay is blocked by your browser, open the video directly: [Watch Deployment Video](./videos/terraform_vpc_aws.mp4)

---

## Architecture Overview

The following infrastructure was provisioned by Terraform:

```text
                        Internet
                             │
                             │
                  ┌──────────▼──────────┐
                  │  Internet Gateway   │
                  │      (IGW)          │
                  └──────────┬──────────┘
                             │
                             │
                  ┌──────────▼──────────┐
                  │      Route Table    │
                  │    0.0.0.0/0 → IGW  │
                  └──────────┬──────────┘
                             │
                             │
                 ┌───────────▼───────────┐
                 │   Public Subnet       │
                 │     10.0.1.0/24       │
                 └───────────┬───────────┘
                             │
                             │
                 ┌───────────▼───────────┐
                 │         VPC           │
                 │     10.0.0.0/16       │
                 └───────────────────────┘
```

---

## Deploying the Infrastructure

From the Terraform project directory:

```bash
cd ~/numeraid/numeraid-aws-configurations/terraform

terraform apply
```

Terraform generated the following execution plan:

```text
Plan: 5 to add, 0 to change, 0 to destroy.
```

### Resources to be created

| Resource | Purpose |
| ----------- | ---------- |
| VPC | Isolated network boundary |
| Subnet | Network segment for workload placement |
| Internet Gateway | Provides internet connectivity |
| Route Table | Controls traffic routing |
| Route Table Association | Attaches subnet to routing table |

---

## Execution

Terraform created the infrastructure in dependency order:

```text
VPC
 ├── Internet Gateway
 ├── Subnet
 ├── Route Table
 └── Route Table Association
```

Deployment completed successfully:

```text
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

### Outputs

```text
nat_eip_id = "eipalloc-0e7d95dc5cc58b426"
nat_gateway_id = "nat-0da70d7bec7ec876e"
private_subnet_id = "subnet-03acbee65e2de8229"
public_subnet_id = "subnet-078d0269f85ba4de3"
security_group_id = "sg-0b35bf43fa418592c"
vpc_id = "vpc-099a9dabb8cbd28c7"
```

### AWS Resources Created

| Resource Type | Resource ID |
| -------------- | ------------- |
| VPC | vpc-0f2c08d95352eefc2 |
| Internet Gateway | igw-095b6edadcafb66b5 |
| Route Table | rtb-0f3d77096d5e50c9d |
| Subnet | subnet-0993b303bd3de511e |
| Route Table Association | rtbassoc-0f03ef3cbdbfa7c7b |

---

Current network allocation:

```text
VPC CIDR
└── 10.0.0.0/16

    Public Subnet
    └── 10.0.1.0/24
```

Because `map_public_ip_on_launch = true`, any EC2 instance launched in this subnet would automatically receive a public IP address.

---

## Lessons Learned

### VPC

Provides network isolation in AWS.

```text
10.0.0.0/16
```

Supports:

```text
65,536 IP addresses
```

### Public Subnet

Created within:

```text
af-south-1a
```

CIDR:

```text
10.0.1.0/24
```

Supports approximately:

```text
251 usable IP addresses
```

(AWS reserves 5 addresses per subnet.)

---

### Internet Gateway

Acts as the bridge between AWS resources and the public internet.

Without the IGW:

```text
Internet - no connectivity
Outbound Traffic - blocked
Inbound Traffic - blocked
```

---

### Route Table

Defined the route:

```text
0.0.0.0/0 → Internet Gateway
```

Meaning:

```text
Any unknown destination
→ Send traffic to the Internet Gateway
```

---

## The True IaC Test

The value of Infrastructure as Code is proving that:

- Infrastructure can be created repeatedly
- Infrastructure can be version controlled
- Infrastructure can be destroyed safely
- Infrastructure leaves no manual dependencies behind

---

## Destroying the infrastructure

To remove everything:

```bash
terraform destroy
```

Terraform generated the following destruction plan:

```text
Plan: 0 to add, 0 to change, 5 to destroy.
```

Resources scheduled for deletion:

```text
- Route Table Association
- Route Table
- Subnet
- Internet Gateway
- VPC
```

Terraform automatically calculated dependencies and removed resources in the correct order.

### Destruction Flow

```text
Route Table Association
           │
           ▼
      Route Table
           │
           ▼
        Subnet
           │
           ▼
  Internet Gateway
           │
           ▼
          VPC
```

---

## Destroy Completed

Terraform successfully removed all infrastructure.

```text
Destroy complete! Resources: 5 destroyed.
```

Infrastructure state after destruction:

```text
VPC - Deleted
Subnet - Deleted
Route Table - Deleted
Internet Gateway - Deleted
Associations - Deleted
```

AWS Monthly Cost:

```text
R0.00
```

---

## Conclusion

This exercise demonstrated the complete lifecycle of Infrastructure as Code using Terraform and AWS.

We successfully:

1. Created a VPC
2. Created a Public Subnet
3. Attached an Internet Gateway
4. Configured Routing
5. Validated Outputs
6. Destroyed All Resources

Create. Validate. Destroy. Repeat.

**Terraform completed.**
