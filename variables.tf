variable "gdd_access_key" {
  description = "The access key for GoDaddy"
  type        = string
  sensitive   = true
}

variable "gdd_secret_key" {
  description = "The secret key for GoDaddy"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "List of subdomains to set the IP for"
  type        = string
  default     = "nunapo.com"
}

variable "subdomain_list" {
  description = "List of subdomains to set the IP for"
  type        = list(string)
  default     = ["argo","flux"]
}

variable "public_ip" {
  description = "Public IP address to set for the subdomains. If not provided, it will be fetched automatically."
  type        = string
  default     = ""
}