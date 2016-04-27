function Get-SIOAlert
{
    [CmdletBinding()]
    Param
    (
    [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
    $AlertID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {
    if  ($AlertID)
        {
        $Uri = "$SIObaseurl/api/instances/$($Myself)::$AlertID"
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

