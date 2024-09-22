# AWS EKS Cluster with Managed Node Group and ALB Ingress Controller using Terraform

This repository contains Terraform code to create an Amazon EKS (Elastic Kubernetes Service) cluster with a managed node group and the AWS ALB (Application Load Balancer) Ingress Controller.

## Prerequisites

- Terraform
- AWS CLI configured with appropriate credentials
- kubectl
- AWS IAM Authenticator for Kubernetes
- Helm

## Setup Instructions

### 1. Clone the Repository

```sh
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```
### 2. Configure Terraform Variables and apply


```sh
aws eks update-kubeconfig --name eks-cluster --region us-east-1
kubectl get nodes
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install my-nginx-ingress ingress-nginx/ingress-nginx
kubectl get pods -n default
kubectl get svc my-nginx-ingress-ingress-nginx-controller

kubectl apply -f kube/deployment.yaml 
kubectl apply -f kube/service.yaml 
kubectl apply -f kube/ingress.yaml

kubectl get svc -n default
curl http://<EXTERNAL-IP>

kubectl delete -f kube/deployment.yaml 
kubectl delete -f kube/service.yaml 
kubectl delete -f kube/ingress.yaml
helm uninstall my-nginx-ingress
```

**Note:** After that, set up the ALB Ingress Controller. Use the eksctl.txt file and follow the steps in the file. For testing everything, use the content in the kube folder. This folder contains the deployment file, service file, and ingress file.
