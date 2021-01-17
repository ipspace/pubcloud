# outputs for nlb.tf

output "lbIP" {
    description = "public ip of load balancer"
    value = aws_eip.eip_nlb.public_ip
}