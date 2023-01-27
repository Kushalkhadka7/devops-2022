.PHONY: cluster delete-clusters help database
.DEFAULT_GOAL := help


APP_ROOT ?= $(shell 'pwd')
CLUSTER_CONFIG ?= $(APP_ROOT)/cluster/kind-cluster.yml
CLUSTER_NAME ?= "devops-demo"
METAL_LB ?= $(APP_ROOT)/metallb
METRIC_SERVER ?= $(APP_ROOT)/metricserver
DATABASE ?= $(APP_ROOT)/database
EFK ?= $(APP_ROOT)/efk
ARGO ?= $(APP_ROOT)/argo
ISTIO ?= $(APP_ROOT)/istio-1.16.1

include $(METAL_LB)/Makefile
include $(METRIC_SERVER)/Makefile
# include $(DATABASE)/Makefile
include $(EFK)/Makefile
include $(ARGO)/Makefile
include $(ISTIO)/Makefile

# Create kind cluster
cluster: 
	@kind create cluster --name $(CLUSTER_NAME) --config $(CLUSTER_CONFIG)

# Delete kind cluster
delete-clusters: 
	@kind delete clusters $(CLUSTER_NAME)

# Get list of kind clusters
cluster-info: ## get all clusters
	@kind get clusters

# User current cluster config file
use-cluster-config: 
	@kubectl config use-context kind-$(CLUSTER_NAME)

# Label given node with the current env
label-node:
	@kubectl label nodes $(NODE_NAME) env=$(STAGE)

# Help
help:
	@echo "Hep"