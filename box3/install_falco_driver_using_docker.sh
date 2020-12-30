#!/bin/bash

# Falco driver on host VM using Docker
docker pull falcosecurity/falco-driver-loader:latest
docker run --rm -i -t \
   --privileged \
   -v /root/.falco:/root/.falco \
   -v /proc:/host/proc:ro \
   -v /boot:/host/boot:ro \
   -v /lib/modules:/host/lib/modules:ro \
   -v /usr:/host/usr:ro \
   -v /etc:/host/etc:ro \
   falcosecurity/falco-driver-loader:latest