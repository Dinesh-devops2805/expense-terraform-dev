locals {
  resource_name = "${var.project_name}-${var.environment}" # expense-dev
  mysql_sg_id   = data.aws_ssm_parameter.mysql_sg_id.value
  #  this is the ssm_parameter --> /expense/dev/mysql_sg_id
  # And the value for it is sg-01e241d06fc9d084a (this we can find in AWS -> systems manager 
  # -> paramater store -> in /expense/dev/mysql_sg_id)
  backend_sg_id = data.aws_ssm_parameter.backend_sg_id.value # sg-06588780319e8fd1a

  frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value # sg-05c8209182c7d564a
  ansible_sg_id  = data.aws_ssm_parameter.ansible_sg_id.value

  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  # it splits the public_subnet_id eg., subnet-1,subnet-2 --> ["subnet-1","subnet-2"] --> subnet[0]
  # subnet-0e32b43ee2a08c298,subnet-09bcf6611ee998f3f  --> ["subnet-0e32b43ee2a08c298","subnet-09bcf6611ee998f3f"] 
  # we only need first index value --> subnet-0e32b43ee2a08c298
  database_subnet_id = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  # subnet-0579eb5e4ec20d64e,subnet-0c81c7c70866f34cd

  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  # subnet-03578840fa631a602,subnet-0875fd277fbdc97b9


}