variable "create_admin_user" {
  description = "Set this to true to create the admin user"
  type        = bool
  default     = false
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_admin" {
    count = var.create_developer_user ? 1 : 0
    name = "${local.env}-${local.eks_name}-eks-admin"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "eks_admin" {
    count = var.create_developer_user ? 1 : 0
    name = "AmazonEKSAdminPolicy"

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_admin" {
    count = var.create_developer_user ? 1 : 0
    role = aws_iam_role.eks_admin.name
    policy_arn = aws_iam_policy.eks_admin.arn
}

resource "aws_iam_user" "admin" {
    count = var.create_developer_user ? 1 : 0
    name = "admin"
}

resource "aws_iam_policy" "eks_assume_admin" {
    count = var.create_developer_user ? 1 : 0
    name = "AmazonEKSAssumeAdminPolicy"

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "${aws_iam_role.eks_admin.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "admin" {
    count = var.create_developer_user ? 1 : 0
    user = aws_iam_user.admin.name
    policy_arn = aws_iam_policy.eks_assume_admin.arn
}

resource "aws_eks_access_entry" "admin" {
    count = var.create_developer_user ? 1 : 0
    cluster_name = aws_eks_cluster.eks.name
    principal_arn = aws_iam_role.eks_admin.arn
    kubernetes_groups = [ "my-admin" ]
}