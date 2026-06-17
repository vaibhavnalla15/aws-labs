# Lab 01: Single EC2 Instance in a Private Subnet with Bastion Host

## Objective

Deploy an EC2 instance in a private subnet and securely access it using a Bastion Host located in a public subnet.

---
## Architecture Diagram
![Bastion Host](./assets/Private%20Subnet%20with%20Bastion%20Host.drawio.png        )
---
## AWS Services Used

- VPC
- Subnets
- Internet Gateway
- Route Tables
- Security Groups
- EC2
- Key Pairs

---
## Architecture

Internet
↓
Bastion Host (Public Subnet)
↓
Private EC2 Instance (Private Subnet)

---
## What I'll Learn

- Difference between public and private subnets
- Why private instances cannot be accessed directly
- How Bastion Hosts work
- Security Group design
- SSH hopping into private instances

---
## Task 1: Create the Network

### VPC

* Name: `lab-vpc`
* CIDR: `10.0.0.0/16`

### Public Subnet

* Name: `public-subnet`
* CIDR: `10.0.1.0/24`

### Private Subnet

* Name: `private-subnet`
* CIDR: `10.0.2.0/24`

---
## Task 2: Internet Gateway & Route Tables

### Internet Gateway

* Name: `lab-igw`
* Attached To: `lab-vpc`

### Public Route Table

* Name: `public-rt`
* Associated Subnet: `public-subnet`
* Route:

  * Destination: `0.0.0.0/0`
  * Target: `lab-igw`

### Private Route Table

* Name: `private-rt`
* Associated Subnet: `private-subnet`
* Route:

  * No internet route configured

---
## Task 3: Launch Bastion Host

### EC2 Instance

* Name: `bastion-host`
* AMI: `Amazon Linux 2023`
* Instance Type: `t2.micro`
* Subnet: `public-subnet`
* Auto-assign Public IP: `Enabled`
* Key Pair: `<your-keypair>`

### Security Group

* Name: `bastion-sg`
* Inbound:

  * SSH (22) → My IP
* Outbound:

  * All Traffic

---
## Task 4: Launch Private EC2 Instance

### EC2 Instance

* Name: `private-ec2`
* AMI: `Amazon Linux 2023`
* Instance Type: `t2.micro`
* Subnet: `private-subnet`
* Auto-assign Public IP: `Disabled`
* Key Pair: `<same-keypair-as-bastion>`

### Security Group

* Name: `private-ec2-sg`
* Inbound:

  * SSH (22) → `bastion-sg`
* Outbound:

  * All Traffic

---
## Task 5: SSH via Bastion Host
- Connected to Bastion Host using SSH.
- Copied the PEM key to the Bastion Host.
- Connected to the Private EC2 using its private IP.

### Copy Key to Bastion Host from Laptop

```bash id="z3shqm"
scp -i <key-pair>.pem <key-pair>.pem ec2-user@<bastion-public-dns>:~
```

### SSH to Bastion Host

```bash id="pw2d5r"
ssh -i <key-pair>.pem ec2-user@<bastion-public-dns>
```

### SSH to Private EC2 (from Bastion Host)

```bash id="v24v8v"
ssh -i <key-pair>.pem ec2-user@<private-ec2-private-ip>
```
---
## Task 6: Verification
- Verified Bastion → Private EC2 access.
- Verified Private EC2 is not directly accessible from the internet.
---

## Result

- Bastion Host deployed in a public subnet
- Private EC2 deployed in a private subnet
- Successful SSH access to the private instance through the Bastion Host

---
## Key Learnings

* Public subnets provide internet access through an Internet Gateway.
* Private subnets do not require public IP addresses.
* Bastion Hosts provide secure administrative access to private instances.
* Security Groups can reference other Security Groups instead of IP addresses.
* Private EC2 instances can be accessed using SSH through a Bastion Host.
* Network design determines how resources communicate within a VPC.

---
## Cleanup

- Delete EC2 instances
- Delete Security Groups
- Delete Route Tables
- Detach and delete Internet Gateway
- Delete Subnets
- Delete VPC