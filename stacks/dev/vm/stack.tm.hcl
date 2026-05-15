stack {
  id          = "vm"
  name        = "vm"
  description = "實驗用 dev VM（IAP SSH + NAT 驗證，實驗後 destroy）"
  tags        = ["dev", "vm"]
  after       = ["/stacks/dev/network"]
}
