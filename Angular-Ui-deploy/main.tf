terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_security_group" "Docker" {
  name        = "Docker-UI"
  description = "Allow inbound traffic"

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  // To Allow SSH Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    type = "terraform-test-security-group"
  }
}

resource "aws_instance" "ubuntu" {
  ami             = "ami-0149b2da6ceec4bb0"
  instance_type   = "t2.small"
  user_data	= file("file.sh")
  vpc_security_group_ids = [aws_security_group.Docker.id]

  tags = {
    Name = "UIServerInstance"
  }
  root_block_device {
        volume_size           = 20
    }
}

