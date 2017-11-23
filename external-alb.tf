##ALB

resource "aws_alb" "frontend" {
  name            = "${lower(var.project)}-${lower(var.environment)}-frontend-alb"
  internal        = false
  security_groups = ["${aws_security_group.sg_elb.id}"]
  subnets         = ["${aws_subnet.subnet_public_dmz.id}", "${aws_subnet.subnet_public_dmz2.id}"]

  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket = "${aws_s3_bucket.elb_logging_bucket.bucket}"
    prefix = "ALB/APP"
#    interval = 5
  }
#  depends_on =        [ "{aws_s3_bucket.elb_logging_bucket.bucket}" ]
  tags {
    Group = "${var.project}"
    Environment = "${var.environment}"
    Version =               "${var.version}"
  }
}


###Target group for ALB

resource "aws_alb_target_group" "webapp" {
  name = "${lower(var.project)}-${var.environment}-tg-webapp"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.vpc_soroco.id}"
  deregistration_delay = 180
  health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 5
      path = "/v1/status"
	  protocol = "HTTP"
	  interval = 10
  }

  tags {
    Group = "${var.project}"
    Environment = "${var.environment}"
	Version =               "${var.version}"
  }
}


#resource "aws_alb_target_group" "webapisecure" {
#	name = "${var.project}-${var.environment}-tg-webapisecure"
#  port = 443
#  protocol = "HTTPS"
#  vpc_id = "${aws_vpc.vpc_blaze.id}"
#  health_check {
#      healthy_threshold = 2
#      unhealthy_threshold = 2
#      timeout = 3
#      path = "/"
#      protocol = "HTTPS"
#	   interval = 10
#  }
#
#
#  tags {
#    Group = "${var.project}"
#    Environment = "${var.environment}"
#  }
#}


#resource "aws_alb_listener" "alb-http" {
#   load_balancer_arn = "${aws_alb.frontend.arn}"
#   port = "80"
#   protocol = "HTTP"
#default_action {
#     target_group_arn = "${aws_alb_target_group.webapi.arn}"
#     type = "forward"
#   }
#}

resource "aws_alb_listener" "alb-https" {
   load_balancer_arn = "${aws_alb.frontend.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
   certificate_arn = "${var.web_ssl_certificate_id}"
default_action {
     target_group_arn = "${aws_alb_target_group.webapp.arn}"
     type = "forward"
   }
}


resource "aws_lb_target_group_attachment" "external1" {
  target_group_arn = "${aws_alb_target_group.webapp.arn}"
  target_id        = "${aws_instance.ec2_app1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "external2" {
  target_group_arn = "${aws_alb_target_group.webapp.arn}"
  target_id        = "${aws_instance.ec2_app2.id}"
  port             = 80
}


#resource "aws_alb_listener_rule" "api-http" {
#  listener_arn = "${aws_alb_listener.alb-http.arn}"
#  priority = 1
#action {
#   type = "forward"
#    target_group_arn = "${aws_alb_target_group.webapi.arn}"
#  }
#condition {
#    field = "path-pattern"
#    values = ["/api*"]
#  }
#}

output "alb_address" {
  value = "${aws_alb.frontend.public_dns}"
}
output "alb_zone_id" {
  value = "${aws_alb.frontend.zone_id}"
}

