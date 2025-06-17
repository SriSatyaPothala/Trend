# Trend Application🚀
Given a set of build files for a react application with vite build.The goal of this project is to containerize and deploy a front End React application using Docker, AWS EKS and Jenkins 🌐 React + EKS + Docker + Jenkins

## Docker: 
- DockerFile: For building Docker image, a single stage dockerfile is created which involves copying the build files in dist directory into nginx root directory (for docker nginx container it is /usr/share/nginx/html) and copying the nginx.conf into main configuration file of nginx(for a docker container it is /etc/nginx/conf.d/default.conf)
- Create a file named dockerfile and nginx.conf file in the root of the project director
- For testing locally
  - pre-requisites: Docker Desktop
  - Command to build docker image: `docker build -t srisatyap/trend:v1 .`
  - Command to run docker image: `docker run -d -p 80:3000 srisatyap/trend:v1`

## Terraform
- For provisioning infrastructure required for VPC, EC2 and IAM roles needed for jenkins deployment and EKS cluster access, terraform is used. Modular structure followed.
- main.tf - entry point and output
- vpc.tf - VPC and networking
- ec2.tf - Jenkins EC2 instance and security groups
- iam.tf - for role creation and policy assignment 
- variables.tf - input variables
- Pre-requisites:
  - Terraform installed
  - AWS CLI configured (Minimum permissions needed: Manage EC2, IAM, VPC, EKS)
- Steps-to-deploy:
  - Initialize terraform - `terraform init`
  - Validate - `terraform validate` -> for any syntax errors
  - Review the execution plan - `terraform plan`
  - Apply the infrastructure - `terraform apply`
- Note:
  - Make sure SSH key pair exists in the same region as the same region as the instance.
  - attach the following policies to the IAM role:
    - AmazonEKSClusterPolicy
    - AmazonEKSWorkerNodePolicy
    - AmazonEKS_CNI_Policy
