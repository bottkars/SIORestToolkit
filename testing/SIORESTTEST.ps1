    #### for testing purposes in ise
    
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
$GatewayIP = "192.168.2.193"
$GatewayPort = 443
$SIOBaseUrl = "https://$($GatewayIP):$GatewayPort" # :$GatewayPort"
$password = ConvertTo-SecureString “Password123!” -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential (“admin”,$password)
$Token = Invoke-RestMethod -Uri "$SIOBaseUrl/api/login" -Method Get -Credential $Credentials
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(':'+$Token))
        $global:ScaleIOAuthHeaders = @{'Authorization' = "Basic $auth"
        'Content-Type' = "application/json"}

(Invoke-RestMethod -Uri "$SIOBaseUrl/api/types/Volume/instances" -Headers $global:ScaleIOAuthHeaders -Method Get).links
(Invoke-RestMethod -Uri "$SIOBaseUrl/api/types/User/instances" -Headers $global:ScaleIOAuthHeaders -Method Get)



Invoke-RestMethod -Uri "$SIOBaseUrl/api/types/$Type/Instances" -Headers $global:ScaleIOAuthHeaders -Method Get
$Type = "volumeList"

(Invoke-RestMethod -Uri "$SIOBaseUrl/api/instances" -Headers $global:ScaleIOAuthHeaders -Method Get).System.links
$Instances
Invoke-RestMethod -Uri "$SIOBaseUrl/api/types/Volume/create" -Headers $global:ScaleIOAuthHeaders -Method Get

(Invoke-RestMethod -Uri "$SIOBaseUrl/api/instances" -Headers $global:ScaleIOAuthHeaders -Method Get)