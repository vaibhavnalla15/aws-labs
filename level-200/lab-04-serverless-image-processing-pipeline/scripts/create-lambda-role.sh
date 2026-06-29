#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity \
--query Account \
--output text)

echo "Creating Lambda IAM Role..."

aws iam create-role \
--role-name ImageProcessingLambdaRole \
--assume-role-policy-document \
file://../policies/lambda-trust-policy.json

echo "Attaching CloudWatch Logs Policy..."

aws iam attach-role-policy \
--role-name ImageProcessingLambdaRole \
--policy-arn \
arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

echo "Creating custom S3 policy..."

aws iam create-policy \
--policy-name LambdaS3ImageProcessingPolicy \
--policy-document \
file://../policies/lambda-s3-policy.json

echo "Attaching S3 Policy..."

aws iam attach-role-policy \
--role-name ImageProcessingLambdaRole \
--policy-arn \
arn:aws:iam::"$ACCOUNT_ID":policy/LambdaS3ImageProcessingPolicy

echo
echo "======================================"
echo "Lambda IAM Role Created Successfully"
echo "======================================"

aws iam list-attached-role-policies \
--role-name ImageProcessingLambdaRole