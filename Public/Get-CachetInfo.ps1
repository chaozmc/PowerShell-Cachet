function Get-CachetInfo {
    <#
    .Synopsis
     Retrieves information from a Cachet server using the API.

    .Description
     Retrieves information from a Cachet server using the API. The JSON returned from the API call is converted into objects.

    .Parameter CachetServer
     The hostname of the Cachet server.

    .Parameter Info
     The specific part of Cachet that will be queried. Can only be one of the following: components, incidents, metric, or subscribers.

    .Parameter APIToken
     The API token key found within a Cachet user's profile.

    .Parameter UseSSL
     Boolean to define if Server should be contacted by SSL

    .Example
     # Get a list of all components
     Get-CachetInfo -CachetServer Cachet01 -Info components -APIToken FmzZg9GGQoanGnBbuyNT
    #>
    param (
        [Parameter(mandatory=$true)]
        [string]$CachetServer,
        [Parameter(mandatory=$true)]
        [ValidateSet('components','incidents','metrics','subscribers')]
        [string]$Info,
        [string]$APIToken,
        [ValidateSet('http','https')]
        [string]$Protocol = 'http'
    )
    

    $splat = @{
    'Uri' = '{0}://{1}/api/v1/{2}' -f $Protocol,$CachetServer,$Info;
    'Method' = 'Get';
    'Headers' = @{
        'X-Cachet-Token'=$APIToken;
        'Content-Type'='application/json'
        }
    }

    $results = Invoke-WebRequest @splat -UseBasicParsing
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
    $deserializer = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
    $deserializer.MaxJsonLength = [int]::MaxValue
    $components = $deserializer.DeserializeObject($results.Content)
    $components.data.foreach{
        $obj = New-Object PSObject
        foreach ($item in $_.Keys) {
            $obj | Add-Member -MemberType NoteProperty -Name $item -Value $_.Item($item)
            }
        $obj
    }
}