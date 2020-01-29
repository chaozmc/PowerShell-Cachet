﻿function Set-CachetComponentStatus {
    <#
    .Synopsis
     Sets the status for a specified named component.

    .Description
     Sets the status for a specified named component. If the specified component does not exist, this command will do nothing and return a warning message.

    .Parameter CachetServer
     The hostname of the Cachet server.

    .Parameter ComponentName
     The exact name of the Cachet component.

    .Parameter Status
     The name of the status to which the component will be set.
    
    .Parameter APIToken
     The API token key found within a Cachet user's profile.

    .Example
     # Sets the 'Internet' component to 'MajorOutage'.
     Set-CachetComponentStatus -CachetServer Cachet01 -ComponentName Internet -Status MajorOutage -APIToken FmzZg9GGQoanGnBbuyNT
    #>
    param (
        [string]$CachetServer = 'localhost',
        [string]$ComponentName = 'localhost',
        [ValidateSet('Operational','PerformanceIssues','PartialOutage','MajorOutage')]
        [string]$Status,
        [string]$APIToken,
        [ValidateSet('http','https')]
        [string]$Protocol = 'http'
    )
    
    $component = Get-CachetInfo -CachetServer $CachetServer -Info components -APIToken $APIToken -Protocol $Protocol | Where-Object -FilterScript {$_.name -eq $ComponentName}
    if ($component) {
        $statId = Get-CachetStatusId -StatusName $Status
        $splat = @{
            'Uri' = '{0}://{1}/api/v1/components/{2}' -f $Protocol, $CachetServer, $component.id;
            'Method' = 'Put';
            'Body' = '{{"status":{0}}}' -f $statId;
            'Headers' = @{
                'X-Cachet-Token'=$APIToken;
                'Content-Type'='application/json'
            }
        }
        Invoke-WebRequest @splat
    }
    else {
        Write-Warning -Message "Could not find component named $ComponentName."
    }
}