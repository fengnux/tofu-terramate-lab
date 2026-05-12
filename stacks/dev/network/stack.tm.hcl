stack {
  id          = "network"
  name        = "network"
  description = "dev VPC、subnet（含 GKE secondary ranges）、IAP SSH firewall、Cloud NAT"
  tags        = ["dev", "network"]
  after       = ["/stacks/dev/apis"]
}
