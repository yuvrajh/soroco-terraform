variable "allocated_storage" {
  default = "200"
}

variable "engine_version" {
  default = "9.6.3"
}

variable "dbinstance_type" {
  default = "db.m4.2xlarge"
}

variable "storage_type" {
  default = "gp2"
}

#variable "vpc_id" {}

variable "database_identifier" {default = "soroco"}

variable "snapshot_identifier" {
  default = ""
}

variable "database_name" {default = "soroco"}

variable "database_password" {default = "$0r0c0$7orm"}

variable "database_username" {default = "soroco"}

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

