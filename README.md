# Trend Application🚀
Given a set of build files for a react application with vite build.The goal of this project is to containerize and deploy a front End React application using Docker, AWS EKS and Jenkins 🌐 React + EKS + Docker + Jenkins

## Docker: 
- DockerFile: For building Docker image, a single stage dockerfile is created which involves copying the build files in dist directory into nginx root directory (for docker nginx container it is /usr/share/nginx/html) and copying the nginx.conf into main configuration file of nginx(for a docker container it is /etc/nginx/conf.d/default.conf)
- Create a file named dockerfile and nginx.conf file in the root of the project director
- For testing locally
  - pre-requisites: Docker Desktop
  - Command to build docker image: `docker build -t srisatyap/trend:v1 .`
  - Command to run docker image: `docker run -d -p 80:3000 srisatyap/trend:v1`

## DockerHub Repository:
- Create a public repository in dockerhub . For instance `srisatyap/dev`

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
## Version Control 
- After cloning the repository to the local, add all the required files one by one and push it to the remote using the following commands.
  - `git status` -> shows you untracked files
  - `git add <filename>` -> adds the files to the staging area
  - `git commit -m "<commit-message>"` -> takes a snapshot (or save the history) of the files in the staging area 
  - `git pull origin main` -> fetches and merges the changes from remote to local
  - `git push origin main` -> pushes the latest committed changes from local to remote 

## Kubernetes
- To deploy the application in AWS EKS Cluster, set it up programatically.
  - On the EC2 instance, created using terraform, install AWS CLI
    - `sudo apt install zip -y`
    - `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
    - `unzip awscliv2.zip`
    - `sudo ./aws/install`
    - using aws configure command, add access key with necessary permissions to create and monitor eks cluster.
  - Install Kubectl , CLI tool for k8s
    - `curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl`
    - `chmod +x ./kubectl`
    - `sudo mv ./kubectl /usr/local/bin`
  - Install eksctl, AWS CLI tool for k8s Cluster management
    - `curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)   _amd64.tar.gz" | tar xz -C /tmp`
    - `sudo mv /tmp/eksctl /usr/local/bin`
  - Create EKS Cluster
    - `eksctl create cluster --name miniproject2 --region ap-south-1 --node-type t3.micro` (This command provisions the EKS control plane and worker nodes in the specified region with the default node group)
    - Use kubectl get nodes to check the cluster creation status successful or not.
    - NOTE: select t3.micro as t2.micro allows 4 pods per node which is sufficient for cluster pods itself ,so to avoid pods going to pending state, choose an instancetype with min t3.micro.
  - Prepare the manifest files
    - `deployment.yml`: define the deployment specifications, along with number of replicas needed and this file image name is modified with the latest build number from jenkins , which helps in deploying the latest image always.
    - `service.yml`: for enabling external access to the application, service manifest is necessary. Note: expose the service on port: 80 (since loadbalancer http by default works with port 80), but keep the targetPort: 3000 as per the requirement.
## Jenkins
- Login to Jenkins and create a user 
- Go to manage Jenkins -> plugins -> available plugins and install the following
  - Github Plugin
  - Docker Pipeline
  - Docker plugin
  - Kubernetes plugin
  - AWS Steps plugin
  - Github Integration plugin 
  - Generic webhook trigger
  - Blue Ocean 
- Create a pipeline job and give it a name . For instance Trend
- Select pipeline build trigger as Github hook trigger for GITScm Polling
- Choose the pipeline script from SCM, give the repository URL and branch
- Specify the script path , click on save and apply.
- Add the webhook trigger in github by going to settings and giving the payload url as
  `http://<jenkins_server-ip>:8080/github-webhook/` and add push event , click on save 
- Whenever there is a push event to github repository, a jenkins build is immediately started.

