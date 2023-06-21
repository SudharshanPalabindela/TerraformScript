provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
}
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.19.0/24"
  availability_zone       = "us-west-2a"
}
resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-west-2b"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "ec2_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_kms_key" "cmk_key" {
  description = "CMK Key"
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-005e54dee72cc1d00" # us-west-2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet1.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    encrypted             = true
    kms_key_id            = aws_kms_key.cmk_key.key_id
  }
}
resource "aws_db_instance" "default" {
  allocated_storage           = 10
  db_name                     = "mydb"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true
  username                    = "admin"
  parameter_group_name        = "default.mysql5.7"
}
  resource "aws_db_subnet_group" "default" {
  name       = "mydb1"
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id  ]
}