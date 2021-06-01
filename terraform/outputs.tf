output "lb_ip" {
  value = kubernetes_ingress.nginx_ingress.status.0.load_balancer.0.ingress.0.ip
}
