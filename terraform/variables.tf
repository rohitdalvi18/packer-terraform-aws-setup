variable "bastion_allowed_ip" {
    type        = string
    description = "Specify your public IP for SSH access."
}

variable "vpc_public_subnet" {
    type        = string
    description = "CIDR block of the public subnet."
}

variable "custom_image_id" {
    type        = string
    description = "Custom AMI for private instances."
}

variable "bastion_key_pair" {
    type        = string
    description = "SSH key for Bastion Host."
}

variable "private_instance_key" {
    type        = string
    description = "SSH key for private EC2 instances."
}