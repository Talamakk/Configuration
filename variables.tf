variable "project_name" {
  description = "ProjectName"
  type        = string
  default     = "AthleticApp"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition = anytrue([
      var.env == "dev",
      var.env == "uat",
      var.env == "prod"
    ])
    error_message = "Specified env does not exist. Allowed values are: dev, uat, prod."
  }
}

variable "region" {
  description = "Region name"
  type        = string
  default     = "polandcentral"

  validation {
    condition = anytrue([
      var.region == "polandcentral",
      var.region == "westeurope",
      var.region == "northeurope"
    ])
    error_message = "Specified region is not allowed or does not exist. Please select other region."
  }
}