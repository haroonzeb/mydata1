
Here is a structured Terraform project layout that meets your requirements. This project will automate the provisioning of infrastructure with a VPC containing public and private subnets, EC2 instances in the public subnet, an RDS instance in the private subnet, and an S3 bucket for storing application logs. The script is modular and reusable.

### Project Structure

css

Copy code

`terraform-project/ │ ├── modules/ │   ├── ec2/ │   │   ├── main.tf │   │   ├── output.tf │   │   └── variables.tf │   ├── rds/ │   │   ├── main.tf │   │   ├── output.tf │   │   └── variables.tf │   ├── s3/ │   │   ├── main.tf │   │   ├── output.tf │   │   └── variables.tf │   └── vpc/ │       ├── main.tf │       ├── output.tf │       └── variables.tf │ ├── environments/ │   └── dev/ │       ├── variables.tfvars │       ├── main.tf │       └── output.tf │ ├── main.tf ├── output.tf └── variables.tf`

### Root Configuration Files

#### `main.tf`

hcl

Copy code

`provider "aws" {   region = var.region }  module "vpc" {   source = "./modules/vpc"   cidr_block = var.vpc_cidr   public_subnet_cidr = var.public_subnet_cidr   private_subnet_cidr = var.private_subnet_cidr }  module "ec2" {   source = "./modules/ec2"   vpc_id = module.vpc.vpc_id   subnet_id = module.vpc.public_subnet_id   instance_type = var.ec2_instance_type }  module "rds" {   source = "./modules/rds"   vpc_id = module.vpc.vpc_id   subnet_id = module.vpc.private_subnet_id   db_instance_class = var.rds_instance_class   db_name = var.rds_db_name   db_username = var.rds_db_username   db_password = var.rds_db_password }  module "s3" {   source = "./modules/s3"   bucket_name = var.s3_bucket_name }`

#### `variables.tf`

hcl

Copy code

`variable "region" {   description = "The AWS region to deploy the infrastructure"   type = string }  variable "vpc_cidr" {   description = "The CIDR block for the VPC"   type = string }  variable "public_subnet_cidr" {   description = "The CIDR block for the public subnet"   type = string }  variable "private_subnet_cidr" {   description = "The CIDR block for the private subnet"   type = string }  variable "ec2_instance_type" {   description = "The instance type for the EC2 instances"   type = string }  variable "rds_instance_class" {   description = "The instance class for the RDS instance"   type = string }  variable "rds_db_name" {   description = "The name of the RDS database"   type = string }  variable "rds_db_username" {   description = "The username for the RDS database"   type = string }  variable "rds_db_password" {   description = "The password for the RDS database"   type = string   sensitive = true }  variable "s3_bucket_name" {   description = "The name of the S3 bucket"   type = string }`

#### `output.tf`

hcl

Copy code

`output "vpc_id" {   value = module.vpc.vpc_id }  output "public_subnet_id" {   value = module.vpc.public_subnet_id }  output "private_subnet_id" {   value = module.vpc.private_subnet_id }  output "ec2_instance_id" {   value = module.ec2.instance_id }  output "rds_instance_endpoint" {   value = module.rds.db_instance_endpoint }  output "s3_bucket_name" {   value = module.s3.bucket_name }`

### Environment-Specific Configuration Files (Example: dev)

#### `environments/dev/variables.tfvars`

hcl

Copy code

`region = "us-east-1" vpc_cidr = "10.0.0.0/16" public_subnet_cidr = "10.0.1.0/24" private_subnet_cidr = "10.0.2.0/24" ec2_instance_type = "t2.micro" rds_instance_class = "db.t2.micro" rds_db_name = "mydatabase" rds_db_username = "admin" rds_db_password = "mypassword" s3_bucket_name = "my-app-logs-bucket"`

#### `environments/dev/main.tf`

hcl

Copy code

`terraform {   backend "local" {     path = "terraform.tfstate"   } }  provider "aws" {   region = var.region }  module "vpc" {   source = "../../modules/vpc"   cidr_block = var.vpc_cidr   public_subnet_cidr = var.public_subnet_cidr   private_subnet_cidr = var.private_subnet_cidr }  module "ec2" {   source = "../../modules/ec2"   vpc_id = module.vpc.vpc_id   subnet_id = module.vpc.public_subnet_id   instance_type = var.ec2_instance_type }  module "rds" {   source = "../../modules/rds"   vpc_id = module.vpc.vpc_id   subnet_id = module.vpc.private_subnet_id   db_instance_class = var.rds_instance_class   db_name = var.rds_db_name   db_username = var.rds_db_username   db_password = var.rds_db_password }  module "s3" {   source = "../../modules/s3"   bucket_name = var.s3_bucket_name }`

#### `environments/dev/output.tf`

hcl

Copy code

`output "vpc_id" {   value = module.vpc.vpc_id }  output "public_subnet_id" {   value = module.vpc.public_subnet_id }  output "private_subnet_id" {   value = module.vpc.private_subnet_id }  output "ec2_instance_id" {   value = module.ec2.instance_id }  output "rds_instance_endpoint" {   value = module.rds.db_instance_endpoint }  output "s3_bucket_name" {   value = module.s3.bucket_name }`

### Module Configuration Files

#### `modules/vpc/main.tf`

hcl

Copy code

`resource "aws_vpc" "main" {   cidr_block = var.cidr_block    tags = {     Name = "main_vpc"   } }  resource "aws_subnet" "public" {   vpc_id            = aws_vpc.main.id   cidr_block        = var.public_subnet_cidr   map_public_ip_on_launch = true    tags = {     Name = "public_subnet"   } }  resource "aws_subnet" "private" {   vpc_id     = aws_vpc.main.id   cidr_block = var.private_subnet_cidr    tags = {     Name = "private_subnet"   } }`

#### `modules/vpc/variables.tf`

hcl

Copy code

`variable "cidr_block" {   description = "The CIDR block for the VPC"   type = string }  variable "public_subnet_cidr" {   description = "The CIDR block for the public subnet"   type = string }  variable "private_subnet_cidr" {   description = "The CIDR block for the private subnet"   type = string }`

#### `modules/vpc/output.tf`

hcl

Copy code

`output "vpc_id" {   value = aws_vpc.main.id }  output "public_subnet_id" {   value = aws_subnet.public.id }  output "private_subnet_id" {   value = aws_subnet.private.id }`

#### `modules/ec2/main.tf`

hcl

Copy code

`resource "aws_instance" "main" {   ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID   instance_type = var.instance_type   subnet_id     = var.subnet_id    tags = {     Name = "main_instance"   } }`

#### `modules/ec2/variables.tf`

hcl

Copy code

`variable "instance_type" {   description = "The instance type for the EC2 instances"   type = string }  variable "subnet_id" {   description = "The subnet ID where the instance will be deployed"   type = string }`

#### `modules/ec2/output.tf`

hcl

Copy code

`output "instance_id" {   value = aws_instance.main.id }`

#### `modules/rds/main.tf`

hcl

Copy code

`resource "aws_db_instance" "main" {   allocated_storage    = 20   storage_type         = "gp2"   engine               = "mysql"   engine_version       = "5.7"   instance_class       = var.db_instance_class   name                 = var.db_name   username             = var.db_username   password             = var.db_password   db_subnet_group_name`