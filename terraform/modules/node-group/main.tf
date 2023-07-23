resource "yandex_kubernetes_node_group" "k8s_nodes" {
  cluster_id    = var.cluster_id
  name          = var.nodes_name

  instance_template {
    platform_id   = var.platform_id

    network_interface {
      nat         = var.nat
      subnet_ids  = [var.k8s_subnet_id]
    }

    resources {
      cores       = var.resources_cores
      memory      = var.resources_memory     
    }

    boot_disk {
      type        = var.disk_type
      size        = var.disk_size
    }

    scheduling_policy {
      preemptible = var.preemptible
    }

    container_runtime {
      type        = var.runtime_type
    }
  }

  scale_policy {
    auto_scale {
      min       = 1
      max       = 3
      initial   = 2
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      start_time = "03:00"
      duration   = "3h"
    }
  }
}
