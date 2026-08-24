<#
.SYNOPSIS
    Automated FSLogix Profile Container Registry Configuration for AVD.
.DESCRIPTION
    Configures session hosts to store user profiles on Azure Files with VHDLocation.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$StorageAccountSharePath = "\\stavdprofiles.file.core.windows.net\profiles"
)

$FSLogixRegPath = "HKLM:\SOFTWARE\FSLogix\Profiles"

if (-not (Test-Path $FSLogixRegPath)) {
    New-Item -Path $FSLogixRegPath -Force | Out-Null
}

Set-ItemProperty -Path $FSLogixRegPath -Name "Enabled" -Value 1 -Type DWord
Set-ItemProperty -Path $FSLogixRegPath -Name "VHDLocations" -Value $StorageAccountSharePath -Type MultiString
Set-ItemProperty -Path $FSLogixRegPath -Name "DeleteLocalProfileWhenVHDShouldApply" -Value 1 -Type DWord

Write-Host "FSLogix profile container configured successfully." -ForegroundColor Green
