#!/bin/bash
kubectl get configmap falco -o jsonpath='{.data.falco\.yaml}' >falco.yaml
