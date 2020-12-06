terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
  }
}

provider "kubernetes" {}

module "kubernetes_teamspeak_db" {
  source = "./modules/teamspeak-db"

  namespace                  = "teamspeak"
  teamspeak_db_root_password = "root-password"
  teamspeak_db_user          = "teamspeak"
  teamspeak_db_password      = "password"
  teamspeak_db_name          = "teamspeak_production"
}

module "kubernetes_teamspeak" {
  source = "./modules/teamspeak"

  namespace                      = "teamspeak"
  teamspeak_db_hostname          = "teamspeak-db-service"
  teamspeak_db_port              = "3306"
  teamspeak_db_user              = "teamspeak"
  teamspeak_db_password          = "password"
  teamspeak_db_name              = "teamspeak_production"
  teamspeak_serveradmin_password = "serveradmin-password"
}
