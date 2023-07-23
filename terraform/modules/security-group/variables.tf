variable "security_group_name" {
  default     = "k8s-public-services"
  type        = string
  description = "A name for security group for connection from WAN"
  nullable    = false
}

variable "k8s_network_id" {
  type        = string
  description = "ID of network for cluster"
  nullable    = false
}

variable "k8s_cidr_blocks" {
  type        = list
  description = "IPv4 CIDR blocks of network for cluster"
  nullable    = false
}
