output "VMs" {
   value = { for i, name in var.vms: name => {
        "Password 1" = random_password.password[i].result
        "Password 2" = random_password.password[i + length(name)].result
      }
    }
  sensitive = true
}