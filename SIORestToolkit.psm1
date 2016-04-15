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
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $GatewayIP = "192.168.2.193",
        $GatewayPort = 443,
        $user = "admin",
        $password = "Password123!"
    )

    Begin
    {
    }
    Process
    {
    Add-Type -TypeDefinition @"
	    using System.Net;
	    using System.Security.Cryptography.X509Certificates;
	    public class TrustAllCertsPolicy : ICertificatePolicy {
	        public bool CheckValidationResult(
	            ServicePoint srvPoint, X509Certificate certificate,
	            WebRequest request, int certificateProblem) {
	            return true;
	        }
	    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
    $SecurePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $Credentials = New-Object System.Management.Automation.PSCredential (“$user”,$Securepassword)
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
function Get-SIOmdmCluster
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
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).System.mdmcluster
    }
    End
    {
    }
}

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
function Get-SIOSystem
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    )

    Begin
    {
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).System | Select-Object @{N="Systemid";E={$_.id}},
    @{N="SystemName";E={$_.name}},
    systemVersionName,
    installIdswid,
    daysInstalled, 
    maxCapacityInGb,
    capacityTimeLeftInDays,
    enterpriseFeaturesEnabled,
    isInitialLicense,
    defaultIsVolumeObfuscated,
    restrictedSdcModeEnabled
    }
    End
    {

    }
}


<######

System........................................................................................................... 577
◆ Protection Domain ......................................................................................... 614
◆ SDS................................................................................................................ 631
◆ StoragePool ................................................................................................... 651
◆ Device............................................................................................................ 669
◆ Volume .......................................................................................................... 679
◆ VTree.............................................................................................................. 685
◆ SDC................................................................................................................ 688
◆ User ............................................................................................................... 693
◆ Fault Set......................................................................................................... 694
◆ RfcacheDevice................................................................................................ 699
◆ Alert............................................................................................................... 703
◆ Installation Manager commands ....................................................................



###>
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
    (Invoke-RestMethod -Uri "$SIObaseurl/api/version" -Headers $ScaleIOAuthHeaders -Method Get)
    }
    End
    {

    }
}


function Get-SIOSDC
{
    [CmdletBinding()]
    Param
    (
    [Parameter(Mandatory = $true)]$SystemID
    )
    Begin
    {
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$SystemID/relationships/Sdc" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object @{N="SDCid";E={$_.id}},
    @{N="SDCName";E={$_.name}},
    onVmWare,
    systemId,
    mdmConnectionState,
    perfParams,
    currProfilePerfParams,
    memoryAllocationFailure,
    socketAllocationFailure,
    sdcGuid,
    sdcIp,
    sdcApproved,
    versionInfo
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
    [Parameter(Mandatory = $true)]$SystemID
    )
    Begin
    {
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$SystemID/relationships/ProtectionDomain" -Headers $ScaleIOAuthHeaders -Method Get) | Select-Object @{N="ProtectionDomainid";E={$_.id}},
    @{N="ProtectionDomainName";E={$_.name}},
    systemId,
    rebuildNetworkThrottlingInKbps,
    rebalanceNetworkThrottlingInKbps,
    overallIoNetworkThrottlingInKbps,
    sdsConfigurationFailureCounterParameters,
    mdmSdsNetworkDisconnectionsCounterParameters,
    sdsSdsNetworkDisconnectionsCounterParameters,
    sdsReceiveBufferAllocationFailuresCounterParameters,
    overallIoNetworkThrottlingEnabled,
    rebuildNetworkThrottlingEnabled,
    rebalanceNetworkThrottlingEnabled,
    protectionDomainState,
    sdsDecoupledCounterParameters
    

    }
    End
    {

    }
}


function Get-SIOStoragePools
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true)]$SystemID
    )
    Begin
    {
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances/System::$SystemID/relationships/storagePoolList" -Headers $ScaleIOAuthHeaders -Method Get) <#| Select-Object @{N="SDCid";E={$_.id}},
    @{N="SDCName";E={$_.name}},
    onVmWare,
    systemId,
    mdmConnectionState,
    perfParams,
    currProfilePerfParams,
    memoryAllocationFailure,
    socketAllocationFailure,
    sdcGuid,
    sdcIp,
    sdcApproved,
    versionInfo#>
    }
    End
    {

    }
}


Function Get-SIOWebException
    {
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        $ExceptionMessage

    )
        $type = $MyInvocation.MyCommand.Name -replace "Get-","" -replace "WebException",""
        switch -Wildcard ($ExceptionMessage)
            {
            "*400*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "400 Bad Request Badly formed URI, parameters, headers, or body content. Essentially a request syntax error."
                }
            "*401*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "Maybe wrong User/Password ?"
                }

            "*403*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "403 Forbidden Not allowed - ScaleIO Gateway is disabled. Enable the gateway by editing the file
<gateway installation directory>/webapps/ROOT/WEB-INF/classes/gatewayUser.properties
The parameter features.enable_gateway must be set to true, and then you must restart the scaleio-gateway service."
                }
            "*404*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "404 Not Found Resource doesn't exist - either an invalid type name for instances list (GET, POST) or an invalid ID for a specific instance (GET, POST /action)"
                }
            "*405*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "405 Method Not Allowed This code will be returned if you try to use a method that is not documented as a supported method."
                }
            "*406*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "406 Not Acceptable Accept headers do not meet requirements (for example, output format, version,language)
"
                }
            "*409*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "409 Conflict The request could not be completed due to a conflict with the current state of the resource.
This code is only allowed in situations where it is expected that the usermight be able to resolve the conflict and resubmit the request.
The response body SHOULD include enough information for the user to correct the issue."
                }
            "*422*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "422 Unprocessable Entity
Semantically invalid content on a POST, which could be a range error, inconsistent properties, or something similar"
                }
            "*500*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "500 Internal Server Error
This code is returned for internal errors - file an AR. It also is returned in some platform management cases when PAPI cannot return a decent error. Best practice is to avoid filing an AR.
"
                }
            "*501*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "501 Not Implemented Not currently used"
                }
            "*503*"
                {
                Write-Host -ForegroundColor White $ExceptionMessage
                Write-Host -ForegroundColor White "503 Service Unavailable"
                }
            default
                {
                Write-Host -ForegroundColor White "general error"
                $_ | fl *
                }                 
            }

    }
