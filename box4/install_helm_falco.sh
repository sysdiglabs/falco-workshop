#!/bin/bash

# Old Falco Helm chart repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update

# Old way of installinf Falco, but the one that works with audit log
# Same with webhook for kube audit, deprecated
helm install falco stable/falco \
    --version 1.0.12 \
    --set falco.webserver.enabled=true \
    --set falco.webserver.clusterIP=10.96.0.99

exit

# New way of installing Falco, not compatible with Minikube right now
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco

exit

# Same with dynamic websink, deprecated by main Kubernetes project
helm install falco falcosecurity/falco \
    --namespace falco \
    --set auditLog.enabled=true --set auditLog.dynamicBackend.enabled=true




 
