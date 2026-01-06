variable "jamfpro_auth_method" {
  description = "The Jamf Pro authentication method. Options are 'basic' for username/password or 'oauth2' for client id/secret."
  type        = string
  default     = "basic"
}

variable "jamfpro_instance_fqdn" {
  description = "The Jamf Pro instance FQDN (e.g., https://yourcompany.jamfcloud.com)"
  type        = string
  sensitive   = true
}

variable "jamfpro_username" {
  description = "The Jamf Pro username for basic authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "jamfpro_password" {
  description = "The Jamf Pro password for basic authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "jamfpro_client_id" {
  description = "The Jamf Pro Client ID for OAuth2 authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "jamfpro_client_secret" {
  description = "The Jamf Pro Client Secret for OAuth2 authentication"
  type        = string
  sensitive   = true
  default     = ""
}
