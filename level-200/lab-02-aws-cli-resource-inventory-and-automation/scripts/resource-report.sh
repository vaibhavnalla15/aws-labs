#!/bin/bash

REPORT_DIR="../reports"
REPORT_FILE="$REPORT_DIR/daily-report.txt"

mkdir -p $REPORT_DIR

echo "===============================================" > $REPORT_FILE
echo "          AWS DAILY RESOURCE REPORT" >> $REPORT_FILE
echo "===============================================" >> $REPORT_FILE
echo "Generated On: $(date)" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "================ EC2 INVENTORY ================" >> $REPORT_FILE

aws ec2 describe-instances \
--query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],InstanceId,State.Name,PrivateIpAddress,Placement.AvailabilityZone]' \
--output table >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "================= S3 INVENTORY ================" >> $REPORT_FILE

aws s3 ls >> $REPORT_FILE

echo "" >> $REPORT_FILE

echo "Report generated successfully:"
echo "$REPORT_FILE" 