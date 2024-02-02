# Pre-requisites

- Install and configure ingress controller (we will be using NGINX in this demo)
- Install istio and its ingress gateway (we will be using istio-ingress as another controller to demonstrate)
- Install kubernative gateway api CRDs

# Configuring NGINX for server snippets

- Edit config map

  ```
  kubectl edit configmap ingress-nginx-controller -n ingress-nginx
  ```

- Apply the configuration

  ```
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: ingress-nginx-controller
    namespace: ingress-nginx
  data:
    enable-snippet: "true"
  ```

- Restart controller
  ```
  kubectl rollout restart deployment ingress-nginx-controller -n ingress-nginx
  ```

# Use loadbalancer (Haproxy for local)

- `sudo vim /etc/haproxy/haproxy.cfg`
- Add your ip taken from `ifconfig`
- `sudo systemctl reload haproxy`
- Sample config

  ```
    listen stats
      bind :9000
      stats enable
      stats uri /stats
      stats refresh 10s

    frontend my_frontend
        bind youripandport:80
        mode http
        default_backend my_backend

    backend my_backend
        mode http
        balance roundrobin
        server server1 youringressip:80 weight 90 check
        server server2 yourgatewayip:80 weight 10 check

  ```

# Test API

- `curl -v your-ip`
- `curl -I your-ip`
- `for i in $(seq 1 100); do curl -sI http://your-lb-ip; done | grep -c NGINX`
- `for i in $(seq 1 100); do curl -sI http://your-lb-ip; done | grep -c ISTIO`
