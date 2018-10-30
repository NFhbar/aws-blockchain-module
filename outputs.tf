output "security_group_id" {
  value = "${module.blockchain_sg.this_security_group_id}"
}

output "instance_ids" {
  value = "${module.blockchain_ec2.id}"
}
