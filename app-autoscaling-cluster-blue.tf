##App Server Autoscaling


# ASG App Server
resource "aws_autoscaling_group" "asg_sorocoapp_blue" {
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
    desired_capacity =          "${var.desired_cluster_size_app_blue}"
    default_cooldown =          480
    health_check_grace_period = 400
    health_check_type =         "ELB"
    launch_configuration =      "${aws_launch_configuration.lc_appserver.name}"
    min_size =                  "${var.min_cluster_size_app_blue}"
    max_size =                  "${var.max_cluster_size_app_blue}"
    name =                      "${lower(var.project)}-${var.environment}-app-blue-asg"
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
        value =                 "${lower(var.project)}-${var.environment}-app-blue-asg"
        propagate_at_launch =   true
    }
    tag = {
        key =                   "Version"
        value =                 "${var.version}"
        propagate_at_launch =   true
    }


}
