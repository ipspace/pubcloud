# outputs of compute.tf

output "instanceAIP" {
    description = "Instance A public IP"
    value = aws_instance.instanceA.public_ip
}

output "instanceBIP" {
    description = "Instance B public IP"
    value = aws_instance.instanceB.public_ip
}