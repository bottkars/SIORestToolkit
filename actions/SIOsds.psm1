function Set-SIOSDSPerformanceParameters
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$SDSid,
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
            $uri = "$SIObaseurl/api/instances/System/action/setSdsPerformanceParameters"
            }
        "1"
            {
            $uri = "$SIObaseurl/api/instances/Sds::$SDSid/action/setSdsPerformanceParameters"
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
function Start-SIOSDSDevicesTest
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$SDSid
        #[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]

    )
    begin {
    $JSonBody = [ordered]@{  
pattern = "readRand"
ioSizeKB = "8"
totalIoSizeMB = "128"
limitInSeconds = "10"
    } | ConvertTo-Json
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
            $uri = "$SIObaseurl/api/instances/Sds::$SDSid/action/startDevicesTest"
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
    
    }
    end {}
}

<#/api/instances/Sds::{id}/
action/startSdsNetwork
Test#>

function Start-SIOSDSNetworkTest
{
    [CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("ID")]
        [ValidatePattern("[0-9A-F]{16}")]$SDSid,
        #[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("NUmMesg")]
        [ValidateRange(1,16)]$numParallelMsgs,
                $networkTestSizeInGb,
        $networkTestLengthInSecs

    )
    begin {
    $JSonBody = [ordered]@{  
numParallelMsgs= "$numParallelMsgs"
networkTestSizeInGb =  "$networkTestSizeInGb"
networkTestLengthInSecs = "$networkTestLengthInSecs"
    } | ConvertTo-Json
    }
    process 
    {
    Write-Verbose $JSonBody
    $uri = "$SIObaseurl/api/instances/Sds::$SDSid/action/startSdsNetworkTest"
    try
        {
        Invoke-RestMethod -Uri $uri -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    end {}
}

