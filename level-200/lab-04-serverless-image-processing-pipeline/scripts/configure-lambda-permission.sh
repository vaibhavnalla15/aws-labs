#!/bin/bash

SOURCE_BUCKET="saul-image-source-1782547817"

aws lambda add-permission \
--function-name image-processing-function \
--principal s3.amazonaws.com \
--statement-id s3invoke \
--action "lambda:InvokeFunction" \
--source-arn arn:aws:s3:::$SOURCE_BUCKET

echo "S3 invoke permission added successfully."


