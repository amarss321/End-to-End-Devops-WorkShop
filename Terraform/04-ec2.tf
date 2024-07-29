data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "workshop-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  key_name               = "workshop-key"
  vpc_security_group_ids = [aws_security_group.workshop-sg.id]
  subnet_id              = aws_subnet.workshop-public-subnet-01.id
  for_each               = toset(["jenkins-master", "build-slave", ])
  tags = {
    Name = "${each.key}"
  }
}