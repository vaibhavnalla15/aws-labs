# Lab 02: Single EC2 Instance in a Private Subnet + Bastion Host + NAT Gateway

## Objective
Deploy a private EC2 instance that can securely receive administrative access through a Bastion Host and initiate outbound internet access using a NAT Gateway.

---

## Architecture Diagram
![Bastion Host](./assets/Bastion%20Host%20-%20NAT%20Gateway.drawio.png)
---

## AWS Services Used

- VPC
- Subnets
- Internet Gateway
- Route Tables
- NAT Gateway
- Elastic IP
- Security Groups
- EC2
- Key Pairs

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
* Instance Type: `t3.micro`
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
* Instance Type: `t3.micro`
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

## Task 5: Create Elastic IP
### Elastic IP

* Purpose: NAT Gateway
* Allocation: Amazon Pool

## Task 6: Create NAT Gateway

### NAT Gateway

* Name: `lab-nat-gateway`
* Subnet: `public-subnet`
* Connectivity Type: `Public`
* Elastic IP: Previously allocated EIP

## Task 7: Update Private Route Table

### Private Route Table

* Name: `private-rt`
* Route Added:

  * Destination: `0.0.0.0/0`
  * Target: `lab-nat-gateway`

## Task 8: Verify Internet Access

### SSH Commands

#### SSH to Bastion Host

```bash
ssh -i <key-pair>.pem ec2-user@<bastion-public-dns>
```

#### SSH to Private EC2

```bash
ssh -i <key-pair>.pem ec2-user@<private-ec2-private-ip>
```

### Verification Commands

```bash
curl https://checkip.amazonaws.com
sudo dnf update -y
```

### Verification Result

* Confirmed outbound internet access from the private EC2.
* Verified that `curl` returned the NAT Gateway Elastic IP.
* Successfully ran package updates.
* Private EC2 remained inaccessible directly from the internet.

## Status

* ✅ Existing Infrastructure Reused
* ✅ Task 1: Create Elastic IP
* ✅ Task 2: Create NAT Gateway
* ✅ Task 3: Update Private Route Table
* ✅ Task 4: Verify Internet Access

### Lab Status

* ✅ Lab Completed

## Key Learnings

* NAT Gateway provides outbound internet access to resources in private subnets.
* Private EC2 instances do not require public IP addresses to access the internet.
* The NAT Gateway must reside in a public subnet and use an Elastic IP.
* Private route tables direct internet-bound traffic (`0.0.0.0/0`) to the NAT Gateway.
* Bastion Hosts provide secure administrative access to private instances.
* Private resources remain inaccessible directly from the internet while still supporting outbound connectivity.