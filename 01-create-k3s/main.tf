# localhost --> cluster-lb:8080 --> services 8080:80--> pod:80


terraform {
  required_providers {
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "0.0.6"
    }
  }
}

# k3s stuff

provider "k3d" {
  # Configuration options
}

resource "k3d_cluster" "mycluster" {
  name    = var.demo_name
  servers = 1
  agents  = 2


  kube_api {
    host      = "127.0.0.1"
    host_ip   = "127.0.0.1"
    host_port = 6445
  }

  image   = "rancher/k3s:v1.20.4-k3s1"
  network = "${var.demo_name}-net"
  token   = "superSecretToken"


  port {
    host_port      = 8080
    container_port = 8080
    node_filters = [
      "loadbalancer",
    ]
  }


  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

  # TODO: add extra_agent_args for oidc configuration

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}
