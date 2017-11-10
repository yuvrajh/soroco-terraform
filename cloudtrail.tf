resource "aws_cloudtrail" "soroco_cloudtrail" {
  name                          = "soroco-cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrial_bucket.id}"
  s3_key_prefix                 = "cloudtraillogs"
  include_global_service_events = "true"
  cloud_watch_logs_role_arn     = "arn:aws:iam::480833364711:role/CloudTrail_CloudWatchLogs_Role"
  cloud_watch_logs_group_arn    = "arn:aws:logs:ap-south-1:480833364711:log-group:CloudTrail/DefaultLogGroup:*"
  is_multi_region_trail         = "true"
}

resource "aws_s3_bucket" "cloudtrial_bucket" {
  bucket        = "ap-south-1-soroco-cloudtrail-bucket"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::ap-south-1-soroco-cloudtrail-bucket"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::ap-south-1-soroco-cloudtrail-bucket/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
