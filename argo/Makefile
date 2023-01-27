.PHONY: deploy-argocd

deploy-argocd:
	@kubectl apply -f $(APP_ROOT)/argo/namespace.yml
	@kubectl apply -f $(APP_ROOT)/argo/argo.yml
	@kubectl apply -f $(APP_ROOT)/argo/kustomize.yml

create-argo-apps:
	@kubectl apply -f $(APP_ROOT)/argo/apps .