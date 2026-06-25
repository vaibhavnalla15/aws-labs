#!/bin/bash

echo "==============================================="
echo "              EC2 INVENTORY REPORT"
echo "==============================================="
echo

aws ec2 describe-instances \
--query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],InstanceId,State.Name,PrivateIpAddress,PublicIpAddress,Placement.AvailabilityZone]' \
--output text | while read NAME ID STATE PRIVATE_IP PUBLIC_IP AZ
do
    echo "+----------------+---------------------------+"
    printf "| %-14s | %-25s |\n" "Name" "${NAME:-N/A}"
    printf "| %-14s | %-25s |\n" "Instance ID" "${ID:-N/A}"
    printf "| %-14s | %-25s |\n" "State" "${STATE:-N/A}"
    printf "| %-14s | %-25s |\n" "Private IP" "${PRIVATE_IP:-N/A}"
    printf "| %-14s | %-25s |\n" "Public IP" "${PUBLIC_IP:-None}"
    printf "| %-14s | %-25s |\n" "AZ" "${AZ:-N/A}"
    echo "+----------------+---------------------------+"
    echo
done