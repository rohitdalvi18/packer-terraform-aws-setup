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
- **[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)** (configured with appropriate credentials)
- **SSH Key Pair** for **[Ansible](https://docs.ansible.com/) Controller** and private EC2 instances

---

## Deploy Infrastructure with Terraform

1. After cloning the repo navigate to the project directory and switch branch:
   ```sh
   cd packer-terraform-aws-setup
   git branch -v -a
   git switch ansible
   ```
2. Create a new file  `terraform.tfvars`  with below secrets:
   ```sh
    ansible_ingress_ip = "YOUR_IP/32"
    vpc_public_subnet           = "VPC_ID"
    ansible_key_pair            = "vockey_OR_deafult_SSH_KEY"
    private_instance_key        = "vockey_OR_PRIVATE_EC2_KEY" 
   ```
3. Initialize Terraform:
   ```sh
   terraform init
   ```
   <img width="608" alt="tf init" src="https://github.com/user-attachments/assets/1bcc8bff-4e53-4c42-a78f-a0f1e0ea4ab4" />

4. Validate the Terraform configuration:
   ```sh
   terraform validate
   ```
   <img width="547" alt="validate" src="https://github.com/user-attachments/assets/9b9cd976-4242-4770-bff7-ca0db47ae22a" />

5. Apply the changes to provision resources:
   ```sh
   terraform apply -var-file=terraform.tfvars
   ```
   <img width="720" alt="apply" src="https://github.com/user-attachments/assets/881ccf8e-08d5-4185-86de-63bc25cc17ab" />

### This will provision the AWS infrastructure

   <img width="720" alt="infra" src="https://github.com/user-attachments/assets/8d29fbaa-db4a-4811-9914-51629e183adf" />


---

## Configure and Execute Ansible

1. Run the following command to securely copy the Ansible playbook and dynamic inventory files to the home directory on the Ansible controller EC2 instance:
   ```sh
   scp ansible_playbook.yaml aws_ec2.yaml ec2-user@<your_ansible_controller_ip>:~
   ```
   <img width="720" alt="scp" src="https://github.com/user-attachments/assets/089a413d-ec2d-47c1-861d-c68162a02dbf" />

2. SSH into the Ansible Controller

- Set the appropriate permissions for your PEM file:
  ```bash
  chmod 600 <PEM_FILE>
  ```

- Add the PEM file to your SSH agent:
  ```bash
  ssh-add <PEM_FILE>
  ```

- Connect to the Ansible Controller EC2 instance:
  ```bash
  ssh -A -i <PEM_FILE> ec2-user@<your_ansible_controller_ip>
  ```

3. Configure AWS Credentials on the Ansible Controller

- Configure your AWS credentials:
  ```bash
  aws configure
  ```

- Set your session token:
  ```bash
  aws configure set aws_session_token <your_aws_session_token>
  ```

4. Execute the playbook on the Ansible Controller EC2 machine:
   ```bash
   ansible-playbook -i aws_ec2.yaml ansible_playbook.yaml -e 'ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"'
   ```
   This will run the playbook using the provided configuration.
   
   <img width="720" alt="a1" src="https://github.com/user-attachments/assets/a1da3caf-8249-46ed-924f-5d93b6d0cd74" />
   <img width="720" alt="a2" src="https://github.com/user-attachments/assets/409174ab-7b70-4c62-a848-0a2e8e54f4f2" />
   <img width="720" alt="a3" src="https://github.com/user-attachments/assets/23348e71-8dd3-417e-b44d-1a49a96d305b" />
   <img width="720" alt="a4" src="https://github.com/user-attachments/assets/8349bcbe-81e7-476a-aa6c-ae0cd719680d" />

5. To validate the installation of Docker on each of the private EC2 instances, initiate an SSH session to the respective instance and execute the following command within the terminal:
   ```bash
   sudo systemctl status docker
   docker --version
   ```
   <img width="720" alt="docker" src="https://github.com/user-attachments/assets/05d093f1-28ee-4ea2-9879-79ca622139b4" />


---


## **Troubleshooting**

### SSH Access Issues

- Ensure the correct user is used (`ubuntu` for Ubuntu, `ec2-user` for Amazon Linux):
  ```sh
  ssh -i labsuser.pem ubuntu@<instance-ip>
  ```
- If permission is denied, verify that `labsuser.pem` has the correct permissions:
  ```sh
  chmod 600 labsuser.pem
  ```

### Ansible Connection Errors

If hosts are unreachable, check the inventory configuration in `aws_ec2.yaml` and confirm instances are accessible.
  ```bash
  aws configure set aws_session_token <your_aws_session_token>
  ```

---

## Cleanup
To destroy all resources, run:
```sh
terraform destroy 
```
---

## Conclusion

This project successfully provisions and configures a set of EC2 instances using Terraform and Ansible, streamlining the deployment of Ubuntu and Amazon Linux environments. By automating system updates, Docker installation, and disk usage monitoring, the setup ensures that all instances are consistently maintained and ready for deployment.  

Through dynamic inventory management with `aws_ec2.yaml`, Ansible can efficiently target instances based on their OS, reducing manual effort. The modular approach allows for easy scaling and modifications in the future.  

