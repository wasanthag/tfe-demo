terraform {
  backend "remote" {
    hostname     = "tfe.lab.local"
    organization = "wwt"
    workspaces {
      name = "jenkins-tfe-vmw"
    }
  }
}
