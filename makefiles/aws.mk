################################################################################
# 変数
################################################################################

################################################################################
# マクロ
################################################################################

################################################################################
# タスク
################################################################################
awscliv2.zip:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" --output "awscliv2.zip"

aws: awscliv2.zip
	unzip awscliv2.zip

.PHONY: install-aws-command
install-aws-command: aws
	sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli

.PHONY: update-aws-command
update-aws-command: aws
	sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

.PHONY: uninstall-aws-command
uninstall-aws-command:
	sudo rm /usr/local/bin/aws
	sudo rm /usr/local/bin/aws_completer
	sudo rm -rf /usr/local/aws-cli

.PHONY: aws-version
aws-version:
	aws --version

.PHONY: aws-configure
aws-configure:
	aws configure

.PHONY: get-caller-identity
get-caller-identity:
	aws sts get-caller-identity

.PHONY: ec2-regions
ec2-regions:
	AWS_PAGER='' aws ec2 describe-regions --all-regions

.PHONY: delete-default-vpcs
delete-default-vpcs:
#	@echo '=================VPC-subnets削除'
#	AWS_PAGER='' && aws ec2 describe-regions | jq --raw-output '.Regions[].RegionName' \
#	| AWS_PAGER='' xargs -I {region} bash -c "aws ec2 describe-vpcs --region {region} | jq '.Vpcs[] | select(.IsDefault = true)' | jq --raw-output '.VpcId' | xargs -I {vpc-id} aws ec2 describe-subnets --filter 'Name=vpc-id,Values={vpc-id}' --region {region} | jq --raw-output '.Subnets[].SubnetId' | xargs -I {subnet-id} aws ec2 delete-subnet --subnet-id {subnet-id} --region {region}"
	AWS_PAGER='' && aws ec2 describe-regions | jq --raw-output '.Regions[].RegionName' \
	| AWS_PAGER='' xargs -I {region} bash -c "aws ec2 describe-vpcs --region {region} | jq '.Vpcs[] | select(.IsDefault = true)' | jq --raw-output '.VpcId' | xargs -I {vpc-id} aws ec2 describe-security-groups --filter 'Name=vpc-id,Values={vpc-id}' --region {region} | jq --raw-output '.SecurityGroups[].GroupId' | xargs -I {security-group-id} aws ec2 delete-security-group --group-id {security-group-id} --region {region}"

#	@echo '=================VPC削除'
#	AWS_PAGER='' && aws ec2 describe-regions \
#	| jq --raw-output '.Regions[].RegionName' \
#	| AWS_PAGER='' xargs -I {region} bash -c "aws ec2 describe-vpcs --region {region} | jq '.Vpcs[] | select(.IsDefault = true)' | jq --raw-output '.VpcId' | xargs -I {vpc-id} aws ec2 delete-vpc --vpc-id {vpc-id} --region {region}"
