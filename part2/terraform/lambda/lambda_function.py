import boto3
import json
from botocore.exceptions import ClientError

# Initialize AWS clients
ec2 = boto3.client('ec2')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('VpcSubnetData')  # DynamoDB table name from variables.tf file -  var 'table_name'

def lambda_handler(event, context):
    # Step 1: Get all VPCs and Subnets
    vpcs_response = ec2.describe_vpcs()
    subnets_response = ec2.describe_subnets()

    vpcs = vpcs_response.get('Vpcs', [])
    subnets = subnets_response.get('Subnets', [])

    # Step 2: Prepare the data
    vpc_map = {}
    for vpc in vpcs:
        vpc_id = vpc['VpcId']
        vpc_map[vpc_id] = {
            'Subnets': []
        }

    for subnet in subnets:
        vpc_id = subnet['VpcId']
        subnet_info = {
            'SubnetId': subnet['SubnetId']
        }
        if vpc_id in vpc_map:
            vpc_map[vpc_id]['Subnets'].append(subnet_info)

    # Step 3: Save the data into DynamoDB
    try:
        for vpc_id, vpc_data in vpc_map.items():
            # Use VPC ID as partition key
            response = table.put_item(
                Item={
                    'VpcId': vpc_id,
                    'Subnets': json.dumps(vpc_data['Subnets'])  # Store as a JSON string
                }
            )
            print(f"Successfully saved data for VPC {vpc_id} to DynamoDB.")
    except ClientError as e:
        print(f"Error saving data to DynamoDB: {e}")
        raise e

    return {
        'statusCode': 200,
        'body': json.dumps(vpc_map)
    }

