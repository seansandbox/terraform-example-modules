variable "region" {	default = "us-east-1" }
variable "instance_type" { default = "t2.micro" }
variable "key_name" { description = "The EC2 key pair name" }
variable "vpc_id" { description = "VPCs are pre-provisioned outside of Terraform's control. Provide the VPC ID to use." }
variable "cloud_account_name" { description = "AWS Cloud Account name" }
variable "environment_number_range" { description = "Environment range start number" }

variable "number_of_instances" {
    default = 1
    description = "Number of instances to create"
}

variable "ec2_instance_guest_os_type" {
	default = "WV"
	description = "A two letter code to designate the hosted guest OS and hosted type. i.e. W for Window, L for Linux, and V for virtual."
}

variable "hosted_application" {
	description = "The hosted application type. E.g. IIS for Internet Information Services, APP for app server, DBS for database server etc..."
}

variable "subnet_id" {
	description = "AWS VPC Subnet to use for the instance"
}

variable "instance_tag_cost-center" { default = "CF4563FG" }

variable "user_data" {
	description = "The path to a custom userdata text file to execute on the provisioned EC2 instance."
	default = "userdata.txt"
}

variable "chef_server_url" {}

variable "chef_environment" {
	description = "Chef environment"
}

variable "chef_user_name" {}

variable "chef_user_key" {}

variable "admin_password" {}