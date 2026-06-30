import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tasks-table')


def lambda_handler(event, context):

    http_method = event['httpMethod']

    # Create Task
    if http_method == 'POST':

        body = json.loads(event['body'])

        task_id = str(uuid.uuid4())

        item = {
            'taskId': task_id,
            'title': body['title'],
            'status': body['status']
        }

        table.put_item(Item=item)

        return {
            'statusCode': 201,
            'body': json.dumps({
                'message': 'Task created successfully',
                'task': item
            })
        }

    # Get All Tasks
    elif http_method == 'GET':

        response = table.scan()

        return {
            'statusCode': 200,
            'body': json.dumps(response['Items'])
        }

    return {
        'statusCode': 400,
        'body': json.dumps('Unsupported method')
    }