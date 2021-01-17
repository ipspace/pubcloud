# terraform file to set up and deploy a web application firewall

# define variables
variable "alb_arn" {
    description = "application load balancer ARN"
    type = string
    default = ""
}

# resources
resource "aws_wafv2_web_acl" "demoWAF" {
    name = "demo-WAF"
    scope = "REGIONAL"

    default_action {
        allow {}
    }

    rule {
        name = "demo-rule-1"
        priority = 1

        action {
            block{}
        }

        statement {
            # search web request components for matches with regular expressions
            regex_pattern_set_reference_statement { 
                arn = aws_wafv2_regex_pattern_set.blockedURL.arn
                
                #The part of a web request that you want AWS WAF to inspect.
                field_to_match {
                    #inspect the request URI path 
                    uri_path {} 
                }

                text_transformation {
                    priority = 1
                    type = "NONE"
                }
            }
        }

        visibility_config {
            cloudwatch_metrics_enabled = false
            metric_name = "demoWAF-blocked-url-rule"
            sampled_requests_enabled = false
        }
    }

    visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name = "demoWAF-metrics"
        sampled_requests_enabled = false
    }
}

resource "aws_wafv2_regex_pattern_set" "blockedURL"{
    name = "blocked-URL"
    scope = "REGIONAL"

    # blocks of regular expression patterns that you want AWS WAF to search for
    regular_expression {
        regex_string = "login"
    }

    regular_expression {
        regex_string = "admin"
    }

    regular_expression {
        regex_string = "registration"
    }
}

resource "aws_wafv2_web_acl_association" "demoWAFtoALB" {
    resource_arn = var.alb_arn
    web_acl_arn = aws_wafv2_web_acl.demoWAF.arn
}
