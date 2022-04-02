provider "aws" {
  region     = "eu-west-3"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  vpc_security_group_ids = [aws_security_group.dynamic.id]
  instance_type          = var.instance_type
  key_name               = "LB"
  user_data              = file("bash.sh")
}

resource "aws_instance" "Ubuntu" {
  ami                    = "ami-0c6ebbd55ab05f070"
  vpc_security_group_ids = [aws_security_group.dynamic.id]
  instance_type          = var.instance_type
  key_name               = "LB"
  user_data              = file("Ubuntu.sh")
}

resource "aws_security_group" "web" {
  name_prefix = "web"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  resource "aws_security_group" "dynamic" {

    name_prefix = "dynamic"
    dynamic "ingress" {
      for_each = ["80", "433", "22", "8080"]
    }
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
