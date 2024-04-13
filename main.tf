data "aws_vpc" "default_vpc" {
  id = "vpc-02ad7bf7ed42cb3b8"
}

data "aws_subnet" "default_subnet" {
  id = "subnet-0a7637a81c51e90a1"
}

resource "aws_security_group" "allow_local" {
  name        = "my-vapp"
  description = "Allow SSH from chirags local"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.76.58.11/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["103.76.58.11/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["103.76.58.11/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = var.tags

}


module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "my-vapp"

  instance_type          = "t2.micro"
  key_name               = "cb-svc"
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.allow_local.id]
  subnet_id              = data.aws_subnet.default_subnet.id

  tags = var.tags
}