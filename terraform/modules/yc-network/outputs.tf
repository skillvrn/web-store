output "k8s_network" {
  value = yandex_vpc_network.k8s-net
}

output "k8s_subnet" {
  value = yandex_vpc_subnet.k8s-subnet
}
