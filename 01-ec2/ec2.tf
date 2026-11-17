resource "aws_instance" "ec2-demo" {
  ami = "ami-0055977a6e828a4f4"
  instance_type = "t3.micro"
  #security_groups = [aws_security_group.ec2-demo-sg.id]
  tags = {
    Name = "ec2-demo"
  }
}

resource "aws_security_group" "ec2-demo-sg" {
  name = "ec2-demo-sg"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-demo-sg"
  } 
}
