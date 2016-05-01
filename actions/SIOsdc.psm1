<#/api/instances/Sd
c::{id}/action/setS
dcPerformancePar
ameters
Required:
perfProfile -
"Default" or
"HighPerform
ance"
#>
function Set-SIOSDCPerformanceParameters
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$Sdcid,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [ValidateSet('Default','HighPerformance')]$perfProfile

    )
    begin {
     $JSonBody = @{  
     perfProfile = $perfProfile
    } | ConvertTo-Json
    }
    process {
    switch ($PsCmdlet.ParameterSetName)
        {
        "0"
            {
            $uri = "$SIObaseurl/api/instances/System/action/setSdcPerformanceParameters"
            }
        "1"
            {
            $uri = "$SIObaseurl/api/instances/Sdc::$Sdcid/action/setSdcPerformanceParameters"
            }
       }
    try
        {
        Invoke-RestMethod -Uri $uri -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
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


