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
