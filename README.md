# RoboShop-Deployment-Using-Terraform-Ansible-on-AWS

This repository provides Terraform configurations to provision the complete infrastructure for the "RoboShop" e-commerce application on Amazon Web Services (AWS). This project automates the setup of all necessary networking, compute, and security resources. It also includes an automated process for configuring the application's various microservices using an Ansible server.

## Table of Contents

- [Architectural Overview](#architectural-overview)
- [Prerequisites](#prerequisites)
- [How to Use This Repository](#how-to-use-this-repository)
- [Modular Infrastructure](#modular-infrastructure)
- [Detailed Configuration](#detailed-configuration)
- [Automated Ansible Provisioning](#automated-ansible-provisioning)
- [Infrastructure Outputs](#infrastructure-outputs)
- [AWS Systems Manager (SSM) Parameter Store Integration](#aws-systems-manager-ssm-parameter-store-integration)
- [Customizable Variables](#customizable-variables)

## Architectural Overview

This Terraform project provisions a comprehensive and scalable architecture on AWS, which includes:

*   **Virtual Private Cloud (VPC):** A custom VPC is created with dedicated public, private, and database subnets. For enhanced availability, these subnets are distributed across two different availability zones.
*   **Internet Gateway (IGW):** An IGW is attached to the VPC to facilitate communication between the resources within the VPC and the public internet.
*   **Security Groups:** For ease of setup in a development environment, a security group is configured to permit all incoming traffic.
*   **EC2 Instances:** A suite of Amazon EC2 instances is launched to host the various microservices that constitute the RoboShop application. The 'web' instance is deployed in a public subnet for external access, while the remaining application and database instances reside in private subnets for enhanced security.
*   **Ansible Server:** A dedicated EC2 instance is configured as an Ansible server. This server automates the provisioning and configuration of all other EC2 instances with their respective application components.
*   **Route 53 Records:** To simplify access, 'A' records are automatically created in AWS Route 53 for each EC2 instance. These records resolve to the respective IP addresses of the instances.
*   **SSM Parameters:** Key infrastructure identifiers, such as the VPC ID, subnet IDs, and security group ID, are systematically stored in the AWS Systems Manager (SSM) Parameter Store. This allows for centralized management and easy retrieval of these values.

## Prerequisites

To successfully deploy this infrastructure, please ensure that you have the following prerequisites in place:

*   **Terraform:** This project is designed to work with Terraform version 6.0 or a later version.
*   **AWS Account:** An active AWS account is required. Your AWS credentials must be configured to allow Terraform to create resources. This can be achieved by configuring the AWS CLI or by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as environment variables.
*   **EC2 Key Pair:** You must have an existing EC2 key pair named `EC2-key` in the `ap-south-1` region.
*   **Git:** Git needs to be installed as it is used to clone the required modules from their GitHub repositories.

## How to Use This Repository

Follow these steps to deploy the RoboShop infrastructure:

1.  **Clone the Repository:**
    ```bash
    git clone <your-repository-url>
    cd <repository-directory>
    ```

2.  **Initialize Terraform:**
    To initialize the Terraform working directory, which involves downloading the necessary providers and modules, execute the command below.
    ```bash
    terraform init
    ```

3.  **Review the Execution Plan:**
    It is a best practice to review the execution plan before making any changes to your infrastructure.
    ```bash
    terraform plan
    ```
    This command provides a detailed summary of all the resources that will be created, modified, or destroyed.

4.  **Apply the Terraform Configuration:**
    If you are satisfied with the execution plan, you can proceed to apply the configuration and create the infrastructure on AWS.
    ```bash
    terraform apply --auto-approve
    ```
    Please note that this process may take several minutes to complete.

5.  **Destroy the Infrastructure:**
    To avoid ongoing charges, you can destroy all the created resources when they are no longer needed.
    ```bash
    terraform destroy --auto-approve
    ```

## Modular Infrastructure

To promote reusability and maintain a clean project structure, this project is built using several Terraform modules:

*   **VPC Module (`module "vpc"`)**
    *   **Source:** `git::https://github.com/Sarthakx67/terraform-aws-vpc-module.git`
    *   **Description:** This module is responsible for provisioning the VPC, all subnets (public, private, and database), and the internet gateway.

*   **Security Group Module (`module "security_group"`)**
    *   **Source:** `git::https://github.com/Sarthakx67/RoboShop-Security-Group-Module.git`
    *   **Description:** This module creates a security group based on user-defined ingress rules. In this specific project, it has been configured to allow all traffic.

*   **EC2 Instance Module (`module "ec2_instance"`)**
    *   **Source:** `terraform-aws-modules/ec2-instance/aws`
    *   **Description:** This module creates the EC2 instances required for each of the RoboShop microservices by iterating through a predefined map of instances.

*   **Ansible Server Module (`module "ec2_ansible"`)**
    *   **Source:** `terraform-aws-modules/ec2-instance/aws`
    *   **Description:** This module is dedicated to deploying the Ansible server instance. It utilizes a `user_data` script to automate the setup and subsequent execution of the Ansible playbooks.

*   **Route 53 Records Module (`module "records"`)**
    *   **Source:** `terraform-aws-modules/route53/aws//modules/records`
    *   **Description:** This module is used to create the necessary DNS records in the specified Route 53 hosted zone, making it easier to access the deployed EC2 instances.

## Detailed Configuration

### Networking

*   **VPC CIDR Block:** The default CIDR block for the VPC is `10.0.0.0/16`.
*   **Public Subnets:** The public subnets are configured with `10.0.1.0/24` and `10.0.2.0/24`.
*   **Private Subnets:** The private subnets are set up with `10.0.11.0/24` and `10.0.12.0/24`.
*   **Database Subnets:** The database subnets are assigned `10.0.21.0/24` and `10.0.22.0/24`.
*   **Availability Zones:** To ensure high availability, the infrastructure is deployed across the `ap-south-1a` and `ap-south-1b` availability zones.

### Security

*   The project establishes a security group named "allow-all," which permits all incoming and outgoing traffic. **Disclaimer:** This configuration is intended for development and testing purposes only and is not recommended for production environments.

## Automated Ansible Provisioning

The `ec2_ansible` module is launched with a `user_data` script designed to automate the setup and configuration of all the RoboShop application components. The script carries out the following steps:

1.  It begins by installing the Extra Packages for Enterprise Linux (EPEL) and Ansible.
2.  Next, it clones the `RoboShop-Ansible-Roles` repository from GitHub.
3.  It then adjusts the permissions for the EC2 key to ensure proper access.
4.  Finally, it runs a sequence of Ansible playbooks to install and configure all the necessary microservices, including:
    *   MongoDB
    *   Catalogue
    *   Redis
    *   User
    *   Cart
    *   Web Server
    *   MySQL
    *   Shipping
    *   RabbitMQ
    *   Payment
    *   Dispatch

All logs generated during this provisioning process are saved to `/tmp/roboshop-ansible-YYYY-MM-DD.log` on the Ansible server.

## Infrastructure Outputs

Upon successful deployment, Terraform will provide the following outputs:

*   **public\_subnet\_ids:** A list containing the IDs of the newly created public subnets.
*   **private\_subnet\_ids:** A list containing the IDs of the newly created private subnets.
*   **database\_subnet\_ids:** A list containing the IDs of the newly created database subnets.

## AWS Systems Manager (SSM) Parameter Store Integration

This project is designed to store critical infrastructure details in the AWS SSM Parameter Store under the `/roboshop/dev/` path. This approach allows other applications and infrastructure components to easily retrieve these configuration values. The following parameters will be created:

*   `/roboshop/dev/vpc_id`
*   `/roboshop/dev/public_subnet_ids`
*   `/roboshop/dev/private_subnet_ids`
*   `/roboshop/dev/database_subnet_ids`
*   `/roboshop/dev/allow_all_security_group_id`

## Customizable Variables

You can customize the following variables by creating a `terraform.tfvars` file or by passing them as arguments on the command line.

| Variable | Description | Default Value |
|---|---|---|
| `cidr_block` | The CIDR block for the VPC. | `"10.0.0.0/16"` |
| `common_tags` | A map of tags to be applied to all resources. | `{ Project = "roboshop-vpc", Environment = "DEV", Terraform = true }` |
| `env` | The name of the deployment environment. | `"dev"` |
| `project_name` | The name designated for the project. | `"roboshop"` |
| `vpc_tags` | Tags specifically for the VPC. | `{ Name = "roboshop-vpc" }` |
| `igw_tags` | Tags specifically for the Internet Gateway. | `{ Name = "roboshop-igw" }` |
| `public_subnet_cidr_block` | A list of CIDR blocks for the public subnets. | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `availability_zone` | A list of availability zones for subnet deployment. | `["ap-south-1a", "ap-south-1b"]` |
| `private_subnet_cidr_block`| A list of CIDR blocks for the private subnets. | `["10.0.11.0/24", "10.0.12.0/24"]` |
| `database_subnet_cidr_block`| A list of CIDR blocks for the database subnets. | `["10.0.21.0/24", "10.0.22.0/24"]` |
| `sg_name` | The designated name for the security group. | `"allow-all"` |
| `sg_description` | The description for the security group. | `"allow-all"` |
| `security_group_ingress_rule`| A list of maps that define the ingress rules for the security group. | `[{ description = "allow-all", cidr_blocks = ["0.0.0.0/0"], from_port = 0, protocol = "-1", to_port = 0 }]` |
| `instances` | A map of EC2 instances to be created, specifying their names and instance types. | `{ mongodb = "t2.micro", mysql = "t2.micro", redis = "t2.micro", rabbitmq = "t2.micro", catalogue = "t2.micro", user = "t2.micro", cart = "t2.micro", shipping = "t2.micro", payment = "t2.micro", web = "t2.micro", dispatch = "t2.micro" }` |
| `zone_name` | The name of the Route 53 hosted zone where DNS records will be created. | `"stallions.space"` |