VERSION_HELMFILE = 0.166.0
FILE_HELMFILE = /tmp/helmfile-$(VERSION_HELMFILE).tar.gz

VERSION_HELM = v3.15.3
FILE_HELM = /tmp/helm-$(VERSION_HELM).tar.gz

# run only with super user
install-helms:
	@curl --output $(FILE_HELM) https://get.helm.sh/helm-v3.15.3-linux-amd64.tar.gz
	@curl --output $(FILE_HELMFILE) -L https://github.com/helmfile/helmfile/releases/download/v$(VERSION_HELMFILE)/helmfile_$(VERSION_HELMFILE)_linux_amd64.tar.gz

	@tar -xf $(FILE_HELM) -C /opt/
	@tar -xf $(FILE_HELMFILE) -C /tmp

	@ln -s /opt/linux-amd64/helm /bin/helm
	@mv /tmp/helmfile /bin/helmfile

	@rm -f $(FILE_HELM)
	@rm -f $(FILE_HELMFILE)

create:
	@kind create cluster --config kind/config.yaml

	#bash utils/01-create-namespaces.sh
	#bash utils/02-add-entry-on-etc-hosts.sh

	kubectl apply -f k8s-manifests/01-create-namespaces.yaml
	kubectl apply -f k8s-manifests/02-setup-hosts.yaml

	#$(MAKE) metallb
	#$(MAKE) ingress-nginx 
	$(MAKE) helmfile

helmfile:
	@helm plugin install https://github.com/databus23/helm-diff || true
	@helmfile apply -f values/helmfile/helmfile.yaml

metallb:
	#@kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.7/config/manifests/metallb-native.yaml
	#@helm repo add metallb https://metallb.github.io/metallb
	#@helm repo update
	#@helm upgrade \
	#	--install \
	#	--namespace metallb-system \
	#	--create-namespace \
	#	-f values/metallb/values.yaml \
	#	metallb \
	#	metallb/metallb

	@kubectl -n metallb-system wait --selector=app=metallb --for=condition=ready pod
	@kubectl apply -f k8s-manifests/03-metallb-pool.yaml

# install-helm as pre step
ingress-nginx:
	#@helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx/
	#@helm repo update
	#@helm upgrade \
	#	--install \
	#	--namespace ingress-nginx \
	#	--create-namespace \
	#	-f values/ingress-nginx/values.yaml \
	#	ingress-nginx \
	#	ingress-nginx/ingress-nginx

destroy:
	@kind delete cluster
