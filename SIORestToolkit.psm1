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
    catch
        {
        "We could not connect to Gateway"
        break
        }
        #>
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(':'+$Token))
        $global:ScaleIOAuthHeaders = @{'Authorization' = "Basic $auth"
        'Content-Type' = "application/json"}
        Write-Host "Successfully connected to ScaleIO $baseurl"
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
    [OutputType([int])]
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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
    $myself = $MyInvocation.MyCommand.Name -replace "Get-SIO",""
    $myself
    }
    Process
    {
    (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
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

function Get-SIOSDC
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
