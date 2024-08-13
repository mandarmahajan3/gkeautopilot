variable "namespaces" {
  description = "A list of namespaces to create in the Kubernetes cluster"
  type        = list(string)
}

variable "ingress_service_name" {
  description = "The name of the service to be used in the ingress configuration"
  type        = string
}

variable "ingress_service_port" {
  description = "The port of the service to be used in the ingress configuration"
  type        = number
}

variable "internal_cidrs" {
  description = "List of internal CIDRs for network policies"
  type        = list(string)
}

variable "allowed_cidr" {
  description = "CIDR block allowed for network ingress"
  type        = string
}