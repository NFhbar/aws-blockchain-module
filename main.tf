# Security Group Module
# https://github.com/terraform-aws-modules/terraform-aws-security-group
module "blockchain_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name}-${var.blockchain}-sg"
  description = "Security group for ${var.blockchain}"
  vpc_id      = "${var.vpc_id}"

  ingress_with_cidr_blocks = [
    {
      from_port   = "${var.blockchain_port}"
      to_port     = "${var.blockchain_port}"
      protocol    = "tcp"
      description = "${var.blockchain} ingress ports"
      cidr_blocks = "${var.cidr_blocks}"
    },
  ]

  egress_rules = ["all-all"]
}

# Conditional Security Group Module
# https://github.com/terraform-aws-modules/terraform-aws-security-group
module "ssh_blockchain_sg" {
  source = "terraform-aws-modules/security-group/aws"

  create              = "${var.ssh}"
  name                = "${var.name}-${var.blockchain}-ssh-sg"
  description         = "SSH Security group for ${var.blockchain}"
  vpc_id              = "${var.vpc_id}"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
}

# Template for Blockchain Initialization
data "template_file" "setup_blockchain" {
  template = "${file("${path.module}/templates/${var.blockchain}.tpl")}"

  vars {
    user        = "${var.user}"
    pass        = "${var.pass}"
    testnet_opt = "${var.testnet}"
  }
}

# EC2 Module with Volume
# https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
# no-key is a key pair which no one has access to
module "blockchain_ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  instance_count              = "${var.instance_count}"
  name                        = "${var.name}-${var.blockchain}-i"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet}"
  vpc_security_group_ids      = "${split(" ", var.ssh ? "${module.blockchain_sg.this_security_group_id} ${module.ssh_blockchain_sg.this_security_group_id}" :  module.blockchain_sg.this_security_group_id)}"
  associate_public_ip_address = true
  key_name                    = "${var.ssh ? var.ssh_key : "no-key"}"
  user_data                   = "${data.template_file.setup_blockchain.rendered}"

  root_block_device = [{
    volume_type           = "gp2"
    volume_size           = "${var.size}"
    delete_on_termination = true
  }]
}
