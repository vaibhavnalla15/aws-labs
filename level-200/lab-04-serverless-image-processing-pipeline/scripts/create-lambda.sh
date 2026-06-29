#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity \
--query Account \
--output text)

aws lambda create-function \
--function-name image-processing-function \
--runtime python3.13 \
--handler lambda_function.lambda_handler \
--zip-file fileb://../lambda/lambda.zip \
--role arn:aws:iam::"$ACCOUNT_ID":role/ImageProcessingLambdaRole

echo
echo "Lambda Function Created Successfully"