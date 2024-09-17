variable "primary_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "secondary_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "access_key" {
    type = string
    sensitive = true
    default = "" 
}
  
variable "secret_key" {
    type = string
    sensitive = true
    default = ""
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

