﻿### functions for Errorhandling
Function Get-SIOWebException
    {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param
    (
        $ExceptionMessage
    )
        $type = $MyInvocation.MyCommand.Name -replace "Get-","" -replace "WebException",""
        switch -Wildcard ($ExceptionMessage)
            {
            "*SSL/TLS secure channel*"
                {
                Write-Host -ForegroundColor Magenta $ExceptionMessage
                Write-Warning "SSL/TLS secure channel error indicates untrasted certificates. Connect using -trustCert Option !"
                }


            "*400*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "400 Bad Request Badly formed URI, parameters, headers, or body content. Essentially a request syntax error."
                }
            "*401*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "Session expired or wrong User/Password ?
    for Gateway commands use: Connect-SIOGateway
    for all other use: Connect-SIOmdm"
                
                }

            "*403*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "403 Forbidden Not allowed - ScaleIO Gateway is disabled. Enable the gateway by editing the file
<gateway installation directory>/webapps/ROOT/WEB-INF/classes/gatewayUser.properties
The parameter features.enable_gateway must be set to true, and then you must restart the scaleio-gateway service."
                }
            "*404*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "404 Not Found Resource doesn't exist - either an invalid type name for instances list (GET, POST) or an invalid ID for a specific instance (GET, POST /action)"
                }
            "*405*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "405 Method Not Allowed This code will be returned if you try to use a method that is not documented as a supported method."
                }
            "*406*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "406 Not Acceptable Accept headers do not meet requirements (for example, output format, version,language)
"
                }
            "*409*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "409 Conflict The request could not be completed due to a conflict with the current state of the resource.
This code is only allowed in situations where it is expected that the usermight be able to resolve the conflict and resubmit the request.
The response body SHOULD include enough information for the user to correct the issue."
                }
            "*422*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "422 Unprocessable Entity
Semantically invalid content on a POST, which could be a range error, inconsistent properties, or something similar"
                }
            "*428*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "Most likely this signals an unconfigured MDM or unapproved Certificates"
                }
            "*500*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "500 Internal Server Error
This code is returned for internal errors - file an AR. It also is returned in some platform management cases when PAPI cannot return a decent error. Best practice is to avoid filing an AR.
"
                }
            "*501*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "501 Not Implemented Not currently used"
                }
            "*503*"
                {
                Write-Warning $ExceptionMessage
                Write-Warning "503 Service Unavailable"
                }
            default
                {
                Write-Warning "general error"
                $_ | fl *
                }                 
            }

    }
