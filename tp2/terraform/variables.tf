# Variables communes
variable "prefix" {
  description = "Préfixe pour les noms de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "West Europe"
}

variable "environment" {
  description = "Environnement: dev ou prod"
  type        = string
}