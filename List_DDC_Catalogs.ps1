<#
    List_DDC_Catalogs.ps1
    (c) 2021 Harry Saryan
    This script can be used with automation tools (i.e. rundeck, ansible)   
#>

param(
  #Enter all the available DDC comma seprated
  $CitrixDDC      = "ddc-01-v,ddc-02-v"
)

$WarningPreference = 'SilentlyContinue'
chdir c:  #Required since you could be on any other PS drive other than C: (i.e. sccm, or IIS)
$CurrentPath = $(split-path $MyInvocation.MyCommand.Path)

#Note, Modules may NOT be included with this repo You may exclude it from this script if necessary 
. "Modules\_LoadAllModules.ps1" |Out-String

fun_OutputParams #Output Param values
fun_Header       #Register Start time

. "$CurrentPath\init_citrix.ps1" -ErrorAction Stop  #Dot source Citrix Login Module

try
{
    $ListItems=@()
    
    $CitrixCat = Get-BrokerCatalog -AdminAddress $WorkingDDC
    $CitrixCat |select Name, AssignedCount,UnassignedCount,UsedCount| sort Name  | ft -AutoSize |out-string -Width 1024

    write "----------------------------------------"
    write "Total Catalogs:$($CitrixCat.count)"
	
}
catch
{
	
    write "Error, Job Failed..."
    write $_.exception.message
}
