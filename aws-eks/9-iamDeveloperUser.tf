variable "create_developer_user" {
  description = "Set this to true to create the developer user"
  type        = bool
  default     = false
}

resource "aws_iam_user" "developer" {
    count = var.create_developer_user ? 1 : 0
    name = "developer"
}

resource "aws_iam_policy" "developer_eks" {
    count = var.create_developer_user ? 1 : 0
    name = "AmazonEKSDeveloperPolicy"

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "developer_eks" {
    count = var.create_developer_user ? 1 : 0
    user = aws_iam_user.developer.name
    policy_arn = aws_iam_policy.developer_eks.arn
}

resource "aws_eks_access_entry" "developer" {
    count = var.create_developer_user ? 1 : 0
    cluster_name =   aws_eks_cluster.eks.name
    principal_arn = aws_iam_user.developer.arn
    kubernetes_groups = [ "my-viewer" ]
}