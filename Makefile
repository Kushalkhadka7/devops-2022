.PHONY: cluster delete-clusters help database
.DEFAULT_GOAL := help


APP_ROOT ?= $(shell 'pwd')
CLUSTER_CONFIG ?= $(APP_ROOT)/cluster/kind-cluster.yml
CLUSTER_NAME ?= "devops-demo"
METAL_LB ?= $(APP_ROOT)/metallb
METRIC_SERVER ?= $(APP_ROOT)/metricserver
DATABASE ?= $(APP_ROOT)/database
EFK ?= $(APP_ROOT)/efk
ISTIO ?= $(APP_ROOT)/istio-1.16.1
K8S ?= $(APP_ROOT)/k8s

include $(METAL_LB)/Makefile
include $(METRIC_SERVER)/Makefile
include $(DATABASE)/Makefile
include $(EFK)/Makefile
include $(ISTIO)/Makefile
include $(K8S)/Makefile

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

deploy-argocd:
	@kubectl apply -f $(APP_ROOT)/argo/namespace.yml
	@kubectl apply -f $(APP_ROOT)/argo/argo.yaml -n argocd
	@kubectl apply -f $(APP_ROOT)/argo/kustomize.yml -n argocd

create-argo-apps:
	@kubectl apply -f $(APP_ROOT)/argo/apps/app.yaml
	@kubectl apply -f $(APP_ROOT)/argo/apps/auth.yml

get-argo-password:
	@kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

deploy-monitoring:
	@kubectl create ns monitoring
	@helm repo add grafana https://grafana.github.io/helm-charts
	@helm repo update 
	@helm install prometheus prometheus-community/prometheus -n monitoring

get-grafana-login-password:
	@kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Help
help:
	@echo "Hep"