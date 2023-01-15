# devops-2022

Devops session 2022

## TODO

DevOps Part 3 Assignment 1

- Deploy ec2 autoscaling group with launch template. -> done
- Deploy App and Api in k8s with nodeslector and resource quota
- Deploy Database in k8s and connect with api
- Create a kubeconfig that has read only access to pods of specific namespace
- Setup EFK in k8s for log

DevOps Part 3 Assignment 2

- Setup GitHub action/circleci/Travisci/jenkins for CI
- Setup ArgoCD for CD or setup argo stack for CI/CD
- Deploy Prometheus and grafana for resource monitoring(create user and alert)
- Deploy cronjob, Ingress and Secrets & configmap

## Steps to run locally

- Create kind cluster with 2 worker nodes
  ```
  make cluster
  ```
- Deploy metric server
  ```
  make deploy-metric-server
  ```
- Label node to dev
  ```
  kubectl label nodes devops-demo-worker env=dev
  ```
- Create namespace and define request quota
  ```
  make ns-quota
  ```
- Deploy mondo-db database
  ```
  make database
  ```
- Deploy application
  ```
  cd app &&  make apply
  ```
- Deploy efk
  ```
  make efk
  ```
