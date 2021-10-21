#!/bin/bash

# https://github.com/falcosecurity/charts/tree/master/falco
# https://github.com/falcosecurity/profiles

if [ ! -d "falco" ]; then
    git clone https://github.com/falcosecurity/falco.git
fi

if [ ! -d "falco-extras" ]; then
    git clone https://github.com/draios/falco-extras.git
fi

./falco-extras/scripts/rules2helm \
    ./custom-rules.yaml \
    > rule_update_falco.yaml

helm upgrade falco falcosecurity/falco -f rule_update_falco.yaml \
    --namespace falco \
    --version 1.5.7 \
    --set auditLog.enabled=true \
    --set auditLog.dynamicBackend.enabled=true \
    --set falco.webserver.enabled=true \
    --set falco.webserver.nodePort=32765
