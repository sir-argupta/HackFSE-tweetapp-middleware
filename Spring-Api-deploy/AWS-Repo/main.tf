provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1" # Setting my region to London. Use your own region here
}

resource "aws_ecr_repository" "my_first_ecr_repo" {
  name = "my-first-ecr-repo" # Naming my repository
}