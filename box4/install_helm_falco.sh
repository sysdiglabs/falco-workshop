#!/bin/bash

# Old way of installing Falco chart, compatible with Minikube 1.8.2, deprecated
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
helm install falco stable/falco --version  1.0.12
exit

# Same with webhook for kube audit, deprecated
helm install falco stable/falco \
    --set falco.webserver.enabled=true \
    --set falco.webserver.clusterIP=10.96.0.40 \
    --namespace falco falcosecurity/falco --version  1.0.12


# New way of installing Falco, not compatible with Minikube right now
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco

# Same with websink, deprecated
helm install falco falcosecurity/falco \
    --namespace falco falcosecurity/falco \
    --set auditLog.enabled=true --set auditLog.dynamicBackend.enabled=true