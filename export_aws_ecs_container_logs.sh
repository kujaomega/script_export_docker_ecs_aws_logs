#!/bin/bash
#
# DESCRIPTION: ECS Export aws container server logs
#



# BEGIN CUSTOMIZATION #
PEM_KEY="~/keys/aws-pem-keys/pem-key.pem"
EC2_USER="ec2-user"
ECR_URI="888888888888.dkr.ecr.eu-west-3.amazonaws.com/test"

# END CUSTOMIZATION #

# BEGIN OTHER VAR DEFINITIONS
AWSCLI_VER=$(aws --version 2>&1 | cut -d ' ' -f 1 | cut -d '/' -f 2)
AWSCLI_VERSION_TARGET=1.17.6
# END OTHER VAR DEFINITIONS

# CHECK AWS CLI VERSION
version_splitted=($(echo $AWSCLI_VER | tr "." "\n"))
version_limit_splitted=($(echo $AWSCLI_VERSION_TARGET | tr "." "\n"))
version_length=${#version_splitted[@]}

for((i=0; i<${version_length};i++)); do
        if [ ${version_splitted[$i]} -lt ${version_limit_splitted[$i]} ]
        then echo "ERROR: Please upgrade your AWS CLI to version ${AWSCLI_VER_TAR} or later!"
                exit 1
        fi

        if [ ${version_splitted[$i]} -gt ${version_limit_splitted[$i]} ]
        then break
        fi

done

# BEGIN SCRIPT
echo "AWS Servers:"
awsCommand=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].[PublicDnsName]")
for reservation in $(echo "$awsCommand" | jq -c '.[]'); do
	for instance in $(echo "$reservation" | jq -c '.[]'); do
		for dns in $(echo "$instance" | jq -c '.[]'); do
			temp="${dns%\"}"
			dns="${temp#\"}"
			echo "$dns" 
			$(ssh -i $PEM_KEY $EC2_USER@${dns} "docker logs \$(docker ps | grep $ECR_URI | awk '{print\$1}')" >& ${dns}-logs.log)
		done
	done
done
