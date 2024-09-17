
#### This configuration sets up two PostgreSQL database instances, one in a primary region and the other in a secondary region, to support a multi-region architecture.

##########Resource: Primary PostgreSQL Database Instance in (us-east-1) region###########

resource "aws_db_instance" "primary_postgres" {
  provider              = aws
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "16"
  instance_class        = "db.t3.medium"
  username              = var.db_username
  password              = var.db_password
  db_subnet_group_name  = var.vpc_primary_db_subnet_group_name
  skip_final_snapshot   = true
  multi_az              = true
  publicly_accessible   = false

  vpc_security_group_ids = [var.primary_db_security_group_id]

  tags = {
    Name = "Olumoko_Primary_PostgreSQL_Database"
  }
}


#########Resource: Secondary PostgreSQL Database Instance in a different region (us-west-2)##############

resource "aws_db_instance" "secondary_postgres" {
  provider              = aws.us-west-2
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "16"
  instance_class        = "db.t3.medium"
  username              = var.db_username
  password              = var.db_password
  db_subnet_group_name  = var.vpc_secondary_db_subnet_group_name
  skip_final_snapshot   = true
  multi_az              = true
  publicly_accessible   = false

  vpc_security_group_ids = [var.secondary_db_security_group_id]

  tags = {
    Name = "Olumoko_Secondary_PostgreSQL_Database"
  }
}
