#!/bin/bash

kubectl exec --stdin --tty $(kubectl get pod -l app=falco -o=name) -- /bin/bash