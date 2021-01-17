output "web1ID" {
    description = "webserver1 ID for lb target group attachment"
    value = aws_instance.webserver1.id
}

output "web1IP" {
    description = "webserver 1 public IPv4"
    value = aws_instance.webserver1.public_ip
}

output "web2ID" {
    description = "webserver2 ID for lb target group attachment"
    value = aws_instance.webserver2.id
}

output "web2IP" {
    description = "webserver 2 public IPv4"
    value = aws_instance.webserver2.public_ip
}

output "web3ID" {
    description = "webserver2 ID for lb target group attachment"
    value = aws_instance.webserver3.id
}

output "web3IP" {
    description = "webserver 3 public IPv4"
    value = aws_instance.webserver3.public_ip
}