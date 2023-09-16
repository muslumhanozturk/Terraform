module "tf-vpc" {
  source = "../modules"
  environment = "dev"
  }

output "vpc-cidr-block" {
  value = module.tf-vpc.vpc_cidr
}


# When we do terraform plan & terraform apply,
# it processes variable.tf and main.tf. 
# but it does not process the outputs. 
# should also be noted here.
