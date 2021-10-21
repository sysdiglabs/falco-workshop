#!/bin/bash

# New way of installing Falco
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Same with dynamic websink, deprecated by main Kubernetes project
helm install falco falcosecurity/falco \
    --namespace falco \
    --version 1.5.7 \
    --set auditLog.enabled=true \
    --set auditLog.dynamicBackend.enabled=true \
    --set falco.webserver.enabled=true \
    --set falco.webserver.nodePort=32765

exit

# Same with dynamic websink, deprecated by main Kubernetes project
helm install falco falcosecurity/falco \
    --namespace falco \
    --set auditLog.enabled=true 
    --set auditLog.dynamicBackend.enabled=true

# Old way of installinf Falco, but the one that works with audit log
# Same with webhook for kube audit, deprecated

helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install falco falcosecurity/falco \
    --set falco.webserver.enabled=true \
    --set falco.webserver.clusterIP=10.96.0.99







 
