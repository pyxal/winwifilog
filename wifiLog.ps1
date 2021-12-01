### WINDOWS WIFI LOGGER
# output format
function outputFormat {
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [hashtable]$Hashtable,

        [ValidateNotNullOrEmpty()]
        [string]$KeyHeader = 'Name',

        [ValidateNotNullOrEmpty()]
        [string]$ValueHeader = 'Value'
    )

    $Hashtable.GetEnumerator() |Select-Object @{Label=$KeyHeader;Expression={$_.Key}},@{Label=$ValueHeader;Expression={$_.Value}}
}

# set initial vars
$dateTime = Get-Date -UFormat "%A %d/%m/%Y %R"
$wai = whoami
$emptyLine = write-host "`n"
$ssidListCmd = netsh wlan show profiles | findstr /i All
$outputList = @{}
$pwCheckList = @()

# fetch wifi credentials
foreach ( $ssid in $ssidListCmd )
{
    $ssid = $ssid.substring(27, $ssid.length - 27)
    $ssidPwCmd = netsh wlan show profile name="$ssid" key=clear | findstr /i Content
    
    if ($ssidPwCmd.length -eq 0) { continue }
    
    $ssidPw = $ssidPwCmd.substring(29, $ssidPwCmd.length - 29)

    $outputList.Add($ssid, $ssidPw)
}

# print output
echo $dateTime
echo $wai
echo $outputList | outputFormat -KeyHeader SSID -ValueHeader KEY
echo $emptyLine
