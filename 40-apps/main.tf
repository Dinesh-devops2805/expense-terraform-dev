module "mysql"{
    source = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.joindevops.id   # we have declared this in data.tf file 
    name =  "${local.resource_name}-mysql" # expense-dev-mysql
    instance_type  = "t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id] 
    # And the value for it is subnet-0579eb5e4ec20d64e (this we can find in AWS -> systems manager 
    # -> paramater store -> in /expense/dev/mysql_sg_id)
    subnet_id  = local.database_subnet_id   # subnet-0579eb5e4ec20d64e

    tags = merge(
        var.common_tags,
        var.mysql_tags,
        {
            Name = "${local.resource_name}-mysql"  # expense-dev
        }

    )
}

# backend instance
module "backend"{
    source = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.joindevops.id   # we have declared this in data.tf file 
    name =  "${local.resource_name}-backend" # expense-dev-backend
    instance_type  = "t3.micro"
    vpc_security_group_ids = [local.backend_sg_id] 
    # And the value for it is subnet-03578840fa631a602 (this we can find in AWS -> systems manager 
    # -> paramater store -> in /expense/dev/backend_sg_id)
    subnet_id  = local.private_subnet_id   # subnet-03578840fa631a602

    tags = merge(
        var.common_tags,
        var.backend_tags,
        {
            Name = "${local.resource_name}-backend"  # expense-dev
        }
    )
}

# frontend instance
module "frontend"{
    source = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.joindevops.id   # we have declared this in data.tf file 
    name =  "${local.resource_name}-frontend" # expense-dev-frontend
    instance_type  = "t3.micro"
    vpc_security_group_ids = [local.frontend_sg_id] 
    # And the value for it is subnet-0e32b43ee2a08c298 (this we can find in AWS -> systems manager 
    # -> paramater store -> in /expense/dev/frontend_sg_id)
    subnet_id  = local.public_subnet_id   # subnet-0e32b43ee2a08c298

    tags = merge(
        var.common_tags,
        var.frontend_tags,
        {
            Name = "${local.resource_name}-frontend"  # expense-dev
        }

    )
}

module "ansible"{
    source = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.joindevops.id   # we have declared this in data.tf file 
    name =  "${local.resource_name}-ansible" # expense-dev-ansible
    instance_type  = "t3.micro"
    vpc_security_group_ids = [local.ansible_sg_id] 
    # And the value for it is subnet-0e32b43ee2a08c298 (this we can find in AWS -> systems manager 
    # -> paramater store -> in /expense/dev/ansible_sg_id)
    subnet_id  = local.public_subnet_id   # subnet-0e32b43ee2a08c298
    user_data = file("expense.sh")
    tags = merge(
        var.common_tags,
        var.ansible_tags,
        {
            Name = "${local.resource_name}-ansible"  # expense-dev-ansible
        }
    )
}


# Route53 records 
module "records"{
    source = "terraform-aws-modules/route53/aws//modules/records"

    zone_name = var.zone_name
    records = [
        {
            name = "mysql"
            type = "A"
            ttl = 1
            records = [
                module.mysql.private_ip 
            ]
        },
        {
            name = "backend"
            type = "A"
            ttl = 1
            records = [
                module.backend.private_ip 
            ]
        },
        {
            name = "frontend"   # frontend.daws81s.fun
            type = "A"
            ttl = 1
            records = [
                module.frontend.private_ip    
            ]
        },
         {
            name = ""   # daws81s.fun
            type = "A"
            ttl = 1
            records = [
                module.frontend.public_ip 
            ]
        }
    ]
}