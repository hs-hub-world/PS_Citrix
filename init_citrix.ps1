<#
    init_citrix.ps1
    (c) 2021 Harry Saryan
    This script can be used in conjunction with other Citrix Scritps (i.e. with Rundeck).
    Note, this script assumes you have Citrix modules installed    
#>

#Prep Citrix Connection
##############################################
param(
    $verbose=$true
)

if($verbose){write "Loading Modules"}

try {
    Add-PSSnapin citrix*      
    if($verbose){write "  Success:"}
}
catch {
    throw $_.exception.message
}

#To silence the cloud authentication prompt/dialog we are setting a temp prof for credentials, 
#see this link for ref: https://discussions.citrix.com/topic/383302-citrixposhsdk-prompts-for-cloud-login-when-used-remotely/
Set-XdCredentials -StoreAs "AutomationPlatformName"  #(i.e. Rundeck, Ansible, Can be anything)
Get-XDAuthentication -ProfileName "AutomationPlatformName" #(i.e. Rundeck, Ansible Can be anything)
foreach($DDC in $($CitrixDDC -split ","))
{
    try {
        if($verbose){write "Trying to Connect:$($DDC)"}
        Get-BrokerMachine -AdminAddress $DDC -ErrorAction Stop |Out-Null
        if($verbose){write "  Successfully Connected To:$($DDC)"}
        $WorkingDDC=$DDC
        break; #Only need one connection    
    }
    catch {
        ##continue
        if($verbose){write "Trying next DDC conneciton in the list. "}
    }
}

if(!$WorkingDDC)
{
    throw "Did not find any working DDC servers. please validate the DDC server name is correct and user has access."
}
else
{
  return $WorkingDDC #You may reference this variable directly from other scripts in the context assuming this script is dot sourced
}

