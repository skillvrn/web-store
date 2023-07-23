resource "yandex_vpc_network" "k8s-net" {
  name = var.yc_network_name
}

resource "yandex_vpc_subnet" "k8s-subnet" {
  v4_cidr_blocks = [var.subnet]
  zone           = var.vpc_subnet_zone
  network_id     = yandex_vpc_network.k8s-net.id
}
