#!/bin/bash

echo "==============================================="
echo "              S3 INVENTORY REPORT"
echo "==============================================="
echo

for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text)
do
    creation_date=$(aws s3api list-buckets \
    --query "Buckets[?Name=='$bucket'].CreationDate" \
    --output text)

    region=$(aws s3api get-bucket-location \
    --bucket $bucket \
    --query "LocationConstraint" \
    --output text)

    # S3 returns None for us-east-1
    if [ "$region" == "None" ]; then
        region="us-east-1"
    fi

    echo "+----------------+---------------------------+"
    printf "| %-14s | %-25s |\n" "Bucket Name" "$bucket"
    printf "| %-14s | %-25s |\n" "Region" "$region"
    printf "| %-14s | %-25s |\n" "Created On" "$creation_date"
    echo "+----------------+---------------------------+"
    echo
done