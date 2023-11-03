## installing istio with ambient profile

```
istioctl install --set profile=ambient --set \
components.ingressGateways[0].enabled=true --set \
components.ingressGateways[0].name=istio-ingressgateway --skip-confirmation
```

## install kubernetes gateway api

```
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd/experimetal?ref=v0.8.0-rc1" | kubectl apply -f -; }
```

## communication between pods

```
kubectl exec deploy/sleep-depl-ns1 -n ns1 -- curl -s http://echoserver-service-ns2.ns2.svc.cluster.local
```
