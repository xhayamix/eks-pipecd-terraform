# EKSクラスターの作成
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_iam_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.public_a.id, aws_subnet.public_c.id]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  # Kubernetesバージョンを指定
  version = "1.29"
}

# EKSノードグループの作成
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_a.id, aws_subnet.public_c.id]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_policy_attachment.eks_cni_policy_attachment,
    aws_iam_policy_attachment.eks_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_es2_role_policy_attachment
  ]

  labels = {
    node = var.node_group_label
  }
}
