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

<#
/api/instances/Volume::{id}/action/revertSnapshot

Required:volumeId - Volumefrom URL and volumeId must be from the same VTree.revertMode -"move" or "copy" or"toggle"

c00c50db00000000

#>
function Restore-SIOSnapshot
{
    [CmdletBinding(DefaultParameterSetName='1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'https://github.com/bottkars/SIORestToolkit',
    ConfirmImpact='Medium'
    )]
    Param
    (
    # Specify the SIO Pool

        [Parameter(Mandatory=$true,ParameterSetName='1',ValueFromPipelinebyPropertyName=$true)]
        [Alias("AVid")]
        [ValidatePattern("[0-9A-F]{16}")]$ancestorVolumeId,
    # Specify the New Volume Name  
        [Parameter(Mandatory=$true,ValueFromPipelinebyPropertyName=$true)][Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")][String]$volumeId,
    # Specify restore type 
        [Parameter(Mandatory=$true)][ValidateSet('move','copy','toggle')][string]$revertMode 
    )
    Begin
    {
    $method = "POST"
    }
    Process
    {
    $JSonBody = @{  
    volumeId = $VolumeId
    revertMode = $revertMode } | ConvertTo-Json
    if ($ConfirmPreference -match "none")
        { 
        $commit = 1 
        }
    else
        {
        switch ($revertMode)
            {
                "toggle"
                {
                $Message = "Content of $volumeId and $ancestorVolumeId will be switched, id´s remain"
                }
                "copy"
                {
                $Message = "Content from $ancestorVolumeId will be copied to $volumeId, id´s remain"
                 }
                "move"
                {
                $Message = "Content from $ancestorVolumeId will be moved to $volumeId, $ancestorVolumeId will be removed"
                }
            }
        $commit = Get-SIOyesno -title "Commit Volume restore" -message $Message
        }
    Switch ($commit)
        {
        1
            {
            Write-Verbose "calling snapshot restore for $ancestorVolumeId from $volumeId"
            Write-Verbose $JSonBody

            try
                {
                Invoke-RestMethod -Uri "$SIObaseurl/api/instances/Volume::$ancestorVolumeId/action/revertSnapshot" -Body $JSonBody -Headers $ScaleIOAuthHeaders -Method $method
                }
            catch
                {
                Get-SIOWebException -ExceptionMessage $_.Exception.Message
                break
                }
            Write-Host "executed $revertMode from $ancestorVolumeId to $volumeId"
            }
        0
            {
            Write-Warning "Volume Deletion refused by user for Volume $VolumeID"
            }  
        }    

    }
    End
    {
    }
}

