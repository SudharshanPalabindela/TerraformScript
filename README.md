# TerraformScript
This is a terraform script that about how to launch an ec2 from scratch, That From VPC and EC2.

## _**Installation**_

1. Ensure you have Terraform installed on your local machine.
2. Clone this repository to your local machine.

## _**Configuration**_

### Before running the Terraform code, you need to configure your AWS credentials. Follow the steps below:

1. Sign in to the AWS Management Console.
2. Go to the IAM service and create a new user with programmatic access.
3. Assign the user appropriate permissions to create EC2 instances.
4. Take note of the access key and secret key generated for the user.


The provided Terraform configuration creates resources in AWS, specifically in the "us-west-2" region. It includes the following resources:

VPC: The configuration creates a VPC with the CIDR block "10.0.0.0/16".

Internet Gateway: An internet gateway is created and associated with the VPC.

Subnets: Four subnets are defined. Two are public subnets named "public_subnet1" and "public_subnet2" with CIDR blocks "10.0.1.0/24" and "10.0.2.0/24" respectively, assigned to availability zones "us-west-2a" and "us-west-2b". The other two are private subnets named "private_subnet1" and "private_subnet2" with CIDR blocks "10.0.19.0/24" and "10.0.4.0/24" respectively, also assigned to availability zones "us-west-2a" and "us-west-2b".

Route Table: A route table is created and associated with the VPC.

Route Table Association: The public subnet "public_subnet1" is associated with the route table.

Security Group: An EC2 security group named "ec2_security_group" is created and associated with the VPC. It allows inbound traffic on port 22 (SSH) from any IP address and allows all outbound traffic.

Key Management Service (KMS) Key: A KMS key named "cmk_key" is created with the description "CMK Key".

EC2 Instance: An EC2 instance named "ec2_instance" is launched with the specified AMI "ami-005e54dee72cc1d00" (for the us-west-2 region) and instance type "t2.micro". The instance is associated with the private subnet "private_subnet1". The root block device is configured with a General Purpose SSD (gp2) volume of 8GB, encrypted using the KMS key created earlier.

Database Instance: An RDS database instance named "default" is created with the following configurations:

Allocated storage: 10GB
Database name: "mydb"
Engine: MySQL
Engine version: 5.7
Instance class: db.t3.micro
Managing master user password
Username: "admin"
Parameter group name: "default.mysql5.7"
Database Subnet Group: A database subnet group named "default" is created, consisting of the private subnets "private_subnet1" and "private_subnet2".

In summary, the code sets up a VPC with public and private subnets, an internet gateway, a route table, a security group, an EC2 instance, and a MySQL database instance in the us-west-2 region of AWS.
