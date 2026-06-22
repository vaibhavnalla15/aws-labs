# Lab 08: S3 Event Notifications with Lambda

## Objective

Learn how to build an event-driven serverless architecture using Amazon S3 and AWS Lambda.

In this lab, whenever a file is uploaded to an S3 bucket, AWS Lambda is automatically triggered to process the event and log information to CloudWatch Logs.

---

# Architecture

```text
            File Upload
                  │
                  ▼
            Amazon S3
                  │
        ObjectCreated Event
                  │
                  ▼
             AWS Lambda
                  │
                  ▼
          Amazon CloudWatch
                Logs
```

---

# Event Flow

```text
User Uploads File
          │
          ▼
      Amazon S3
          │
          ▼
ObjectCreated Event
          │
          ▼
 AWS Lambda Triggered
          │
          ▼
 Process Event Data
          │
          ▼
 Write Logs To CloudWatch
```

---

# AWS Services Used

- Amazon S3
- AWS Lambda
- Amazon CloudWatch
- AWS IAM

---

# Concepts Covered

- Event-Driven Architecture
- Serverless Computing
- Lambda Triggers
- S3 Event Notifications
- CloudWatch Logs
- Lambda Execution Roles
- File Type Filtering
- IAM Permissions
- Troubleshooting Lambda Failures

---

# Repository Structure

```text
level-100/
└── lab-08-s3-event-notifications-with-lambda/
    ├── README.md
    ├── assets/
    └── lambda/
        └── lambda_function.py
```

---

# Task 1: Create S3 Bucket

Created a new S3 bucket.

## Configuration

| Setting             | Value       |
| ------------------- | ----------- |
| Bucket Name         | bucket-name |
| Region              | us-east-1   |
| Block Public Access | Enabled     |

---

# Task 2: Create Lambda Function

Created a Lambda function.

## Configuration

| Setting       | Value            |
| ------------- | ---------------- |
| Function Name | s3-upload-logger |
| Runtime       | Python 3.14       |
| Architecture  | x86_64           |

---

## Execution Role

Selected:

```text
Create a new role with basic Lambda permissions
```

AWS automatically created an execution role with:

```text
AWSLambdaBasicExecutionRole
```

attached.

---

# Why Does Lambda Need an IAM Role?

```text
Lambda Function
       │
       ▼
   IAM Role
       │
       ▼
AWS Permissions
```

Without an IAM role, Lambda cannot:

- Write logs
- Access S3
- Access DynamoDB
- Call AWS APIs

---

# Task 3: Add Python Code

Replaced the default code with the following:

```python
import json

def lambda_handler(event, context):

    print("===== New S3 Event Received =====")

    for record in event['Records']:

        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        object_size = record['s3']['object']['size']

        print(f"Bucket Name : {bucket_name}")
        print(f"Object Name : {object_key}")
        print(f"Object Size : {object_size} bytes")

    return {
        'statusCode': 200,
        'body': json.dumps('S3 event processed successfully')
    }
```

---

# Understanding the Event Structure

```text
event
└── Records
      └── s3
            ├── bucket
            └── object
```

Important fields:

```python
record['s3']['bucket']['name']
```

Returns:

```text
Bucket Name
```

---

```python
record['s3']['object']['key']
```

Returns:

```text
Object Name
```

---

```python
record['s3']['object']['size']
```

Returns:

```text
Object Size
```

---

# Task 4: Review Lambda Permissions

Reviewed the automatically created IAM role.

Verified that:

```text
AWSLambdaBasicExecutionRole
```

was attached.

Reviewed policy actions:

```json
"logs:CreateLogGroup",
"logs:CreateLogStream",
"logs:PutLogEvents"
```

These permissions allow Lambda to write logs to CloudWatch.

---

# Task 5: Configure S3 Event Notification

Configured S3 Event Notification.

## Configuration

| Setting     | Value                    |
| ----------- | ------------------------ |
| Event Name  | trigger-lambda-on-upload |
| Event Type  | All Object Create Events |
| Destination | Lambda Function          |
| Lambda      | s3-upload-logger         |

---

# Event Notification Architecture

```text
Amazon S3
      │
      ▼
ObjectCreated Event
      │
      ▼
AWS Lambda
```

Whenever a new object is uploaded, Lambda automatically executes.

---

# Task 6: Upload Test Files

Uploaded test files:

