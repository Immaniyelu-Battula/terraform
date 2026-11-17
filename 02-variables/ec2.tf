resource "aws_instance" "ec2-demo" {
  ami = var.ami
  instance_type = var.instance_type
  #security_groups = [aws_security_group.ec2-demo-sg.id]
  tags = var.ec2-tags
}

# resource "aws_security_group" "ec2-demo-sg" {
#   name = "ec2-demo-sg"

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "ec2-demo-sg"
#   } 
# }
