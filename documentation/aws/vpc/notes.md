# Amazon VPC 🕸️

## 1) What is a VPC?

A VPC is your own private network inside AWS.

- Definition: A virtual network that lives inside AWS.
- Function: It holds your EC2 instances, RDS databases, load balancers, and other services.
- Why it matters: It gives you control over IP ranges, subnets, route tables, and security.
- Cost: Creating a VPC itself is usually free.

Think of it like:

- Your home = AWS account
- Your walls and rooms = VPC
- Different rooms = subnets

---

## 2) Subnet

A subnet is a smaller section inside a VPC.

- Definition: A range of IP addresses inside your VPC.
- Function: It decides where resources live.
- Important rule: A subnet sits in only one Availability Zone (AZ).
- Cost: Usually no extra charge just for the subnet itself.

Example:

- VPC: 10.0.0.0/16
- Public subnet: 10.0.1.0/24
- Private subnet: 10.0.2.0/24

---

## 3) Public subnet vs Private subnet

### Public subnet

- Definition: A subnet with internet access.
- Function: Hosts web servers or load balancers that must be reached from the internet.
- Needs: Internet Gateway and public IP.
- Cost: Public IPs can cost money.

### Private subnet

- Definition: A subnet without direct internet access.
- Function: Hosts databases, app servers, or backend services.
- Needs: No direct public route.
- Cost: Usually cheaper, but NAT gateway may add cost.

---

## 4) Internet Gateway (IGW)

- Definition: A door between your VPC and the internet.
- Function: Lets internet traffic reach public resources in your VPC.
- Cost: Charged based on usage and hourly cost.

Simple idea:

Internet -> Internet Gateway -> Public subnet -> EC2

---

## 5) NAT Gateway

- Definition: A gateway for private resources to reach the internet without exposing themselves to the internet.
- Function: Private instances can download updates, connect to package repos, or talk to the internet in a controlled way.
- Cost: Hourly charge + data processing charge.

Use this when:

- App servers are in a private subnet
- They need outbound internet access
- You do not want inbound internet traffic

---

## 6) Route Table

- Definition: A set of rules telling traffic where to go.
- Function: It decides if traffic should go to the internet, a NAT gateway, or another network.
- Cost: Usually no direct charge.

Example:

- Route to local VPC network = local
- Route to internet = Internet Gateway
- Route to private internet access = NAT Gateway

---

## 7) Availability Zone (AZ)

- Definition: One isolated data center inside an AWS Region.
- Function: Spreads your app across different physical locations for better availability.
- Cost: Running resources in multiple AZs costs more, but improves resilience.

Good pattern:

- One AZ = cheaper, less resilient
- Two AZs = safer for production

---

## 8) CIDR

- Definition: The IP address range for a VPC or subnet.
- Function: Tells AWS which IP addresses belong to your network.
- Example: 10.0.0.0/16 or 172.31.0.0/16
- Cost: No direct cost.

Important:

- Do not overlap with your on-premises network.
- Do not overlap between VPCs if they need to connect.

---

## 9) Security Group

- Definition: A virtual firewall for EC2 instances.
- Function: Allows or blocks traffic to your instance.
- Behavior: Statefull.
- Cost: No separate charge for basic use.

Simple rule:

- Security Group = instance-level security

---

## 10) Network ACL (NACL)

- Definition: A firewall for subnets.
- Function: Controls traffic entering or leaving a subnet.
- Behavior: Stateless.
- Cost: Usually no extra charge.

Simple rule:

- NACL = subnet-level security

---

## 11) VPN and Direct Connect

### VPN

- Definition: Secure connection between your office network and AWS.
- Function: Private communication through the internet.
- Cost: Based on connection and data usage.

### Direct Connect

- Definition: Dedicated private connection to AWS.
- Function: More stable and faster than a normal VPN.
- Cost: Dedicated connection cost applies.

---

## 12) VPC Endpoints

- Definition: Private connection to AWS services without using the internet.
- Function: Lets your private resources talk to AWS services like S3 and DynamoDB privately.
- Cost: Small hourly and data charges may apply.

Use when:

- You want private communication
- You want to avoid NAT or public IPs

---

## 13) Quick visual map

```text
Internet
   |
   v
Internet Gateway
   |
   v
   VPC
   / \
 Public   Private
 Subnet   Subnet
   |        |
 EC2      RDS / App
   |        |
   v        v
Security  Security
Group     Group
```

---

## 14) Simple cost summary

VPC itself = usually free

Paid things often include:

- NAT Gateway
- Elastic IPs
- Public IPv4 addresses
- VPN / Direct Connect
- VPC Endpoints
- Some monitoring and analysis tools

Private IPv4 = usually free
Public IPv4 = often charged

---
