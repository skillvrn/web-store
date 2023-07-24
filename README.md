# Инфраструктура

## Зависимости

| Элемент | Значение | 
|--------------|-----------|
| terraform.required_providers | >= 0.94 |
| terraform.version | >= 1.4.0 |
| Yandex Cloud CLI | 0.108.1 |
| kubectl | v5.0.1 |
| helm | v3.12.0 |

## Создание инфраструктуры

### Подготовительные работы

- [Зарегистрировать аккаунт в Яндекс.Облаке](https://cloud.yandex.ru/docs/billing/quickstart/)
- [Создать каталог](https://cloud.yandex.ru/docs/resource-manager/operations/folder/create)
- [Создать сервисный аккаунт с правами `Editor` для управления ресурсами](https://cloud.yandex.ru/docs/iam/quickstart-sa#create-sa)
- [Создать статический ключ для сервисного аккаунта](https://cloud.yandex.ru/docs/iam/concepts/authorization/key)
- Создать Object Storage S3 бакет для хранения состояния terraform
- Создать Object Storage S3 бакет для хранения медиа файлов приложения

### Получение доступа к управлению через YC CLI

- [Установить YC](https://cloud.yandex.ru/docs/cli/quickstart)
- [По сгенерированному статическому ключу настроить доступ к своему каталогу в облаке](https://cloud.yandex.ru/docs/cli/quickstart)
- [Установить terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Для безопасности, в работе обычно использовался IAM_Token, который необходимо периодически обновлять и записывать в `terraform/terraform.tfvars` в формате:

`iam_token="..."`

*Файл добавлен в исключения в .gitignore*

### Создание инфраструктуры в автоматическом режиме

- Загрузите репозиторий

```
git clone git@github.com:skillvrn/web-store.git
```

- Перейти в директорию с тераформом

```
cd web-store/terraform
```

- По необходимости отредактировать переменные:

| Название переменной | Адрес файла | Значение по умолчанию | Назначение |
|--------------|-----------|------------|------------|
| `cloud_id` | `variables.tf` | `b1g1kocv9lk6m51luk8o` | ID облака в YC |
| `folder_id` | `variables.tf` | `b1gs8bb343i69r2ftqng` | ID каталога в YC |
| `zone` | `variables.tf` | `ru-central1-a` | Зона доступности для создания объектов |
| `ip_name` | `modules/static-ip/variables.tf` | `k8s-ip` | Название для статического IP адреса |
| `deletion_protection` | `modules/static-ip/variables.tf` | `true` | Флаг запрета на удаление статического IP-адреса |
| `vpc_subnet_zone` | `modules/yc-network/variables.tf` | `ru-central1-a` | Зона доступности для создания сети и подсетей |
| `yc_network_name` | `modules/yc-network/variables.tf` | `k8s-net` | Имя для сети |
| `subnet` | `modules/yc-network/variables.tf` | `10.2.0.0/16` | Идентификатор и CIDR подсети для кластера |
| `disk_name` | `modules/grafana-disk/variables.tf` | `disk_name` | Название диска для подключения к Grafana Pod |
| `disk_type` | `modules/grafana-disk/variables.tf` | `network-hdd` | Тип диска, который будет создан |
| `disk_size` | `modules/grafana-disk/variables.tf` | `1` | Размер диска в Гигабайтах |
| `disk_image_id` | `modules/grafana-disk/variables.tf` | `fd8s0rs9nmtku47an507` | Образ диска с полностью готовой конфигурацией Grafana |
| `sa_name` | `modules/service-account/values.tf` | `k8s-account` | Название для сервисного аккаунта |
| `security_group_name` | `modules/security-group/values.tf` | `k8s-public-services` | Название для политики безопасности |
| `kms_key_name` | `modules/kms-key/values.tf` | `kms_key_name` | Название для ключа авторизации |
| `k8s_version` | `modules/k8s-cluster/values.tf` | `1.24` | Версия Kubernetes |
| `nodes_name` | `modules/node-group/values.tf` | `k8s-nodes` | Название для группы инстансов кластера |
| `platform_id` | `modules/node-group/values.tf` | `standard-v1` | Идентификатор платформы для node-group |
| `runtime_type` | `modules/node-group/values.tf` | `containerd` | Тип runtime платформы для Nodes |
| `disk_type` | `modules/node-group/values.tf` | `network-hdd` | Тип дисковой системы для использования на Nodes |
| `disk_size` | `modules/node-group/values.tf` | `30` | Размер дисков на Node'ах в Гигабайтах |
| `resources_cores` | `modules/node-group/values.tf` | `2` | Количество ядер CPU для Nodes |
| `resources_memory` | `modules/node-group/values.tf` | `4` | Объем оперативной памяти на Nodes |
| `preemptible` | `modules/node-group/values.tf` | `true` | Флаг, отвечающий за тип ВМ по режиму работы (прерываемая или нет) |
| `nat` | `modules/node-group/values.tf` | `true` | Флаг, указывающий, будут ли ВМ для нужд кластера получать доступ в Интернет |

- Создайте новый token для доступа к облаку тераформом

```
yc iam create-token
```

- Запишите полученный ключ в переменную (описано выше)
- Прописать доступ к S3 для хранения состояния teraform

В каталоге `terraform/` необходимо создать файл `config.s3.tfbackend` и в него записать данные для доступа к бакету тераформом в формате:

```
access_key="************"
secret_key="************"
```

- Выполните:

```
terraform init
terraform apply -auto-approve
```

При этом будут созданы следующие объекты:

1. Статический IP-адрес (в спецификации указано, что данный объект удалять нельзя - сделано, чтобы не править DNS-записи)
2. Сеть и подсети для master и worker Nodes
3. Диск на основе сохраненного образа с готовым конфигом и дашбордами для монтирования его к поду Grafana
4. Сервисный аккаунт с необходимыми правами для работы с кластером
5. Политику сетевых правил, разрешающей подключение к сервисам из интернета и наоборот
6. Ключ шифрования Yandex Key Management Service для шифрования важной информации
7. Кластер Managed Service for Kubernetes
8. Виртуальные машины для K8s кластера
9. Файл состояния тераформа в S3

При создании кластера назначается группа безопасности, а также сервисный аккаунт для управления кластером и нодами.

После создания каждого объекта терраформ делает вывод необходимых данных для передачи в смежные модули. Все зависимости описаны в корневой спецификации main.tf.
Примерное время выполнения - 10 минут.

### Создание доступа в кластер для непрерывной интеграции

- Вернитесь в корень репозитория

```
cd ../
```

- Выведите список кластеров облака:

```
yc managed-kubernetes cluster list
```

- Создайте конфигурацию для внешнего подключения к кластеру:

```
yc managed-kubernetes cluster get-credentials <cluster_id> --external --kubeconfig ./.kube/config
```

- [Установите kubectl](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
- Создайте в кластере 3 объекта (ClusterRoleBinding, Secret и ServiceAccount) при помощи подготовленного манифеста:

```
kubectl create -f scripts/sa.yaml
```

- Сгенерируйте сертификат и конфигурационный файл для дальнейшего его использования в CI/CD

```
./scripts/get-kube-config.sh
```

*Примечание: в скрипте используется утилита [jq](https://jqlang.github.io/jq/) для выделения нужной информации из json, поэтому проверьте, что она установлена*

В результате буду созданы 2 файла `kubeconfig` и `ca.pem`.

- Теперь необходимо содержание данных файлов закодировать в base64 и создать в качестве переменных Gitlab CI, в проекте для CI/CD:

```
cat ./kubeconfig | base64
```

Данный вывод сохранить в переменную `KUBE_CONFIG`

```
cat ./ca.pem | base64
```

Данный вывод сохранить в переменную `CLUSTER_CERT`

- Удалить локальные файлы:

```
rm ./kubeconfig
rm ./ca.pem
```

### DNS

Прописать NS-записи:

| Имя | Тип | Значение |
|--------------|-----------|-----------|
| `web-store-fqdn.ru.` | `A` | `Static_IP` |
| `prometheus-fqdn.ru.` | `A` | `Static_IP` |
| `alertmanager-fqdn.ru.` | `A` | `Static_IP` |
| `grafana.skillvrn.ru.` | `A` | `Static_IP` |

## Установка сервисов

### Подготовительные работы

- Создать namespace в кластере

```
kubectl create namespace dumplings-store
```

- Определить в конфигурации namespace по умолчанию:

```
kubectl config set-context --current --namespace=dumplings-store
```

- [Установить Helm](https://helm.sh/ru/docs/intro/install/)
- Добавить репозитории на локальной машине

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

### Ingress

- Установить Ingress-controller

```
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace dumplings-store --set controller.service.loadBalancerIP=Static_IP
```

*Примечание 1: Static_IP - это статический IP адрес, полученный при создании объекта тераформом - при необходимости заменить*

*Примечание 2: После выполнения команды в облаке будет создан Network Load Balancer*

### Менеджер SSL-сертификатов

- Установить менеджер сертификатов для их автоматического получения при создании сервисов

```
helm upgrade --install cert-manager jetstack/cert-manager --namespace dumplings-store --version v1.12.0 --set installCRDs=true
```

*Примечание: --set installCRDs=true говорит, что нужно автоматически установить дополнительные типы ресурсов в кластер, иначе придётся это делать руками*

- В кластере объявите ресурс центра сертификации. Для этого используйте подготовленный манифест `scripts/acme-issuer.yaml`. Обратите внимание, что внутри есть важные переменные, которые можно изменить:

| Элемент | Значение | 
|--------------|-----------|
| `name` | `letsencrypt` |
| `namespace` | `my-namespace` |
| `spec.acme.server` | `https://acme-v02.api.letsencrypt.org/directory` |
| `spec.acme.email` | `someaddress@domain.ru` |

*Примечание: spec.acme.server можно изменить на тестовый ресурс https://acme-staging-v02.api.letsencrypt.org/directory, если нам нужно произвести тестирования наших сервисов. Почитать про ограничения можно [тут](https://support.cloudways.com/en/articles/5129566-let-s-encrypt-ssl-certificates-limitations)*

```
kubectl apply -f scripts/acme-issuer.yaml
```

## Удаление инфраструктуры

```
terraform destroy -auto-approve
```
