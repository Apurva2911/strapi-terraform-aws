output "ec2_public_ip" {
  description = "Public IP to SSH into Strapi Server"
  value       = aws_instance.strapi.public_ip
}

output "ec2_dns" {
  value = aws_instance.strapi.public_dns
}
