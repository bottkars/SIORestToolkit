

<#Start devices test /api/instances/Sds::{id}/
/api/instances/Protectio
nDomain::{id}/action/qu
eryProtectionDomainNet
work
#>
function Get-SIOProtectionDOmainNetwork
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$ProtectionDOmainID
        #[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]

    )
    begin {
    $JSonBody = [ordered]@{  
pattern = "readRand"
ioSizeKB = "8"
totalIoSizeMB = "128"
limitInSeconds = "10"
    } | ConvertTo-Json
    }
    process 
    {
    $uri = "$SIObaseurl/api/instances/ProtectionDomain::$ProtectionDOmainID/action/queryProtectionDomainNetwork"
    try
        {
        Invoke-RestMethod -Uri $uri -Headers $ScaleIOAuthHeaders -Method Post | Select-Object -ExpandProperty Syncroot | Select-Object -ExpandProperty peerConnectionStates  #-Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    end {}
}

<#
/api/instances/ProtectionDomain::{id}/action/inactivateProtectionDomain
#>

function Suspend-SIOProtectionDomain
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$ProtectionDOmainID,
        #[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [switch]$forceShutdown
    )
    begin {
     if ($forceShutdown.IsPresent)
        {
        $force = "TRUE"
        }
    else
        {
        $force = "FALSE"
        }
    $JSonBody = [ordered]@{  
forceShutdown  = $force
    } | ConvertTo-Json
    }
    process 
    {
    Write-Verbose $JSonBody
    $uri = "$SIObaseurl/api/instances/ProtectionDomain::$ProtectionDOmainID/action/inactivateProtectionDomain"
    try
        {
        Invoke-RestMethod -Uri $uri -Headers $ScaleIOAuthHeaders -Method Post # | Select-Object -ExpandProperty Syncroot | Select-Object -ExpandProperty peerConnectionStates  #-Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    end {}
}

<#
Software type resources 625
REST API Reference
/api/instances/Protectio
nDomain::{id}/action/acti
vateProtectionDomain#>

function Resume-SIOProtectionDomain
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$ProtectionDOmainID,
        #[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [switch]$forceActivate
    )
    begin {
     if ($forceActivate.IsPresent)
        {
        $force = "TRUE"
        }
    else
        {
        $force = "FALSE"
        }
    $JSonBody = [ordered]@{  
forceActivate  = $force
    } | ConvertTo-Json
    }
    process 
    {
    Write-Verbose $JSonBody
    $uri = "$SIObaseurl/api/instances/ProtectionDomain::$ProtectionDOmainID/action/inactivateProtectionDomain"
    try
        {
        Invoke-RestMethod -Uri $uri -Headers $ScaleIOAuthHeaders -Method Post # | Select-Object -ExpandProperty Syncroot | Select-Object -ExpandProperty peerConnectionStates  #-Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    end {}
}
