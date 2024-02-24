variable "solution-name" {
  type        = string
  description = "The name of the solution"
}

variable "environment" {
  type        = string
  description = "The Name of the environment you are deploying to"
  validation {
    condition     = contains(["dev", "test", "uat", "prod"], var.environment)
    error_message = "please provide an environment name from one of the followinf [dev, test, uat, prod]"
  }
}
