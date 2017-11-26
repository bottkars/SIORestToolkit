<#
function from List all intances
(Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get) | get-member -Name *list
deviceList
faultSetList
protectionDomainList
rfcacheDeviceList
sdcList
sdsList
storagePoolList
volumeList
vTreeList
#>

function Get-SIOdeviceList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
    End
    {

    }
}
function Get-SIOfaultSetList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
    End
    {

    }
}
function Get-SIOprotectionDomainList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
    End
    {

    }
}
function Get-SIOrfcacheDeviceList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
    End
    {

    }
}
function Get-SIOsdcList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }

    }
    End
    {

    }
}
function Get-SIOsdsList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }

    }
    End
    {

    }
}
function Get-SIOstoragePoolList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }

    }
    End
    {

    }
}
function Get-SIOvolumeList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }

    }
    End
    {

    }
}
function Get-SIOvTreeList
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )
    Begin
    {
    $typelist = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $type = $typelist -replace "List",""
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$typelist | Select-Object -ExcludeProperty links,name,id -Property @{N="$($type)Name";E={$_.name}},
        @{N="$($type)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }

    }
    End
    {

    }
}