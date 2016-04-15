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

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
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
