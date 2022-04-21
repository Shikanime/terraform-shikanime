resource "null_resource" "multipass_wonderland" {
  provisioner "local-exec" {
    command = "multipass launch --cloud-init ${local_sensitive_file.cloud_config_wonderland.filename} --name wonderland --disk 50G"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "multipass delete wonderland --purge"
  }
}

resource "local_sensitive_file" "cloud_config_wonderland" {
  content = yamlencode({
    hostname         = "wonderland",
    manage_etc_hosts = true,
    resize_rootfs    = true,
    growpart = {
      mode = "auto",
      devices = [
        "/"
      ],
      ignore_growroot_disabled = false
    },
    package_update             = true,
    package_upgrade            = true,
    package_reboot_if_required = true,
    packages = [
      "ntp",
      "avahi-daemon",
      "inotify-tools"
    ],
    locale   = "en_US.UTF-8",
    timezone = "Europe/Paris",
    users = [
      "default",
      {
        name        = "devas",
        gecos       = "Shikanime Deva",
        sudo        = "ALL=(ALL) NOPASSWD:ALL",
        shell       = "/bin/bash",
        lock_passwd = true,
        ssh_authorized_keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7pi5OYqzuMkTymIbJUJteIU3dz+OgduiF5O9cA+B7u devas@ishtar"
        ]
      }
    ],
    write_files = [
      {
        content     = "[server]\nhost-name=wonderland\n",
        permissions = "0644",
        path        = "/etc/avahi/avahi-daemon.conf"
      }
    ],
    ssh_keys = {
      "ed25519_private" : tls_private_key.ed25519_wonderland.private_key_openssh,
      "ed25519_public" : tls_private_key.ed25519_wonderland.public_key_openssh,
      "rsa_private" : tls_private_key.rsa_wonderland.private_key_openssh,
      "rsa_public" : tls_private_key.rsa_wonderland.public_key_openssh
    },
    runcmd = [
      "su devas -l -c \"curl -L https://nixos.org/nix/install | NIX_EXTRA_CONF=\\\"experimental-features = nix-command flakes\\\" sh -s -- --daemon\""
    ]
  })
  filename = "${path.module}/cloud-config-wonderland.txt"
}

resource "tls_private_key" "rsa_wonderland" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "ed25519_wonderland" {
  algorithm = "ED25519"
}
