
variable "version" {
    default = "1.0.0"
    description = "The version of TF"
}

variable "environment"      { default = "staging"   description = "ENV" }
variable "project"          { default = "SOROCO"   description = "PROJECT" }
variable "aws_account_id"   { default = "480833364711" description = "replace with your aws account id" }
variable "aws_account_number"   { default = "480833364711" description = "replace with your aws account id" }

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
variable "aws_region"       { default = "ap-south-1"  description = "PROD region 1" }
variable "az_1"             { default = "ap-south-1a"  description = "PROD az 1" }
variable "az_2"             { default = "ap-south-1b"  description = "PROD az 2" }


##AMI

variable "ami" {
    default = {
        ap-south-1_amz_hvm =       "ami-099fe766" # Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
        ap-south-1_amz_hvm_rhel =  "ami-e41b618b" # Red Hat Enterprise Linux 7.4 (HVM), SSD Volume Type
        ap-south-1_amz_hvm_awslinux     =       "ami-2ed19c41" # Amazon Linux AMI 2017.09.1 (HVM), SSD Volume Type
        }
    description = "Latest Available AMIs"
}


##Instance Type
variable "instance_type" {
    default = {
        bastion =           "t2.micro"
        application =       "t2.medium"

    }
    description = "AWS instance type (must be compatible with corresponding AMI)"
}

##Key Pair
variable "key_name"      { default = "hdfclife-app"  description = "Create and Download the mentioned key before applying" }
variable "tkey_name"      { default = "terraform-key"  description = "Create and Download the mentioned key before applying" }

variable "ssh_user"      { default = "ubuntu"     description = "ssh user" }
variable "sshrhel_user"  { default = "ec2-user"   description = "ssh user" }

##ELB Certificate ARN

variable "web_ssl_certificate_id" { default =  "arn:aws:acm:ap-south-1:480833364711:certificate/44882d94-447a-474c-90cb-6ef9af8b6a90"}


# ELB Account Numbers
##http://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html

variable "elb_account_number" {
    default = {
        us-east-1 = "127311923021"
        us-west-1 = "027434742980"
	eu-central-1 = "054676820928"
        ap-south-1 = "718504428378"
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

#ASG Script

variable "desired_cluster_size_script" {default = 1 description = "desired" }
variable "min_cluster_size_script"     {default = 1 description = "min" }
variable "max_cluster_size_script"     {default = 1 description = "max" }
