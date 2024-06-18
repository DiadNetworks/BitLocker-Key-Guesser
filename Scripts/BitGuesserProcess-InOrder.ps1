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

$global:bitKeys = @()
while ($true) {
    for ($i = 0; $i -lt 10000; $i++) {
        $global:bitKeys += GenerateBitLockerKey
    }
    $global:bitKeys | ForEach-Object -Parallel {
        try {
            $recoveryKey = $_
            $process = Start-Process -FilePath "manage-bde" -ArgumentList "-unlock $using:driveLetter -RecoveryPassword $recoveryKey" -WindowStyle Hidden -PassThru -Wait
            # Check the exit code of the process
            if ($process.ExitCode -eq 0) {
                Write-Host "$recoveryKey SUCCESS" -ForegroundColor Green
                $recoveryKey | Out-File -FilePath "$using:saveLocation" -Append
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
