function Get-CachetMetric {
    <#
    .Synopsis
     Gets a information about a metric.

    .Description
     Gets information about a metric.

    .Parameter CachetServer
     The hostname of the Cachet server.

    .Parameter MetricID
     The ID number of the Cachet metric.
    
    .Parameter APIToken
     The API token key found within a Cachet user's profile.

    .Example
     # Sets the 'Internet' component to 'MajorOutage'.
     Get-CachetMetric -CachetServer Cachet01 -MetricID 1 -APIToken FmzZg9GGQoanGnBbuyNT
    #>
    param (
        [Parameter(Mandatory=$true)]    
        [string]$Server = 'localhost',
        [int]$ID,
        [Parameter(Mandatory=$false)]
        [string]$APIToken,
        [ValidateSet('http','https')]
        [string]$Protocol = 'http'

    )

    $splat = @{
        'Server' = $Server
        'Resource' = 'Metrics'
        'Method' = 'Get';
        'ApiToken' = $APIToken
        'Protocol' = $Protocol
    }

    if ($ID) {
        $splat.ID = $ID
    }

    Invoke-CachetRequest @splat
}