##ENDPOINT FOR S3

resource "aws_vpc_endpoint" "private-s3" {
  vpc_id       = "${aws_vpc.vpc_soroco.id}"
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = ["${aws_route_table.rt_nat_gw.id}", "${aws_route_table.rt_rds.id}", "${aws_route_table.rt_igw.id}"]
  policy       = <<EOF
{
    "Statement": [
        {
            "Action": "*",
            "Effect": "Allow",
            "Resource": "*",
            "Principal": "*"
        }
    ]
}
EOF
}

