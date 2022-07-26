# localhost --> cluster-lb:8080 --> services 8080:80--> pod:80


terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}


# K8s stuff
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-${var.demo_name}"
}
resource "kubernetes_namespace" "example" {
  metadata {
    name = "${var.demo_name}-app-namespace"
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "${var.demo_name}-demo-app"
    labels = {
      app = "${var.demo_name}"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "${var.demo_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.demo_name}"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "demo-app"
          port {
            container_port = 80
            name           = "http"
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = var.demo_name
  }
  spec {
    selector = {
      app = "${var.demo_name}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

