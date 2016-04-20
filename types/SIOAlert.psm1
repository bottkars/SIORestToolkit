function Get-SIOAlert
{
    [CmdletBinding()]
    Param
    (

    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {

    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/types/$Myself/instances" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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

