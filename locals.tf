locals {
  tags = {
    Environment    = var.environment
    OwnerEmail     = var.ownerEmail
    ManagedBy      = var.managedBy
    BillingAccount = var.billingAccount
  }
}
