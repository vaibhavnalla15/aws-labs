# Lab 09: Simple Serverless API with Lambda

## Objective

Build a simple serverless backend API using AWS Lambda.

This lab demonstrates how to create a Lambda function that returns a JSON response, uses environment variables, handles errors gracefully, writes logs to CloudWatch, and follows production best practices.

---

# Architecture

```text
           Client/Test Event
                    │
                    ▼
              AWS Lambda
                    │
                    ▼
             JSON Response
                    │
                    ▼
          Amazon CloudWatch
                  Logs
```

---

# Request Flow

```text
Client Request
      │
      ▼
AWS Lambda Function
      │
      ▼
Process Business Logic
      │
      ▼
Generate JSON Response
      │
      ▼
Return HTTP Response
```

---

# AWS Services Used

- AWS Lambda
- Amazon CloudWatch
- AWS IAM

---

# Concepts Covered

- Serverless Computing
- JSON Responses
- HTTP Status Codes
- Environment Variables
- Error Handling
- CloudWatch Logging
- Lambda Configuration
- Memory Optimization
- Timeout Optimization

---

# Repository Structure

```text
level-100/
└── lab-09-simple-serverless-api-with-lambda/
    ├── README.md
    └── lambda/
        └── lambda_function.py
```

---

# Task 1: Create Lambda Function

Created a Lambda function.

## Configuration

| Setting       | Value                 |
| ------------- | --------------------- |
| Function Name | serverless-status-api |
| Runtime       | Python 3.14           |
| Architecture  | x86_64                |

---

## Execution Role

Selected:

```text
Create a new role with basic Lambda permissions
```

AWS automatically attached:

```text
AWSLambdaBasicExecutionRole
```

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
- Access AWS resources
- Call AWS APIs

---

# Task 2: Write API Response Code

Implemented the following Lambda code:

```python
import json
import os
from datetime import datetime


def lambda_handler(event, context):

    try:

        application_name = os.environ.get(
            "APPLICATION_NAME",
            "Unknown Application"
        )

        environment = os.environ.get(
            "ENVIRONMENT",
            "unknown"
        )

        custom_message = os.environ.get(
            "CUSTOM_MESSAGE",
            "No message configured"
        )

        response = {
            "application": application_name,
            "environment": environment,
            "status": "healthy",
            "message": custom_message,
            "timestamp": datetime.utcnow().isoformat()
        }

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps(response)
        }

    except Exception as error:

        print(f"Error: {str(error)}")

        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "status": "error",
                "message": "Internal Server Error"
            })
        }
```

---

# Understanding the Response Structure

```json
{
  "statusCode": 200,
  "headers": {},
  "body": "{}"
}
```

---

## statusCode

Represents the HTTP response code.

Examples:

```text
200 → Success
400 → Bad Request
401 → Unauthorized
403 → Forbidden
404 → Not Found
500 → Internal Server Error
```

---

## headers

Contains HTTP response headers.

Example:

```json
"headers": {
    "Content-Type": "application/json"
}
```

---

## body

Contains the actual response returned to the client.

---

# Task 3: Test Lambda Function

Created test event:

```json
{}
```

Executed the Lambda function successfully.

Observed:

```text
Status: Succeeded
```

Returned JSON response:

```json
{
  "application": "AWS Labs API",
  "environment": "development",
  "status": "healthy",
  "message": "Hello from AWS Lambda!",
  "timestamp": "2026-06-23T10:30:45.123456"
}
```

---

# Task 4: Add Environment Variables

Configured:

| Key              | Value                  |
| ---------------- | ---------------------- |
| APPLICATION_NAME | AWS Labs API           |
| ENVIRONMENT      | development            |
| CUSTOM_MESSAGE   | Hello from AWS Lambda! |

---

# Why Use Environment Variables?

Benefits:

- Avoid hardcoding values
- Support multiple environments
- Simplify configuration changes
- Improve maintainability

---

# Real-World Examples

Environment variables commonly store:

```text
Database Endpoints

API URLs

Environment Names

Configuration Values
```

Sensitive values should be stored in:

```text
AWS Secrets Manager

or

AWS Systems Manager Parameter Store
```

---

# Task 5: Read Environment Variables

Used:

```python
os.environ.get(
    "APPLICATION_NAME",
    "Unknown Application"
)
```

Advantages:

- Reads values dynamically
- Prevents application crashes
- Supports default values

---

# Task 6: Add Error Handling

Implemented:

```python
try:
    # Application logic

except Exception as error:
    # Error handling
```

---

# Why Error Handling?

Without error handling:

