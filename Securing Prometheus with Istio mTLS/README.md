References:
 - https://istio.io/latest/docs/ops/integrations/prometheus/#tls-settings 

---

Set up the prometheus helm charts

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Install Prometheus into `prometheus` namespace

```
helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus --create-namespace
```

Grabbing tcpdump for wireshark:

- Setup istio with privileged proxies to be able to run tcpdump
  ```
  istioctl install --set values.global.proxy.privileged=true
  ```
- Exec into target pod and run tcpdump
  ```
  kubectl exec -it httpbin-0 -c istio-proxy -- bash
  sudo su
  tcpdump -i eth0 -w /dev/test-eth.pcap
  ```
- Copy out dump for analysis
  ```
  kubectl cp httpbin-0:/dev/test-eth.pcap test.eth.pcap -c istio-proxy
  ```
