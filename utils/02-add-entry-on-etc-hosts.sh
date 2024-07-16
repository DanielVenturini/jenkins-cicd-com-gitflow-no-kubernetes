controlPlaneAddress=$(docker inspect kind-control-plane --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

# adding entry on hosts for all workers
for container in $(docker ps -f label=io.x-k8s.kind.role=worker -q); do
	docker exec ${container} bash -c "echo ${controlPlaneAddress} argocd.localhost.com jenkins.localhost.com gitea.localhost.com sonarqube.localhost.com harbor.localhost.com >> /etc/hosts"
done
