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
“snapshotDefs”: [ {“volumeId”:”2dd9132300000000”,
“snapshotName”:”snap1”},
{“volumeId”:”1234"}]}

return:
volumeIdList
snapshotGroupId
for example:
{
"volumeIdList":[
"2dd9132400000001
"
],
"snapshotGroupId"
:"d2e53daf0000000
1"
}
#>
function New-SIOSnapshot
{
    [CmdletBinding()]
    Param
    (
    # Specify the SIO Pool

        [Parameter(Mandatory=$true,ParameterSetName='1')]
        [Alias("SID")]
        [ValidatePattern("[0-9A-F]{16}")]$SystemID,
    # Specify the New Volume Name  
        [Parameter(Mandatory=$true,ValueFromPipelinebyPropertyName=$true,ValueFromPipeline=$true)][Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")][String[]]$volumeId,
    # Specify if thin, default thick  
        [Parameter(Mandatory=$false)][Alias("SN")][string[]]$SnapshotName
    )
    Begin
    {
    $i=0
    if ($volumeId -is [array])
        {
        Write-Verbose "calling snapsot with listarray"
        foreach ($volume in $volumeid)
            {
            try
                {
                $snapname = $SnapshotName[$i]
                }
            catch
                {
                $Snapname = ""
                }
            finally
                {
                $Innerbody += @(@{ volumeId = $volume
                snapshotName = $Snapname })
                $i++
                }
    
            }
        $fromarray = $true
        }
    }
    Process
    {
    IF (!$fromarray)
        {
        Write-Verbose "calling snapshot from Pipeline"
        try
            {
            $snapname = $SnapshotName[$i]
            }
        catch
            {
            $Snapname = ""
            }
        finally
            {
            $Innerbody += @(@{ volumeId = $volumeId
            snapshotName = $Snapname })
            $i++
            }
        }
    }
    End
    {
    $JSonBody = @{  
    snapshotDefs = $Innerbody  } | ConvertTo-Json
    Write-Verbose $JSonBody
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$($SystemID)/action/snapshotVolumes" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
}

