variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
}

variable "daily_backup_retention_days" {
  type        = number
  description = "Number of days daily backups have to be retained"
  default     = 35
}

variable "monthly_backup_retention_days" {
  type        = number
  description = "Number of days monthly backups have to be retained"
  default     = 365
}

variable "only_daily_backup_retention_days" {
  type        = number
  description = "Number of days daily backups have to be retained"
  default     = 35
}

variable "only_daily_backup_retention_days" {
  type        = number
  description = "Number of days daily backups have to be retained"
  default     = 35
}

variable "only_monthly_backup_retention_days" {
  type        = number
  description = "Number of days daily backups have to be retained"
  default     = 365
}

variable "only_monthly_backup_retention_days" {
  type        = number
  description = "Number of days daily backups have to be retained"
  default     = 365
}