variable "cluster" {
  type        = string
  description = "AKS cluster where this app is deployed. Either 'test' or 'production'"
}
variable "namespace" {
  type        = string
  description = "AKS namespace where this app is deployed"
}
variable "environment" {
  type        = string
  description = "Name of the deployed environment in AKS"
}
variable "azure_resource_prefix" {
  type        = string
  description = "Standard resource prefix. Usually s189t01 (test) or s189p01 (production)"
}
variable "config" {
  type        = string
  description = "Long name of the environment configuration, e.g. development, staging, production..."
}
variable "config_short" {
  type        = string
  description = "Short name of the environment configuration, e.g. dv, st, pd..."
}
variable "service_name" {
  type        = string
  description = "Full name of the service. Lowercase and hyphen separated"
}
variable "service_short" {
  type        = string
  description = "Short name to identify the service. Up to 6 charcters."
}
variable "deploy_azure_backing_services" {
  type        = bool
  default     = true
  description = "Deploy real Azure backing services like databases, as opposed to containers inside of AKS"
}
variable "enable_postgres_ssl" {
  type        = bool
  default     = true
  description = "Enforce SSL connection from the client side"
}
variable "enable_postgres_backup_storage" {
  type        = bool
  default     = false
  description = "Create a storage account to store database dumps"
}
variable "enable_postgres_high_availability" {
  type        = bool
  default     = false
  description = "Enable high availability for PostgreSQL (doubles cost)"
}
variable "docker_image" {
  type        = string
  description = "Docker image full name to identify it in the registry. Includes docker registry, repository and tag e.g.: ghcr.io/dfe-digital/teacher-pay-calculator:673f6309fd0c907014f44d6732496ecd92a2bcd0"
}
variable "external_url" {
  type        = string
  default     = null
  description = "Healthcheck URL for StatusCake uptime monitoring"
}
variable "apex_url" {
  type        = string
  default     = null
  description = "URL for StatusCake SSL certificate monitoring. Only for DNS zone apex domain."
}
variable "statuscake_contact_groups" {
  type        = list(any)
  default     = []
  description = "ID of the contact group in statuscake web UI"
}
variable "enable_monitoring" {
  type        = bool
  default     = false
  description = "Enable monitoring and alerting"
}
variable "send_traffic_to_maintenance_page" {
  type        = bool
  default     = false
  description = "During a maintenance operation, keep sending traffic to the maintenance page instead of resetting the ingress"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of replicas for the application deployment"
}

variable "postgres_flexible_server_sku" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "SKU for the PostgreSQL flexible server. Use 'GP_Standard_D2ds_v4' for production"
}

variable "azure_maintenance_window" {
  type = object({
    day_of_week  = number
    start_hour   = number
    start_minute = number
  })
  default = null
  description = "Maintenance window for PostgreSQL. Day 0 = Sunday, 1 = Monday, etc."
}

locals {
  postgres_ssl_mode = var.enable_postgres_ssl ? "require" : "disable"

}

variable "enable_logit" { default = true }

variable "worker_memory_max" {
  type        = string
  default     = "1Gi"
  description = "Maximum memory allocation for Solid Queue worker pods"
}

variable "worker_replicas" {
  type        = number
  default     = 1
  description = "Number of Solid Queue worker replicas"
}



