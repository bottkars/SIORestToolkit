<#
/api/instances/System::{id}/action/snapshotVolumes
POST Required:
snapshotDefs – a
list of combination
of “volumeId”
volume ID and
“snapshotName”
(optional field)
snapshot name.
For example: {
“snapshotDefs”: [ {“
volumeId”:”2dd913
2300000000”,
“snapshotName”:”s
nap1”},
{“volumeId”:”1234”
}]}
volumeIdList
snapshotGroupId
for example:
{
"volumeIdList":[
"2dd9132400000001
"
],

#>
function New-SIOVolumeSnapshot
{
    [CmdletBinding()]
    Param
    (
    # Specify the SIO Volumes

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")][string[]]$VolumeID,
    # Specify the SystemID 

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("CID")]
        [ValidatePattern("[0-9A-F]{16}")]$systemID
        )
    Begin
    {
    }
    Process
    {

    $Body = @{  
     'volumeId' = $volumeId
    }  
    $JSonBody = ConvertTo-Json $Body
    Write-Verbose $JSonBody
    try
        {
        #
        $NewSnap= Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$systemID/action/snapshotVolumes" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    Get-SIOVolume -VolumeID $VolumeID
    }
    End
    {
    }
}
"snapshotGroupId"
:"d2e53daf0000000
1"
}
Operations (page 14 of 23)
Operation URI Method Parameters Notes Return