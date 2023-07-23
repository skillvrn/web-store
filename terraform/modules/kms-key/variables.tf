variable "kms_key_name" {
  default     = "kms-key"
  type        = string
  description = "A key for encrypting important information such as passwords, OAuth tokens, and SSH keys"
  nullable    = false
}
