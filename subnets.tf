# DMZ

resource "aws_subnet" "subnet_public_dmz" {
    vpc_id = "${aws_vpc.vpc_soroco.id}"
    cidr_block = "${var.soroco_dmz}"
    availability_zone = "${var.az_1}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.project}-Public-1a"
        Environment = "${var.environment}"
        Version = "${var.version}"
    }
}

resource "aws_subnet" "subnet_public_dmz2" {
    vpc_id = "${aws_vpc.vpc_soroco.id}"
    cidr_block = "${var.soroco_dmz2}"
    availability_zone = "${var.az_2}"
    map_public_ip_on_launch = true

    tags {
        Name = "${var.project}-Public-1b"
        Environment = "${var.environment}"
        Version = "${var.version}"
    }
}



# Private Subnets

resource "aws_subnet" "subnet_private_application1" {
    vpc_id = "${aws_vpc.vpc_soroco.id}"
    cidr_block = "${var.soroco_a}"
    availability_zone = "${var.az_1}"

    tags {
        Name = "${var.project}-application-1a"
        Environment = "${var.environment}"
        Version = "${var.version}"
    }
}

resource "aws_subnet" "subnet_private_application2" {
    vpc_id = "${aws_vpc.vpc_soroco.id}"
    cidr_block = "${var.soroco_a1}"
    availability_zone = "${var.az_2}"

    tags {
        Name = "${var.project}-application-1b"
        Environment = "${var.environment}"
        Version = "${var.version}"
    }
}


resource "aws_subnet" "subnet_private_postgresql1" {
    vpc_id = "${aws_vpc.vpc_soroco.id}"
    cidr_block = "${var.soroco_b}"
    availability_zone = "${var.az_1}"

    tags {
        Name = "${var.project}-postgresql-1a"
        Environment = "${var.environment}"
        Version = "${var.version}"
    }
}

resource "aws_subnet" "subnet_private_postgresql2" {
    vpc_id = "${aws_vpc.vpc_soroco.id}"
    cidr_block = "${var.soroco_b1}"
    availability_zone = "${var.az_2}"

    tags {
        Name = "${var.project}-postgresql-1b"
        Environment = "${var.environment}"
        Version = "${var.version}"
    }
}

