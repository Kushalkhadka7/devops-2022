.PHONY: deploy-mongo-db

# Deploy mongo db on cluster
deploy-mongo-db:
	@kubectl apply -f $(APP_ROOT)/database/config.yml -n $(STAGE)
	@kubectl apply -f $(APP_ROOT)/database/secrets.yml -n $(STAGE) 
	@kubectl apply -f $(APP_ROOT)/database/mongo-db.yml -n $(STAGE)
	@kubectl apply -f $(APP_ROOT)/database/service.yml -n $(STAGE)
