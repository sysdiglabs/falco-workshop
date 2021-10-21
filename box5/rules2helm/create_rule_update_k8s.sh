#!/bin/bash

search_dir=../falco/rules.d

nrules=0
if [ "$(ls -A $search_dir)" ]; then
  rules_d_files=
  for entry in "$search_dir"/*
  do
    rules_d_files="$rules_d_files $entry"
    nrules=$((nrules+1))
  done
  ./rules2helm.sh ../falco/falco_rules.local.yaml $rules_d_files >rule_update_falco.yaml
else
  ./rules2helm.sh ../falco/falco_rules.local.yaml >rule_update_falco.yaml
fi
echo "Updating $nrules custom rules files"



