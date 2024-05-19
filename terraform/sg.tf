# alb用のセキュリティグループ
resource "aws_security_group" "alb_security_group" {
  name        = "alb-security-group"
  description = "Allow inbound traffic on port 443 for HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


// eksクラスタ生成後に使う
resource "aws_security_group_rule" "alb_security_group_rule" {
  security_group_id        = var.node_security_group_id
  type                     = "ingress"
  from_port                = 30020 
  to_port                  = 30020 
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_security_group.id
}


# EKSクラスタ用セキュリティグループ
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  vpc_id      = aws_vpc.main.id

  // grpc
  ingress {
    from_port   = 50051
    to_port     = 50051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // http 
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS用セキュリティグループ
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Redis用セキュリティグループ
resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}