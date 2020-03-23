# Script to export docker ECS AWS logs
This script is used to export the aws ecs logs with a certain ecr uri

## bash Requirements
aws-cli (previously configured)

jq

awk

cut

tr

I have not tested it in previous versions of aws cli to 1.17.6

## Execution
Change the PEM_KEY, EC2_USER and ECR_URI variables for your desired and execute it with:
`bash ./export_aws_ecs_container_logs.sh`

## Output
It will output files with the [dns-name]-logs.log in the same folder
