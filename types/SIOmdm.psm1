<#
Properties Type Required\Optional for POST
id String -
name String Optional
volumeSizeInKb Long Required
isObfuscated Deprecated in v2.0 Deprecated in v2.0
creationTime Long -
volumeType ThickProvisioned or ThinProvisioned or
Snapshot
Optional (only ThickProvisioned and
ThinProvisioned)
consistencyGroupId String -
mappingToAllSdcsEnabled Boolean -
mappedSdcInfoList List of SdcMappingInfo -
ancestorVolumeId String -
vtreeId String -
storagePoolId String Required
useRmcache Boolean Optional
#>

function Get-SIOmdm
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    # (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
    }
    End
    {}
}


function Get-SIOVolume
{
    [CmdletBinding()]
    Param
    (
    )
    Begin
    {
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    # (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
    }
    End
    {}
}
