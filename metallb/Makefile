.PHONY: deploy-metal-lb

# Deploy metallb overlay network to kind cluster
deploy-metal-lb: 
	@kubectl apply -f $(METAL_LB)/namespace.yml
	@kubectl apply -f $(METAL_LB)/metallb.yml
	@kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 
