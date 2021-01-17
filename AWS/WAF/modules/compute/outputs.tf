# outputs of compute.tf

output "web1_pub_ip" {
    value = aws_instance.webserver1.public_ip
}

output "web1_prvt_ip" {
    value = aws_instance.webserver1.private_ip
}

output "web2_pub_ip" {
    value = aws_instance.webserver2.public_ip
}

output "web2_prvt_ip" {
    value = aws_instance.webserver2.private_ip
}

output "bastion_pub_ip" {
    value = aws_instance.bastion.public_ip
}

output "database_prvt_ip" {
    value = aws_instance.database.private_ip
}

output "web1_id" {
    value = aws_instance.webserver1.id
}

output "web2_id" {
    value = aws_instance.webserver2.id
}