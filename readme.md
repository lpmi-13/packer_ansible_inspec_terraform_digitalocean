# Packer, Ansible, Inspec and Terraform on Digital Ocean

*Based on the excellent work at https://github.com/gordonmurray/packer_ansible_inspec_terraform_aws*

A working demo application created using Packer, Ansible, Inspec and Terraform, deployed to Digital Ocean.

The purpose of this demo app is to show a working example of these tools working together.

The end result is a simple Hello World script running on a droplet instance in Digital Ocean.

* [Packer](https://www.packer.io/) is used to create a snapshot image on Digital Ocean. You can then use that custom image as the base for spinning up a droplet.

* [Ansible](https://www.ansible.com/) is used within Packer to install some neccessary services while Packer is building the image.

* [Inspec](https://www.inspec.io/) is used within Packer also, to perform some verification steps to make sure Packer and Ansible have created the image as expected.

* [Terraform](https://www.terraform.io/) is used to create the minimum Digital Ocean infrastructure we need. It will use the image created by Packer and create a small running droplet instance on Digital Ocean.

## Before you begin, You will need

* a Digital Ocean account and your [Digital Ocean API Key](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#HowToGenerateaPersonalAccessToken)
* [Packer](https://www.packer.io/) installed locally
* [Terraform](https://www.terraform.io/) installed locally
* [Inspec](https://www.inspec.io/) installed locally
(if installing as a gem, be sure to install both `inspec` and `inspec-bin`)

## Usage

1. Clone this repo
1. Validate Packer using : `packer validate -var-file=packer/variables.json packer/server.json`

(packer evaluates the file paths in the server.json from where the `packer validate`  command is run, so that might be the cause of an error if you run it in the wrong place)
1. Build the snapshot image with Packer using : `packer build -var-file=packer/variables.json packer/server.json`

(be sure that the `DIGITALOCEAN_API_TOKEN` environment variable has been exported first, or it will fail...also grab the ID of the snapshot to use in terraform. This will be in the output at the end of the build process)

1. Deploy the image with Terraform using:
* `cd /terraform`

(be sure that the `TF_VAR_do_api_token` environment variable has been exported and set to the same value as `DIGITALOCEAN_API_TOKEN`)
* `terraform init`
* `terraform apply`

## Clean up

### Terraform destroy

`terraform destroy`

### Delete the Digital Ocean snapshot

(only possible via the Digital Ocean command line or web UI, so not dealing with that here)
