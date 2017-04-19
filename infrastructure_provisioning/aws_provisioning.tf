terraform {
  backend "s3" {
    bucket = "prod-avidya-terraform-state"
    key    = "aws_provisioning.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "avidya_microservice_prod_ec2" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  tags {
    Name = "avidya_microservice"
    Env = "prod" 
  }
}
