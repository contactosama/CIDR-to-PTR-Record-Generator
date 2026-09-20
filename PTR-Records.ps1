# Ask user for CIDR

$cidr = Read-Host "Enter IP Pool (CIDR format, e.g., 202.63.220.0/24)"

# Output file

$Downloads = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$outFile = "$Downloads\PTR-Records.txt"
Remove-Item $outFile -ErrorAction SilentlyContinue

# Function to get network and broadcast

function Get-IPRangeFromCIDR {
param ($cidr)

```
$parts = $cidr -split "/"
$ip = $parts[0]
$prefix = [int]$parts[1]

$bytes = [System.Net.IPAddress]::Parse($ip).GetAddressBytes()
[array]::Reverse($bytes)
$ipInt = [BitConverter]::ToUInt32($bytes, 0)

$hostBits = 32 - $prefix

if ($hostBits -eq 0) {
    $mask = 0xFFFFFFFF
}
else {
    $mask = [uint32](([math]::Pow(2, 32) - 1) - ([math]::Pow(2, $hostBits) - 1))
}

$network = $ipInt -band $mask
$broadcast = $network + [uint32]([math]::Pow(2, $hostBits) - 1)

return @{
    Network   = $network
    Broadcast = $broadcast
}
```

}

# Get network/broadcast

$range = Get-IPRangeFromCIDR $cidr
$network = $range.Network
$broadcast = $range.Broadcast

$totalIPs = $broadcast - $network + 1

Write-Host "Total IPs: $totalIPs"
Write-Host "Generating PTR records..."

for ($ipInt = $network; $ipInt -le $broadcast; $ipInt = [uint32]($ipInt + 1)) {

```
$b = [BitConverter]::GetBytes($ipInt)
[array]::Reverse($b)
$ip = [System.Net.IPAddress]::new($b)

$octets = $ip.ToString().Split(".")
$lastOctet = $octets[-1]
$thirdOctet = $octets[2]

$hostname = "corp-khi-$lastOctet-$thirdOctet.abc.com."
$line = "{0}`tPTR`t{1}" -f $lastOctet, $hostname

Add-Content -Path $outFile -Value $line
```

}

Write-Host "`n✅ PTR Records saved to: $outFile"
