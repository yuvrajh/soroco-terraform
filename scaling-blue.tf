### AutoScaling Policies & CloudWatch alarms

# AutoScaling Policies

resource "aws_autoscaling_policy" "asp_increase_capacity_blue" {
    adjustment_type =           "ChangeInCapacity"
    autoscaling_group_name =    "${aws_autoscaling_group.asg_sorocoapp_blue.name}"
    cooldown =                  480
    name =                      "${var.environment}_asp_increase_capacity_blue"
    scaling_adjustment =        2
}

resource "aws_autoscaling_policy" "asp_decrease_capacity_blue" {
    adjustment_type =           "ChangeInCapacity"
    autoscaling_group_name =    "${aws_autoscaling_group.asg_sorocoapp_blue.name}"
    cooldown =                  480
    name =                      "${var.environment}_asp_decrease_capacity_blue"
    scaling_adjustment =        -1
}

# CloudWatch Metric Alarms

resource "aws_cloudwatch_metric_alarm" "cw_metric_cpu_high_blue" {

    actions_enabled =           true
    alarm_actions =             [ "${aws_autoscaling_policy.asp_increase_capacity_blue.arn}" ]
    alarm_description =         "Monitors APP Server Average CPU utilization"
    alarm_name =                "${var.project}_App_Server_ASG_CPU_HIGH_Alarm_blue"
    comparison_operator =       "GreaterThanOrEqualToThreshold"
    evaluation_periods =        "2"
    metric_name =               "CPUUtilization"
    namespace =                 "AWS/EC2"
    period =                    "60"
    statistic =                 "Average"
    threshold =                 "75"
    dimensions {
        AutoScalingGroupName =  "${aws_autoscaling_group.asg_sorocoapp_blue.name}"
    }
}

resource "aws_cloudwatch_metric_alarm" "cw_metric_cpu_low_blue" {

    actions_enabled =           true
    alarm_actions =             [ "${aws_autoscaling_policy.asp_decrease_capacity_blue.arn}" ]
    alarm_description =         "Monitors APP Server Average CPU utilization"
    alarm_name =                "${var.project}_App_Server_ASG_CPU_LOW_Alarm_blue"
    comparison_operator =       "LessThanOrEqualToThreshold"
    evaluation_periods =        "3"
    metric_name =               "CPUUtilization"
    namespace =                 "AWS/EC2"
    period =                    "60"
    statistic =                 "Average"
    threshold =                 "32"
    dimensions {
        AutoScalingGroupName =  "${aws_autoscaling_group.asg_sorocoapp_blue.name}"
    }
}
