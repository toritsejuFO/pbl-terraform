locals {
  security_groups = {
    # security group for EALB
    ext_alb_sg = {
      name        = "ext-alb-sg"
      description = "for external loadbalncer"
    }

    # security group for bastion
    bastion_sg = {
      name        = "bastion-sg"
      description = "for bastion instances"
    }

    # security group for nginx
    nginx_sg = {
      name        = "nginx-sg"
      description = "nginx instances"
    }

    # security group for IALB
    int_alb_sg = {
      name        = "int-alb-sg"
      description = "for internal loadbalancer"
    }

    # security group for webservers
    webserver_sg = {
      name        = "webserver-sg"
      description = "webservers security group"
    }

    # security group for data-layer
    datalayer_sg = {
      name        = "datalayer-sg"
      description = "data layer security group"
    }
  }
}
