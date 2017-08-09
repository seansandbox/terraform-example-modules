variable "region" {
	default = "us-east-1"
}

variable "vpc_id" {
	description = "VPCs are pre-provisioned outside of Terraform's control. Provide the VPC ID to use."
}

variable "instance_type" {
	default = "t2.micro"
}

variable "number_of_instances" {
    default = 1
    description = "Number of instances to create"
}

variable "cloud_account_name" {
	default = "AWS14"
    description = "The AWS cloud account name. E.g. AWS14"
}

variable "ec2_instance_guest_os_type" {
	default = "WV"
	description = "A two letter code to designate the hosted guest OS and hosted type. i.e. W for Window, L for Linux, and V for virtual."
}

variable "hosted_application" {
	description = "The hosted application type. E.g. IIS for Internet Information Services, APP for app server, DBS for database server etc..."
}

variable "environment_number_range" {
	description = "The number to start this environment naming convention off of. E.g. 800"
}

variable "subnet_id" {
	description = "AWS VPC Subnet to use for the instance"
}

variable "key_name" {
	description = "Name of the key pair file to associate with the provisioned EC2 instance."
}

variable "instance_tag_cost-center" {
	default = "CF4563FG"
}

variable "user_data" {
	description = "The path to a custom userdata text file to execute on the provisioned EC2 instance."
	default = "userdata.txt"
}
