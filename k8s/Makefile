.PHONY: dev-env-resource-quota

# Make resource quota for dev namespace
dev-env-resource-quota:
	@kubectl apply -f $(APP_ROOT)/k8s/namespaces.yml
	@kubectl apply -f $(APP_ROOT)/k8s/resource_quota.yml
