output "tde_vpc_id" {
    value = "${aws_vpc.tde_vpc}"
 }
output "tde_public_subnets_id" {
  value  = ["${aws_subnet.tde_public_subnet.*.id}"]
}

output "tde_private_subnets_id" {
  value  = ["${aws_subnet.tde_private_subnet.*.id}"]
}

output "tde_securty_group_sg_id" {
  value  = "${aws_security_group.tde_securty_group.id}"
}

output "tde_security_groups_ids" {
  value  = ["${aws_security_group.tde_securty_group.id}"]
}

output "tde_public_route_table" {
  value  = "${aws_route_table.tde_route_table_public.id}"
}
