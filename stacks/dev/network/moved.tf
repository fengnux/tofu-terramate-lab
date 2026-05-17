moved {
  from = google_compute_network.vpc
  to   = module.vpc.google_compute_network.vpc
}

moved {
  from = google_compute_subnetwork.primary
  to   = module.vpc.google_compute_subnetwork.primary
}

moved {
  from = google_compute_firewall.allow_iap_ssh
  to   = module.vpc.google_compute_firewall.allow_iap_ssh
}

moved {
  from = google_compute_router.nat
  to   = module.vpc.google_compute_router.nat
}

moved {
  from = google_compute_router_nat.nat
  to   = module.vpc.google_compute_router_nat.nat
}
