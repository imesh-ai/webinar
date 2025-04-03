helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus --create-namespace

istioctl install --set values.global.proxy.privileged=true

kubectl exec -it httpbin-0 -c istio-proxy -- bash
sudo su
tcpdump -i eth0 -w /dev/test-eth.pcap

kubectl cp httpbin-0:/dev/test-eth.pcap test.eth.pcap -c istio-proxy