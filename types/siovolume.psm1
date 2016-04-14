function Get-SIOVolume
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
    # (Invoke-RestMethod -Uri "$SIObaseurl/api/instances" -Headers $ScaleIOAuthHeaders -Method Get).$myself | Select-Object * -ExcludeProperty links
    <#    
    @{N="SDCName";E={$_.name}},
    #>
    }
    End
    {}
}
