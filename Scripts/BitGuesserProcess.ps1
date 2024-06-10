param (
    [Parameter(Mandatory=$true)]
    [string]$driveLetter
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
    $bitKey = GenerateBitLockerKey
    try {
        $process = Start-Process -FilePath "manage-bde" -ArgumentList "-unlock $driveLetter -RecoveryPassword $bitKey" -NoNewWindow -PassThru -Wait

        # Check the exit code of the process
        if ($process.ExitCode -eq 0) {
            Write-Host "$bitKey SUCCESS" -ForegroundColor Green
            $bitKey | Out-File -FilePath ".\SuccessfulKey.txt"
            break
        } else {
            throw "Unlock failed with exit code $($process.ExitCode)"
        }
    }
    catch {
        Write-Host "$bitKey failed" -ForegroundColor Red
    }
}