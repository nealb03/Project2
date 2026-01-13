# My TF module
This is an example to setup the infrastructure

## Usage
Sample usage:
~~
resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.webserver.id

    tags = {
        name = "${var.webserver_name} webserver"
    }
}
~~