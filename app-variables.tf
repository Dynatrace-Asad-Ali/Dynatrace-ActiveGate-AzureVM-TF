#############################
## Application - Variables ##
#############################

# company name 
variable "company" {
  type        = string
  description = "The company name used to build resources"
}

# application name 
variable "app_name" {
  type        = string
  description = "The application name used to build resources"
}

# environment
variable "environment" {
  type        = string
  description = "The environment to be built"
}

#azure Linux flavor
variable "location" {
  type        = string
  description = "Azure Linux flavor where the activegate will be installed"
  default     = "north europe"
}

