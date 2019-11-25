# Variables used

variable "default_droplet_size" {
  // read from terraform.tfvars
  type = "string"
}

variable "default_region" {
  // read from terraform.tfvars
  type = "string"
}

variable "apply_immediately" {
  // read from terraform.tfvars
  type    = "string"
  default = "false"
}

variable "encryption_at_rest" {
  // read from terraform.tfvars
  type    = "string"
  default = "true"
}
