resource "aws_iam_role" "iam_role_nodes" {
    name = "${var.env}-${var.eks_name}-eks-nodes"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY 
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.iam_role_nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.iam_role_nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.iam_role_nodes.name
}

resource "aws_eks_node_group" "eks_node" {
    cluster_name = aws_eks_cluster.eks.name
    version = local.eks_version
    node_group_name = "ecosystem-node"
    node_role_arn = aws_iam_role.iam_role_nodes.arn
    subnet_ids = [
        aws_subnet.private_subnet_1.id,
        aws_subnet.private_subnet_2.id
    ]

    capacity_type = "ON_DEMAND"
    instance_types = ["t3.medium"]

    scaling_config {
      desired_size = 1
      max_size = 3
      min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

    labels = {
        role = "ecosystem-node"
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
        aws_iam_role_policy_attachment.amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy
    ]

    # Allow external changes without Terraform plan difference
    lifecycle {
      ignore_changes = [ scaling_config[0].desired_size ]
    }
}