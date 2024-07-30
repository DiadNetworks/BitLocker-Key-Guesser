#Requires -Version 7.0

param (
    [Parameter(Mandatory=$true)]
    [string]$driveLetter,
    [Parameter(Mandatory=$true)]
    [string]$saveLocation,
    [Parameter(Mandatory=$true)]
    [int]$coreCount
)

# Initialize a global variable to store the current key count
if (-not (Get-Variable -Name currentKey -Scope Global -ErrorAction SilentlyContinue)) {
    $Global:currentKey = 0
}

function GenerateBitLockerKey {
    # Convert the current key count to a string with leading zeros, padded to 48 digits
    $keyString = $Global:currentKey.ToString("D48")

    # Split the key string into 6 segments of 8 digits each
    $keySegments = @()
    for ($i = 0; $i -lt 8; $i++) {
        $segment = $keyString.Substring($i * 6, 6)
        $keySegments += $segment
    }

    # Combine the segments into a single string separated by hyphens
    $mockKey = $keySegments -join '-'

    # Increment the current key count
    $Global:currentKey++

    return $mockKey
}

while ($true) {
    $bitKeys = @()
    for ($i = 0; $i -lt 10000; $i++) {
        $bitKeys += GenerateBitLockerKey
    }
    $bitKeys | ForEach-Object -Parallel {
        $recoveryKey = $_
        Start-Process -FilePath "manage-bde" -ArgumentList "-unlock $using:driveLetter -RecoveryPassword $recoveryKey" -WindowStyle Hidden
        Write-Host "$recoveryKey" -ForegroundColor Yellow
    } -ThrottleLimit $coreCount
}
Read-Host
