variable "solution-name" {
    type = string
    description = "The name of the solution"
}

variable "environment"{
    type = string
    description = "The Name of the environment you are deploying to"
    validation{
        condition = contains(["dev", "test", "uat", "prod"], var.environment)
        error_message = "please provide an environment name from one of the followinf [dev, test, uat, prod]"
    }
}

variable "azure-region" {
    type = string
    description = "The azure region to deploy to"
    validation {
        condition = contains(["asia", "eastasia", "asiapacific", "southeastasia", "australia", "australiacentral", "australiacentral2", "australiaeast", "australiasoutheast", "brazil", "brazilsouth", "brazilsoutheast", "canada", "canadacentral", "canadaeast", "chinaeast", "chinaeast2", "chinaeast3", "chinanorth", "chinanorth2", "chinanorth3", "europe", "northeurope", "westeurope", "francecentral", "francesouth", "germanycentral", "germanynorth", "germanynortheast", "germanywestcentral", "global", "india", "centralindia", "southindia", "westindia", "israelcentral", "italynorth", "japan", "japaneast", "japanwest", "korea", "koreacentral", "koreasouth", "norway", "norwayeast", "norwaywest", "polandcentral", "qatarcentral", "southafricanorth", "southafricawest", "singapore", "sweden", "swedencentral", "swedensouth", "switzerlandnorth", "switzerlandwest", "uaecentral", "uaenorth", "uk", "uksouth", "ukwest", "unitedstates", "centralus", "eastus", "eastus2", "northcentralus", "southcentralus", "westus", "westus2", "westus3", "westcentralus", ], var.azure-region)
        error_message = "Please ensure that your region matches the internal azure region name: https://github.com/claranet/terraform-azurerm-regions/blob/master/REGIONS.md"
    }
}

variable "node_sku" {
    type = string
    description = "The SKU of the VMs to run the Kubernetes agent pool on"
    default = "Standard_DS2_v2"
}

variable "vm_username" {
  type        = string
  description = "Username for vm-1"
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "Password for vm-1"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
  default = {
    Domain             = "Audience Brain"
    DataClassification = "Confidential"
    Criticality        = "Medium"
    OpsCommitment      = "Audience Brain Team"
  }
}
