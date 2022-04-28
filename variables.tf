variable "name" {
  type    = string
  default = "wonderland"
}

variable "locale" {
  type        = string
  description = "Locale"
}

variable "timezone" {
  type        = string
  description = "Timezone"
}

variable "ssh_authorized_keys" {
  type        = list(string)
  default     = []
  description = "SSH Authorized Keys"
}

variable "gitlab_username" {
  type        = string
  description = "Gitlab Username"
}
