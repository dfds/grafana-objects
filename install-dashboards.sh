#!/bin/bash

S_CONTEXT=$(kubectl config current-context)
if [[ $S_CONTEXT == "hellman-saml" ]]; then
    echo "#---------------------------------- WARNING ----------------------------------#"
    echo "# You may not run this towards Hellman. Use the Azure DevOps pipeline instead #"
    echo "#-----------------------------------------------------------------------------#"
else
    if [[ -d configmaps ]]; then
        rm -rf configmaps
    fi
    pwsh Convert-JSONToConfigmap.ps1
    if [[ $? -ne 0 ]]; then
        echo "#---------------------------------- WARNING ----------------------------------#"
        echo "# PowerShell conversion of configmaps failed. Is PowerShell installed?        #"
        echo "#-----------------------------------------------------------------------------#"
        exit 1
    else
        kubectl delete configmaps -n monitoring -l grafana_objects="1"
        kubectl apply -f configmaps  -n monitoring
        kubectl rollout restart deployment -n monitoring monitoring-grafana
    fi
fi
