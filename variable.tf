variable "rg_name" {
  type        = string
  description = "grup name"
  default     = "app_grp"
}
variable "location" {
  type        = string
  description = "location"
  default     = "North Europe"
}
variable "VN_address_space" {
  type        = string
  description = "addrress space of VN"
  default     = "10.0.0.0/16"
}

variable "Subnets_names" {
  type        = list(string)
  description = "Names of subnets"
  default     = ["prod_subnet", "dev_subnet"]
}

variable "Subnets_addresses" {
  type        = list(string)
  description = "Addresses of subnets"
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}
