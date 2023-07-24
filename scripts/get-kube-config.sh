#!/bin/bash

# Получаем идентификатор рабочего кластера (доступ к YC уже должен быть настроен)
CLUSTER_ID=$(yc managed-kubernetes cluster list | sed -n 4p | awk '{ print $2 }')

# Получаем сертификат кластера для подтверждения подлинности кластера K8s
yc managed-kubernetes cluster get --id $CLUSTER_ID --format json | \
  jq -r .master.master_auth.cluster_ca_certificate | \
  awk '{gsub(/\\n/,"\n")}1' > ca.pem

# Подготавливаем Token объекста ServiceAccount для аутентификации в кластере
SA_TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | \
  grep admin-user | \
  awk '{print $1}') -o json | \
  jq -r .data.token | \
  base64 --d)

# Получаем IP адрес кластера
MASTER_ENDPOINT=$(yc managed-kubernetes cluster get --id $CLUSTER_ID \
  --format json | \
  jq -r .master.endpoints.external_v4_endpoint)

# Создаем файл конфигурации
# Сведения о кластере
kubectl config set-cluster yc-managed-k8s \
  --certificate-authority=ca.pem \
  --server=$MASTER_ENDPOINT \
  --kubeconfig=kubeconfig

# Токен
kubectl config set-credentials admin-user \
  --token=$SA_TOKEN \
  --kubeconfig=kubeconfig

# Контекст
kubectl config set-context dumplings-store \
  --cluster=yc-managed-k8s \
  --user=admin-user \
  --kubeconfig=kubeconfig

# Применяем данную конфигурацию
kubectl config use-context dumplings-store \
  --kubeconfig=kubeconfig
