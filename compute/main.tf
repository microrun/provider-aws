terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }
  }
}

data "aws_ami" "flatcar_stable_lts_latest" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "product-code"
    values = ["5ijnyb4cj5cwh2tc5e65ebw41"]
  }
}

resource "aws_instance" "machine" {
  instance_type = var.instance_type
  user_data     = var.user_data
  ami           = data.aws_ami.flatcar_stable_lts_latest.image_id

  associate_public_ip_address = true

  tags = {
    "Name": "${var.name}",
    "microrun": "rocks!"
  }
}