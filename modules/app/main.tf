# App security group: allow SSH (optional) and allow inbound from web SG on app port (e.g., 8080)
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = var.vpc_id
  description = "App tier SG - accepts traffic from web tier"

  ingress {
    description = "Allow web to app"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

   ingress {
    description = "Allow web to app"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

  # SSH for admin (optional)
  #ingress {
  #  from_port   = 22
  #  to_port     = 22
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #  description = "SSH (adjust in prod!)"
  #}

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.web_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "app-sg" }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name
  associate_public_ip_address = false

#  user_data = <<-EOF
#              #!/bin/bash
#              yum update -y
#              # dummy app - listens on 8080
#              yum install -y python3
#              cat <<'PY' >/home/ec2-user/app.py
#              from http.server import HTTPServer, BaseHTTPRequestHandler
#              class H(BaseHTTPRequestHandler):
#                  def do_GET(self):
#                      self.send_response(200)
#                      self.send_header('Content-type','text/plain')
#                      self.end_headers()
#                      self.wfile.write(b"Hello from app tier")
#              httpd = HTTPServer(('0.0.0.0', 8080), H)
#              httpd.serve_forever()
#              PY
#              nohup python3 /home/ec2-user/app.py &>/dev/null &
#              EOF

  tags = { Name = "app-instance" }
}