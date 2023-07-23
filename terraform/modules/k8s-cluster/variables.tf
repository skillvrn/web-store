variable "k8s_version" {
  default     = "1.24"
  type        = string
  description = "Version of installed K8s"
  nullable    = false
}

variable "zone" {
  type        = string
  description = "Default zone for infrastructure"
  nullable    = false
}

variable "k8s_network_id" {
  type        = string
  description = "ID of network for K8s cluster"
  nullable    = false
}

variable "k8s_subnet_id" {
  type        = string
  description = "Network subnet ID for K8s cluster"
  nullable    = false
}

variable "security_group_ids" {
  type        = string
  description = "List IDs of vpc security group"
  nullable    = false
}

variable "service_account_id" {
  type        = string
  description = "ID of service account for terraform"
  nullable    = false
}

variable "kms_key_id" {
  type        = string
  description = "KMS key id for terraform"
  nullable    = false
}
