variable "project_id" {
  type        = string
  description = "GCP Project ID for UAT environment"
  default     = "insurverse-uat"
}

variable "region" {
  type        = string
  description = "GCP Region"
  default     = "asia-southeast1"
}

variable "zone" {
  type        = string
  description = "GCP Zone for zonal resources"
  default     = "asia-southeast1-a"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "uat-isv"
}

variable "vpc_name" {
  type        = string
  description = "Custom VPC Name"
  default     = "vpc-uat-isv"
}

variable "db_password" {
  type        = string
  description = "Cloud SQL Admin Password"
  sensitive   = true
  default     = "UatISV_SecurePass2026!"
}
