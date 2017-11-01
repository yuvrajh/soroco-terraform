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


