#main module outputs

output "public_ip" {
	value = module.network.public_ip
	description = "public ip of instance"
}