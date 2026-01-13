
resource "aws_instance" "sample" {
  ami           = var.ec2.ami_id
  instance_type = var.ec2_instance_type

    tags = {
        name = var.ec2_instance_name
    }
}




