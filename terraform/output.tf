output "web_server_public_ip" {
  description = "Public web server IP"
  value       = aws_instance.web-server.public_ip
}

output "app_server_private_ip" {
  description = "Private app server IP"
  value       = aws_instance.app.private_ip
}

output "web_dns_name" {
  description = "DNS name of web server"
  value       = aws_route53_record.web.name
}

output "ssh_connection" {
  description = "Connection to web server"
  value       = "ssh -i ~/.ssh/id_ed25519 ec2-user@${aws_instance.web-server.public_ip}"
}
