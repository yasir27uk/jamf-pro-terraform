variable "jamfpro_instance_fqdn" {
  description = "The Jamf Pro FQDN"
  type        = string
  sensitive   = true
}

variable "jamfpro_client_id" {
  description = "Jamf Pro Client ID"
  type        = string
  sensitive   = true
}

variable "jamfpro_client_secret" {
  description = "Jamf Pro Client Secret"
  type        = string
  sensitive   = true
}

variable "enable_client_sdk_logs" {
  default = false
}

variable "client_sdk_log_export_path" {
  default = ""
}

variable "jamfpro_hide_sensitive_data" {
  default = true
}

variable "jamfpro_jamf_load_balancer_lock" {
  default = true
}

variable "jamfpro_mandatory_request_delay_milliseconds" {
  default = 1000
}