$OrganizationName = " "
$projectName = " "

$PAT = " "

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PAT")) }

$UriOrga = "https://$($OrganizationName).visualstudio.com/" 
$UriOrga
$uriAccount = $UriOrga + "_apis/projects?api-version=6.0"
$response = Invoke-RestMethod -Uri $uriAccount -Method get -Headers $AzureDevOpsAuthenicationHeader 


$Project = $response.value | where { $_.Name -eq $projectName }

$ProjectID = $Project.id

echo $ProjectID

$AZurl = 'https:/.dev.azure.com/{ORG}/_apis/userentitlements?api-version=7.0'

$AZbase64AuthInfo = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PAT")) }

$AZbody = 
@{
  accessLevel = @{
   accountLicenseType = "Stakeholder";
  }
  extensions =  @{
      id = "ms.feed"
    }
  user = @{
     principalName=  " ";
     subjectKind =  "user";
  }
  projectEntitlements =  @{
      group = @{
        groupType = "Contributors";
      }
      projectRef = @{
        id = $ProjectID
      }
    } 
} | ConvertTo-Json


$AZresponse = Invoke-RestMethod -Uri $AZurl -Method Post -ContentType "application/json" -Body $AZbody -Headers $AZbase64AuthInfo

$AZresponse