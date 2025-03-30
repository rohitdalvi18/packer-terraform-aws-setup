resource "aws_security_group" "private_host_sg" {
  name   = "private-host-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion_sg.id] # Allow SSH from Bastion
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "private_hosts" {
  count                       = 6
  ami                         = var.custom_image_id
  key_name                    = var.private_instance_key
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.private_host_sg.id]

  tags = {
    Name = "private-node-${count.index + 1}"
  }
}