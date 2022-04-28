terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.23"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.3"
    }
  }
  required_version = "~> 1.0"
}
