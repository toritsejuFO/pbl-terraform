locals {
  tags = {
    Enviroment     = var.Environment
    OwnerEmail     = var.OwnerEmail
    ManagedBy      = var.ManagedBy
    BillingAccount = var.BillingAccount
  }
}
