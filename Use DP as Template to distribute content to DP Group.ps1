

# Uncomment the line below if running in an environment where script signing is 
# required.
#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" # Import the ConfigurationManager.psd1 module 
#Set-Location "P01:" # Set the current location to be the site code.
$SiteCode = Read-Host “Enter your ConfigMgr Site code (XXX)” 
$SiteCode = $SiteCode + “:” 
Set-Location $SiteCode 
Write-Host “”

$TemplateDP=Read-Host “Enter The FQDN of the DP to use as a template” 
$DPGroupName = Read-Host “Enter your DPGroupName” 

$A=Get-CMDistributionStatus | Select-Object *
$B=$A | Where-Object {$_.NamedValueDictionary.Servername -eq "$TemplateDP"}
$SoftwareName=$B
foreach ($Name in $SoftwareName){
    Write-Host "$($Name.ObjectType) - $($Name.ObjectTypeID) - $($Name.SoftwareName)"
    If ($Name.ObjectType -eq 0 ){Start-CMContentDistribution -PackageId $name.PackageID -DistributionPointGroupName "$DPGroupName"}
    
    If ($Name.ObjectType -eq 512 ){
        Get-CMApplication -Name "$($name.SoftwareName)" |     Start-CMContentDistribution -DistributionPointGroupName "$DPGroupName"
    }
    If ($Name.ObjectType -eq 5 ){Start-CMContentDistribution -DeploymentPackageId  $name.PackageID -DistributionPointGroupName "$DPGroupName"}

    If ($Name.ObjectType -eq 258 ){Start-CMContentDistribution -BootImageId  $name.PackageID -DistributionPointGroupName "$DPGroupName"}

}