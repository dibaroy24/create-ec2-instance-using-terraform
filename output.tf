output "ec2_public_ip" {
    value = aws_instance.myapp-server.public_ip
}

output "ec2_public_dns" {
    value = aws_instance.myapp-server.public_dns
}

output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
}

output "elastic_ip" {
    description = "The Elastic IP address of the EC2 instance"
    value       = aws_eip.my_elastic_ip.public_ip
}

output "eip_public_dns" {
    description = "The public DNS name of the Elastic IP of the EC2 instance"
    value       = aws_eip.my_elastic_ip.public_dns
}
