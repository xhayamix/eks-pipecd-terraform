resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       =  var.elasticache_subnet_group_name
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_c.id]

  tags = {
    Name = var.elasticache_subnet_group_name
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.elasticache_name
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = var.elasticache_instance_count
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}