globals "gke" {
  master_cidr     = "172.16.0.0/28"
  release_channel = "REGULAR"

  master_authorized_cidrs = [
    {
      cidr_block   = "10.10.0.0/20" # 對齊 globals.network.cidr_primary；dev-subnet 內 VM 可達 master
      display_name = "dev-subnet-primary"
    },
  ]

  # lab 階段允許 destroy，production 應改回 true
  deletion_protection = false
}
