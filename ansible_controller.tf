resource "aws_security_group" "ansible_sg" {
  name   = "ansible-controller-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.ansible_ingress_ip] # Allow SSH from Ansible control node
  }

  egress {
    protocol    = "-1" 
    from_port   = 0    
    to_port     = 0    
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible-controller" {
  ami                         = "ami-0ea554099279c88d1" # Amazon Linux
  key_name                    = var.ansible_key_pair
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  user_data = file("provision_ansible.sh")

  tags = {
    Name = "Ansible Controller"
    OS   = "amazon-linux"
  }
}