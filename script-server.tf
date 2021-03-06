##Script  Host


data "template_file" "script_user_data" {
    template = "${file("${path.module}/resources/launch-configs/lc-script.sh")}"
}

resource "aws_launch_configuration" "lc_script" {
  name_prefix   = "script-server--"
  image_id      = "${lookup(var.ami, "${var.aws_region}_amz_hvm")}"
  instance_type = "${lookup(var.instance_type, "bastion")}"
  iam_instance_profile = "${aws_iam_instance_profile.script_iam_instance_profile.name}" 
  key_name = "${var.tkey_name}"
  security_groups = ["${aws_security_group.sg_script_server.id}"]
  associate_public_ip_address = false
  enable_monitoring =         true
  user_data =                 "${data.template_file.script_user_data.rendered}"
  # Storage
#  ebs_optimized =             true
  root_block_device = {
        volume_type =           "gp2"
        volume_size =           "50"
        delete_on_termination = true

    } 
  lifecycle {
    create_before_destroy = true
  }
}
# ASG Script
resource "aws_autoscaling_group" "asg_script_server" {
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
    desired_capacity =          "${var.desired_cluster_size_script}"
    default_cooldown =          210
    health_check_grace_period = 210
    health_check_type =         "EC2"
    launch_configuration =      "${aws_launch_configuration.lc_script.name}"
    min_size =                  "${var.min_cluster_size_script}"
    max_size =                  "${var.max_cluster_size_script}"
    name =                      "${var.environment}_asg_script"

    vpc_zone_identifier = [
        "${aws_subnet.subnet_private_postgresql1.id}",
        "${aws_subnet.subnet_private_postgresql1.id}"
        ]

    tag = {
        key =                   "Environment"
        value =                 "${var.environment}"
        propagate_at_launch =   true
    }
    tag = {
        key =                   "Name"
        value =                 "${var.project}_asg_script"
        propagate_at_launch =   true
    }
    tag = {
        key =                   "Version"
        value =                 "${var.version}"
        propagate_at_launch =   true
    }

    lifecycle { ignore_changes = [ "desired_capacity", "min_size", "max_size" ] }

}


#Instance Profile for script server
resource "aws_iam_role" "script_instance_role" {
    name = "${var.project}_script_instance_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "script_iam_instance_profile" {
    name = "${var.project}_script_iam_instance_profile_${var.aws_region}"
    role = "${aws_iam_role.script_instance_role.name}"
}

data "template_file" "tpl_iamrolepolicy_ec2_script_access" {
    template = "${file("${path.module}/resources/policies/script-ec2-access.json")}"
    vars {
        aws_region =    "${var.aws_region}"
        project    =    "${lower(var.project)}"
    }

}

resource "aws_iam_role_policy" "iamrolepolicy_ec2_script_access" {
    name = "${var.environment}_ec2_scriptserver_access"
    role = "${aws_iam_role.script_instance_role.id}"
    policy = "${data.template_file.tpl_iamrolepolicy_ec2_script_access.rendered}"
}


