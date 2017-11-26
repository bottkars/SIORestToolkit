<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Connect-SIOGateway
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $GatewayIP = "192.168.2.223",
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
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
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
        $Token = Invoke-RestMethod -Uri "$SIObaseurl/api/gatewayLogin" -Method Get -Credential $Credentials
        }
    catch [System.Net.WebException]
        {
        #Write-Warning $_.Exception.Message
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        Break
        }
    catch
        {
        #Write-Verbose $_
        Write-Warning $_.Exception.Message
        break
        }
        #>
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(':'+$Token))
        $global:ScaleIOGatewayAuthHeaders = @{'Authorization' = "Basic $auth"}
        #'Content-Type' = "application/json"}
        Write-Host "Successfully connected to ScaleIO $SIObaseurl"
        Get-SIOGatewayConfiguration
        # Write-Output $ScaleIOAuthHeaders
    }
    End
    {
    }
}

function Get-SIOGatewayConfiguration
{
    [CmdletBinding()]
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
        Invoke-RestMethod -Uri "$SIObaseurl/api/Configuration" -Headers $ScaleIOGatewayAuthHeaders -Method Get
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

function Update-SIOGatewayPassword
{
    [CmdletBinding()]
    Param
    (
    # Specify the SIO Volume

        [Parameter(Mandatory=$false,ParameterSetName='1')]
        $NewPassword
    )
    Begin
    {
    if (!$NewPassword)
        {
        $SecPassword = Read-Host -AsSecureString
        #decrypting password:
        $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($SecPassword)
        $NewPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
        }
    }
    Process
    {
        
        $Body = @{  
        gatewayAdminPassword = $NewPassword
        }
        $JSonBody = ConvertTo-Json $Body
        Write-Verbose $JSonBody
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/updateConfiguration" -Headers $ScaleIOGatewayAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    End
    {
    Write-Host -ForegroundColor White "Gateway Password changed"
    }
}

function Update-SIOGatewaymdmIp
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ParameterSetName='1')][ipaddress[]]$mdmIp
    )
    Begin
    {
    }
    Process
    {
        
        $Body = @{  
        mdmAddresses = @($mdmIp.IPAddressToString)
        }
        $JSonBody = ConvertTo-Json $Body
        Write-Verbose $JSonBody
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/updateConfiguration" -Headers $ScaleIOGatewayAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    End
    {
    Write-Host -ForegroundColor White "Gateway mdm ips changed changed"
    }
}

function New-SIOMdmCluster
# from/api/instances/System/action/createMdmCluster
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ParameterSetName='1')][ipaddress]$mdmIp,
        [Parameter(Mandatory=$true,ParameterSetName='1')][ipaddress[]]$ips
        #[Parameter(Mandatory=$false,ParameterSetName='1')][ipaddress[]]$mdmManagementIps,
        #[Parameter(Mandatory=$false,ParameterSetName='1')][switch]$updateConfiguration
    )
    Begin
    {
    }
    Process
    {
        # mdmManagementIps = $mdmManagementIps.IPAddressToString}
       
        $Body = @{
        mdmIp =$mdmIp.IPAddressToString
        ips =@($ips.IPAddressToString)
        updateConfiguration ="true"
        }
        $JSonBody = ConvertTo-Json $Body -Verbose
        Write-Verbose $JSonBody
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System/action/createMdmCluster" -Headers $ScaleIOGatewayAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    End
    {
    Write-Host -ForegroundColor White "MDM Cluster Created"
    }
}

#/api/getHostCertificate/Mdm?host=10.76.60.10
function Get-SIOHostCertificate
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ipaddress]$IP,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Mdm','Lia')]
        $Type,
        $outfile
    )

    Begin
    {
    }
    Process
    {

    if (!$outfile)
            {
            $outfile = "$($ip.IPAddressToString).cer"
            }
    $uri = "$SIObaseurl/api/getHostCertificate/$($Type)?host=$($IP.IPAddressToString)" 
    if ($PSCmdlet.MyInvocation.BoundParameters["verbose"].IsPresent)
        {
        Write-Host -ForegroundColor Yellow "Calling $uri with Method $method"
        }
    try
        {
        Invoke-RestMethod -Uri "$Uri" -Headers $ScaleIOGatewayAuthHeaders -Method Get -OutFile $outfile -SessionVariable mycert
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
        Write-Host "Certificate written as $outfile"
        if ($PSCmdlet.MyInvocation.BoundParameters["verbose"].IsPresent)
        {
            Get-Content $outfile
            $mycert
        }

    }
    End
    {
    }
}

function Add-SIOTrustedHostCertificate
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]$infile,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Mdm','Lia')]
        $Type
    )

    Begin
    {
    }
    Process
    {
    $Content = [IO.file]::ReadAllText($infile)
    $JSonBody = [ordered]@{ file = $Content } | ConvertTo-Json 
         if ($PSCmdlet.MyInvocation.BoundParameters["verbose"].IsPresent)
            {
            Write-Host -ForegroundColor Yellow "Calling $uri with Method $method and body:
            $JSonBody"
            }

    try
        {
		#Invoke-RestMethod -Uri $uri -Method Post -InFile $filePath -ContentType "multipart/form-data"
        Invoke-RestMethod -Uri "$SIObaseurl/api/trustHostCertificate/$($Type)" -Headers $ScaleIOGatewayAuthHeaders -Method Post -ContentType 'multipart/form-data' -InFile $infile
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

#/api/gatewaySetSecureCommunication

function Set-SIOGatewaySecureCommunication
{
    [CmdletBinding()]
    Param
    (
    # Specify the SIO Volume

        [Parameter(Mandatory=$false,ParameterSetName='1')]
        [switch]$disable
    )
    Begin
    {
    }
    Process
    {
        
        $Body = @{  
        'allowNonSecureCommunicationWithMDM'= "$($disable.IsPresent)"
        }
        $JSonBody = ConvertTo-Json $Body
        Write-Verbose $JSonBody
    try
        {
        Invoke-RestMethod -Uri "$SIObaseurl/api/gatewaySetSecureCommunication" -Headers $ScaleIOGatewayAuthHeaders -Method Post -Body $JSonBody
        }
    catch
        {
        Get-SIOWebException -ExceptionMessage $_.Exception.Message
        break
        }
    
    }
    End
    {
    Get-SIOGatewayConfiguration
    }
}