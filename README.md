# AWS Labs: A Portfolio of Hands-On Cloud Projects ☁️

Welcome to my **AWS Labs Repository**!

This repository contains a collection of hands-on AWS projects designed to build strong practical skills in Cloud Computing. The labs progress from foundational AWS concepts to more advanced real-world architectures, following a learn-by-doing approach.

The primary goal of this repository is to develop practical experience with AWS core services, troubleshooting, security, networking, automation, and serverless technologies.

---

# Repository Structure

```text
aws-labs/
├── level-100/
├── level-200/
├── level-300/
└── README.md
```

---

# Project Levels

The labs are organized into multiple levels based on complexity and real-world relevance.

## Level 100 (Foundational)

Focuses on AWS core services and fundamental cloud concepts.

Topics include:

* AWS Networking
* EC2
* IAM
* S3
* CloudFront
* EBS
* RDS
* Auto Scaling
* Load Balancing
* Lambda
* API Gateway
* CloudWatch

---


# Level 100 Labs (Foundational AWS Projects)

This section contains beginner-friendly labs designed to build a strong foundation in AWS core services.

---

## Lab 01: Single Private EC2 with Bastion Host

**Description:** Deploy a private EC2 instance inside a private subnet and securely access it using a Bastion Host.

**Services Used:**

* Amazon VPC
* Amazon EC2
* Security Groups

**Concepts Covered:**

* Public and Private Subnets
* Bastion Host Architecture
* Secure SSH Access
* VPC Networking

**Link:** [Lab 01](level-100/lab-01-single-private-ec2-with-bastion-host)

---

## Lab 02: Private EC2 with Bastion and NAT Gateway

**Description:** Deploy private EC2 instances with outbound internet access through a NAT Gateway while maintaining secure inbound access through a Bastion Host.

**Services Used:**

* Amazon VPC
* Amazon EC2
* NAT Gateway

**Concepts Covered:**

* NAT Gateway
* Route Tables
* Private Networking
* Secure Architecture

**Link:** `level-100/lab-02-private-ec2-with-bastion-and-nat-gateway`

---

## Lab 03: Secure EC2 Auto Scaling and Load Balancing

**Description:** Build a highly available web application architecture using Auto Scaling Groups and Application Load Balancers.

**Services Used:**

* Amazon EC2
* Auto Scaling
* Elastic Load Balancer

**Concepts Covered:**

* High Availability
* Health Checks
* Auto Scaling
* Load Balancing

**Link:** `level-100/lab-03-secure-ec2-auto-scaling-load-balancing`

---

## Lab 04: RDS Database Access from EC2

**Description:** Deploy an Amazon RDS MySQL database and securely access it from an EC2 instance.

**Services Used:**

* Amazon RDS
* Amazon EC2

**Concepts Covered:**

* Managed Databases
* Security Groups
* Database Connectivity
* Client-Server Architecture

**Link:** `level-100/lab-04-rds-database-access-from-ec2`

---

## Lab 05: EC2 EBS Volumes and Snapshots

**Description:** Learn Linux disk management by attaching, mounting, and managing Amazon EBS volumes and snapshots.

**Services Used:**

* Amazon EC2
* Amazon EBS

**Concepts Covered:**

* EBS Volumes
* Snapshots
* Linux Filesystems
* Disk Management

**Link:** `level-100/lab-05-ec2-ebs-volumes-and-snapshots`

---

## Lab 06: IAM Least Privilege and Policy Management

**Description:** Implement IAM users, groups, roles, and custom policies following the Principle of Least Privilege.

**Services Used:**

* AWS IAM

**Concepts Covered:**

* IAM Users
* IAM Groups
* IAM Roles
* Custom Policies
* Least Privilege

**Link:** `level-100/lab-06-iam-least-privilege-and-policy-management`

---

## Lab 07: CloudFront with S3 Static Website

**Description:** Deploy a secure static website using Amazon S3 and deliver content globally through Amazon CloudFront.

**Services Used:**

* Amazon S3
* Amazon CloudFront

**Concepts Covered:**

* Content Delivery Network (CDN)
* Origin Access Control (OAC)
* Static Website Hosting
* CloudFront Caching

**Link:** `level-100/lab-07-cloudfront-with-s3-static-website`

---

## Lab 08: S3 Event Notifications with Lambda

**Description:** Build an event-driven serverless architecture where file uploads to Amazon S3 automatically trigger AWS Lambda.

**Services Used:**

* Amazon S3
* AWS Lambda
* Amazon CloudWatch

**Concepts Covered:**

* Event-Driven Architecture
* S3 Event Notifications
* Lambda Triggers
* CloudWatch Logs

**Link:** `level-100/lab-08-s3-event-notifications-with-lambda`

---

## Lab 09: Simple Serverless API with Lambda

**Description:** Build a simple serverless backend API using AWS Lambda that returns structured JSON responses.

**Services Used:**

* AWS Lambda
* Amazon CloudWatch

**Concepts Covered:**

* Serverless Computing
* Environment Variables
* Error Handling
* API Development

**Link:** [Lab-09](level-100/lab-09-simple-serverless-api-with-lambda)

---

## Lab 10: API Gateway with Lambda

**Description:** Expose a Lambda function to the internet using Amazon API Gateway and build a fully serverless REST API.

**Services Used:**

* Amazon API Gateway
* AWS Lambda
* Amazon CloudWatch

**Concepts Covered:**

* HTTP APIs
* API Gateway Routes
* Lambda Integration
* Serverless APIs

**Link:** `level-100/lab-10-api-gateway-with-lambda`

---

# Skills Demonstrated

* AWS Core Services
* VPC Networking
* IAM Security
* EC2 Administration
* Linux Administration
* High Availability Architectures
* Serverless Computing
* Event-Driven Architectures
* API Development
* Cloud Troubleshooting
* Monitoring and Logging

---

# Future Enhancements

* Infrastructure as Code (Terraform)
* AWS CLI Automation
* CI/CD Pipelines
* Containerization
* Production-Grade Architectures
* Advanced Security Implementations

---

# Author

**Vaibhav Nalla**
Aspiring AWS Cloud Engineer | Cloud Enthusiast 
