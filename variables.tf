variable "subscription_id" {
  type = string
}

variable "allowed_public_ips" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "vm_publisher" {
  type = string
}

variable "vm_offer" {
  type = string
}

variable "vm_sku" {
  type = string
}

variable "vm_version" {
  type = string
}

variable "vm_userdata_file" {
  type = string
}
