
# README
This README contains information for the solution of a following challenge:
> Create AWS Lambda that lists all VPCs and Subnets in the account and saves the data in a database.



## Requirements

- [Terraform](https://developer.hashicorp.com/terraform/install/) - Terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - This topic describes how to install or update the latest release of the AWS Command Line Interface (AWS CLI) on supported operating systems.

## Setup

1 - To setup the function, we have two options:

Option 1 - Create the function manually from the [AWS Console](https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/begin) and paste the code from the repo folder:
```bash
    git clone https://github.com/barzanov/tech-challenge.git
    cd ./part2/terraform/lambda
```
##### NOTE: a manual creation of DynamoDB will be needed and a IAM role with sufficient permissions!

Option 2 - Run the provided terraform code:
```bash
    git clone https://github.com/barzanov/tech-challenge.git
    cd ./part2/terraform
    aws configure # Optional - if not already configured
    terraform init
    terraform apply
```

2 - Run manually the function from the [console](https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/functions)

3 - Observe the output in [DynamoDB table](https://us-east-1.console.aws.amazon.com/dynamodbv2/home?region=us-east-1#tables)


## Steps for testing function:
1. Go to [AWS Lambda Console](https://console.aws.amazon.com/lambda)
2. Open Your Lambda: lambda-vpc-list
3. Click on “Test”
4. Create a Test Event
    - Click “Create new test event”
    - Name it (e.g., test-vpcs)
    - For the event JSON, use: {}
5. Observe the output in [DynamoDB table](https://us-east-1.console.aws.amazon.com/dynamodbv2/home?region=us-east-1#tables)


## Configurations

The setup allows for an easy function update.

1 - To update function, navigate to the following directory:
```bash
    cd ./part2/terraform/labda
```
then edit the following file - 'lambda_function.py'. Once completed, zip it to archive - 'function.zip' (replacing the old one).

2 - Re-run terraform apply:
```bash
    terraform apply
```
then the function will be re-deployed.