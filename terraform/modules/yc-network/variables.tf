variable "vpc_subnet_zone" {
  default     = "ru-central1-a"
  type        = string
  description = "Default zone for infrastructure"
  validation {
    condition     = contains(toset(["ru-central1-a", "ru-central1-b", "ru-central1-c"]), var.vpc_subnet_zone)
    error_message = "Select availability zone from the list: ru-central1-a, ru-central1-b, ru-central1-c."
  }
  nullable    = false
}

variable "yc_network_name" {
  default     = "k8s-net"
  type        = string
  description = "The name for the network"
  nullable    = false
}

variable "folder_id" {
  default     = "b1gs8bb343i69r2ftqng"
  type        = string
  description = "ID of folder on Yandex Cloud"
  nullable    = false
}

variable "subnet" {
  default     = "10.2.0.0/16"
  type        = string
  description = "Network subnet for cluster"
  nullable    = false
}
