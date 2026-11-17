variable "ami" {
  type=string
  default = "ami-0055977a6e828a4f4"
  description = "ec2 ami id"  
}

variable "instance_type" {
type=string
default = "t3.micro"
description = "aws instance type"  
}