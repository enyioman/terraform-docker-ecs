resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-project"
  }
}














# resource "aws_vpc" "TF_KP19" {
#   cidr_block       = var.vpc_cidr
#   instance_tenancy = "default"

#   tags = {
#     Name = "VPC for ecs_KP19"
#   }
# }
