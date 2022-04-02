output "name" {
  value = aws_instance.web.public_ip
}

output "name_dns" {
  value = aws_instance.web.public_dns
}
