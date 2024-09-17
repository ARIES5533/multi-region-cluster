
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

variable "vpc_primary_db_subnet_group_name" {
    default = ""
}
variable "vpc_secondary_db_subnet_group_name" {
    default = ""
}


variable "primary_db_security_group_id" {
  description = "Security group ID for the primary database"
  type        = string
}

variable "secondary_db_security_group_id" {
  description = "Security group ID for the secondary database"
  type        = string
}

variable "db_username" {
  type        = string
  default = "olumoko"
}

variable "db_password" {
  type        = string
  sensitive   = true 
  default = "Callmyname5533"
}