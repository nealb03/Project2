




filter {
  name = "name"
  values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}

filter {
  name = "virtualization\-type"
  values = ["hvm"]
}

owners = ["099720109477"] # Canonical


module "my_ec2_instance" {
  source = "./new_module"

  ec2_instance_type = var.ec2_instance_type
  ec2_instance_name = var.ec2_instance_type
    number_of_instances = var.number_of_instances
  ec2_ami_i  = data.aws_ami.cloud.cobus.id
}

output "instance_id" {
  value = module.my_ec2_instance.ec2_instance_id
}

 