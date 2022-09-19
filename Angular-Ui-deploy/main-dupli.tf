resource "aws_key_pair" "deployer" {
  key_name   = "terraform"
  public_key = file("files/mykey.pem")
}

variable "security_groups" {
    description = "The attribute of security_groups information"
    type = list(object({
      name        = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }
  security_groups = [{
    from_port   = 22
    name        = "Office Wifi CIDR Range"
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] # you can replace with your office wifi outbount IP range
    }, {
    from_port   = 80
    name        = "NGINX Port"
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]

  data "http" "laptop_outbound_ip" {
    url = "http://ipv4.icanhazip.com"
  }

resource "aws_security_group" "sg" {
  description = "test sg for terraform"
  vpc_id      = "my vpc id"
  ingress {
    description = "Laptop Outbount IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.laptop_outbound_ip.body)}/32"]
  }
  dynamic "ingress" {
    for_each = var.security_groups
    content {
      description = ingress.value["name"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "instance" {
    ami                         = "ami-04ff9e9b51c1f62ca"
    availability_zone           = "us-east-1"
    instance_type               = "t2.micro"
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.sg.id]
    subnet_id                   = aws_subnet.main.id
    key_name                    = aws_key_pair.deployer.id
    tags = {
        Name = "TweetAppServerInstance"
      }
    root_block_device {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 20
      volume_type           = "gp3"
    }
    user_data = file("ubuntu.sh")
  }