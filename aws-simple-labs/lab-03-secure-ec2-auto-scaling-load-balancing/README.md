# Lab 03: Secure EC2 Auto Scaling + Load Balancing

## Objective

Build a highly available web application using an Application Load Balancer and an Auto Scaling Group. Configure EC2 instances using User Data so that they bootstrap automatically without manual intervention.

---

## Architecture

![ec2-asg-alb](./assets/EC2%20Auto%20Scaling%20+%20ALB.drawio.png)
---

## AWS Services Used

* VPC
* Public Subnets
* Internet Gateway
* Route Tables
* Security Groups
* EC2
* Launch Templates
* User Data
* Application Load Balancer (ALB)
* Target Groups
* Auto Scaling Groups (ASG)

---

## Task 1: Create the Network

### VPC

* Name: `lab-vpc`
* CIDR: `10.0.0.0/16`

### Public Subnet A

* Name: `public-subnet-a`
* AZ: `us-east-1a`
* CIDR: `10.0.1.0/24`

### Public Subnet B

* Name: `public-subnet-b`
* AZ: `us-east-1b`
* CIDR: `10.0.2.0/24`

---

## Task 2: Internet Gateway & Route Tables

### Internet Gateway

* Name: `lab-igw`
* Attached to: `lab-vpc`

### Public Route Table

* Name: `public-rt`

### Associated Subnets

* `public-subnet-a`
* `public-subnet-b`

### Route

* `0.0.0.0/0 → lab-igw`

---

## Task 3: Security Groups

### ALB Security Group (`alb-sg`)

#### Inbound

* HTTP (80) → `0.0.0.0/0`

#### Outbound

* All Traffic

---

### EC2 Security Group (`web-sg`)

#### Inbound

* HTTP (80) → `alb-sg`

#### Outbound

* All Traffic

---

## Task 4: Launch Template

### Launch Template

* Name: `web-launch-template`
* Version: `v1`
* AMI: `Amazon Linux 2023`
* Instance Type: `t3.micro`
* Security Group: `web-sg`
* Key Pair: None

### User Data

```bash
#!/bin/bash

# Update installed packages
dnf update -y

# Install Apache
dnf install -y httpd

# Start Apache automatically on boot
systemctl enable httpd

# Start Apache immediately
systemctl start httpd

# Get hostname of the instance
HOSTNAME=$(hostname)

# Create web page
echo "<h1>Hello from Auto Scaling</h1><p>${HOSTNAME}</p>" > /var/www/html/index.html
```

---

## Task 5: Target Group

### Configuration

* Target Type: `Instances`
* Name: `web-tg`
* Protocol: `HTTP`
* Port: `80`
* VPC: `lab-vpc`

### Health Checks

* Protocol: HTTP
* Path: `/`
* Port: Traffic port
* Success Codes: `200`
* Healthy Threshold: `2`
* Unhealthy Threshold: `5`
* Timeout: `5 seconds`
* Interval: `30 seconds`

### Targets

* No instances registered manually

---

## Task 6: Application Load Balancer

### Configuration

* Name: `web-alb`
* Type: `Application Load Balancer`
* Scheme: `Internet-facing`
* IP Type: `IPv4`

### Subnets

* `public-subnet-a`
* `public-subnet-b`

### Security Group

* `alb-sg`

### Listener

* HTTP : 80

### Default Action

* Forward to `web-tg`

---

## Task 7: Auto Scaling Group

### Configuration

* Name: `web-asg`
* Launch Template: `web-launch-template`
* Launch Template Version: Latest

### Network

* VPC: `lab-vpc`
* Subnets:

  * `public-subnet-a`
  * `public-subnet-b`

### Load Balancing

* Attached to existing Target Group: `web-tg`

### Health Checks

* Type: `ELB`
* Grace Period: `300 seconds`

### Capacity

#### Initial Troubleshooting

* Desired: `1`
* Minimum: `1`
* Maximum: `2`

#### Final Configuration

* Desired: `2`
* Minimum: `2`
* Maximum: `4`

---

## Verification

### Verified User Data

* Apache installed automatically.
* Apache started automatically.
* Custom web page created automatically.

### Verified ALB

* ALB DNS accessible through browser.
* Application returned HTTP 200.

### Verified Load Balancing

Refreshing the ALB DNS showed requests being served by different instances.

Example:

```text
Hello from Auto Scaling
ip-10-0-1-xxx.ec2.internal

Refresh

Hello from Auto Scaling
ip-10-0-2-xxx.ec2.internal
```

### Verified High Availability

* Multiple healthy targets across different Availability Zones.

---

## Troubleshooting

### Issue 1: Targets Became Unhealthy

#### Symptoms

```text
Target Group → Unhealthy
ASG continuously replaced instances
```

#### Investigation

Checked:

* Target Group health status
* EC2 instance status
* User Data
* Launch Template
* Security Groups

#### Resolution

* Simplified User Data.
* Updated Launch Template with a new version.
* Updated ASG to use the latest Launch Template version.
* Reduced Desired Capacity to 1 for troubleshooting.
* Enabled public IP assignment for troubleshooting.
* Allowed new instances to register successfully.

#### Outcome

```text
Targets → Healthy
```

---

### Issue 2: ASG Replacement Loop

#### Symptoms

```text
EC2 instances terminated automatically.
New instances launched repeatedly.
```

#### Root Cause

ASG was using ELB Health Checks.

Unhealthy instances were automatically replaced.

#### Resolution

* Stabilized the environment by reducing capacity.
* Fixed the unhealthy target issue.
* Increased capacity again after validation.

---

## Key Learnings

* Launch Templates standardize EC2 configurations.
* User Data enables automatic server bootstrapping.
* Application Load Balancers distribute traffic across healthy targets.
* Target Groups determine where ALB forwards requests.
* Health Checks directly influence target health.
* Auto Scaling Groups automatically maintain desired capacity.
* ASG can terminate and replace unhealthy instances without manual intervention.
* Security Groups should follow the principle of least privilege.
* Troubleshooting should be evidence-driven rather than assumption-driven.
* Simplifying the environment is an effective way to isolate production issues.
* High availability is achieved through Multi-AZ deployments.

---

## Status

* ✅ Lab Completed
* ✅ Load Balancing Verified
* ✅ Auto Scaling Verified
* ✅ High Availability Verified
* ✅ Real Troubleshooting Experience Gained
