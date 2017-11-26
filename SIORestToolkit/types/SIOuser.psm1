<#

<#uses /api/types/User/instances
Properties Type Required\Optional for POST
id String -
name String Required
userRole Monitor, Configure, Administrator,
Superuser, Security, FrontendConfig or
BackendConfig
Required
passwordChangeRequired Boolean -
systemId String -
#>
#>

function New-SIOUser
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (

    # Specify the New Name  
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$false)][Alias("VN")]$UserName,
    # Specify the New Role 
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$false)][ValidateSet('Monitor','Configure','Administrator',
'Superuser','Security','FrontendConfig','BackendConfig')][string]$userRole = 'Monitor'
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {

    $Body = @{  
     name = $UserName
     userRole = $userRole
    }  
    $JSonBody = ConvertTo-Json $Body
    Write-Verbose $JSonBody
    try
        {
        $NewUser = Invoke-RestMethod -Uri "$SIObaseurl/api/types/$Myself/instances" -Headers $ScaleIOAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    $NewUser | Select-Object @{N="UserName";E={$UserName}},@{N="UserTole";E={$userRole}},@{N="$($Myself)ID";E={$_.id}},* -ExcludeProperty id 
    }
    End
    {}
}

