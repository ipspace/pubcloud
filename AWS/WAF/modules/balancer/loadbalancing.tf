# file to deploy application load balancer with listeners

# create application load balancer

resource "aws_lb" "webAlb" {
    name = var.alb_name
    internal = false
    load_balancer_type = "application"
    security_groups = var.alb_security_group_id
    subnets = [var.pub_sub1_id, var.pub_sub2_id]
}

# create target groups 

resource "aws_lb_target_group" "albTgHttp" {
    name = "HTTP-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "httpAttach1" {
    target_group_arn = aws_lb_target_group.albTgHttp.arn
    target_id = var.web1_id
    port = 80
}

resource "aws_lb_target_group_attachment" "httpAttach2" {
    target_group_arn = aws_lb_target_group.albTgHttp.arn
    target_id = var.web2_id
    port = 80
}

# create listeners

resource "aws_lb_listener" "listenerHttp" {
    load_balancer_arn = aws_lb.webAlb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward" 
        target_group_arn = aws_lb_target_group.albTgHttp.arn
    }
}

output "alb_dns_name" {
    value = aws_lb.webAlb.dns_name
}
output "alb_arn" {
    value = aws_lb.webAlb.arn
}