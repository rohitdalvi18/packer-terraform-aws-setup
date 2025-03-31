variable "ansible_ingress_ip" {
    type        = string
    description = "Specify your public IP for SSH access."
}

variable "vpc_public_subnet" {
    type        = string
    description = "CIDR block of the public subnet."
}

variable "ansible_key_pair" {
    type        = string
    description = "SSH key for Bastion Host."
}

variable "private_instance_key" {
    type        = string
    description = "SSH key for private EC2 instances."
}