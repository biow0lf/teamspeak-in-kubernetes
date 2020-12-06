resource "kubernetes_persistent_volume_claim" "teamspeak_pvc" {
  metadata {
    name = "teamspeak-pvc"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_stateful_set" "teamspeak_stateful_set" {
  metadata {
    name = "teamspeak-stateful-set"
    namespace = var.namespace
    labels = {
      app = "teamspeak"
    }
  }
  spec {
    service_name = "teamspeak-service"
    replicas = 1
    selector {
      match_labels = {
        app = "teamspeak"
      }
    }
    template {
      metadata {
        labels = {
          app = "teamspeak"
        }
      }
      spec {
        container {
          name = "teamspeak"
          image = "docker.io/library/teamspeak:3.13.2"
          image_pull_policy = "Always"
          volume_mount {
            mount_path = "/var/ts3server/"
            name = "teamspeak-data"
          }
          // env {
          //   name = "TS3SERVER_LICENSEPATH"
          //   value = ""
          // }
          // env {
          //   name = "TS3SERVER_QUERY_PROTOCOLS"
          //   value = "raw"
          // }
          // env {
          //   name = "TS3SERVER_QUERY_TIMEOUT"
          //   value = "300"
          // }
          // env {
          //   name = "TS3SERVER_QUERY_SSH_RSA_HOST_KEY"
          //   value = "ssh_host_rsa_key"
          // }
          // env {
          //   name = "TS3SERVER_IP_WHITELIST" # https://github.com/TeamSpeak-Systems/teamspeak-linux-docker-images/pull/69
          //   value = "query_ip_whitelist.txt"
          // }
          // env {
          //   name = "TS3SERVER_IP_BLACKLIST" # https://github.com/TeamSpeak-Systems/teamspeak-linux-docker-images/pull/69
          //  value = "query_ip_blacklist.txt"
          // }
          env {
            name = "TS3SERVER_DB_PLUGIN"
            # List of values: "ts3db_sqlite3", "ts3db_mariadb", "ts3db_postgresql"
            value = "ts3db_mariadb"
          }
          // env {
          //   name = "TS3SERVER_DB_PLUGINPARAMETER"
          //   value = "/var/run/ts3server/ts3db.ini"
          // }
          // env {
          //   name = "TS3SERVER_DB_SQLPATH"
          //   value = "/opt/ts3server/sql/"
          // }
          env {
            name = "TS3SERVER_DB_SQLCREATEPATH"
            # List of values: "create_sqlite", "create_mariadb", "create_postgresql"
            value = "create_mariadb"
          }
          // env {
          //   name = "TS3SERVER_DB_CONNECTIONS"
          //   value = "10"
          // }
          // env {
          //   name = "TS3SERVER_DB_CLIENTKEEPDAYS"
          //   value = "30"
          // }
          // env {
          //   name = "TS3SERVER_LOG_PATH"
          //   value = "/var/ts3server/logs"
          // }
          // env {
          //   name = "TS3SERVER_LOG_QUERY_COMMANDS"
          //   value = "0"
          // }
          // env {
          //   name = "TS3SERVER_LOG_APPEND"
          //   value = "0"
          // }
          // env {
          //   name = "TS3SERVER_SERVERQUERYDOCS_PATH"
          //   value = "/opt/ts3server/serverquerydocs/"
          // }
          // env {
          //   name = "TS3SERVER_QUERY_IP"
          //   value = ""
          // }
          env {
            name = "TS3SERVER_QUERY_PORT"
            value = var.teamspeak_query_raw_port
          }
          // env {
          //   name = "TS3SERVER_FILETRANSFER_IP"
          //   value = ""
          // }
          env {
            name = "TS3SERVER_FILETRANSFER_PORT"
            value = var.teamspeak_filetransfer_port
          }
          // env {
          //   name = "TS3SERVER_VOICE_IP"
          //   value = ""
          // }
          env {
            name = "TS3SERVER_DEFAULT_VOICE_PORT"
            value = var.teamspeak_voice_port
          }
          // env {
          //   name = "TS3SERVER_QUERY_SSH_IP"
          //  value = ""
          // }
          env {
            name = "TS3SERVER_QUERY_SSH_PORT"
            value = var.teamspeak_query_ssh_port
          }
          env {
            name = "TS3SERVER_SERVERADMIN_PASSWORD"
            value = var.teamspeak_serveradmin_password
          }
          // env {
          //   name = "TS3SERVER_MACHINE_ID"
          //   value = ""
          // }
          // env {
          //   name = "TS3SERVER_QUERY_SKIPBRUTEFORCECHECk" # https://github.com/TeamSpeak-Systems/teamspeak-linux-docker-images/pull/68
          //   value = ""
          // }
          // env {
          //   name = "TS3SERVER_HINTS_ENABLED"
          //   value = ""
          // }
          env {
            name = "TS3SERVER_DB_HOST"
            value = var.teamspeak_db_hostname
          }
          env {
            name = "TS3SERVER_DB_PORT"
            value = var.teamspeak_db_port
          }
          env {
            name = "TS3SERVER_DB_USER"
            value = var.teamspeak_db_user
          }
          env {
            name = "TS3SERVER_DB_PASSWORD"
            value = var.teamspeak_db_password
          }
          env {
            name = "TS3SERVER_DB_NAME"
            value = var.teamspeak_db_name
          }
          env {
            name = "TS3SERVER_DB_WAITUNTILREADY"
            value = "30"
          }
          env {
            name = "TS3SERVER_LICENSE"
            value = "accept"
          }
//          resources {
//            limits {
//              cpu    = "0.5"
//              memory = "512Mi"
//            }
//            requests {
//              cpu    = "250m"
//              memory = "50Mi"
//            }
//          }
          port {
            container_port = var.teamspeak_voice_port
            protocol = "UDP"
          }
          port {
            container_port = var.teamspeak_query_raw_port
          }
          port {
            container_port = var.teamspeak_query_ssh_port
          }
          port {
            container_port = var.teamspeak_filetransfer_port
          }
        }
        volume {
          name = "teamspeak-data"
          persistent_volume_claim {
            claim_name = "teamspeak-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "teamspeak_service" {
  metadata {
    name = "teamspeak-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "teamspeak"
    }
    port {
      name     = "voice"
      port     = var.teamspeak_voice_port
      protocol = "UDP"
    }
    port {
      name = "server-query-raw"
      port = var.teamspeak_query_raw_port
    }
    port {
      name = "server-query-ssh"
      port = var.teamspeak_query_ssh_port
    }
    port {
      name = "file-transport"
      port = var.teamspeak_filetransfer_port
    }
    type = "ClusterIP"
  }
}
