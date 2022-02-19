variable "enviroment" {
  description   = "VPC"
}
variable "region"{
    description = "AWS Deployment region for Kubernetes implementation"
    default     = "us-east-1"
}

variable "vpc_cidr" {
  description   = "AWS VPC cidr"
}

variable "tde_public_subnets_cidr" {
  description   = "AWS public subnet cidr"
}

variable "tde_private_subnets_cidr" {
  description   = "AWS public subnet cidr"
}

variable "tde_availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}
