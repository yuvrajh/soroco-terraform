##App Server Autoscaling


data "template_file" "app_user_data" {
    template = "${file("${path.module}/resources/launch-configs/lc-app-server.sh")}"
}

resource "aws_launch_configuration" "lc_appserver" {
  name_prefix   = "${lower(var.project)}-app-green-lc-"
  image_id      = "${lookup(var.ami, "${var.aws_region}_amz_hvm_app_auto")}"
  instance_type = "${lookup(var.instance_type, "application_autoscale")}"
  iam_instance_profile = "${aws_iam_instance_profile.default_iam_instance_profile.name}" 
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.sg_application.id}"]
  associate_public_ip_address = false
  enable_monitoring =         true
  user_data =                 "${data.template_file.app_user_data.rendered}"
  # Storage
#  ebs_optimized =             true
  root_block_device = {
        volume_type =           "gp2"
        volume_size =           "100"
        delete_on_termination = true

    } 
  lifecycle {
    create_before_destroy = true
  }
}
# ASG App Server
resource "aws_autoscaling_group" "asg_sorocoapp" {
    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupPendingInstances",
        "GroupStandbyInstances",
        "GroupTerminatingInstances",
        "GroupTotalInstances"
    ]
    desired_capacity =          "${var.desired_cluster_size_app}"
    default_cooldown =          480
    health_check_grace_period = 400
    health_check_type =         "ELB"
    launch_configuration =      "${aws_launch_configuration.lc_appserver.name}"
    min_size =                  "${var.min_cluster_size_app}"
    max_size =                  "${var.max_cluster_size_app}"
    name =                      "${lower(var.project)}-${var.environment}-app-green-asg"
    target_group_arns = ["${aws_alb_target_group.webapp.arn}", "${aws_alb_target_group.webappinternal.arn}"]
    vpc_zone_identifier = [
        "${aws_subnet.subnet_private_application1.id}",
        "${aws_subnet.subnet_private_application2.id}"
        ]
    lifecycle { ignore_changes = [ "desired_capacity", "min_size", "max_size" ] }
    tag = {
        key =                   "Environment"
        value =                 "${var.environment}"
        propagate_at_launch =   true
    }
    tag = {
        key =                   "Name"
        value =                 "${lower(var.project)}-${var.environment}-app-green-asg"
        propagate_at_launch =   true
    }
    tag = {
        key =                   "Version"
        value =                 "${var.version}"
        propagate_at_launch =   true
    }


}
