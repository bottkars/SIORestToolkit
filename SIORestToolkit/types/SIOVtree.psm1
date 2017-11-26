function Get-SIOVTree
{
    [CmdletBinding()]
    Param
    (
    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
    $VtreeID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {
    if  ($VtreeID)
        {
        $Uri = "$SIObaseurl/api/instances/$($Myself)::$VtreeID"
        }
    else
        {
        $uri = "$SIObaseurl/api/types/$Myself/instances"
        }
    try
        {
        (Invoke-RestMethod -Uri $Uri -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
        @{N="$($Myself)ID";E={$_.id}},* 
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
<#
/api/instances/VTre
e::{id}/relationships
/Volume
#>
function Get-SIOVTreeVolume
{
    [CmdletBinding()]
    Param
    (
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
    $VtreeID
    )
    Begin
    {
    $Type = "Volume"
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Myself = $Myself -replace $Type
    }
    Process
    {

    $Uri = "$SIObaseurl/api/instances/$($Myself)::$VtreeID/relationships/$Type"

    try
    {
    Invoke-RestMethod -Uri $Uri -Headers $ScaleIOAuthHeaders -Method Get | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Type)Name";E={$_.name}},@{N="$($Type)ID";E={$_.id}},* 
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
<#
/api/instances/VTre
e::{id}/relationships
/Statistics
#>
function Get-SIOVTreeStatistics
{
    [CmdletBinding()]
    Param
    (
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
    $VtreeID
    )
    Begin
    {
    $Type = "Statistics"
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Myself = $Myself -replace $Type
    }
    Process
    {

    $Uri = "$SIObaseurl/api/instances/$($Myself)::$VtreeID/relationships/$Type"

    try
    {
    Invoke-RestMethod -Uri $Uri -Headers $ScaleIOAuthHeaders -Method Get | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Type)Name";E={$_.name}},@{N="$($Type)ID";E={$_.id}},* 
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
