# jenkins-cicd-com-gitflow-no-kubernetes

My notes about the DevOps [course](https://www.udemy.com/course/jenkins-cicd-com-gitflow-no-kubernetes) with K8S and Jenkins. This deploys a Kind cluster (Kubernetes In Docker) with Nginx Ingress, Jenkins and Helm.

## Create

Clone this repository and run:

```bash
make create
```

This creates a cluster with Kind. Please, ensure the api-server node (container) has the address `172.18.0.2`, because this is the address configured in `kind/config.yaml`.

```bash
docker inspect kind-control-plane --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

If not, destroy the cluster and create it again.

### Destroy

Please, run the following command:

```bash
make destroy
```

Or you can simply delete Kind containers like this:

```bash
docker rm -f $(docker ps -qa --filter label=io.x-k8s.kind.cluster=kind)
```

### Network considerations

If Kind cluster is running inside of another host, such as a VM, some redirects may be required:

```bash
kubectl get ingress -A    # check ingress's address
iptables -t nat -A PREROUTING -p tcp -d LOCAL_IP_ADDRESS --dport 80 -j DNAT --to-destination INGRESS_ADDRESS:80
iptables -t nat -A POSTROUTING -p tcp -d INGRESS_ADDRESS --dport 80 -j MASQUERADE
iptables -A FORWARD -p tcp -d INGRESS_ADDRESS --dport 80 -j ACCEPT
```
