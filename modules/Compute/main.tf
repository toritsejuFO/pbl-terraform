# create instance for jenkins
resource "aws_instance" "Jenkins" {
  ami                         = var.jenkins_ami
  instance_type               = "t2.micro"
  subnet_id                   = var.compute_subnets
  vpc_security_group_ids      = var.compute_sg
  associate_public_ip_address = true
  key_name                    = var.keypair

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-Jenkins"
    },
  )
}


#create instance for sonbarqube
resource "aws_instance" "sonbarqube" {
  ami                         = var.sonar_ami
  instance_type               = "t2.medium"
  subnet_id                   = var.compute_subnets
  vpc_security_group_ids      = var.compute_sg
  associate_public_ip_address = true
  key_name                    = var.keypair

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-sonbarqube"
    },
  )
}

# create instance for artifactory
resource "aws_instance" "artifactory" {
  ami                         = var.jfrog_ami
  instance_type               = "t2.medium"
  subnet_id                   = var.compute_subnets
  vpc_security_group_ids      = var.compute_sg
  associate_public_ip_address = true
  key_name                    = var.keypair

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-artifactory"
    },
  )
}
