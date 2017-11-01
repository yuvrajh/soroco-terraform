
variable "version" {
    default = "1.0.0"
    description = "The version of TF"
}

variable "environment"      { default = "PROD"   description = "ENV" }
variable "project"          { default = "SOROCO"   description = "PROJECT" }
variable "aws_account_id"   { default = "215268188550" description = "replace with your aws account id" }
variable "aws_account_number"   { default = "215268188550" description = "replace with your aws account id" }

variable "aws_account_name" { default = "electron" description = "replace with your aws account name" }


#VPC
variable "vpc"              { default = "172.26.8.0/24"   description = "Main VPC" }
variable "soroco_dmz"        { default = "172.26.8.128/28"  description = "DMZ Subnet" }
variable "soroco_dmz2"       { default = "172.26.8.144/28"  description = "DMZ Subnet" }
variable "soroco_a"          { default = "172.26.8.0/27"   description = "Application Subnet A" }
variable "soroco_a1"         { default = "172.26.8.32/27"  description = "Application Subnet A1" }
variable "soroco_b"          { default = "172.26.8.64/27"  description = "RDS PostgreSQL Subnet B" }
variable "soroco_b1"         { default = "172.26.8.96/27"  description = "RDS PostgreSQL Subnet B1" }

#Region & Availability Zones
variable "aws_region"       { default = "us-east-1"  description = "PROD region 1" }
variable "az_1"             { default = "us-east-1a"  description = "PROD az 1" }
variable "az_2"             { default = "us-east-1b"  description = "PROD az 2" }


##AMI

variable "ami" {
    default = {
        us-east-1_amz_hvm =       "ami-5e8c9625" # Amazon Linux AMI 2017.09.rc-0.20170913 x86_64 HVM GP2
        us-east-1_amz_hvm_rhel =  "ami-c998b6b2" # Red Hat Enterprise Linux 7.4 (HVM), SSD Volume Type
        }
    description = "Latest Available AMIs"
}


##Instance Type
variable "instance_type" {
    default = {
        bastion =           "t2.micro"
        application =       "t2.large"

    }
    description = "AWS instance type (must be compatible with corresponding AMI)"
}

##Key Pair
variable "key_name"      { default = "20171101-awsprodkey"  description = "Create and Download the mentioned key before applying" }

variable "ssh_user"      { default = "ubuntu"     description = "ssh user" }
variable "sshrhel_user"  { default = "ec2-user"   description = "ssh user" }

##ELB Certificate ARN

variable "web_ssl_certificate_id" { default =  "arn:aws:acm:us-east-1:215268188550:certificate/631548a8-2913-495a-9412-53eb2d835bc3"}


# ELB Account Numbers
##http://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html

variable "elb_account_number" {
    default = {
        us-east-1 = "127311923021"
        us-west-1 = "027434742980"
	eu-central-1 = "054676820928"
    }
}


#ELB

variable "http_port"  { default = "80"   description = "instance port" }
variable "https_port" { default = "443"  description = "ELB port" }


#RDS

variable "allocated_storage" {
  default = "200"
}

variable "engine_version" {
  default = "9.6.3"
}

variable "dbinstance_type" {
  default = "db.t2.large"
}

variable "storage_type" {
  default = "gp2"
}

#variable "vpc_id" {}

variable "database_identifier" {default = "soroco"}

variable "snapshot_identifier" {
  default = ""
}

variable "database_port" {
  default = "5432"
}

variable "backup_retention_period" {
  default = "7"
}

variable "backup_window" {
  # 03:00AM-03:30AM IST
  default = "21:30-22:00"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM IST
  default = "sun:19:00-sun:19:30"
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "final_snapshot_identifier" {
  default = "terraform-aws-postgresql-rds-snapshot"
}

variable "skip_final_snapshot" {
  default = true
}

variable "copy_tags_to_snapshot" {
  default = false
}

variable "multi_availability_zone" {
  default = true
}

variable "storage_encrypted" {
  default = false
}


