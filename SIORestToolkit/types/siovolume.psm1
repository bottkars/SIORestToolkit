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
    Param
    (
    # Specify the SIO Pool

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("SPID")]
        [ValidatePattern("[0-9A-F]{16}")]$storagePoolID,
    # Specify the New Volume Name  
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)][Alias("VN")]$VolumeName,
    # Specify if thin, default thick  
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)][switch]$Thin,
    # Specify the New Volume Size in GB 
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)][ValidateRange(1,64000)][int]$SizeInGB = 4
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
     storagePoolId = $storagePoolID
     volumeSizeInKb = ($SizeInGB*1024*1024).ToString()
     volumeType = $VolumeType
    }  
    $JSonBody = ConvertTo-Json $Body
    Write-Verbose $JSonBody
    try
        {
        $NewVolume = Invoke-RestMethod -Uri "$SIObaseurl/api/types/Volume/instances" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    Write-Verbose $NewVolume.id
    Get-SIOVolume -VolumeID $NewVolume.ID
    }
    End
    {}
}

