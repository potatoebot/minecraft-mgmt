provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow ssh from home"

  ingress {
    description = "ssh port"
    from_port   = 22 
    to_port     = 22 
    protocol    = "tcp"
    cidr_blocks = ["74.136.116.3/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft"
  }
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft"
  description = "Expose minecraft port"

  ingress {
    description = "minecraft port"
    from_port   = 25565 
    to_port     = 25565 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minecraft"
  }
}

resource "aws_instance" "example" {
  ami             = "ami-0f7919c33c90f5b58"
  instance_type   = "t3a.small"
  security_groups = [aws_security_group.minecraft.name, aws_security_group.ssh.name]
  key_name        = "minecraft"
}

