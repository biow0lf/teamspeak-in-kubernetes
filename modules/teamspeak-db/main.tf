resource "kubernetes_persistent_volume_claim" "teamspeak_db_pvc" {
  metadata {
    name      = "teamspeak-db-pvc"
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

resource "kubernetes_stateful_set" "teamspeak_db_stateful_set" {
  metadata {
    name      = "teamspeak-db-stateful-set"
    namespace = var.namespace
    labels = {
      app = "teamspeak-db"
    }
  }
  spec {
    service_name = "teamspeak-db-service"
    selector {
      match_labels = {
        app = "teamspeak-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "teamspeak-db"
        }
      }
      spec {
        container {
          name              = "teamspeak-db"
          image             = "docker.io/library/mariadb:10.5.8"
          image_pull_policy = "Always"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.teamspeak_db_root_password
          }
          env {
            name  = "MYSQL_USER"
            value = var.teamspeak_db_user
          }
          env {
            name  = "MYSQL_PASSWORD"
            value = var.teamspeak_db_password
          }
          env {
            name  = "MYSQL_DATABASE"
            value = var.teamspeak_db_name
          }
          volume_mount {
            mount_path = "/var/lib/mysql"
            name       = "teamspeak-db-data"
          }
//          resources {
//            requests {
//              cpu    = "250m"
//              memory = "128Mi"
//            }
//            limits {
//              cpu    = "500m"
//              memory = "256Mi"
//            }
//          }
          port {
            container_port = 3306
          }
        }
        volume {
          name = "teamspeak-db-data"
          persistent_volume_claim {
            claim_name = "teamspeak-db-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "teamspeak_db_service" {
  metadata {
    name      = "teamspeak-db-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "teamspeak-db"
    }
    session_affinity = "ClientIP"
    port {
      port = 3306
    }
    type = "ClusterIP"
  }
}
