provider "aws" {
    region = "us-west-2"
}

provider "aws" {
    alias  = "east"
    region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

module "brents_webserver" {
    source          = "../modules/webserver"
    vpc_id          = aws_vpc.main.id
    cidr_block      = "10.0.0.0/16"
    webserver_name  = "brent"
    ami             = "ami-0c55b159cbfafe1f0"
    instance_type   = "t2.micro"
}

module "brents_webserver_east" {
    source          = "../modules/webserver"
    providers = {
        aws = aws.east
    }
    vpc_id          = aws_vpc.main.id
    cidr_block      = "10.0.0.0/16"
    webserver_name  = "brent-east"
    ami             = "ami-IDGOESHERE"
    instance_type   = "t2.large"
}

output "instance_data" {
  value = module.brents_webserver.instance
}



