provider "aws" {
  region = var.location
}

variable my_ip {}

# Create VPC
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "${var.location}a"
  tags = {
    Name: "${var.env_prefix}-subnet-1"
  }
}

# Create Public Route Table
resource "aws_route_table" "vpc_public_route_table" {
  vpc_id = aws_vpc.myapp-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_prefix}-pub-rtb"
  }
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.vpc_public_route_table.id
}

# Create Internet Gateway
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

# Create Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow specific ports"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = var.ingress_port_1
    to_port = var.ingress_port_1
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = var.ingress_port_2
    to_port = var.ingress_port_2
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name: "${var.env_prefix}-sg"
  }
}

resource "aws_eip" "my_elastic_ip" {
  domain     = "vpc"
  instance   = aws_instance.myapp-server.id
  depends_on = [aws_internet_gateway.myapp-igw] # Ensure IGW is created before EIP
}


data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  availability_zone = "${var.location}a"

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("install-services.sh")
  user_data_replace_on_change = true

  tags = {
    Name: "${var.env_prefix}-server"
  }
}

