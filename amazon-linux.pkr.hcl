variable "ssh_public_key" {}

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon_linux" {
  ami_name      = "custom-amazon-linux-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-08b5b3a93ed654d19"
  ssh_username  = "ec2-user"

  user_data = <<EOF
#!/bin/bash
echo "${var.ssh_public_key}" >> /home/ec2-user/.ssh/authorized_keys
chmod 600 /home/ec2-user/.ssh/authorized_keys
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
EOF
}

build {
  name = "my-packer"
  sources = [
    "source.amazon-ebs.amazon_linux"
  ]
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user"
    ]
  }
}