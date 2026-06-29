#!/bin/bash

AWS_REGION="us-east-1"
RANDOM_ID=$(date +%s)

SOURCE_BUCKET="saul-image-source-$RANDOM_ID"
DEST_BUCKET="saul-image-processed-$RANDOM_ID"

echo "Creating source bucket..."

aws s3api create-bucket \
--bucket "$SOURCE_BUCKET" \
--region $AWS_REGION

echo "Creating processed bucket..."

aws s3api create-bucket \
--bucket "$DEST_BUCKET" \
--region $AWS_REGION

echo "Enabling versioning..."

aws s3api put-bucket-versioning \
--bucket "$SOURCE_BUCKET" \
--versioning-configuration Status=Enabled

aws s3api put-bucket-versioning \
--bucket "$DEST_BUCKET" \
--versioning-configuration Status=Enabled

echo
echo "========================================"
echo "Buckets Created Successfully"
echo "========================================"
echo "Source Bucket    : $SOURCE_BUCKET"
echo "Processed Bucket : $DEST_BUCKET"
echo "========================================"