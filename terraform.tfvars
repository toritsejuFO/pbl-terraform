region                              = "us-east-1"
vpc_cidr                            = "172.16.0.0/16"
enable_dns_support                  = true
enable_dns_hostnames                = true
preferred_number_of_public_subnets  = 2
preferred_number_of_private_subnets = 4

# Tags
name           = "IAC"
environment    = "development"
ownerEmail     = "toriboi.fo@gmail.com"
managedBy      = "Terraform"
billingAccount = "792628092527"

bastion_ami   = "ami-0f0d43328d9d1d966"
nginx_ami     = "ami-0b8ce3b5b0c2079ba"
webserver_ami = "ami-074ec5445a292dd36"

keypair = "default_kp"

master_username = "admin"
master_password = "minda123"
