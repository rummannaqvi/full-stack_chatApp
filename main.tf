provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "xiiops_auth" {
  key_name   = "xiiops_auth"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJZMMEhJaKcn62hIHbuS01B2bcMi7AXD8JmFHPxax4dbfK/MgadLE5cE3bDZqGevh41DntRJX7JWc9HnMWY0iakxws3o9iFEgAxssKk8HRoxDyHA+KL4oR+9Gyya8eGP1laZcspmo3dQXSfJzz8+XknFPdu32F4W7tQ7ZlpcrjflhGVEgv/q3ouZD0vTHSKg+qwQ9Y8BVHqxWFtBJSXJtsETmUc38cuaAd5fjw53aEoNfdfxEPqt5MmtZJihBYQ8TNlsy1VuWS2zaiA9XRCVU3WS0rgwflGMUtMEPavrqNTJh9PQqAE1F969zeF/lFMJQX9B+IgODxRNlqyifFWc0N"
}

resource "aws_security_group" "xiiops_sg" {
  name_prefix = "xiiops_sg_"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "xiiops_instance" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.xiiops_auth.key_name

  vpc_security_group_ids = [aws_security_group.xiiops_sg.id]

  tags = {
    Name = "xiiops_instance"
  }
}

output "public_ip" {
  value = aws_instance.xiiops_instance.public_ip
}