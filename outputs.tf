output "public_ip" {
    description = "IP address of the created instance"
    value = aws_instance.EC2instance.public_ip
}