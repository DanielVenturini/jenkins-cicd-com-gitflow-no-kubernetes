create:
	@kind create cluster --config kind/config.yaml

	#bash utils/01-create-namespaces.sh
	#bash utils/02-add-entry-on-etc-hosts.sh
	kubectl apply -f k8s-manifests/01-create-namespaces.yaml
	kubectl apply -f k8s-manifests/02-setup-hosts.yaml

destroy:
	@kind delete cluster
