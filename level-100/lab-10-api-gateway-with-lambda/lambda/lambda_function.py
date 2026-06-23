import json
from datetime import datetime


def lambda_handler(event, context):

    response = {
        "application": "AWS Labs API",
        "status": "healthy",
        "message": "Hello from API Gateway + Lambda!",
        "timestamp": datetime.utcnow().isoformat()
    }

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps(response)
    }