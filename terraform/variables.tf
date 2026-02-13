variable "cloudflare_api_token" {
    type        = string
    sensitive   = true
    description = "Cloudflare token"
}

variable "cloudflare_zone_id" {
    type        = string
    description = "Cloudflare domen id"
}

variable "domain_name" {
    type        = string
    description = "ihavryliuk.pp.ua"
}

variable "aws_route53_zone_id" {
    type        = string
    description = "Hosted zone id"
}

variable "ssh_public_key" {
    type        = string
    sensitive   = true
    description = "SSH pub key"
}

variable "my_ip" {
    type        = string
    sensitive   = true
    description = "My ip"
}

variable "aws_access_key" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}
