locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  /*we will get the value [go to systems manager -> parameter store -> click on expense/dev/vpc_id and 
    you will find out the value]*/
}