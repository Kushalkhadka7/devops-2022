.PHONY: cluster delete-clusters help database
.DEFAULT_GOAL := help

APP_ROOT ?= $(shell 'pwd')

# Load all the environment variables from .env
export $(cat .env | xargs)

define BROWSER_PYSCRIPT
	import os, webbrowser, sys

	try:
		from urllib import pathname2url
	except:
		from urllib.request import pathname2url

	webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

APP_ROOT ?= $(shell 'pwd')
CLUSTER_CONFIG ?= $(APP_ROOT)/cluster/kind-cluster.yml
CLUSTER_NAME ?= "devops-demo"
METAL_LB ?= $(APP_ROOT)/metallb
METRIC_SERVER ?= $(APP_ROOT)/metricserver

cluster: ## create cluster
	@kind create cluster --name $(CLUSTER_NAME) --config $(CLUSTER_CONFIG)

delete-clusters: ## delete cluster
	@kind delete clusters $(CLUSTER_NAME)

cluster-info: ## get all clusters
	@kind get clusters

use-cluster-config: ## user current cluster config file
	@kubectl config use-context kind-$(CLUSTER_NAME)

cluster-lb: ## deploy metallb overlay network to cluster
	@kubectl apply -f $(METAL_LB)/namespace.yml
	@kubectl apply -f $(METAL_LB)/metallb.yml
	@kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" 

deploy-metric-srv:
	@kubectl apply -f $(METRIC_SERVER)/deployment.yml

label-node:
	@kubectl label nodes $(NODE_NAME) env=$(STAGE)

ns-quota:
	@kubectl apply -f $(APP_ROOT)/k8s .

database:
	@kubectl apply -f $(APP_ROOT)/database .

efk:
	@kubectl apply -f $(APP_ROOT)/efk .

deploy-monitoring:
	@kubectl create ns monitoring
	@helm repo add grafana https://grafana.github.io/helm-charts
	@helm repo update 
	@helm install prometheus prometheus-community/prometheus -n monitoring

get-grafana-login-password:
	@kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)