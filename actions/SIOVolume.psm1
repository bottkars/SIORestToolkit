
<#uses /api/instances/Volume::{id}/action/addMappedSdc
sdcId – SDC id
or
guid – SDC guid
Optional:
allowMultipleMappings - "TRUE" or
"FALSE"
#>
function Add-SIOmappedSDC
{
    [CmdletBinding()]
    Param
    (
    # Specify the SIO Volume

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")]$VolumeID,
    # Specify the SDC ID 

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("CID")]
        [ValidatePattern("[0-9A-F]{16}")]$sdcId,
        [Switch]$allowMultipleMappings
    )
    Begin
    {
    }
    Process
    {

    $Body = @{  
     sdcId = $sdcId
     allowMultipleMappings = "$($allowMultipleMappings.IsPresent)"
    }  
    $JSonBody = ConvertTo-Json $Body
    Write-Verbose $JSonBody
    try
        {
        $NewVolume = Invoke-RestMethod -Uri "$SIObaseurl/api/instances/Volume::$VolumeID/action/addMappedSdc" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
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
<#
/api/instances/Volume::{id}/action/removeMappedSdc
Required:
sdcId - SDC id
or
guid - SDC guid
or
allSdcs with empty
value
Optional:
ignoreScsiInitiators
- "TRUE" or "FALSE"
skipApplianceValid
ation (TRUE\FALSE)
#>

function Remove-SIOmappedSDC
{
    [CmdletBinding()]
    Param
    (
    # Specify the SIO Volume
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")]$VolumeID,
    # Specify the SDC ID 
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("CID")]
        [ValidatePattern("[0-9A-F]{16}")]$sdcId,
    # Specify all sdcs
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='2')]
        [Switch]$allSdcs
    )
    Begin
    {
    }
    Process
    {
    If ($allSdcs.IsPresent)
        {
        $Body = @{  
        allSdcs = ''}
    }
    else
        {
        $Body = @{  
        sdcId = $sdcId}
        }    
    $JSonBody = ConvertTo-Json $Body
    Write-Verbose $JSonBody
    try
        {
        $NewVolume = Invoke-RestMethod -Uri "$SIObaseurl/api/instances/Volume::$VolumeID/action/removeMappedSdc" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    #Get-SIOVolume -VolumeID $VolumeID
    }
    End
    {
    }
}
<#
/api/instances/Volume::{id}/action/removeVolume
POST Required:
removeMode –
"ONLY_ME"
or
"INCLUDING_DESCE
NDANTS"
or
"DESCENDANTS_O
NLY"
or
"WHOLE_VTREE"
#>
function Remove-SIOVolume
{
    [CmdletBinding(DefaultParameterSetName='1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'https://github.com/bottkars/SIORestToolkit',
                  ConfirmImpact='Medium')]
    Param
    (
    # Specify the SIO Volume
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position = 1)]
        [Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")]$VolumeID,
    # Specify the SDC ID 
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [Alias("RMODE")]
        [ValidateSet("ONLY_ME","INCLUDING_DESCENDANTS","DESCENDANTS_ONLY","WHOLE_VTREE")]$removeMode = "ONLY_ME"
    )
    Begin
    {
    }
    Process
    {
    if ($ConfirmPreference -match "none")
        { 
        $commit = 1 
        }
    else
        {
        $commit = Get-SIOyesno -title "Commit Volume Deletion" -message "This will delete Volume $VolumeID"
        }
    Switch ($commit)
        {
            1
            {
            $Body = @{  
                removeMode = $removeMode
                }    
            $JSonBody = ConvertTo-Json $Body
            Write-Verbose $JSonBody
            try
                {
                $RemoveVolume = Invoke-RestMethod -Uri "$SIObaseurl/api/instances/Volume::$VolumeID/action/removeVolume" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
                }
            catch
                {
                Get-SIOWebException -ExceptionMessage $_.Exception.Message
                break
                }
            Write-Host -ForegroundColor White "VOlume $VolumeID Removed"
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



