#!/bin/bash

# https://github.com/falcosecurity/charts/tree/master/falco
# https://github.com/falcosecurity/profiles

[ ! -d "falco-extras" ] && git clone https://github.com/draios/falco-extras.git
cd falco-extras
./scripts/rules2helm ../rules/falco_rules.local.yaml ../rules/k8s_audit_rules.yaml > rule_update_falco.yaml

helm upgrade falco falcosecurity/falco -f rule_update_falco.yaml \
    --set falco.webserver.enabled=true \
    --set falco.webserver.clusterIP=10.96.0.99 \
    --set=pullPolicy=IfNotPresent --wait --timeout 40s