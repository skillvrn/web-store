resource "yandex_compute_disk" "grafana-disk" {
  name     = var.disk_name
  type     = var.disk_type
  zone     = var.zone
  size     = var.disk_size
  image_id = var.disk_image_id
}
