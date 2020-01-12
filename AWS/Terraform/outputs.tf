#calling module outputs

output "public_dns" {
	value = module.ec2instance.public_dns
	description = "public dns of instance"
}