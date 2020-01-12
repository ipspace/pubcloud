#fullstack outputs

output "public_dns" {
	value = aws_instance.ubuntuVM.public_dns
	description = "public dns of instance"
}