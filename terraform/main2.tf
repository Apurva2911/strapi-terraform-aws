# -------------------------------
# Provider
# -------------------------------
provider "aws" {
  region = var.aws_region
}

# -------------------------------
# Data source: Availability zones
# -------------------------------
data "aws_availability_zones" "available" {}

# -------------------------------
# VPC
# -------------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

# -------------------------------
# Public Subnets
# -------------------------------
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project}-public-subnet-${count.index + 1}"
  }
}

# -------------------------------
# Private Subnets
# -------------------------------
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project}-private-subnet-${count.index + 1}"
  }
}

# -------------------------------
# Internet Gateway
# -------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# -------------------------------
# Public Route Table
# -------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-rt"
  }
}

# -------------------------------
# Associate Route Table with Public Subnets
# -------------------------------
resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------------
# Security Group for EC2
# -------------------------------
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow SSH + Strapi"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi"
    from_port   = 1337
    to_port     = 1337
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

# -------------------------------
# Key Pair for EC2
# -------------------------------
resource "tls_private_key" "strapi_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.strapi_key.private_key_pem
  filename = "/home/apurv/strapi-key.pem"
  file_permission = "0400"
}


resource "aws_key_pair" "strapi_key" {
  key_name   = "strapi-key"
  public_key = tls_private_key.strapi_key.public_key_openssh
}

# -------------------------------
# EC2 INSTANCE
# -------------------------------
resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-02b8269d5e85954ef"  # Ubuntu 22.04 Mumbai
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.strapi_key.key_name
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io git
    systemctl start docker
    systemctl enable docker

    # Create folder for your project
    mkdir -p /home/ubuntu/strapi-app
    cd /home/ubuntu/strapi-app

    # Optional: clone your repo (if using git)
    # git clone <YOUR_REPO_URL> .

    # Build Docker image from your Dockerfile
    docker build -t strapi-app .

    # Run the container
    docker run -d -p 1337:1337 --name strapi-app strapi-app
  EOF

  tags = {
    Name = "${var.project}-ec2"
  }
}

# -------------------------------
# Output Public IP
# -------------------------------
output "strapi_public_ip" {
  value = aws_instance.strapi_ec2.public_ip
}
