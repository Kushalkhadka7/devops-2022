install-istio-binary:
	echo $(APP_ROOT)/istio-1.16.1/bin/istioctl
	sudo cp $(APP_ROOT)/istio-1.16.1/bin/istioctl /usr/local/bin && istioctl

install-istio-profile:
	@istioctl install --set profile=demo -y

enable-istio-injection:
	@kubectl label namespace default istio-injection=enabled
	@kubectl label namespace dev istio-injection=enabled

reload-pods:
	@kubectl rollout restart deployment dev-manager -n dev
	@kubectl rollout restart deployment dev-auth -n dev

deploy-ingress-gateway:
	@kubectl apply -f $(APP_ROOT)/ingress/gateway.yml

deploy-virtual-services:
	@kubectl apply -f $(APP_ROOT)/ingress/virtualservice/auth.yml
	@kubectl apply -f $(APP_ROOT)/ingress/virtualservice/manager.yml
	@kubectl apply -f $(APP_ROOT)/ingress/virtualservice/kiali.yml
	@kubectl apply -f $(APP_ROOT)/ingress/virtualservice/argo.yml