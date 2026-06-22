import json


def lambda_handler(event, context):

    print("===== New S3 Event Received =====")

    # Loop through all uploaded objects
    for record in event['Records']:

        # Get bucket name
        bucket_name = record['s3']['bucket']['name']

        # Get uploaded file name
        object_key = record['s3']['object']['key']

        # Get file size in bytes
        object_size = record['s3']['object']['size']

        print(f"Bucket Name : {bucket_name}")
        print(f"Object Name : {object_key}")
        print(f"Object Size : {object_size} bytes")

    return {
        'statusCode': 200,
        'body': json.dumps('S3 event processed successfully')
    }