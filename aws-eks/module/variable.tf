variable "eks" {
    description = "EKS Name"
    type = string
    default = "ecosystem"
}

variable "eks_version" {
    description = "EKS Version"
    type = string
    default = "1.28"
}

variable "env" {
    description = "Environment"
    type = string
}