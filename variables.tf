variable "server_port" {
  description = "Port on which web server runs"
  default     = "80"
}

variable "public_key" {
  description = "public_key on this machine"
}

variable "key_name" {
  description = "SSH Key to remote into instances"
}

variable "vpc_cidr" {
  description = "CIDR block for VPN"
}

variable "subnet_cidr" {
  description = "CIDR block for CIDR"
}
