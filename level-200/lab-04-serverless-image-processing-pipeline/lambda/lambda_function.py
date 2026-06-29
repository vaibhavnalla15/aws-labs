import json
import urllib.parse
import boto3

s3 = boto3.client('s3')

DESTINATION_BUCKET = 'saul-image-processed-1782547817'


def lambda_handler(event, context):

    source_bucket = event['Records'][0]['s3']['bucket']['name']

    source_key = urllib.parse.unquote_plus(
        event['Records'][0]['s3']['object']['key']
    )

    destination_key = f"processed-{source_key}"

    print(f"Source Bucket: {source_bucket}")
    print(f"Source Object: {source_key}")

    copy_source = {
        'Bucket': source_bucket,
        'Key': source_key
    }

    s3.copy_object(
        Bucket=DESTINATION_BUCKET,
        CopySource=copy_source,
        Key=destination_key
    )

    print(f"Copied to {DESTINATION_BUCKET}/{destination_key}")

    return {
        'statusCode': 200,
        'body': json.dumps('Image processed successfully')
    }