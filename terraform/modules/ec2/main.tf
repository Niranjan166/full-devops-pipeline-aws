data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"

    values = ["hvm"]
  }
}

#Generate SSH Key
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Upload Public Key to AWS
resource "aws_key_pair" "dms_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${path.root}/keys/dev-ec2-key.pem"
  content  = tls_private_key.ec2_key.private_key_pem
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}-app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.dms_key.key_name

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  vpc_security_group_ids = [var.ec2_security_group_id]

  user_data = base64encode(file("${path.module}/user-data.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-${var.environment}-app"
      Environment = var.environment
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-launch_template"
    Environment = var.environment
  }
}

resource "aws_instance" "app" {
  subnet_id = var.public_subnet_ids[0]

  launch_template {
    id = aws_launch_template.app.id

    version = "$Latest"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }
}