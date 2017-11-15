resource "aws_flow_log" "flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.flow_log_group.name}"
  iam_role_arn   = "${aws_iam_role.flow_log_role.arn}"
  vpc_id         = "${aws_vpc.vpc_soroco.id}"
  traffic_type   = "ALL"
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = "${lower(var.project)}_${var.environment}_flow_log_group"
}


resource "aws_cloudwatch_log_stream" "sorocovpc_flow_log_stream" {
  name           = "sorocovpc_flow_log_stream"
  log_group_name = "${aws_cloudwatch_log_group.flow_log_group.name}"
}

resource "aws_iam_role" "flow_log_role" {
  name = "vpc_flow_log_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow_log_policy" {
  name = "${lower(var.project)}_${var.environment}_flow_log_policy"
  role = "${aws_iam_role.flow_log_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
