# main.auto.tf file

# use vpc-aaf620d3
variable "VPC1_ID" {
  default = "<your_vpc>"
}

# aws provider docs:
# https://www.terraform.io/docs/providers/aws/index.html
# authentication can be driven by environment variables too
# $ export AWS_ACCESS_KEY_ID="anaccesskey"
# $ export AWS_SECRET_ACCESS_KEY="asecretkey"
# $ export AWS_DEFAULT_REGION="us-west-2"
# $ terraform plan

provider "aws" {
  version                 = "~> 2.0"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "<your_profile>"
  region                  = "us-west-2"
}

# search and define image to use
# login user = 'ubuntu'
data "aws_ami" "UBUNTU_IMG" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-16.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# search and define vpc to use
data "aws_vpc" "VPC1" {
  id = var.VPC1_ID
}

# create specific security group
resource "aws_security_group" "test01_sg" {
  name        = "test01_sg"
  description = "specific SG for pn-test01"
  vpc_id      = var.VPC1_ID
  ingress = [
    {
      description      = "in-ssh-any"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "in-icmp-any"
      from_port        = -1
      to_port          = -1
      protocol         = "icmp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  egress = [
    {
      description      = "out-any"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_instance" "test01_vm" {
  ami           = data.aws_ami.UBUNTU_IMG.id
  instance_type = "t2.micro"
  subnet_id     = "<your_subnet>"
  # you can also specify existing SG ID directly
  # vpc_security_group_ids      = ["sg-2099ad5c"]

  # or use the one created above
  vpc_security_group_ids      = [aws_security_group.pn-test01_SG.id]
  key_name                    = "<your_ssh_key>"
  associate_public_ip_address = true

  tags = {
    Name = "<your_vm_name>"
  }
}
