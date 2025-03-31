# Terraform and Ansible AWS Setup

## **Project Overview**

- Provision **6 EC2 instances** (3 Ubuntu, 3 Amazon Linux) using Terraform.
- Deploy an **Ansible Controller** for remote configuration.
- Execute an **Ansible Playbook** to:
  - Update and upgrade system packages.
  - Install and configure Docker.
  - Report disk usage.

---

## Project Structure
```
.
|
├── versions.tf                 # Terraform version and provider details
├── variables.tf                # Variables for Terraform setup
├── vpc.tf                      # VPC setup
├── ansible_controller.tf       # Ansible controller setup
├── ansible_playbook.yaml       # Playbook for system maintenance
├── aws_ec2.yaml                # Dynamic inventory configuration
├── provision_ansible.sh        # Automates Ansible setup
├── private_ec2_instances.tf    # Private EC2 instances setup
├── outputs.tf                  # Terraform outputs
├── providers.tf                # AWS provider configuration
├── terraform.tfvars            # User-defined secret values (ignored in Git)
├── README.md                   # Documentation
├── .gitignore                  # Ignore sensitive files
├── labsuser.pem                # Your AWS lab key (ignored in Git)
└── keypair.pem                 # Your private EC2 SSH key (ignored in Git)
```

---

## Prerequisites
Ensure you have the following installed:
- **[Terraform](https://developer.hashicorp.com/terraform/downloads)** (>= 1.3.0)
- **AWS CLI** (configured with appropriate credentials)
- **SSH Key Pair** for **[Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) Controller** and private EC2 instances

---

## Deploy Infrastructure with Terraform

1. Navigate to the **Terraform** directory:
   ```sh
   cd terraform/
   ```
2. Create a new file  `terraform.tfvars`  with below secrets:
   ```sh
    bastion_allowed_ip = "YOUR_IP/32"
    vpc_public_subnet           = "VPC_ID"
    custom_image_id             = "YOUR_CUSTOM_AMI_ID"
    bastion_key_pair            = "vockey_OR_deafult_SSH_KEY"
    private_instance_key        = "vockey_OR_PRIVATE_EC2_KEY" 
   ```
3. Initialize Terraform:
   ```sh
   terraform init
   ```
4. Validate the Terraform configuration:
   ```sh
   terraform validate
   ```
5. Apply the changes to provision resources:
   ```sh
   terraform apply -var-file=terraform.tfvars
   ```

### Output
After deployment, Terraform provides:
- **VPC ID**
  
    <img width="720" alt="vpc" src="https://github.com/user-attachments/assets/e76cbd69-b15d-4251-897c-320d56bbb81c" />

- **Public Subnets & Private Subnets IDs**
  
    <img width="720" alt="subnet" src="https://github.com/user-attachments/assets/a8510c88-46b7-45eb-917b-ab7604427995" />

- **Bastion Host Public IP**
  
    <img width="720" alt="bastain host" src="https://github.com/user-attachments/assets/950c7ac0-5c2a-4aab-a06f-cba083ca1e2f" />

- **Private EC2 Instance Details**
  
    <img width="720" alt="priavte ec2s and bastian host" src="https://github.com/user-attachments/assets/e342f584-46d4-485c-92c7-ecdba4e4d6ef" />

---

## SSH Access
- **Bastion Host:** Connect using your SSH key:
  ```sh
  ssh -i <your-bastion-key>.pem ec2-user@<bastion-public-ip>
  ```
- **Private EC2:** From the Bastion Host, use:
  ```sh
  ssh -i <your-private-key>.pem ec2-user@<private-ec2-ip>
  ```

### Output

   <img width="720" alt="ssh" src="https://github.com/user-attachments/assets/b3f8e8cc-212d-44e6-8340-1caca81c140e" />

---

## Cleanup
To destroy all resources, run:
```sh
terraform destroy 
```
---

## Conclusion

This demonstrates the automated provisioning of AWS infrastructure using Packer for creating a custom AMI and Terraform for deploying a secure, scalable architecture. By integrating a bastion host, private EC2 instances, and modular Terraform configurations, the setup ensures a structured and efficient deployment process. With this approach, infrastructure can be easily managed, replicated, and scaled while maintaining security best practices. 🚀

