function Move-SIOMDMownerShip
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
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
    Write-Host -ForegroundColor White "mdm successfully to $SlaveMmdId, waiting for Gateway on configuration update"
    do 
        {
        sleep 5
        Write-Verbose "Waiting for Gateway to Respond new Master MDM"
        
        try
        {
        $NewState = (Get-SIOmdmCluster -WarningAction SilentlyContinue).master
        }
        catch
        {}
        } 
    until ($NewState)
    $NewState
}
function Set-SIOMdmPerformanceParameters
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [ValidateSet('Default','HighPerformance')]$perfProfile

    )
    begin {}
    process {
    $JSonBody = @{  
     perfProfile = $perfProfile
    } | ConvertTo-Json 
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System/action/setMdmPerformanceParameters" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    Write-Host -ForegroundColor White "Performanceprofile set to $perfProfile"
    }
    end {}
}


