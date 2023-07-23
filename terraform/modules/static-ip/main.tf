resource "yandex_vpc_address" "addr" {
  name                = var.ip_name
  description         = "Static IP for load balancer of K8s cluster"
  folder_id           = var.folder_id

  external_ipv4_address {
    zone_id             = var.zone
  }

  deletion_protection = var.deletion_protection
}
