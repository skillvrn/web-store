variable "zone" {
  type        = string
  description = "Default zone for infrastructure"
  nullable    = false
}

variable "cluster_id" {
  type        = string
  description = "ID of K8s cluster for creating nodes"
  nullable    = false
}

variable "nodes_name" {
  default     = "k8s-nodes"
  type        = string
  description = "Name of nodes for K8s clister"
  nullable    = false
}

variable "platform_id" {
  default     = "standard-v1"
  type        = string
  description = "Platfom ID for nodes"
  nullable    = false
}

variable "runtime_type" {
  default     = "containerd"
  type        = string
  description = "Platfom runtime type for nodes"
  nullable    = false
}

variable "k8s_subnet_id" {
  type        = string
  description = "Network subnet ID for K8s cluster"
  nullable    = false
}

variable "disk_type" {
  default     = "network-hdd"
  type        = string
  description = "Disk type for nodes"
  nullable    = false
}

variable "disk_size" {
  default     = 30
  type        = string
  description = "Size of the disk in GB"
  nullable    = false
}

variable "resources_cores" {
  default     = 2
  type        = number
  description = "CPU cores for nodes"
  nullable    = false
}

variable "resources_memory" {
  default     = 4
  type        = number
  description = "RAM size in GB for nodes"
  nullable    = false
}

variable "preemptible" {
  default     = true
  type        = bool
  description = "Specifies if the machine is preemptible"
}

variable "nat" {
  default     = true
  type        = bool
  description = "Provide a public address, for instance, to access from Internet"
}
