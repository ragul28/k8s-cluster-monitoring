#!/user/bin/env bash
#Creates complete monitoring

work_dir='pwd'
namespace=monitoring

echo "checking if kubectl is present"

if ! hash kubectl 2>/dev/null
then
    echo "'kubectl' was not found in PATH"
    echo "Kindly ensure that you can acces an existing kubernetes cluster via kubectl"
    exit
fi

kubectl version --short

echo "Current list of namespaces on the kubernetes cluster:"
echo
kubectl get namespace

ns = kubectl get namespace | grep $namespace | awk '{print $1}'

if [ "$ns" != "" ]; then
    echo "Using $namespace namespace"
else
    kubectl create namespace $namespace
    echo "Using created namespace"
echo

echo "Creating prometheus deployment"

kubectl create -n $namespace -f $work_dir/cluster-role.yaml

kubectl create -n $namespace -f $work_dir/config-map.yaml

kubectl create -n $namespace -f $work_dir/prometheus-deployment.yaml


echo "Creating grafana deployment"

kubectl create -n $namespace -f $work_dir/grafana-deployment.yaml


echo "Creating grafana config for provisioning"

kubectl create configmap -n $namespace --from-file=$work_dir/grafana-conf/dashboards.yaml

kubectl create configmap -n $namespace --from-file=$work_dir/grafana-conf/datasource.yaml


echo "Creating grafana dashboard as configmap"

kubectl create configmap -n $namespace --from-file=$work_dir/grafana-conf/nginx-dashboard.json

kubectl create configmap -n $namespace --from-file=$work_dir/grafana-conf/clustermon-dashboard.json

kubectl create configmap -n $namespace --from-file=$work_dir/grafana-conf/nodemon-dashboard.json


echo "Printout Of the $namespace Objects"

echo
kubectl get -n $namespace all
