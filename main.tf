provider "aws"  {
    region = "us-east-1"
}

variable "cidr_blocks" {
    description = "scidr blocks and tag names for vpc and subnets"
    type = list(object({
        cidr_block = string 
        name = string
        
    }))
}


resource "aws_vpc" "dev" {
    cidr_block = var.cidr_blocks[0].cidr_block
    tags ={
        Name: var.cidr_blocks[0].name
    }

}

resource "aws_subnet" "dev-subnet-1"  {
    vpc_id = aws_vpc.dev.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "us-east-1a"
    tags ={
        Name: var.cidr_blocks[1].name
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2"  {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.96.0/20"
    availability_zone = "us-east-1a"
    tags ={
        Name: "subnet-default-dev"
    }
}


output "dev-vpc-id" {
  value       = aws_vpc.dev.id
  description = "DEV VPC ID"
}


output "dev-subnet" {
  value       = aws_subnet.dev-subnet-1.id
}





