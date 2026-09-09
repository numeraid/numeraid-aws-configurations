# Numeraid AWS Kubernetes Infrastructure Lab

## Overview

This project documents the design, deployment, validation, and troubleshooting of a Kubernetes-ready AWS environment provisioned entirely using Terraform.

The environment was built using a production-style network architecture with:

- Custom VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- NAT Gateway
- Security Groups
- Bastion Host
- Control Plane Node
- Worker Node

The primary objective was to learn and validate AWS networking concepts, Terraform infrastructure automation, secure access patterns, and Kubernetes prerequisites before cluster bootstrapping.

---

## Architecture

```text
                    Internet
                        │
                        │
                ┌───────▼───────┐
                │ Internet GW   │
                └───────┬───────┘
                        │
        ┌───────────────┴────────────────┐
        │                                │
        ▼                                ▼

 Public Subnet                  Private Subnet
 10.0.1.0/24                     10.0.2.0/24

┌──────────────┐             ┌─────────────────┐
│ Bastion Host │───────────▶│ Control Plane   │
│ 10.0.1.124   │     SSH     │ 10.0.2.222      │
└──────────────┘             └─────────────────┘
                                      │
                                      │
                                      ▼

                             ┌─────────────────┐
                             │ Worker Node     │
                             │ 10.0.2.141      │
                             └─────────────────┘

                                      │
                                      ▼

                               NAT Gateway
                              13.247.252.63

                                      │
                                      ▼

                                  Internet
```

---

# Infrastructure Components

## Networking

### VPC

```text
vpc-035f8be80fb9f0c49
CIDR: 10.0.0.0/16
```

### Public Subnet

```text
subnet-0fdff04d8e8bc139e
CIDR: 10.0.1.0/24
```

Used for:

- Bastion Host
- NAT Gateway

### Private Subnet

```text
subnet-040cbec1a4d634f45
CIDR: 10.0.2.0/24
```

Used for:

- Kubernetes Control Plane
- Kubernetes Worker Node

### Internet Gateway

```text
igw-01a811bb25c636936
```

Provides Internet access to the public subnet.

### NAT Gateway

```text
nat-01cc6ba8ce54dfd15
Public IP: 13.247.252.63
```

Allows instances in private subnets to reach the Internet without exposing them publicly.

---

# Compute Resources

## Bastion Host

```text
Instance Type: t3.micro

Subnet:
10.0.1.0/24

Private IP:
10.0.1.124
```

Purpose:

- Secure SSH entry point into the environment
- Access gateway into private Kubernetes nodes

---

## Kubernetes Control Plane

```text
Instance Type: t3.small

Private IP:
10.0.2.222
```

Purpose:

- Run Kubernetes control plane components
- Host Kubernetes API Server

---

## Kubernetes Worker

```text
Instance Type: t3.small

Private IP:
10.0.2.141
```

Purpose:

- Run application workloads
- Join Kubernetes cluster

---

# Security Design

## Bastion Security Group

Allowed:

```text
TCP 22 (SSH)
Source: 0.0.0.0/0
```

Outbound:

```text
All Traffic
```

---

## Kubernetes Security Group

Allowed:

```text
TCP 6443
Kubernetes API Server

TCP 443
HTTPS

TCP 80
HTTP

TCP 22
Source: Bastion Security Group
```

Outbound:

```text
All Traffic
```

### Security Improvement

Instead of allowing:

```text
Internet → Kubernetes Nodes
```

SSH access was restricted to:

```text
Bastion Host → Kubernetes Nodes
```

This follows a more secure production-like design.

---

# Terraform Deployment

## Planning

```bash
terraform plan -out=tfplan
```

## Apply

```bash
terraform apply tfplan
```

Provisioned:

- VPC
- Subnets
- Security Groups
- EC2 Instances
- NAT Gateway
- Internet Gateway
- Route Tables
- SSH Key Pair

---

# NAT Gateway Learning

Initially, the assumption was that a NAT Gateway could be used to connect to private servers.

This was incorrect.

A NAT Gateway only allows:

```text
Private Instance
        │
        ▼
    Internet
```

Examples:

```bash
apt update
docker pull
curl google.com
```

A NAT Gateway does NOT support:

```text
Laptop
   │
   ▼
Internet
   │
   ▼
NAT Gateway
   │
   ▼
Private EC2
```

For inbound administration access, a Bastion Host or AWS Systems Manager is required.

---

# Bastion Host Deployment

A dedicated Bastion Host module was created.

Purpose:

```text
Internet
    │
    ▼
 Bastion
    │
    ▼
 Private Nodes
```

Deployment:

```bash
terraform apply
```

Result:

```text
Bastion EC2 created successfully
```

---

# SSH Troubleshooting

## Initial Attempt

Connected to Bastion:

```bash
ssh -i numeraid.pem ubuntu@<bastion-public-ip>
```

Attempted:

```bash
ssh -i numeraid.pem ubuntu@10.0.2.222
```

Result:

```text
Connection timed out
```

---

## Root Cause

A previous Terraform change removed:

```text
SSH Access
Port 22
```

from the Kubernetes Security Group.

