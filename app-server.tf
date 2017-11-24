##APP1 SERVER

resource "aws_instance" "ec2_app1" {
    ami =                   "${lookup(var.ami, "${var.aws_region}_amz_hvm_rhel")}"
    instance_type =         "${lookup(var.instance_type, "application")}"
    key_name =              "${var.key_name}"
    monitoring =            true
    source_dest_check =     false
    iam_instance_profile =  "${aws_iam_instance_profile.default_iam_instance_profile.name}"
    subnet_id =             "${aws_subnet.subnet_private_application1.id}"
	root_block_device {
        volume_type           = "gp2"
        volume_size           = 100
        delete_on_termination = false
    }
    vpc_security_group_ids = [
        "${aws_security_group.sg_application.id}"
        ]

    tags {
        Environment =       "${var.environment}"
        Name =              "${var.project}_app_server_a"
        Version =           "${var.version}"
    }
}


# Outputs

output "APP1 SSH" {
    value = "ssh -A ${var.sshrhel_user}@${aws_instance.ec2_app1.private_dns}"
}

##APP2 SERVER

resource "aws_instance" "ec2_app2" {
    ami =                   "ami-f53f719a"
    instance_type =         "${lookup(var.instance_type, "application")}"
    key_name =              "${var.key_name}"
    monitoring =            true
    source_dest_check =     false
    iam_instance_profile =  "${aws_iam_instance_profile.default_iam_instance_profile.name}"
    private_ip  =   "172.26.8.42"
    subnet_id =             "${aws_subnet.subnet_private_application2.id}"
        root_block_device {
        volume_type           = "gp2"
        volume_size           = 100
        delete_on_termination = true
    }
    vpc_security_group_ids = [
        "${aws_security_group.sg_application.id}"
        ]

    tags {
        Environment =       "${var.environment}"
        Name =              "${var.project}_app_server_b"
        Version =           "${var.version}"
    }
}


# Outputs

output "APP2 SSH" {
    value = "ssh -A ${var.sshrhel_user}@${aws_instance.ec2_app2.private_dns}"
}

