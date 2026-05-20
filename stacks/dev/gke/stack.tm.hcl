stack {
  id          = "gke"
  name        = "gke"
  description = "dev Autopilot GKE cluster on dev-vpc（private endpoint，從 dev-vm IAP bastion 存取）"
  tags        = ["dev", "gke"]
  after       = ["/stacks/dev/apis", "/stacks/dev/network"]
}
