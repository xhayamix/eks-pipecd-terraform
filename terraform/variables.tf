
variable "aws_account_id" {
  description = "AWSアカウントID"
  type        = string
}

// alb
variable "alb_name" {
  description = "ALB Name"
  type        = string
}

variable "target_group_name" {
  description = "Target Group Name"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Autoscaling Group Name"
  type        = string
}

// eks
variable "cluster_name" {
  description = "Cluster名"
  type        = string
}

variable "node_group_name" {
  description = "NodeGroup名"
  type        = string
}

variable "node_group_label" {
  description = "Nodeラベル"
  type        = string
}

variable "node_security_group_id" {
  description = "NodeセキュリティグループID"
  type        = string
}

// rds
variable "rds_subnet_group_name" {
  description = "RDS Subnet Group 名"
  type        = string
}

variable "rds_name" {
  description = "RDS名(aurora)"
  type        = string
}

variable "rds_database" {
  description = "DB名"
  type        = string
}

variable "rds_username" {
  description = "RDSユーザー名"
  type        = string
}

variable "rds_password" {
  description = "RDSパスワード"
  type        = string
}

variable "rds_instance_count" {
  description = "RDSインスタンス数(aurora)"
  type        = number
}

// redis
variable "elasticache_subnet_group_name" {
  description = "ElastiCache Subnet Group 名"
  type        = string
}

variable "elasticache_name" {
  description = "ElastiCache名"
  type        = string
}

variable "elasticache_instance_count" {
  description = "ElastiCacheインスタンス数"
  type        = number
}


//ecr
variable "aws_ecr_repository_name" {
  description = "ECRリポジトリ名"
  type        = string
}

variable "github_id" {
  description = "GitHubID"
  type        = string
}

variable "github_repository_name" {
  description = "GitHubリポジトリ名"
  type        = string
}