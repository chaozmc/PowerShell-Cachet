function New-CachetIncidentUpdate {
    param (
        # Server FQDN or IP
        [Parameter(Mandatory=$true)]
        [string]$Server,
        [Parameter(Mandatory=$true)]
        [int]$ID,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Investigating','Identified','Watching','Fixed')]
        $Status,
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$ApiToken,
        [ValidateSet('http','https')]
        [string]$Protocol = 'http'
    )

    $splat = @{
        Server = $Server
        Resource = 'IncidentUpdates'
        Method = 'POST'
        ID = $ID
        Body = @{
            'status' = $Status
            'message' = $Message
        }
        ApiToken = $ApiToken
        Protocol = $Protocol
    }
    
    Invoke-CachetRequest @splat
}