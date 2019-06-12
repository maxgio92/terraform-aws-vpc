variable "vpc_cidr" {
  type        = "string"
  description = "The CIDR block of the VPC"
}

variable "enable_dns_hostnames" {
  default     = true
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults true."
}

variable "public_subnet_count" {
  default     = "2"
  description = "How much public subnets to create"
}

variable "public_subnet_mask_newbits" {
  default     = "8"
  description = "The number of bits of the public subnet mask to add to the ones of the VPC's subnet mask. E.g: VPC's CIDR block: 10.0.0.0/8 (8 bits subnet mask); private subnet's CIDR block: 10.0.0.0/16 (16 bits subnet mask, 8 new bits). "
}

variable "private_subnet_count" {
  default     = "2"
  description = "How much private subnets to create"
}

variable "private_subnet_mask_newbits" {
  default     = "8"
  description = "The number of bits of the private subnet mask to add to the ones of the VPC's subnet mask. E.g: VPC's CIDR block: 10.0.0.0/8 (8 bits subnet mask); private subnet's CIDR block: 10.0.0.0/16 (16 bits subnet mask, 8 new bits). "
}

variable "prefix_name" {
  type        = "string"
  description = "The prefix name for the resources of the VPC"
  default     = "my"
}

variable "default_tags" {
  type        = "map"
  description = "The default tags to apply to the resoures of the VPC"

  default = {
    Terraform = "true"
  }
}
