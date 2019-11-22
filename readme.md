# Packer, Ansible, Inspec and Terraform on Digital Ocean

*Based on the excellent work at https://github.com/gordonmurray/packer_ansible_inspec_terraform_aws*

A working demo application created using Packer, Ansible, Inspec and Terraform, deployed to Digital Ocean.

The purpose of this demo app is to show a working example of these tools working together.

The end result is a simple Hello World script running on a droplet instance in Digital Ocean.

* [Packer](https://www.packer.io/) is used to create a snapshot image on Digital Ocean. You can then use that custom image as the base for spinning up a droplet.

* [Ansible](https://www.ansible.com/) is used within Packer to install some neccessary services while Packer is building the image.

* [Inspec](https://www.inspec.io/) is used within Packer also, to perform some verfification steps to make sure Packer and Ansible have created the image as expected.

* [Terraform](https://www.terraform.io/) is used to create the minimum Digital Ocean infrastructure we need. It will use the image created by Packer and create a small running droplet instance on Digital Ocean.

## A short video of the Packer, Ansible and Inspec stage

[![asciicast](https://asciinema.org/a/aO3KtTeRAmQNJy5QZ2UJRAv0Z.svg)](https://asciinema.org/a/aO3KtTeRAmQNJy5QZ2UJRAv0Z)

## A short video of the Terraform stage

[![asciicast](https://asciinema.org/a/282235.svg)](https://asciinema.org/a/282235)

## Before you begin, You will need

* You will need a Digital Ocean account and your [Digital Ocean API Key](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#HowToGenerateaPersonalAccessToken)
* [Packer](https://www.packer.io/) installed locally
* [Terraform](https://www.terraform.io/) installed locally
* [Inspec](https://www.inspec.io/) installed locally

## Create an AWS user

Use the following steps to create a new user in your AWS account and give it permission to create EC2 instances and Route53 zones. This will be used by Packer and Terraform to create an AMI and an EC2 instance.

* `aws iam create-user --user-name example`
* `aws iam create-access-key --user-name example`
* ( Make sure to save the AccessKeyId and SecretAccessKey from the output)
* `aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --user-name example`
* `aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --user-name example`
* Create a file at ~/.aws/credentials with the following content: 

```
[example]
aws_access_key_id = Your_AccessKeyId
aws_secret_access_key = Your_SecretAccessKey
```
* Copy your public key so Terraform can use it to create a .pem file which you can use to SSH in to the EC2 instance if needed: `cat ~/.ssh/id_rsa.pub > ../terraform/files/id_rsa.pub`

## Usage

1. Clone this repo
2. Add your Digital Ocean API key to terraform/terraform.tfvars
3. Validate Packer using : `packer validate -var-file=packer/variables.json packer/server.json`
(packer evaluates the file paths in the server.json from where the `packer validate`  command is run, so that might be the cause of an error if you run it in the wrong place)
4. Build the AMI with Packer using : `packer build -var-file=packer/variables.json packer/server.json`
(be sure that the `API_TOKEN` environment variable has been exported first, or it will fail)
5. Deploy the image with Terraform using:
* `cd /terraform`
* `terraform init`
* `terraform apply`

## Clean up

### Terraform destroy

`terraform destroy`

### Delete the AWS IAM user

`aws iam  delete-user --user-name example`

### Delete the AMI created by Packer

First, get the AMI ID value using:

`aws ec2 describe-images --filters "Name=tag:Name,Values=example.com" --profile=example --region=eu-west-1 --query 'Images[*].{ID:ImageId}'`

### Then delete the AMI

`aws ec2 deregister-image --image-id ami-<value>`

