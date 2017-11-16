### Load Balancers

# Front End

resource "aws_elb" "elb_fe" {
    name =                      "${var.project}-elb-fe"
    cross_zone_load_balancing = true
    internal        = false
    security_groups =           ["${aws_security_group.sg_elb.id}"]
    subnets = [
        "${aws_subnet.subnet_public_dmz.id}",
        "${aws_subnet.subnet_public_dmz2.id}"
        ]

    depends_on = [ "aws_s3_bucket.elb_logging_bucket" ]

    access_logs {
        bucket =                "${aws_s3_bucket.elb_logging_bucket.bucket}"
        bucket_prefix =         "ELB/APP"
        interval =              60
    }

    listener {
        instance_port =         "${var.http_port}"
        instance_protocol =     "http"
        lb_port =               "${var.http_port}"
        lb_protocol =           "http"
#        ssl_certificate_id =    "${var.web_ssl_certificate_id}"
    }

    health_check {
        healthy_threshold =     2
        unhealthy_threshold =   2
        target =                "HTTP:${var.http_port}/v1/status"
        timeout =               3
        interval =              6
    }
    
   instances                        = ["${aws_instance.ec2_app1.id}", "${aws_instance.ec2_app2.id}"]
        cross_zone_load_balancing   = true
  	idle_timeout                = 120
  	connection_draining         = true
  	connection_draining_timeout = 120

    idle_timeout =              60

    tags {
        Name =                  "${var.project}_elb_fe"
        Environment =           "${var.environment}"
        Version =               "${var.version}"
    }
}