```text
Application Failure
        │
        ▼
Unhandled Exception
        │
        ▼
Application Crash
```

With error handling:

```text
Application Failure
        │
        ▼
Exception Caught
        │
        ▼
Error Logged
        │
        ▼
Friendly Response Returned
```

---

# Task 7: Test Failure Scenario

Intentionally introduced:

```python
custom_message = os.environ["CUSTOM_MESSAGE_BROKEN"]
```

Result:

```text
KeyError Exception
```

Lambda returned:

```json
{
  "statusCode": 500,
  "body": "{\"status\":\"error\",\"message\":\"Internal Server Error\"}"
}
```

---

# Root Cause

Environment variable:

```text
CUSTOM_MESSAGE_BROKEN
```

did not exist.

---

# Resolution

Restored:

```python
os.environ.get(
    "CUSTOM_MESSAGE",
    "No message configured"
)
```

Retested successfully.

---

# Task 8: Review CloudWatch Logs

Opened:

```text
/aws/lambda/serverless-status-api
```

Observed:

```text
START RequestId

END RequestId

REPORT RequestId
```

Also observed custom logs:

```text
Error: 'CUSTOM_MESSAGE_BROKEN'
```

---

# CloudWatch REPORT Metrics

Examples:

```text
Duration

Billed Duration

Memory Size

Max Memory Used
```

Example:

```text
Duration: 3.42 ms

Memory Size: 128 MB

Max Memory Used: 72 MB
```

---

# Task 9: Optimize Memory and Timeout

Updated Lambda settings.

| Setting | Default | Updated |
| ------- | ------- | ------- |
| Memory  | 128 MB  | 256 MB  |
| Timeout | 3 sec   | 10 sec  |

---

# Why Tune Memory?

Increasing memory:

```text
More Memory
      │
      ▼
More CPU Allocation
      │
      ▼
Faster Execution
```

---

# Why Tune Timeout?

Timeout controls maximum execution duration.

Example:

```text
Lambda Timeout = 3 Seconds

Execution Time = 4 Seconds

Result = Timeout Error
```

---

# Optimization Strategy

```text
Monitor CloudWatch Metrics
         │
         ▼
Tune Memory
         │
         ▼
Tune Timeout
         │
         ▼
Reduce Cost
```

---

# Troubleshooting

## Issue 1: Missing Environment Variable

### Symptoms

```text
Lambda returned statusCode 500
```

### Root Cause

Application attempted to access a non-existent environment variable.

### Resolution

Used:

```python
os.environ.get()
```

instead of:

```python
os.environ[]
```

---

# Issue 2: Application Errors

### Troubleshooting Workflow

```text
Lambda Failure
      │
      ▼
CloudWatch Logs
      │
      ▼
Check Error Message
      │
      ▼
Check Environment Variables
      │
      ▼
Fix Problem
      │
      ▼
Retest
```

---

# Real-World Use Cases

- Health Check APIs
- Backend Microservices
- Application Status APIs
- Serverless Backends
- REST APIs
- Monitoring Endpoints

---

# Key Learnings

## AWS Lambda

- Create Functions
- Deploy Code
- Test Functions
- Return JSON Responses

---

## Environment Variables

- External Configuration
- Environment-Specific Settings
- Avoid Hardcoding

---

## Error Handling

- Catch Exceptions
- Return Friendly Responses
- Improve Reliability

---

## CloudWatch

- Logging
- Monitoring
- Troubleshooting

---

## Optimization

- Memory Tuning
- Timeout Tuning
- Cost Optimization

---

#  Notes

## What is AWS Lambda?

AWS Lambda is a serverless compute service that runs code without provisioning or managing servers.

---

## What are Environment Variables in Lambda?

Environment variables store configuration values outside the application code.

---

## Why should you avoid hardcoding values?

Hardcoding reduces flexibility and makes applications difficult to maintain across environments.

---

## Why use try/except blocks?

To handle failures gracefully and prevent application crashes.

---

## Where do you troubleshoot Lambda issues?

First check:

```text
Amazon CloudWatch Logs
```

---

## How do you optimize Lambda cost?

- Monitor CloudWatch metrics
- Tune memory allocation
- Tune timeout values
- Avoid over-provisioning

---

## What is the purpose of statusCode in Lambda?

It represents the HTTP response status returned to the client.

---

# Status

```text
✅ Lab Completed

✅ Lambda Function Created

✅ JSON API Response Implemented

✅ Environment Variables Configured

✅ Error Handling Implemented

✅ Failure Scenario Tested

✅ CloudWatch Logs Reviewed

✅ Memory Optimized

✅ Timeout Optimized

✅ Production Best Practices Applied
```
