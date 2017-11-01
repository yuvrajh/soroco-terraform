### Security Groups

# Alphabetical order, please...


# ELB
resource "aws_security_group" "sg_elb" {
    description =       "Allows HTTPS traffic to the elb"
    name =              "${var.project}_sg_elb"
    vpc_id =            "${aws_vpc.vpc_soroco.id}"
	
	#HTTPS
	ingress {
        from_port =     443
        to_port =       443
        protocol =      "tcp"
        cidr_blocks =   ["0.0.0.0/0"]
    }
	#HTTP
        ingress {
        from_port =     80
        to_port =       80
        protocol =      "tcp"
        cidr_blocks =   ["0.0.0.0/0"]
    }


    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_elb"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}


# APPLICATION SERVER SG
resource "aws_security_group" "sg_application" {
    description =       "Allows HTTP/HTTPS traffic to the APP from ELB"
    name =              "${var.project}_sg_app"
    vpc_id =            "${aws_vpc.vpc_soroco.id}"
	
	#HTTP
    ingress {
        from_port =     80
        to_port =       80
        protocol =      "tcp"
	security_groups = ["${aws_security_group.sg_elb.id}"]
    }
	
	# SSH
    ingress {
        from_port =     22
        to_port =       22
        protocol =      "tcp"
        security_groups = ["${aws_security_group.sg_bastion.id}"]
    }


    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_app"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
   }
}


# Bastion
resource "aws_security_group" "sg_bastion" {
    description =       "Allows SSH traffic to the Bastion"
    name =              "${var.environment}_sg_bastion"
    vpc_id =            "${aws_vpc.vpc_soroco.id}"

    ingress {
        from_port =     22
        to_port =       22
        protocol =      "tcp"
        cidr_blocks =   ["183.87.61.58/32", "219.65.95.10/32"]
    }

    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_bastion"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}


# SG_RDS_PostgreSQL
resource "aws_security_group" "sg_postgresql" {
    description =       "Allows DB connection to the App"
    name =              "${var.project}_sg_postgresql"
    vpc_id =            "${aws_vpc.vpc_soroco.id}"


    #PostgreSQL
    ingress {
        from_port =     5432
        to_port =       5432
        protocol =      "tcp"
        security_groups = ["${aws_security_group.sg_application.id}"]
    }


    egress {
        from_port =     0
        to_port =       0
        protocol =      "-1"
        cidr_blocks =   ["0.0.0.0/0"]
    }

    tags {
        Name =          "${var.project}_sg_bastion"
        Environment =   "${var.environment}"
        Version =       "${var.version}"
    }
}


