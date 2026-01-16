### provider "jamfpro" {
###   auth_method = "oauth2"
### 
###   jamfpro_instance_fqdn = var.jamfpro_instance_fqdn
###   client_id             = var.jamfpro_client_id
###   client_secret         = var.jamfpro_client_secret
### 
###   enable_client_sdk_logs               = var.enable_client_sdk_logs
###   client_sdk_log_export_path           = var.client_sdk_log_export_path
###   hide_sensitive_data                  = var.jamfpro_hide_sensitive_data
###   jamfpro_load_balancer_lock           = var.jamfpro_jamf_load_balancer_lock
###   token_refresh_buffer_period_seconds  = 0
###   mandatory_request_delay_milliseconds = var.jamfpro_mandatory_request_delay_milliseconds
### }