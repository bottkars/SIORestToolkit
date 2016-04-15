function Move-SIOMDMownerShip
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("MdmID")]
        [validateLength(16,16)][ValidatePattern("[0-9A-F]{16}")]$SlaveMmdId

    )
    $Body = @{  
     id = $SlaveMmdId
    }  
    $JSonBody = ConvertTo-Json $Body
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System/action/changeMdmOwnership" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    Write-Host -ForegroundColor White "Switched Successfully to $SlaveMmdId, waiting for Gateway to Update Configuration"
    do {sleep 1;Write-Verbose "Waiting for Gateway to Respond new Master MDM";($NewState = Get-SIOmdmCluster -ErrorAction SilentlyContinue).master} until ($NewState)
}



<#
/api/instances
/System/actio
n/changeMdm
Ownership
#>