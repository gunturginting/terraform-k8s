module "aws_eks" {
    source = "./aws-eks"
    region = var.region
    env = var.env
    zone_1 = var.zone_1
    zone_2 = var.zone_2
    zone_3 = var.zone_3
    eks_name = var.eks_name
}