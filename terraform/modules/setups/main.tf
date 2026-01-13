provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

module "Brents_webserver" {
    source = "../modules/webserver"
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/16"
    webserver_name = "Brent"
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"



}