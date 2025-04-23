# Source: https://learn.microsoft.com/azure/virtual-desktop/configure-single-sign-on?WT.mc_id=Portal-Microsoft_Azure_WVD
# By default, when single sign-on (SSO) is enabled, users are prompted to allow the remote desktop connection when connecting to a new AVD session host or Windows 365 Cloud PC. Microsoft Entra remembers the consent for 30 days before prompting the end-users again.
# This script suppresses the single sign-on (sso) consent prompts for Azure virtual desktop and Windows 365.


Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Applications

Connect-MgGraph -Scopes "Application.Read.All","Application-RemoteDesktopConfig.ReadWrite.All"

$MSRDspId = (Get-MgServicePrincipal -Filter "AppId eq 'a4a365df-50f1-4397-bc59-1a1564b8bb9c'").Id
$WCLspId = (Get-MgServicePrincipal -Filter "AppId eq '270efc09-cd0d-444b-a71f-39af4910ec45'").Id

If ((Get-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $MSRDspId) -ne $true) {
    Update-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $MSRDspId -IsRemoteDesktopProtocolEnabled
}

If ((Get-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $WCLspId) -ne $true) {
    Update-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $WCLspId -IsRemoteDesktopProtocolEnabled
}

# Verify:
Get-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $MSRDspId
Get-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $WCLspId

$tdg = New-Object -TypeName Microsoft.Graph.PowerShell.Models.MicrosoftGraphTargetDeviceGroup
$tdg.Id = "84384f9f-ec6c-4cd6-ac9a-193a2ab84f9b"
$tdg.DisplayName = "AVD-Hosts-DynamicGroup"

New-MgServicePrincipalRemoteDesktopSecurityConfigurationTargetDeviceGroup -ServicePrincipalId $MSRDspId -BodyParameter $tdg
New-MgServicePrincipalRemoteDesktopSecurityConfigurationTargetDeviceGroup -ServicePrincipalId $WCLspId -BodyParameter $tdg


# Can support upto 10 groups, to remove groups later
#Remove-MgServicePrincipalRemoteDesktopSecurityConfigurationTargetDeviceGroup -ServicePrincipalId $MSRDspId -TargetDeviceGroupId "<Group object ID>"
#Remove-MgServicePrincipalRemoteDesktopSecurityConfigurationTargetDeviceGroup -ServicePrincipalId $WCLspId -TargetDeviceGroupId "<Group object ID>"
