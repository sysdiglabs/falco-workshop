#!/bin/bash

source ./ver_falco.sh
# echo "Using Falco version $FALCO_VERSION"

./create_rule_update_k8s.sh

result=$(helm upgrade falco --namespace falco -f rule_update_falco.yaml \
  $FALCO_K8S_AUDIT \
  stable/falco --version "$FALCO_CHART_VERSION" \
  --set=pullPolicy=IfNotPresent --wait --timeout 40s 2>&1)


if [ $? -eq 0 ]; then
  rm rule_update_falco.yaml >/dev/null
  # echo "Falco rules updated"
  exit 0
fi

echo "🛑  Can't update rules"
echo "$result"
exit 1

