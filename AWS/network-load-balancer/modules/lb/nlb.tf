
#deploy a load balancer

resource "aws_eip" "eip_nlb" {
    tags = {
        Name = "elastic-ip-for-nlb"
    }
}


resource "aws_lb" "load_balancer" {
    name = var.lbName
    load_balancer_type = var.lbType  
    
    subnet_mapping {
        subnet_id = var.subnetID
        allocation_id = aws_eip.eip_nlb.id
    } 
}

resource "aws_lb_listener" "lb_listener_http" {
    load_balancer_arn = aws_lb.load_balancer.arn
    
    port = "80"
    protocol = "TCP" 
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.lb_target_group_http.arn
    }
}

resource "aws_lb_listener" "lb_listener_https" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = "443"
    protocol = "TCP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.lb_target_group_https.arn
    }
}

resource "aws_lb_target_group" "lb_target_group_http" {
    name = var.tgNameHttp
    port = "80"
    protocol = "TCP"
    vpc_id = var.vpcID

    health_check {
        interval = 30
        port = 80   
        protocol = "TCP"
    }
}

resource "aws_lb_target_group" "lb_target_group_https" {
    name = var.tgNameHttps
    port = "443"
    protocol = "TCP"
    vpc_id = var.vpcID

    health_check {
        interval = 30
        port = 443   
        protocol = "TCP"
    }
}

resource "aws_lb_target_group_attachment" "web1_http" {
    target_group_arn = aws_lb_target_group.lb_target_group_http.arn
    port = 80
    target_id = var.web1ID
}

resource "aws_lb_target_group_attachment" "web2_http" {
    target_group_arn = aws_lb_target_group.lb_target_group_http.arn
    port = 80
    target_id = var.web2ID
}

resource "aws_lb_target_group_attachment" "web3_http" {
    target_group_arn = aws_lb_target_group.lb_target_group_http.arn
    port = 80
    target_id = var.web3ID
}

resource "aws_lb_target_group_attachment" "web1_https" {
    target_group_arn = aws_lb_target_group.lb_target_group_https.arn
    port = 443
    target_id = var.web1ID
}

resource "aws_lb_target_group_attachment" "web2_https" {
    target_group_arn = aws_lb_target_group.lb_target_group_https.arn
    port = 443
    target_id = var.web2ID
}

resource "aws_lb_target_group_attachment" "web3_https" {
    target_group_arn = aws_lb_target_group.lb_target_group_https.arn
    port = 443
    target_id = var.web3ID
}