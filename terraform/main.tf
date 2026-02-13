resource "aws_key_pair" "deployer" {
  key_name   = "dev-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP, HTTPS, SSH from everywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-server-sg"
  description = "Allow access only from web-server"

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web-server" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.micro"
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    name = "web-server"
  }
}

resource "aws_instance" "app" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.micro"
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.app_sg.name]

  tags = {
    name = "app"
  }
}

resource "aws_route53_record" "web" {
  zone_id = var.aws_route53_zone_id
  name    = "web.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web-server.public_ip]
}

resource "aws_route53_record" "app" {
  zone_id = var.aws_route53_zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.app.public_ip]
}