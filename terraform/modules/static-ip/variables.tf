variable "ip_name" {
  default     = "k8s-ip"
  type        = string
  description = "K8S zonal IP address"
  nullable    = false
}

variable "zone" {
  type        = string
  description = "Default zone for infrastructure"
  nullable    = false
}

variable "folder_id" {
  default     = "b1gs8bb343i69r2ftqng"
  type        = string
  description = "ID of folder on Yandex Cloud"
  nullable    = false
}

variable "deletion_protection" {
  default     = true
  type        = bool
  description = "Flag that protects the address from accidental deletion"
}
