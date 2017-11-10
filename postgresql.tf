#Postgre-SQL RDS Multi-AZ

resource "aws_db_instance" "postgresql" {
  allocated_storage          = "${var.allocated_storage}"
  engine                     = "postgres"
  engine_version             = "${var.engine_version}"
  identifier                 = "${var.database_identifier}"
  snapshot_identifier        = "${var.snapshot_identifier}"
  instance_class             = "${var.dbinstance_type}"
  storage_type               = "${var.storage_type}"
  name                       = "${var.database_name}"
  password                   = "${var.database_password}"
  username                   = "${var.database_username}"
  backup_retention_period    = "${var.backup_retention_period}"
  backup_window              = "${var.backup_window}"
  maintenance_window         = "${var.maintenance_window}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  final_snapshot_identifier  = "${var.final_snapshot_identifier}"
  skip_final_snapshot        = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot      = "${var.copy_tags_to_snapshot}"
  multi_az                   = "${var.multi_availability_zone}"
  port                       = "${var.database_port}"
  vpc_security_group_ids     = ["${aws_security_group.sg_postgresql.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.postgre_sg.name}"
  parameter_group_name       = "${aws_db_parameter_group.postgres_pg.name}"
  storage_encrypted          = "${var.storage_encrypted}"
  monitoring_interval        = "60"

  tags {
    Name        = "${var.project}-postgresql"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}


resource "aws_db_subnet_group" "postgre_sg" {
  name       = "postgresmainsg"
  subnet_ids = ["${aws_subnet.subnet_private_postgresql1.id}", "${aws_subnet.subnet_private_postgresql2.id}"]

  tags {
    Name = "soroco-pg-subnetgroup"
  }
}

resource "aws_db_parameter_group" "postgres_pg" {
  name   = "postgres-pg"
  description = "postgres-pg9.6"
  family = "postgres9.6"
}


output "dbendpoint" {
  value = "${aws_db_instance.postgresql.endpoint}"
}
