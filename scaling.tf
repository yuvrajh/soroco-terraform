### AutoScaling Policies & CloudWatch alarms

# AutoScaling Policies

resource "aws_autoscaling_policy" "asp_increase_capacity" {
    adjustment_type =           "ChangeInCapacity"
    autoscaling_group_name =    "${aws_autoscaling_group.asg_sorocoapp.name}"
    cooldown =                  480
    name =                      "${var.environment}_asp_increase_capacity"
    scaling_adjustment =        2
}

resource "aws_autoscaling_policy" "asp_decrease_capacity" {
    adjustment_type =           "ChangeInCapacity"
    autoscaling_group_name =    "${aws_autoscaling_group.asg_sorocoapp.name}"
    cooldown =                  480
    name =                      "${var.environment}_asp_decrease_capacity"
    scaling_adjustment =        -1
}

# CloudWatch Metric Alarms

resource "aws_cloudwatch_metric_alarm" "cw_metric_cpu_high" {

    actions_enabled =           true
    alarm_actions =             [ "${aws_autoscaling_policy.asp_increase_capacity.arn}" ]
    alarm_description =         "Monitors APP Server Average CPU utilization"
    alarm_name =                "${var.project}_App_Server_ASG_CPU_HIGH_Alarm"
    comparison_operator =       "GreaterThanOrEqualToThreshold"
    evaluation_periods =        "2"
    metric_name =               "CPUUtilization"
    namespace =                 "AWS/EC2"
    period =                    "60"
    statistic =                 "Average"
    threshold =                 "75"
    dimensions {
        AutoScalingGroupName =  "${aws_autoscaling_group.asg_sorocoapp.name}"
    }
}

resource "aws_cloudwatch_metric_alarm" "cw_metric_cpu_low" {

    actions_enabled =           true
    alarm_actions =             [ "${aws_autoscaling_policy.asp_decrease_capacity.arn}" ]
    alarm_description =         "Monitors APP Server Average CPU utilization"
    alarm_name =                "${var.project}_App_Server_ASG_CPU_LOW_Alarm"
    comparison_operator =       "LessThanOrEqualToThreshold"
    evaluation_periods =        "3"
    metric_name =               "CPUUtilization"
    namespace =                 "AWS/EC2"
    period =                    "60"
    statistic =                 "Average"
    threshold =                 "32"
    dimensions {
        AutoScalingGroupName =  "${aws_autoscaling_group.asg_sorocoapp.name}"
    }
}
