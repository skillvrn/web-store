variable "disk_name" {
  default     = "grafana-disk"
  type        = string
  description = "Name for disk which will be used for Grafana in K8s cluster as Persistent Volume"
  nullable    = false
}

variable "zone" {
  type        = string
  description = "Default zone for infrastructure"
  nullable    = false
}

variable "disk_type" {
  default     = "network-hdd"
  type        = string
  description = "Flag that protects the address from accidental deletion"
  nullable    = false
}

variable "disk_size" {
  default     = "1"
  type        = number
  description = "Size of new Disk"
  nullable    = false
}

variable "disk_image_id" {
  default     = "fd8s0rs9nmtku47an507"
  type        = string
  description = "Image for starting Grafana"
  nullable    = false
}
