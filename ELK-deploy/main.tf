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

resource "aws_instance" "app_server" {
  ami             = "ami-04ff9e9b51c1f62ca"
  instance_type   = "t2.micro"
  user_data	= file("file.sh")
  security_groups = [ "Docker" ]

  tags = {
    Name = "ELKServerInstance"
  }
}

resource "aws_security_group" "Docker" {
  tags = {
    type = "terraform-test-security-group"
  }
}