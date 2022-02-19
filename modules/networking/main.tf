/**** VPC-thedatabaseengineer ***/
resource "aws_vpc" "tde_vpc" {
    cidr_block                = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags                      = {
                  name        = "${var.enviroment}-tde_vpc"
                  enviroment  = "${var.enviroment}"
                  managedby   = "terraform_tde"
    }
}

/**** subnet for vpc ****/
/***public subnet for TDE ***/
resource "aws_subnet" "tde_public_subnet" {
    vpc_id                    = "${aws_vpc.tde_vpc.id}"
    count                     = "${length(var.tde_public_subnets_cidr)}"
    cidr_block                = "${element(var.tde_public_subnets_cidr, count.index)}"
    availability_zone         = "${element(var.tde_availability_zones, count.index)}"
    map_public_ip_on_launch   = true
    tags                      = {
                  name        = "${var.enviroment}-${element(var.tde_availability_zones, count.index)}-tde_public_subnet"
                  enviroment  = "${var.enviroment}"
                  managedby   = "terraform_tde"
    }
}
/*** private subnet for TDE ***/
resource "aws_subnet" "tde_private_subnet" {
    vpc_id                    = "${aws_vpc.tde_vpc.id}"
    count                     = "${length(var.tde_private_subnets_cidr)}"
    cidr_block                = "${element(var.tde_private_subnets_cidr, count.index)}"
    availability_zone         = "${element(var.tde_availability_zones, count.index)}"
    map_public_ip_on_launch   = false
    tags                      = {
                  name        = "${var.enviroment}-${element(var.tde_availability_zones, count.index)}-tde_private_subnet"
                  enviroment  = "${var.enviroment}"
                  managedby   = "terraform_tde"
    }
}
/** routing table for public subnet **/
resource "aws_route_table" "tde_route_table_public" {
    vpc_id                    = "${aws_vpc.tde_vpc.id}"
    tags                      = {
                  name        = "${var.enviroment}-tde_route_table_public"
                  enviroment  = "${var.enviroment}"
                  managedby   = "terraform_tde"
    }
}
/** routing table for private subnet **/
resource "aws_route_table" "tde_route_table_private" {
    vpc_id                    = "${aws_vpc.tde_vpc.id}"
    tags                      = {
                  name        = "${var.enviroment}-tde_route_table_private"
                  enviroment  = "${var.enviroment}"
                  managedby   = "terraform_tde"
    }
}

/*** internet gateway for public subnet ***/
resource "aws_internet_gateway" "tde_igy" {
    vpc_id         = "${aws_vpc.tde_vpc.id}"
    tags           = {
        name       = "${var.enviroment}-tde_igy"
        enviroment = "${var.enviroment}"
        managedby  =  "terraform-tde"
    }
  }
/*** Elastic ip for NAT ***/
resource "aws_eip" "tde_eip" {
    vpc            = true
    depends_on     = [aws_internet_gateway.tde_igy]
    tags           = {
        name       = "${var.enviroment}-tde_eip"
        enviroment = "${var.enviroment}"
        managedby  =  "terraform-tde"
    }
  }
/***nat gateway for private subnet ***/
resource "aws_nat_gateway" "tde_ngy" {
    allocation_id  = "${aws_eip.tde_eip.id}"
    subnet_id      = "${element(aws_subnet.tde_public_subnet.*.id, 0)}"
    depends_on     = [
      aws_internet_gateway.tde_igy
    ]
    tags           = {
        name       = "${var.enviroment}-tde_ngy"
        enviroment = "${var.enviroment}"
        managedby  =  "terraform-tde"
    }
}
/*** route for public IGY subnet ***/
resource "aws_route" "tde_route_public_igy" {
    route_table_id         = "${aws_route_table.tde_route_table_public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.tde_igy.id}"
  }
/*** route for private NGY subnet ***/
resource "aws_route" "tde_route_private_ngy" {
    route_table_id         = "${aws_route_table.tde_route_table_private.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_nat_gateway.tde_ngy.id}"
  }
/*** route table assoication for public subnet ***/
resource "aws_route_table_association" "tde_rta_public" {
    count          = "${length(var.tde_public_subnets_cidr)}"
    subnet_id      = "${element(aws_subnet.tde_public_subnet.*.id , count.index)}"
    route_table_id = "${aws_route_table.tde_route_table_public.id}"
  }
/*** route table assoication for private subnet ***/
resource "aws_route_table_association" "tde_rta_private" {
    count          = "${length(var.tde_private_subnets_cidr)}"
    subnet_id      = "${element(aws_subnet.tde_private_subnet.*.id , count.index)}"
    route_table_id = "${aws_route_table.tde_route_table_private.id}"
  }
/*** securty group for VPC ***/
resource "aws_security_group" "tde_securty_group" {
    name           = "${var.enviroment}-default-sg"
    description    = "Default security group to allow inbound and outbound from vpc"
    vpc_id         = "${aws_vpc.tde_vpc.id}"
    depends_on     = [
      aws_vpc.tde_vpc
    ]
    ingress {
        from_port  = "0"
        to_port    = "0"
        protocol   = "-1"
        self       = true
    }
    egress  {
      from_port    = "0"
      self         = true
      to_port      = "0"
      protocol     = "-1"
    } 
    tags           = {
        name       = "${var.enviroment}-tde_securty_group"
        enviroment = "${var.enviroment}"
        managedby  =  "terraform-tde"
    }
}
