terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.94"
    }
  }

# Описание бэкенда хранения состояния
backend "s3" {
  endpoint   = "storage.yandexcloud.net"
  bucket     = "terraform"
  region     = "ru-central1"
  key        = "terraform.tfstate"
  # access_key = "I AM IN config.s3.tfbackend"
  # secret_key = "I AM IN config.s3.tfbackend"

  skip_region_validation      = true
  skip_credentials_validation = true
  }

  required_version = ">= 1.4.0"
}
