# Test script to create a Project in AD

# Parameters: 
param
(
    [parameter(HelpMessage="The Azure DevOps Organization the project will be created in.")]
    $org = " ",

    [parameter(HelpMessage="The name of the project.")]
    $projectName = "Liv Project",

    [parameter(HelpMessage="The name of the process used.")]
    $processName = " ",

    [parameter(HelpMessage="The list of processes in the tenant")]
    $processList = "api-version=7.2-preview.1",
    
    [parameter(HelpMessage="The list of projects in the tenant")]
    $projectList = "api-version=7.2-preview.4",
)

# The Organization URL
$fullOrgURL = "https://dev.azure.com/$org

# PAT for authentication

$az devops login --organization $fullOrgURL
Write-host "Creating to $org."
az devops login --org $fullOrgUrl

# Get list of all processes
$processesUrl = "$azureDevOpsUrl/_apis/process/processes?$processList"
$processesResponse = Invoke-RestMethod -Uri $processesUrl -Headers $headers -Method Get
$processes = $processesResponse.value

$processes | ForEach-Object {
    If ($_.name -eq $processName) {
        $processID = $_.id
        Write-Host "Process ID: $processID for Process Name: $processName"
    }
}

# Checking and getting list of Projects in ADO
$p = az devops project show --project $projectName --org $fullOrgUrl 
Write-host "Checking if project '$projectName' already exists." -ForegroundColor Blue
if ($p -ne $null) {
  # if this triggers, the project DOES exist
  Write-host "Project '$projectName' already exists. Exiting Pipeline."
  exit
}

# Create new project
Write-host "Creating new project: '$projectName'" -ForegroundColor Blue
$project = az devops project create --name $projectName --org $fullOrgURL