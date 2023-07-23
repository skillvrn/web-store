variable "sa_name" {
  default     = "k8s-account"
  type        = string
  description = "K8S zonal service account"
  nullable    = false
}

variable "folder_id" {
  default     = "b1gs8bb343i69r2ftqng"
  type        = string
  description = "ID of folder on Yandex Cloud"
  nullable    = false
}
