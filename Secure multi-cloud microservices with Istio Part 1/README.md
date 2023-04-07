# mTLS Demo

This demo will walk you through ensuring your workloads communicate only over mutual TLS after migrating to Istio.
By default, Istio enables mTLS in permissive mode, which allows both secure and insecure communication between workloads. On forcing mTLS to strict mode for a particular namespace, all insecure traffic to that namespace will fail.

- Set up the cluster
```
$ kubectl create ns demo-1
$ kubectl apply -f <(istioctl kube-inject -f httpbin.yaml) -n demo-1
$ kubectl apply -f <(istioctl kube-inject -f sleep.yaml) -n demo-1
$ kubectl create ns demo-2
$ kubectl apply -f <(istioctl kube-inject -f httpbin.yaml) -n demo-2
$ kubectl apply -f <(istioctl kube-inject -f sleep.yaml) -n demo-2
```
- Set up unsecured namespace
```
$ kubectl create ns demo-unsecured
$ kubectl apply -f sleep.yaml -n demo-unsecured
```
- If privileged proxies are enabled (`values.global.proxy.privileged=true`),  print out all traffic to `demo-`'s httpbin. You will notice that most of the traffic will be encrypted, even the traffic from `demo-unsecured`.
```
$ kubectl exec -n demo-1 "$(kubectl get pod -n demo-1 -l app=httpbin -o jsonpath={.items..metadata.name})" -c istio-proxy -- sudo tcpdump dst port 80  -A
```
- Verify by sending curl http requests
```
$ for from in "demo-1" "demo-2" "demo-unsecured"; do
	for to in "demo-1" "demo-2"; do
		kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl http://httpbin.${to}:8000/ip -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n";
	done;
done
```
- Lock down to strict mTLS by namespace
```
$ kubectl apply -f strict-mtls.yaml -n demo-1
```
- Verify that the requests to the locked down namespace fail if they come from the unsecured namespace
```
$ for from in "demo-1" "demo-2" "demo-unsecured"; do
	for to in "demo-1" "demo-2"; do
		kubectl exec "$(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name})" -c sleep -n ${from} -- curl http://httpbin.${to}:8000/ip -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n";
	done;
done
```
- If privileged proxies were enabled, you will notice that there is no traffic from `demo-unsecured`


## Securing to mTLS for entire mesh

By putting the strict mTLS policy in the system namespace of your Istio installation, you can lock down workloads in all namespaces to only accept mutual TLS traffic:
```
$ kubectl apply -f strict-mtls.yaml -n istio-system
```

## Cleanup
 - Remove the peer authentication policies
```
$ kubectl delete -f strict-mtls.yaml -n demo-1
$ kubectl delete -f strict-mtls.yaml -n istio-system
```
 - Remove the peer authentication policies
```
$ kubectl delete ns demo-1 demo-2 demo-unsecured
```