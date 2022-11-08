resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_az1" {
    availability_zone = var.subnet_az[0]
}

resource "aws_default_subnet" "default_az2" {
    availability_zone = var.subnet_az[1]
}