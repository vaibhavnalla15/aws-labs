#!/bin/bash

echo "==============================================="
echo "         AWS COST SAVER AUTOMATION"
echo "==============================================="
echo

INSTANCE_IDS=$(aws ec2 describe-instances \
--filters "Name=tag:Environment,Values=dev" \
          "Name=instance-state-name,Values=running" \
--query "Reservations[*].Instances[*].InstanceId" \
--output text)

if [ -z "$INSTANCE_IDS" ]
then
    echo "No running development instances found."
else
    echo "Stopping development instances..."
    echo

    for id in $INSTANCE_IDS
    do
        echo "Stopping instance: $id"
        aws ec2 stop-instances --instance-ids $id >/dev/null
    done

    echo
    echo "Cost optimization completed successfully."
fi