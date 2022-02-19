variable "enviroment" {
  description = "Prod VPC"
  default     = "prod"
}

variable "region" {
  description = "AWS Deployment region for Kubernetes implementation"
  default     = "us-east-1"
}

variable "tde_vpc_cidr" {
  description = "AWS VPC cidr"
  default     = "10.0.0.0/16"
}

variable "tde_public_subnets_cidr" {
  description = "AWS public subnet cidr"
  type        = list
  default     = ["10.0.1.0/24"]
}

variable "tde_private_subnets_cidr" {
  description = "AWS private subnet cidr"
  type        = list
  default     = ["10.0.2.0/24"]
}