```text
test.txt
image.jpg
notes.pdf
```

Each upload triggered Lambda automatically.

---

# Task 7: Verify CloudWatch Logs

Opened:

```text
/aws/lambda/s3-upload-logger
```

Observed logs similar to:

```text
===== New S3 Event Received =====

Bucket Name : bucket-name

Object Name : test.txt

Object Size : 25 bytes
```

Also observed Lambda execution logs:

```text
START RequestId

END RequestId

REPORT RequestId
```

---

# Lambda REPORT Example

```text
Duration

Billed Duration

Memory Size

Max Memory Used
```

These metrics are important for troubleshooting and optimization.

---

# Task 8: Add File Type Filtering

Deleted the original notification and created a new one.

## Configuration

| Setting       | Value                    |
| ------------- | ------------------------ |
| Event Name    | process-jpg-images       |
| Event Type    | All Object Create Events |
| Suffix Filter | .jpg                     |
| Destination   | Lambda                   |

---

# Verification

Uploaded:

```text
image1.jpg
```

Result:

```text
Lambda Triggered
```

Uploaded:

```text
notes.txt
```

Result:

```text
Lambda Not Triggered
```

---

# Why Use Filters?

Real-world examples:

```text
Only process images (.jpg)

Only process CSV files (.csv)

Only process PDFs (.pdf)
```

Example architecture:

```text
Users Upload Photos
          │
          ▼
      Amazon S3
          │
          ▼
Only JPG Files Trigger Lambda
          │
          ▼
 Resize Images
```

---

# Task 9: Test Failure Scenarios

Intentionally removed:

```text
AWSLambdaBasicExecutionRole
```

from the Lambda execution role.

Uploaded:

```text
failure-test.jpg
```

Observed:

```text
CloudWatch logging failed
```

---

# Root Cause

Lambda no longer had permission to:

```text
Create Log Streams

Write Logs
```

---

# Resolution

Reattached:

```text
AWSLambdaBasicExecutionRole
```

Retested.

Logging worked successfully.

---

# Real Troubleshooting Workflow

```text
System Failure
      │
      ▼
Check CloudWatch Logs
      │
      ▼
Check IAM Permissions
      │
      ▼
Check Event Notification
      │
      ▼
Identify Missing Permission
      │
      ▼
Fix
      │
      ▼
Retest
```

---


# Real-World Use Cases

- Image Processing
- Video Transcoding
- Malware Scanning
- ETL Pipelines
- Data Ingestion
- File Validation
- Automatic Notifications
- Document Processing

---

# Key Learnings

## Amazon S3

- Bucket Creation
- Event Notifications
- Event Filtering

---

## AWS Lambda

- Serverless Compute
- Event Processing
- Automatic Scaling

---

## CloudWatch

- Application Logging
- Monitoring
- Troubleshooting

---

## IAM

- Execution Roles
- Least Privilege
- Permission Troubleshooting

---

## Event-Driven Architecture

```text
S3 Event
     │
     ▼
Lambda Trigger
     │
     ▼
Process Event
     │
     ▼
CloudWatch Logs
```

---

# Notes

## What is Event-Driven Architecture?

A design pattern where events trigger actions automatically.

Example:

```text
S3 Upload
      │
      ▼
Lambda Trigger
```

---

## What is AWS Lambda?

AWS Lambda is a serverless compute service that runs code without provisioning or managing servers.

---

## What triggers a Lambda function?

Examples:

- S3
- API Gateway
- EventBridge
- DynamoDB Streams
- SNS
- SQS

---

## Why does Lambda need an IAM role?

Lambda uses IAM roles to obtain permissions to access AWS resources.

---

## Where do you troubleshoot Lambda failures?

First check:

```text
Amazon CloudWatch Logs
```

---

## How can you trigger Lambda only for image uploads?

Configure S3 Event Notification filters:

```text
Suffix = .jpg
```

---

## What happens if Lambda lacks permissions?

The function may fail or be unable to access AWS services.

---

# Status

```text
✅ Lab Completed

✅ S3 Bucket Created

✅ Lambda Function Created

✅ Python Event Processing Implemented

✅ IAM Execution Role Reviewed

✅ S3 Event Notification Configured

✅ CloudWatch Logs Verified

✅ File Type Filtering Implemented

✅ Failure Scenario Tested

✅ Event-Driven Architecture Implemented
```
