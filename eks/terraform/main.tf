# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  
  name = "test-vpc"
  cidr = var.vpc_cidr
  
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
}

# # ALB
# resource "aws_lb" "test_alb" {
#   name               = var.alb_name
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [module.eks.cluster_security_group_id]
#   subnets            = module.vpc.public_subnets

#   enable_deletion_protection = false
# }

# resource "aws_lb_target_group" "tg" {
#   name     = "test-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.vpc.vpc_id
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.test_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }

# # Route53
# resource "aws_route53_zone" "adozoo_zone" {
#   name = var.domain_name
# }

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.adozoo_zone.zone_id
#   name    = "www"
#   type    = "A"

#   alias {
#     name                   = aws_lb.test_alb.dns_name
#     zone_id                = aws_lb.test_alb.zone_id
#     evaluate_target_health = true
#   }
# }
