output "public_ip" {
    description = "IP address of the created instance"
    value = aws_instance.ec2instance.public_ip
}

output "ssh_username" {
  value = aws_instance.ec2instance.key_name
}
