deploy-monitoring:
	@kubectl create ns monitoring
	@helm repo add grafana https://grafana.github.io/helm-charts
	@helm repo update 
	@helm install prometheus prometheus-community/prometheus -n monitoring

get-grafana-login-password:
	@kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
