##Bastion Host

resource "aws_instance" "ec2_bastion" {
    ami =                   "${lookup(var.ami, "${var.aws_region}_amz_hvm")}"
    instance_type =         "${lookup(var.instance_type, "bastion")}"
    key_name =              "${var.key_name}"
    monitoring =            true
    source_dest_check =     false
    iam_instance_profile =  "${aws_iam_instance_profile.default_iam_instance_profile.name}"
    subnet_id =             "${aws_subnet.subnet_public_dmz.id}"
	root_block_device {
        volume_type           = "gp2"
        volume_size           = 10
        delete_on_termination = true
    }
 
    vpc_security_group_ids = [
        "${aws_security_group.sg_bastion.id}"
    ]

    tags {
        Environment =       "${var.environment}"
        Name =              "${var.project}_bastion_server"
        Version =           "${var.version}"
    }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.ec2_bastion.id}"
  allocation_id = "${aws_eip.elastic_ip_bastion_host.id}"
}

# Outputs

output "Bastion SSH" {
    value = "ssh -A ${var.ssh_user}@${aws_instance.ec2_bastion.public_dns}"
}
