# Import all YAML files in folder
$YAMLFiles = Get-ChildItem -Name -File -Filter '*.yaml' -Path ".\datasources"

Write-Output "Creating secrets folder"
New-Item -Name "secrets" -ItemType "directory"

Write-Output "Converting the following Secrets:"

foreach ($File in $YAMLFiles) {
    $DATASOURCE_NAME = ($File -replace "-[0-9]{13}", "" -replace " ", "-" -replace ".yaml", "").ToLower()

    # Generate secret, indenting YAML 4 spaces
    (Get-Content .\templates\template-datasource-s.yaml) -replace "DATASOURCE_NAME", $DATASOURCE_NAME | Out-File .\secrets\$($DATASOURCE_NAME)-s.yaml
    '    ' + (Get-Content .\datasources\$($File) -Raw) -replace "`n", "`n    " | Out-File .\secrets\$($DATASOURCE_NAME)-s.yaml -Append

}

Get-ChildItem -Name -Path ".\secrets"