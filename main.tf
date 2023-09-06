provider "aws" {} 

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
# variable my_ip {}
# variable instance_type {}
# variable server_key_pair {}
# variable public_key_location {}

resource "aws_vpc" "myapp-vpc" {
	cidr_block = var.vpc_cidr_block
	tags = {
		Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
	vpc_id = aws_vpc.myapp-vpc.id
	cidr_block = var.subnet_cidr_block
	availability_zone = var.avail_zone

	tags = {
		Name: "${var.env_prefix}-subnet-1"
	}
}

resource "aws_internet_gateway" "myapp-igw" {
	vpc_id = aws_vpc.myapp-vpc.id

	tags = {
		Name: "${var.env_prefix}-igw"
	}
}

# resource "aws_default_route_table" "main-rtb" {
# 	default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
# 	route {
# 		cidr_block = "0.0.0.0/0"
# 		gateway_id = aws_internet_gateway.myapp-igw.id
# 	}
		
# 	tags = {
# 		Name: "${var.env_prefix}-main-rtb"
# 	}
# }

data "aws_vpc" "existing-vpc" {
    default = true
}

resource "aws_subnet" "myapp-subnet-2" {
	vpc_id = data.aws_vpc.existing-vpc.id
	cidr_block = "172.31.48.0/20"
	availability_zone = "ap-south-1a"

	tags = {
		Name: "${var.env_prefix}-subnet-2"
	}
}

output "dev-vpc-id" {
    value = aws_vpc.myapp-vpc.id
}
output "dev-subnet-id" {
    value = aws_subnet.myapp-subnet-1.id
}

resource "aws_route_table" "myapp-route-table" {
	vpc_id = aws_vpc.myapp-vpc.id 

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.myapp-igw.id
	}
	tags = {
		Name: "${var.env_prefix}-rtb"
	}
}
