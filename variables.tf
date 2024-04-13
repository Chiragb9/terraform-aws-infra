variable "tags" {
  default = {
    Terraform   = "true"
    Environment = "test"
  }
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}