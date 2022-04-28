resource "local_sensitive_file" "cloud_config" {
  content = jsonencode({
    hostname         = var.name
    manage_etc_hosts = true
    resize_rootfs    = true
    growpart = {
      mode = "auto"
      devices = [
        "/"
      ]
      ignore_growroot_disabled = false
    }
    package_update             = true
    package_upgrade            = true
    package_reboot_if_required = true
    packages = [
      "zsh",
      "ntp",
      "avahi-daemon",
      "inotify-tools",
      "unzip",
      "zip",
      "wget",
      "curl",
      "subversion",
      "mercurial",
      "git",
      "darcs"
    ]
    locale   = var.locale
    timezone = var.timezone
    users = [
      {
        name                = "devas"
        gecos               = "Shikanime Deva"
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        shell               = "/bin/bash"
        lock_passwd         = true
        ssh_authorized_keys = var.ssh_authorized_keys
      }
    ]
    write_files = [
      {
        content     = <<-EOF
          [server]
          host-name=${var.name}
        EOF
        permissions = "0644"
        path        = "/etc/avahi/avahi-daemon.conf"
      }
    ]
    ssh_keys = {
      id_ed25519_private = tls_private_key.id_ed25519.private_key_openssh
      id_ed25519_public  = tls_private_key.id_ed25519.public_key_openssh
      id_rsa_private     = tls_private_key.id_rsa.private_key_openssh
      id_rsa_public      = tls_private_key.id_rsa.public_key_openssh
    }
    runcmd = [
      "su devas -l -c \"curl -L https://nixos.org/nix/install | NIX_EXTRA_CONF=\\\"experimental-features = nix-command flakes\\\" sh -s -- --daemon\""
    ]
  })
  filename = "${path.module}/cloud-config.txt"
}

resource "github_user_ssh_key" "default" {
  title = title(var.name)
  key   = tls_private_key.id_ed25519.public_key_openssh
}

resource "tls_private_key" "id_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "id_ed25519" {
  algorithm = "ED25519"
}
