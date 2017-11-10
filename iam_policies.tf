#Defult Profile for Instances (empty)
resource "aws_iam_role" "default_instance_role" {
    name = "${var.project}_default_instance_role"
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

resource "aws_iam_instance_profile" "default_iam_instance_profile" {
    name = "${var.project}_default_iam_instance_profile_${var.aws_region}"
    role = "${aws_iam_role.default_instance_role.name}"
}

data "template_file" "tpl_iamrolepolicy_ec2_cloudwatch_access" {
    template = "${file("${path.module}/resources/policies/cloudwatch-ec2-access.json")}"
}

resource "aws_iam_role_policy" "iamrolepolicy_ec2_cloudwatch_access" {
    name = "${var.environment}_ec2_cloudwatch_access"
    role = "${aws_iam_role.default_instance_role.id}"
    policy = "${data.template_file.tpl_iamrolepolicy_ec2_cloudwatch_access.rendered}"
}


