resource "yandex_kubernetes_cluster" "k8s-zonal" {
  network_id              = var.k8s_network_id

  master {
    version               = var.k8s_version
    zonal {
      zone      = var.zone
      subnet_id = var.k8s_subnet_id
    }

    public_ip             = true

    security_group_ids    = ["${var.security_group_ids}"]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  release_channel         = "STABLE"

  kms_provider {
    key_id = var.kms_key_id
  }
}
