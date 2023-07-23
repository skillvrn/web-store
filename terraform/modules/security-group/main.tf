resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = var.security_group_name
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = var.k8s_network_id
  
  ingress {
    protocol          = "TCP"
    description       = "Проверки доступности с диапазона адресов балансировщика нагрузки"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ANY"
    description       = "Разрешает взаимодействие под-под и сервис-сервис"
    v4_cidr_blocks    = concat(var.k8s_cidr_blocks)
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    protocol          = "ICMP"
    description       = "ICMP-пакеты c внутренних подсетей"
    v4_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
 
  ingress {
    protocol          = "TCP"
    description       = "Из интернета на диапазон портов NodePort"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 32767
  }

  ingress {
    protocol          = "ICMP"
    description       = "ICMP-пакеты из интернета на кластер"
    v4_cidr_blocks    = ["0.0.0.0/0"]
  }

  egress {
    protocol          = "ANY"
    description       = "Исходящий трафик"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
}