---

## Fix

Added a new Terraform rule:

```text
Source:
Bastion Security Group

Destination:
Kubernetes Security Group

Port:
22/TCP
```

Applied:

```bash
terraform apply
```

---

## Successful SSH

Connected successfully:

```bash
ssh -i numeraid.pem ubuntu@10.0.2.222
```

Verified access to the Control Plane through the Bastion Host.

---

# Connectivity Validation

## Verify NAT Routing

Executed:

```bash
curl ifconfig.me
```

Output:

```text
13.247.252.63
```

Matched:

```text
NAT Gateway Public IP
13.247.252.63
```

Result:

Private subnet Internet access confirmed.

---

## Verify Internet Reachability

Executed:

```bash
ping -c 4 google.com
```

Result:

```text
4 packets transmitted
4 packets received
0% packet loss
```

Validated:

- DNS Resolution
- Outbound Routing
- NAT Functionality

---

# Operating System Preparation

Updated Ubuntu packages:

```bash
sudo apt update
sudo apt upgrade
```

Successfully upgraded system packages and dependencies.

---

# Container Runtime Installation

Installed Containerd:

```bash
sudo apt install containerd
```

Installed packages:

```text
containerd
runc
```

Validated:

```bash
sudo systemctl status containerd
```

Result:

```text
active (running)
```

---

# Configuration Issue Encountered

Attempted:

```bash
containerd config default | sudo tee /etc/
```

Result:

```text
tee: /etc/: Is a directory
```

Root Cause:

Configuration file path was omitted.

Correct command:

```bash
containerd config default | sudo tee /etc/containerd/config.toml
```

---

# Kubernetes Host Preparation

## Disable Swap

```bash
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

Verification:

```bash
free -h
```

Output:

```text
Swap: 0B
```

Required for Kubernetes.

---

## Load Kernel Modules

Created:

```bash
/etc/modules-load.d/k8s.conf
```

Contents:

```text
overlay
br_netfilter
```

Loaded:

```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

---

# Progress Achieved

## Infrastructure

- [x] Terraform Project Structure
- [x] VPC
- [x] Public Subnet
- [x] Private Subnet
- [x] Route Tables
- [x] Internet Gateway
- [x] NAT Gateway
- [x] Security Groups
- [x] SSH Key Pair
- [x] Bastion Host
- [x] Control Plane Node
- [x] Worker Node

## Access

- [x] SSH to Bastion
- [x] SSH from Bastion to Control Plane
- [x] Private Network Validation

## Connectivity

- [x] Internet Access from Private Subnet
- [x] DNS Resolution
- [x] NAT Gateway Validation

## Kubernetes Preparation

- [x] Ubuntu Updated
- [x] Containerd Installed
- [x] Swap Disabled
- [x] Kernel Modules Prepared

---

# Planned Next Steps

## Kubernetes Installation

Install:

```bash
kubelet
kubeadm
kubectl
```

---

## Cluster Bootstrap

Initialize:

```bash
kubeadm init
```

---

## Join Worker Node

Execute:

```bash
kubeadm join
```

using the join command generated during cluster initialization.

---

## Install CNI

Deploy:

```text
Calico
```

to provide pod networking.

---

## Install ArgoCD

Deploy:

```text
ArgoCD
```

for GitOps-based Kubernetes application delivery.

---

# Terraform Destroy Exercise

As part of learning infrastructure lifecycle management, a full Terraform destroy was executed.

Command:

```bash
terraform destroy
```

Terraform successfully removed:

- Bastion Host
- Control Plane
- Worker Node
- Security Groups
- NAT Gateway
- Elastic IP
- Route Tables
- Internet Gateway
- Subnets
- VPC
- Key Pair

Observed event:

```text
Broadcast message from root:

The system will power off now!
```

This immediately terminated active SSH sessions because the Bastion Host itself was destroyed.

---

# Key Lessons Learned

## NAT Gateways

NAT Gateways provide:

```text
Private Subnet → Internet
```

They do not provide:

```text
Internet → Private Subnet
```

---

## Bastion Hosts

Private infrastructure requires a secure entry point.

Typical options:

```text
Bastion Host
AWS Systems Manager Session Manager
```

---

## Security Groups

The correct model is:

```text
Laptop
    │
    ▼
Bastion SG
    │
    ▼
Kubernetes SG
```

instead of exposing Kubernetes nodes directly to the Internet.

---

## Terraform Discipline

Always verify:

```bash
terraform plan
```

before running:

```bash
terraform apply
```

or:

```bash
terraform destroy
```

Terraform executes exactly what is shown in the plan.

---

# Outcome

This exercise successfully validated:

- Infrastructure as Code with Terraform
- AWS Networking Fundamentals
- Public and Private Subnet Design
- NAT Gateway Routing
- Bastion Host Access Patterns
- Security Group Architecture
- EC2 Administration
- Kubernetes Node Preparation

The environment is now fully understood and ready for the next phase:

```text
Kubernetes Cluster Bootstrap
→ Install kubeadm
→ Initialize cluster
→ Join worker node
→ Install Calico
→ Deploy ArgoCD
```
