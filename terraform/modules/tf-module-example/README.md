# My TF module
This is an example to setup the infrastructure

## Usage
Sample usage:
~~
module "my_ec2_instance" {
  source = "github.com/nealb03/Apps/tree/terraform-workflow"

  ec2_instance_type = "t3.micro"
  ec2_instance_name = "My instance"
  number_of_instances = 1
  ec2_ami_i  = < your AMI ID to use to launch the instance>
}
~~