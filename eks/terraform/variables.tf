variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS Cluster name"
  default     = "test-eks-cluster"
}

variable "alb_name" {
  description = "ALB Name"
  default     = "test-alb"
}

variable "domain_name" {
  description = "Domain name for Route53"
  default     = "adozoo.com"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}
