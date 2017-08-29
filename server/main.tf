# Default security group to access the instances via WinRM over HTTP and HTTPS, as well as RDP
resource "aws_security_group" "default" {
  name        = "${var.server_instance_sg_name}"
  description = "Provisioned by terraform"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.server_instance_sg_name}"
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WinRM access from anywhere
  ingress {
    from_port   = 5985
    to_port     = 5985
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RDP access from anywhere
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance Resource for Module
resource "aws_instance" "default" {
	
    count = "${var.number_of_instances}"
    ami = "${data.aws_ami.amazon_windows_2012R2.image_id}"
    key_name = "${var.key_name}"
    
    # Our SG to allow WinRM/RDP/HTTP access
  	security_groups = ["${aws_security_group.default.id}"]

    subnet_id = "${var.subnet_id}"
    instance_type = "${var.instance_type}"
    user_data = "${template_file.user_data.rendered}"
    tags {
        Name = "${var.cloud_account_name}${var.ec2_instance_guest_os_type}${var.hosted_application}${format("%03d", var.environment_number_range + count.index + 1)}"
        Cost-Center = "${var.instance_tag_cost-center}"
    }

    provisioner "remote-exec" {
      inline = [
        "echo ${var.instance_remote_data} >> C:\\remotedata\\remotedata.txt"
      ]

      connection {
        type     = "winrm"
        user     = "Administrator"
        password = "${var.admin_password}"
      }
    }

    provisioner "chef"  {
        environment             = "${var.chef_environment}"
        run_list                = ["${split(",", var.chef_run_list)}"]
        attributes_json = <<-EOF
          {"set_hostname":"${var.cloud_account_name}${var.ec2_instance_guest_os_type}${var.hosted_application}${format("%03d", var.environment_number_range + count.index + 1)}"}
        EOF
        node_name               = "${var.cloud_account_name}${var.ec2_instance_guest_os_type}${var.hosted_application}${format("%03d", var.environment_number_range + count.index + 1)}"
        server_url              = "${var.chef_server_url}"
        skip_install            = false
        ssl_verify_mode         = ":verify_none"
        # If you have an existing client node in chef, this will replace the existing node with this one.
        recreate_client         = true
        user_name               = "${var.chef_user_name}"
        user_key                = "${var.chef_user_key}"

        connection {
          type     = "winrm"
          user     = "Administrator"
          password = "${var.admin_password}"
        }
    }
}

resource "template_file" "user_data" { 
  filename = "userdata.tpl"
  vars {
    admin_password = "${var.admin_password}"
  }
}

# Lookup the correct AMI based on the region specified
data "aws_ami" "amazon_windows_2012R2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-*"]
  }
}