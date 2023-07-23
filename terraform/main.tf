module "yc-network" {
  source             = "./modules/yc-network"
  vpc_subnet_zone    = var.zone
}

module "service-account" {
  source             = "./modules/service-account"
  folder_id          = var.folder_id
}

module "kms-key" {
  source             = "./modules/kms-key"
}

module "security-group" {
  source             = "./modules/security-group"
  k8s_network_id     = module.yc-network.k8s_network.id
  k8s_cidr_blocks    = module.yc-network.k8s_subnet.v4_cidr_blocks
}

module "static-ip" {
  source             = "./modules/static-ip"
  zone               = var.zone
  folder_id          = var.folder_id
}

module "grafana-disk" {
  source             = "./modules/grafana-disk"
  zone               = var.zone
}

module "k8s-cluster" {
  source             = "./modules/k8s-cluster"
  zone               = var.zone
  k8s_network_id     = module.yc-network.k8s_network.id
  k8s_subnet_id      = module.yc-network.k8s_subnet.id
  security_group_ids = module.security-group.sec_group.id
  service_account_id = module.service-account.service_account_id.id
  kms_key_id         = module.kms-key.kms_key.id
  depends_on = [
    module.service-account
  ]
}

module "node-group" {
  source             = "./modules/node-group"
  cluster_id         = module.k8s-cluster.k8s_cluster.id
  k8s_subnet_id      = module.yc-network.k8s_subnet.id
  zone               = var.zone
}
