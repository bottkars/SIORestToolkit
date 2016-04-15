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

function New-SIOVolume
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    # Specify the SIO Pool

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("SPID")]
        [validateLength(16,16)][ValidatePattern("[0-9A-F]{16}")]$PoolID,
    # Specify the New Volume Name  
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)][Alias("VN")]$VolumeName,
    # Specify if thin, default thick  
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)][switch]$Thin,
    # Specify the New Volume Size in GB 
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$false)][ValidateRange(1,64000)][int]$SizeInGB
    )
    Begin
    {
    $type = $MyInvocation.MyCommand.Name -replace "New-SIO",""
    If ($Thin.IsPresent)
        {
        $VolumeType = "ThinProvisioned"
        }
    else
        {
        $VolumeType = "ThickProvisioned"
        }
    }
    Process
    {

    $Body = @{  
     name = $VolumeName
     storagePoolId = $PoolID
     volumeSizeInKb = ($SizeInGB*1024).ToString()
     volumeType = $VolumeType
    }  
    $JSonBody = ConvertTo-Json $Body
    try
        {
        $NewVolume = Invoke-RestMethod -Uri "$SIObaseurl/api/types/Volume/instances" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-VolumeWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    Get-SIOVolume -VolumeID $NewVolume.ID
    }
    End
    {}
}


function Get-SIOVolume
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("VID")]
        [validateLength(16,16)][ValidatePattern("[0-9A-F]{16}")]$VolumeID

    )
    Begin
    {
    $type = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    }
    Process
    {
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/instances/$type::$VolumeID" -Headers $ScaleIOAuthHeaders -Method Get | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},*
        }
    catch
        {
        Get-VolumeWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
    End
    {}
}

Function Get-VolumeWebException
    {
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        $ExceptionMessage

    )
        $type = $MyInvocation.MyCommand.Name -replace "Get-","" -replace "WebException",""
        switch -Wildcard ($ExceptionMessage)
            {
            "*(500)*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "The error indicates that the $Type does not exist or already exists"
                }
            default
                {
                Write-Host -ForegroundColor White "general error"
                $_ | fl *
                }                 
            }

    }