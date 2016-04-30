<#/api/instances/Protectio
nDomain::{id}/action/qu
eryDevicesTestResults#>
function Get-SIODevicesTestResults
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$ProtectionDomainID
        #[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]

    )
    begin {
}

    process {
    switch ($PsCmdlet.ParameterSetName)
        {
        "0"
            {
            $uri = "$SIObaseurl/api/instances/System/action/setSdsPerformanceParameters"
            }
        "1"
            {
            $uri = "$SIObaseurl/api/instances/ProtectionDomain::$ProtectionDomainID/action/queryDevicesTestResults"
            }
       }
    try
        {
        Invoke-RestMethod -Uri $uri -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody #| Select-Object  *| Select-Object deviceId, deviceTestResults #-ExpandProperty  deviceTestResults
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    end {}
}

