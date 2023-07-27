#!/bin/bash
set -e
target_folder=$1

if [ -z "$target_folder" ]
then
  echo 'Please specify target folder'
  exit 1
fi

echo 'Creating configmaps for alert rules...'
alert_rules_folder="alerts/*.yaml"
for f in $alert_rules_folder;
do
  parentname="$(basename "$(dirname "$f")")"
  Alert_Rule_Name=$(echo $(basename ${f}) | sed 's/.yaml//g')
  target_manifest_file=$target_folder/${Alert_Rule_Name}-alerts.yaml
  cat templates/template-alert-rules-cm.yaml | sed "s/RULENAME/${Alert_Rule_Name}/g"  > $target_manifest_file
  cat $f | sed "1s/^//" | sed "s/^/    /g"  >> $target_manifest_file
done
echo 'Done.'