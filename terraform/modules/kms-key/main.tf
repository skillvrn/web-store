resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи
  name              = var.kms_key_name
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год
}
