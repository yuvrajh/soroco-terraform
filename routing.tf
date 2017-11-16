### Route tables

# REMINDER: A subnet can only be associated with one route table at a time,
# but you can associate multiple subnets with the same route table.

# Main Route Table

# We leave the MRT alone and don't associate with it.
# If anything auto-assocaiates, its default route is safe

resource "aws_route_table" "rt_igw" {
    vpc_id =                "${aws_vpc.vpc_soroco.id}"
    route {
        cidr_block =        "0.0.0.0/0"
        gateway_id =        "${aws_internet_gateway.igw_soroco.id}"
    }

    tags {
        Environment =       "${var.environment}"
        Name =              "${var.project}_rt_igw"
        Version =           "${var.version}"
    }
}

# Route to NAT Gateway
resource "aws_route_table" "rt_nat_gw" {
    vpc_id =                "${aws_vpc.vpc_soroco.id}"
    route {
        cidr_block =        "0.0.0.0/0"
        nat_gateway_id =    "${aws_nat_gateway.nat_gateway_a.id}"
    }
        tags {
        Environment =       "${var.environment}"
        Name =              "${var.project}_rt_nat_a"
        Version =           "${var.version}"
    }
}

# Route to LOCAL For RDS
resource "aws_route_table" "rt_rds" {
        vpc_id =                "${aws_vpc.vpc_soroco.id}"
        route {
        cidr_block =        "0.0.0.0/0"
        nat_gateway_id =    "${aws_nat_gateway.nat_gateway_a.id}"
        }
    
        tags {
        Environment =       "${var.environment}"
        Name =              "${var.project}_rt_rds"
        Version =           "${var.version}"
    }
}

# NAT/IGW Associations
resource "aws_route_table_association" "rta_igw" {
    subnet_id =             "${aws_subnet.subnet_public_dmz.id}"
    route_table_id =        "${aws_route_table.rt_igw.id}"
}

##subnet_public_dmz2

resource "aws_route_table_association" "rta_igw1" {
    subnet_id =             "${aws_subnet.subnet_public_dmz2.id}"
    route_table_id =        "${aws_route_table.rt_igw.id}"
}


resource "aws_route_table_association" "rta_nat_gw_a" {
    subnet_id =             "${aws_subnet.subnet_private_application1.id}"
    route_table_id =        "${aws_route_table.rt_nat_gw.id}"
}

resource "aws_route_table_association" "rta_nat_gw_a1" {
    subnet_id =             "${aws_subnet.subnet_private_application2.id}"
    route_table_id =        "${aws_route_table.rt_nat_gw.id}"
}

resource "aws_route_table_association" "rta_rds_b" {
    subnet_id =             "${aws_subnet.subnet_private_postgresql1.id}"
    route_table_id =        "${aws_route_table.rt_rds.id}"
}

resource "aws_route_table_association" "rta_rds_b1" {
    subnet_id =             "${aws_subnet.subnet_private_postgresql2.id}"
    route_table_id =        "${aws_route_table.rt_rds.id}"
}
