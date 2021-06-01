provider "kubernetes" {
  host = "https://${google_container_cluster.test-cluster.endpoint}"
  token = data.google_service_account_access_token.my_kubernetes_sa.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.test-cluster.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-first-namespace"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu = "100m"
              memory = "512Mi"
            }
            requests = {
              cpu = "100m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }

    type = "NodePort"
  }
}

resource "kubernetes_ingress" "nginx_ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "nginx-ingress"
    annotations = {
      "cloud.google.com/load-balancer-type" = "External",
      "kubernetes.io/ingress.class" = "gce",
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.nginx.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}
