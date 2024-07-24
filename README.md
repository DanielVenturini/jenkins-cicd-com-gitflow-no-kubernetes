# jenkins-cicd-com-gitflow-no-kubernetes

My notes about the DevOps [course](https://www.udemy.com/course/jenkins-cicd-com-gitflow-no-kubernetes) with K8S and Jenkins. This deploy and Kind cluster (Kubernetes In Docker) with Nginx Ingress, Jenkins and Helm.

## Create

Clone this repository and type:

```bash
make create
```

This will create the cluster with Kind. Please, ensure the api-server node (container) has the address `172.18.0.2`, because this is the address configured in `kind/config.yaml`.

```bash
docker inspect kind-control-plane --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

If not, destroy the cluster and create it again.

### Destroy

Please, run the following command:

```bash
make destroy
```

Or you can simply delete the Kind containers like this:

```bash
docker rm -f $(docker ps -qa --filter label=io.x-k8s.kind.cluster=kind)
```
