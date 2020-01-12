#outputs of compute.tf resources for use in other modules

output "public_dns" {
	value = aws_instance.Web_VM.public_dns
	description = "public DNS of UbuntuVM for access over CLI"
}