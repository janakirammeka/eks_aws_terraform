resource "random_id" "random_id_prefix" {
  byte_length = 2
}
/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}
module "networking" {
  source = "../../modules/networking"

  region                   = var.region
  enviroment               = var.enviroment
  vpc_cidr                 = var.tde_vpc_cidr
  tde_public_subnets_cidr  = var.tde_public_subnets_cidr
  tde_private_subnets_cidr = var.tde_private_subnets_cidr
  tde_availability_zones   = local.production_availability_zones

}
