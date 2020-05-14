terraform {
  backend "s3" {
    bucket  = "potatoebot"
    key     = "minecraft/tf_state"
    region  = "us-east-2"
  }
}
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "potatoebot"
    key    = "minecraft/tf_state"
    region = "us-east-2"
  }
}

# Set the desired phase of the deployment
# "normal": no render server, no provisional MC server
# "render": render server, no provisional MC server
# "setup": no render server, provisional MC server
# "staging": no render server, provisional MC server, route to provisional MC server
variable "phase" {
  type  = string
}

variable "render_image_id" {
  type    = string
  default = "none"
}

locals {
  enable_render           = var.phase == "render" ? true : false
  enable_provisionalMCS   = var.phase == "setup" || var.phase == "staging" ? true : false 
  use_provisionalMCS      = var.phase == "staging" ? true : false
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "potatoebot" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.potatoebot.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.potatoebot.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "main"
  }
}



resource "aws_subnet" "minecraft" {
  vpc_id                  = "${aws_vpc.potatoebot.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "minecraft"
  }
}


resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow ssh from home"
  vpc_id      = aws_vpc.potatoebot.id

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
  vpc_id      = aws_vpc.potatoebot.id

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
resource "aws_instance" "MCS" {
  ami             = "ami-0f7919c33c90f5b58"
  instance_type   = "t3a.small"
  key_name        = "minecraft"
  subnet_id       = aws_subnet.minecraft.id
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.minecraft.id]
}

resource "aws_instance" "provisionalMCS" {
  ami             = "ami-0f7919c33c90f5b58"
  instance_type   = "t3a.small"
  key_name        = "minecraft"
  count           = local.enable_provisionalMCS ? 1 : 0
  subnet_id       = aws_subnet.minecraft.id
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.minecraft.id]
}

#resource "aws_instance" "webserver" {
#}

resource "aws_instance" "render" {
  ami               = var.render_image_id
  instance_type     = "t3.2xlarge"
  key_name          = "minecraft"
  count             = local.enable_render ? 1 : 0
  subnet_id       = aws_subnet.minecraft.id
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.minecraft.id]
}

resource "aws_route53_record" "mc_alias" {
    name    = "mc.potatoebot.com" 
    zone_id = "Z1037556WKWX6437PGJP"
    type    = "A"
    ttl     = "60"
    records = ["${local.use_provisionalMCS ? aws_instance.provisionalMCS[0].public_ip : aws_instance.MCS.public_ip}"]
}

output "MCS_public_ip" {
    value = "${aws_instance.MCS.public_ip}"
}

output "MCS_dns" {
  value = "${aws_instance.MCS.public_dns}"  
}

output "render_dns" {
    value = [for r in aws_instance.render : "${r.public_dns}"]
}
