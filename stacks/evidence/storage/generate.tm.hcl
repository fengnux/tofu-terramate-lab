generate_hcl "_locals.tf" {
  content {
    locals {
      personal_email = global.owner.personal_email
    }
  }
}
