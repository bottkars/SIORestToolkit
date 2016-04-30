function Connect-SIOmdm
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $GatewayIP = "192.168.2.193",
        $GatewayPort = 443,
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)][pscredential]$Credentials,
        [switch]$trustCert
    )

    Begin
    {
    if ($trustCert.IsPresent)
        {
        Unblock-SIOCerts
        }  
    }
    Process
    {
    if (!$Credentials)
        {
        $User = Read-Host -Prompt "Please Enter ScaleIO MDM username"
        $SecurePassword = Read-Host -Prompt "Enter ScaleIO Password for user $user" -AsSecureString
        $Credentials = New-Object System.Management.Automation.PSCredential (“$user”,$Securepassword)
        }
    write-Verbose "Generating Login Token"
    $Global:SIObaseurl = "https://$($GatewayIP):$GatewayPort" # :$GatewayPort"
    Write-Verbose $SIObaseurl
    try
        {
        $Token = Invoke-RestMethod -Uri "$SIObaseurl/api/login" -Method Get -Credential $Credentials
        }
    catch [System.Net.WebException]
        {
        # Write-Warning $_.Exception.Message
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        Break
        }
    catch
        {
        Write-Verbose $_
        Write-Warning $_.Exception.Message
        break
        }
        #>
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(':'+$Token))
        $global:ScaleIOAuthHeaders = @{'Authorization' = "Basic $auth" 
        'Content-Type' = "application/json"}
        Write-Host "Successfully connected to ScaleIO $SIObaseurl"
        Get-SIOSystem 
        # Write-Output $ScaleIOAuthHeaders


    }
    End
    {
    }
}
function Get-SIOmdmCluster
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Param1,

        # Param2 help description
        [int]
        $Param2
    )

    Begin
    {
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).System.mdmcluster
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        }
    }
    End
    {
    }
}
function Get-SIOSystem
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )

    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Excludeproperties = ('links','name','id',
    'performanceParameters',
    'currentProfilePerformanceParameters',
    'sdcMdmNetworkDisconnectionsCounterParameters',
    'sdcSdsNetworkDisconnectionsCounterParameters',
    'sdcMemoryAllocationFailuresCounterParameters',
    'sdcSocketAllocationFailuresCounterParameters',
    'sdcLongOperationsCounterParameters')
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).System | Select-Object -ExcludeProperty $Excludeproperties -Property @{N="$($Myself)Name";E={$_.name}},
        @{N="$($Myself)ID";E={$_.id}},* #-ExpandProperty mdmCluster
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
function Get-SIOAPIversion
{
    [CmdletBinding()]
    Param
    (
    )
    Begin
    {
    }
    Process
    {
    try
        {

        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    (Invoke-RestMethod -Uri "$SIObaseurl/api/version" -Headers $ScaleIOAuthHeaders -Method Get)
    }
    End
    {

    }
}
function Get-SIOStatistics
{
    [CmdletBinding(DefaultParameterSetName='2'
    )]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
    [ValidatePattern("[0-9A-F]{16}")][String[]]$SystemID,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='2')]
    [ValidatePattern("[0-9A-F]{16}")][String[]]$ProtectionDomainID,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='3')]
    [ValidatePattern("[0-9A-F]{16}")][String[]]$VolumeID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {
    switch ($PsCmdlet.ParameterSetName)
        {
        "1"
            {
            $Instance = "System"
            $InstanceID = $SystemID 
            }

        "2"
            {
            $Instance = "ProtectionDomain"
            $InstanceID = $ProtectionDomainID
            }
        "3"
            {
            $Instance = "Volume"
            $InstanceID = $VolumeID
            }

        }
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/$Instance::$InstanceID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOProtectionDomain
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position = 1)]$SystemID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Excludeproperties = ('links','name','id')
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$SystemID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty $Excludeproperties -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOSdc
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position = 1)]$SystemID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$SystemID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOUser
{
    [CmdletBinding(DefaultParameterSetName = '0')]
    Param
    (
    [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName=$true,ParameterSetName='0')]
    [switch]$all=$true,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='6')]
    [ValidatePattern("[0-9A-F]{16}")][String[]]$UserID,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1',Position = 1)]
    [ValidatePattern("[0-9A-F]{16}")][String[]]$SystemID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Excludeproperties = ('links','name','id')
    }
    Process
    {
        switch ($PsCmdlet.ParameterSetName)
        {
        "0"
            {
            $Instance = "User"
            $Uri = "$SIObaseurl/api/types/$Instance/instances"
            }

        "1"
            {
            $Instance = "System"
            $InstanceID = $SystemID
            $Relationship = '/relationships/User'
            $Uri = "$SIObaseurl/api/instances/$Instance::$InstanceID$Relationship"
            }
        "2"
            {
            $Instance = "ProtectionDomain"
            $InstanceID = $ProtectionDomainID
            }
        "3"
            {
            $Instance = "Volume"
            $InstanceID = $VolumeID
            }
        "4"
            {
            $Instance = "StoragePool"
            $InstanceID = $StoragePoolID
            }
        "5"
            {
            $Instance = "VTree"
            $InstanceID = $VTreeID
            }
        "6"
            {
            $Instance = "User"
            $InstanceID = $UserID
            $Relationship = ""
            $Uri = "$SIObaseurl/api/instances/$Instance::$InstanceID$Relationship"
            }
        }
    try
        {
        (Invoke-RestMethod -Uri $Uri -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty $Excludeproperties -Property @{N="$($Myself)Name";E={$_.name}},
        @{N="$($Myself)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    }
    <#
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$SystemID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
        @{N="$($Myself)ID";E={$_.id}},* 
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
    #>
    End
    {

    }
}
function Get-SIOStoragePool
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position = 1)]$ProtectionDomainID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Instance = "ProtectionDomain"
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/$Instance::$ProtectionDomainID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOSds
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position = 1)]$ProtectionDomainID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
        $Instance = "ProtectionDomain"

    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/$Instance::$ProtectionDomainID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOFaultSet
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position = 1)]$ProtectionDomainID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    $Instance = "ProtectionDomain"
    }
    Process
    {
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/$Instance::$ProtectionDomainID/relationships/$Myself" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOVolume
{
    [CmdletBinding(DefaultParameterSetName='3')]
    
    Param
    (
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='3')]
        [Alias("VID")]
        [ValidatePattern("[0-9A-F]{16}")][string[]]$VolumeID,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='4')]
        [ValidatePattern("[0-9A-F]{16}")][String[]]$StoragePoolID,
        [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,ParameterSetName='5')]
        [ValidatePattern("[0-9A-F]{16}")][String[]]$VTreeID
    )
    Begin
    {
    $Myself = $MyInvocation.MyCommand.Name.Substring(7)
    }
    Process
    {
        switch ($PsCmdlet.ParameterSetName)
        {
        "1"
            {
            $Instance = "System"
            $InstanceID = $SystemID 
            }
        "2"
            {
            $Instance = "ProtectionDomain"
            $InstanceID = $ProtectionDomainID
            }
        "3"
            {
            $Instance = "Volume"
            $InstanceID = $VolumeID
            }
        "4"
            {
            $Instance = "StoragePool"
            $InstanceID = $StoragePoolID
            }
        "5"
            {
            $Instance = "VTree"
            $InstanceID = $VTreeID
            }
        "6"
            {
            $Instance = "User"
            $InstanceID = $UserID
            }
        }
    try
        {
        (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/$Instance::$InstanceID" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object  -ExcludeProperty links,name,id -Property @{N="$($Myself)Name";E={$_.name}},
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
function Get-SIOyesno
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://labbuildr.com/',
                  ConfirmImpact='Medium')]
    Param
    (
$title = "Delete Files",
$message = "Do you want to delete the remaining files in the folder?",
$Yestext = "Yestext",
$Notext = "notext"
    )
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","$Yestext"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No","$Notext"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)
return ($result)
}
