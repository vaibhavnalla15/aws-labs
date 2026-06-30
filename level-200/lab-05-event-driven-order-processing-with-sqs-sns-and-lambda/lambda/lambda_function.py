import json
import boto3

sns = boto3.client('sns')

SNS_TOPIC_ARN = "arn:aws:sns:us-east-1:321869098112:order-notification-topic"


def lambda_handler(event, context):

    for record in event['Records']:

        message = json.loads(record['body'])

        order_id = message['order_id']
        customer = message['customer']
        product = message['product']

        print(f"Processing Order: {order_id}")
        print(f"Customer: {customer}")
        print(f"Product: {product}")

        notification = (
            f"Order Processed Successfully\n\n"
            f"Order ID: {order_id}\n"
            f"Customer: {customer}\n"
            f"Product: {product}"
        )

        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="New Order Processed",
            Message=notification
        )

    return {
        'statusCode': 200,
        'body': 'Order processed successfully'
    }