##ELB Logging Bucket

resource "aws_s3_bucket" "elb_logging_bucket" {
    acl =               "log-delivery-write"
    bucket =            "${var.aws_region}-${lower(var.project)}-elb-logging-bucket"
    force_destroy =     true
    policy =            "${data.template_file.tpl_s3_elb_logging_policy.rendered}"

    depends_on =        [ "data.template_file.tpl_s3_elb_logging_policy" ]

    tags {
        Environment =   "${var.environment}"
        Name =          "elb_logging_bucket_${var.project}"
    }
}


# ELB Logging Access to S3

data "template_file" "tpl_s3_elb_logging_policy" {
    template = "${file("${path.module}/resources/policies/s3-elb-logging-policy.json")}"
    vars {
        aws_account_number =    "${var.aws_account_number}"
        elb_logging_bucket =    "${var.aws_region}-${lower(var.project)}-elb-logging-bucket"
        elb_account_number =    "${lookup(var.elb_account_number, var.aws_region)}"
    }
}


resource "aws_s3_bucket" "ec2_config_bucket" {
    acl =               "private"
    bucket =            "${var.aws_region}-${lower(var.project)}-ec2-config-bucket"
#    server_side_encryption = "AES256"
    force_destroy =     true
#    policy =            "${data.template_file.tpl_s3_elb_logging_policy.rendered}"

#    depends_on =        [ "data.template_file.tpl_s3_elb_logging_policy" ]
    logging {
    target_bucket = "${aws_s3_bucket.ec2_config_bucket_log_bucket.id}"
    target_prefix = "log/"
  }

    tags {
        Environment =   "${var.environment}"
        Name =          "ec2_config_bucket_${var.project}"
    }
}


resource "aws_s3_bucket" "ec2_config_bucket_log_bucket" {
  bucket = "${var.aws_region}-${lower(var.project)}-ec2-config-bucket-logs"
  acl    = "log-delivery-write"
}
