## Nginx ingress

To monitor nginx ingress with grafana dashboard install nginx ingress with helm.
used helm chart values yaml file is enabled with monitoring.    

1. Installing helm

```bash
kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade

helm version
```

2. Installing nginx ingress using helm
```bash
helm install stable/nginx-ingress --name nginx-ingress -f values.yaml --namespace kube-system
```