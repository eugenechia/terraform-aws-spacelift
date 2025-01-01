output "security_group_id" {
  value = aws_security_group.spacelift_sg.id
}

output "subnet_id" {
  value = aws_subnet.spacelift_public_subnet.id
}