# Lab 04: RDS MySQL with EC2 Client

## Objective

Launch a MySQL RDS database and connect to it from an EC2 instance. Verify connectivity by creating a database, table, inserting records, and querying data.

---

## Architecture

![rds-ec2-clinet](./assets/RDS%20+%20EC2%20Client.drawio.png)
---

## AWS Services Used

* Amazon RDS (MySQL)
* Amazon EC2
* Security Groups
* DB Subnet Group
* VPC

---

## Task 1: Create Network

### VPC

* Name: `lab-vpc`
* CIDR: `10.0.0.0/16`

### Public Subnet

* Name: `public-subnet`
* AZ: `us-east-1a`
* CIDR: `10.0.1.0/24`

### Private Subnet A

* Name: `private-subnet-a`
* AZ: `us-east-1a`
* CIDR: `10.0.2.0/24`

### Private Subnet B

* Name: `private-subnet-b`
* AZ: `us-east-1b`
* CIDR: `10.0.3.0/24`

---

## Task 2: Internet Gateway & Route Table

### Internet Gateway

* Name: `lab-igw`

### Route Table

* Name: `public-rt`

### Route

```text
0.0.0.0/0 → Internet Gateway
```

### Subnet Association

```text
public-subnet
```

---

## Task 3: Create DB Subnet Group

### Configuration

* Name: `mysql-db-subnet-group`
* VPC: `lab-vpc`

### Subnets

* private-subnet-a
* private-subnet-b

---

## Task 4: Create Security Groups

### EC2 Security Group

#### Name

```text
ec2-client-sg
```

#### Inbound

| Type | Source |
| ---- | ------ |
| SSH  | My IP  |

---

### RDS Security Group

#### Name

```text
mysql-rds-sg
```

#### Inbound

| Type         | Source        |
| ------------ | ------------- |
| MySQL (3306) | ec2-client-sg |

---

## Task 5: Launch RDS MySQL

### Configuration

| Setting        | Value        |
| -------------- | ------------ |
| Engine         | MySQL        |
| Template       | Free Tier    |
| Deployment     | Single-AZ    |
| Instance Class | db.t4g.micro |
| Identifier     | mysql-lab-db |
| Username       | admin        |

### Notes

AWS new Free Tier experience automatically used the default VPC and hid advanced networking options.

---

## Task 6: Launch EC2 Client

### Configuration

| Setting        | Value             |
| -------------- | ----------------- |
| Name           | mysql-client      |
| AMI            | Amazon Linux 2023 |
| Instance Type  | t3.micro          |
| Security Group | ec2-client-sg     |

---

## Task 7: Install MySQL Client

### Connect to EC2

```bash
ssh -i <key-pair>.pem ec2-user@<public-ip>
```

### Update Packages

```bash
sudo dnf update -y
```

### Install MySQL Client

```bash
sudo dnf install mariadb105 -y
```

### Verify Installation

```bash
mysql --version
```

Output:

```text
mysql  Ver 15.1 Distrib 10.5.29-MariaDB
```

---

## Task 8: Connect to RDS

### Obtain Endpoint

```text
RDS → mysql-lab-db → Connectivity & Security
```

### Connect

```bash
mysql -h <rds-endpoint> -u admin -p
```

### Successful Connection

```text
Welcome to the MariaDB monitor
```

---

## Task 9: Create Database & Tables

### Show Databases

```sql
SHOW DATABASES;
```

### Create Database

```sql
CREATE DATABASE labdb;
```

### Use Database

```sql
USE labdb;
```

### Create Table

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    role VARCHAR(100)
);
```

### Insert Data

```sql
INSERT INTO employees (name, role)
VALUES
('Soul', 'Cloud Engineer'),
('John', 'DevOps Engineer');
```

### Query Data

```sql
SELECT * FROM employees;
```

### Output

```text
+----+-------+-----------------+
| id | name  | role            |
+----+-------+-----------------+
| 1  | Soul  | Cloud Engineer  |
| 2  | John  | DevOps Engineer |
+----+-------+-----------------+
```

---

## Verification

### Verified RDS

* RDS status became Available.
* Endpoint generated successfully.
* MySQL accepted remote connections.

### Verified EC2

* EC2 launched successfully.
* MySQL client installed.

### Verified Connectivity

* EC2 connected to RDS successfully.
* Authentication succeeded.

### Verified Database Operations

* Database created.
* Table created.
* Records inserted.
* Records queried successfully.

---

## Troubleshooting

### Issue 1: RDS Wizard Did Not Show Networking Options

#### Symptoms

```text
Only Free Tier template available.
Dev/Test and Production disabled.
No Connectivity section visible.
```

#### Cause

AWS new account onboarding experience uses a simplified RDS creation wizard.

#### Resolution

* Proceeded with Free Tier template.
* Allowed AWS to provision using default VPC.
* Adapted the lab accordingly.

---

### Issue 2: db.t3.micro Not Available

#### Symptoms

```text
db.t3.micro unavailable.
```

#### Cause

AWS now defaults many new accounts to:

```text
db.t4g.micro
```

#### Resolution

Used:

```text
db.t4g.micro
```

for RDS.

---

### Issue 3: Access Denied Creating Table

#### Error

```text
ERROR 1044 (42000)
Access denied for user 'admin'@'%'
to database 'mysql'
```

#### Cause

Connected to the system database:

```text
mysql
```

instead of an application database.

#### Resolution

```sql
CREATE DATABASE labdb;
USE labdb;
```

---

### Issue 4: Missing Application Database

#### Symptoms

```text
SHOW DATABASES;
```

returned:

```text
information_schema
mysql
performance_schema
sys
```

#### Cause

The initial database was not created during provisioning.

#### Resolution

Created the database manually:

```sql
CREATE DATABASE labdb;
```

---

## Key Learnings

* RDS uses endpoints instead of server IPs.
* Security Groups control database access.
* EC2 can act as a database client.
* MySQL client can connect remotely to RDS.
* A successful RDS deployment does not automatically mean an application database exists.
* Database context matters (`USE database_name`).
* AWS new Free Tier accounts may hide advanced RDS networking options.
* Troubleshooting should begin with evidence rather than assumptions.

---

## Status

* ✅ Lab Completed
* ✅ RDS Deployed
* ✅ EC2 Client Deployed
* ✅ MySQL Connectivity Verified
* ✅ Database Created
* ✅ Table Created
* ✅ Records Inserted
* ✅ Records Queried
* ✅ Real Troubleshooting Experience Gained
