#Requires -RunAsAdministrator

function RefreshDrives {
    $driveLetters = [System.IO.DriveInfo]::getdrives() | Where-Object {$_.DriveType -ne 'Network'} | Select-Object -Property Name | ForEach-Object { $_.Name -replace '\\', '' }
    $driveSelectBox.Items.Clear()
    $driveSelectBox.Items.AddRange($driveLetters)
}

$global:process = @()
function OnStartButtonClick {
    $global:process = @()
    $guesserProgressBar.MarqueeAnimationSpeed = 10
    $guesserProgressLabel.Text = "Starting processes..."
    $driveLetter = $driveSelectBox.Text
    Write-Host "$($driveSelectBox.Text)"
    Write-Host "$driveLetter"
    for ($i = 1; $i -le $processAmountSelector.Value; $i++) {
        $proc = Start-Process -FilePath powershell -ArgumentList "-NoProfile -WindowStyle Hidden -File .\Scripts\BitGuesserProcess.ps1 -driveLetter $driveLetter" -PassThru
        $global:process += $proc
        Write-Host "Process $i started: $($process[$i - 1].Id)"
        $infoBox.Text = "Processes running: $i`r`n"
    }
    
    $guesserProgressLabel.Text = "Generating keys..."
}

function OnStopButtonClick {
    $guesserProgressLabel.Text = "Stopping processes..."
    
    for ($i = 0; $i -lt $global:process.Count; $i++) {
        Stop-Process -Id $global:process[$i].Id
        Write-Host "Process $($i + 1) stopped: $($global:process[$i].Id)"
        $infoBox.Text = "Processes running: $($global:process.Count - 1 - $i)`r`n"
    }
    
    $guesserProgressBar.MarqueeAnimationSpeed = 0
    $guesserProgressBar.Refresh()
    $guesserProgressLabel.Text = ""
}

# Loading external assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$BitGuesserGUI = New-Object System.Windows.Forms.Form

$guesserProgressBar = New-Object System.Windows.Forms.ProgressBar
$guesserProgressLabel = New-Object System.Windows.Forms.Label
$driveSelectBox = New-Object System.Windows.Forms.ComboBox
$driveLetterLabel = New-Object System.Windows.Forms.Label
$processAmountLabel = New-Object System.Windows.Forms.Label
$processAmountSelector = New-Object System.Windows.Forms.NumericUpDown
$refreshButton = New-Object System.Windows.Forms.Button
$startButton = New-Object System.Windows.Forms.Button
$stopButton = New-Object System.Windows.Forms.Button
$infoBox = New-Object System.Windows.Forms.TextBox
#
# guesserProgressBar
#
$guesserProgressBar.ForeColor = [System.Drawing.SystemColors]::Info
$guesserProgressBar.Location = New-Object System.Drawing.Point(13, 226)
$guesserProgressBar.Name = "guesserProgressBar"
$guesserProgressBar.Size = New-Object System.Drawing.Size(359, 23)
$guesserProgressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
$guesserProgressBar.Visible = $true
$guesserProgressBar.MarqueeAnimationSpeed = 0
$guesserProgressBar.TabIndex = 9
#
# guesserProgressLabel
#
$guesserProgressLabel.AutoSize = $true
$guesserProgressLabel.Location = New-Object System.Drawing.Point(12, 204)
$guesserProgressLabel.Name = "guesserProgressLabel"
$guesserProgressLabel.Size = New-Object System.Drawing.Size(146, 13)
$guesserProgressLabel.TabIndex = 8
$guesserProgressLabel.Text = ""
#
# driveSelectBox
#
$driveSelectBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$driveSelectBox.FormattingEnabled = $true
$driveSelectBox.Location = New-Object System.Drawing.Point(175, 14)
$driveSelectBox.Name = "driveSelectBox"
$driveSelectBox.Size = New-Object System.Drawing.Size(40, 21)
$driveSelectBox.TabIndex = 1
#
# driveLetterLabel
#
$driveLetterLabel.AutoSize = $true
$driveLetterLabel.Location = New-Object System.Drawing.Point(12, 17)
$driveLetterLabel.Name = "driveLetterLabel"
$driveLetterLabel.Size = New-Object System.Drawing.Size(119, 13)
$driveLetterLabel.TabIndex = 0
$driveLetterLabel.Text = "Bit Locked Drive Letter:"
#
# processAmountLabel
#
$processAmountLabel.AutoSize = $true
$processAmountLabel.Location = New-Object System.Drawing.Point(12, 43)
$processAmountLabel.Name = "processAmountLabel"
$processAmountLabel.Size = New-Object System.Drawing.Size(139, 13)
$processAmountLabel.TabIndex = 3
$processAmountLabel.Text = "Amount of processes to run:"
#
# processAmountSelector
#
$processAmountSelector.Location = New-Object System.Drawing.Point(175, 41)
$processAmountSelector.Maximum = 9999999999
$processAmountSelector.Name = "processAmountSelector"
$processAmountSelector.Size = New-Object System.Drawing.Size(80, 20)
$processAmountSelector.TabIndex = 4
$processAmountSelector.Value = 10
#
# refreshButton
#
$refreshButton.Location = New-Object System.Drawing.Point(272, 12)
$refreshButton.Name = "refreshButton"
$refreshButton.Size = New-Object System.Drawing.Size(100, 23)
$refreshButton.TabIndex = 2
$refreshButton.Text = "Refresh Drives"
$refreshButton.UseVisualStyleBackColor = $true
$refreshButton.Add_Click({RefreshDrives})
RefreshDrives
#
# startButton
#
$startButton.Location = New-Object System.Drawing.Point(297, 147)
$startButton.Name = "startButton"
$startButton.Size = New-Object System.Drawing.Size(75, 23)
$startButton.TabIndex = 6
$startButton.Text = "Start"
$startButton.UseVisualStyleBackColor = $true
$startButton.Add_Click({OnStartButtonClick})
#
# stopButton
#
$stopButton.Location = New-Object System.Drawing.Point(297, 176)
$stopButton.Name = "stopButton"
$stopButton.Size = New-Object System.Drawing.Size(75, 23)
$stopButton.TabIndex = 7
$stopButton.Text = "Stop"
$stopButton.UseVisualStyleBackColor = $true
$stopButton.Add_Click({OnStopButtonClick})
#
# infoBox
#
$infoBox.BackColor = [System.Drawing.SystemColors]::Control
$infoBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$infoBox.Location = New-Object System.Drawing.Point(12, 69)
$infoBox.Multiline = $true
$infoBox.Name = "infoBox"
$infoBox.Size = New-Object System.Drawing.Size(224, 130)
$infoBox.TabIndex = 5
$infoBox.Text = "Processes running: `r`n"
#
# BitGuesserGUI
#
$BitGuesserGUI.ClientSize = New-Object System.Drawing.Size(384, 261)
$BitGuesserGUI.Controls.Add($infoBox)
$BitGuesserGUI.Controls.Add($stopButton)
$BitGuesserGUI.Controls.Add($startButton)
$BitGuesserGUI.Controls.Add($refreshButton)
$BitGuesserGUI.Controls.Add($processAmountSelector)
$BitGuesserGUI.Controls.Add($processAmountLabel)
$BitGuesserGUI.Controls.Add($driveLetterLabel)
$BitGuesserGUI.Controls.Add($driveSelectBox)
$BitGuesserGUI.Controls.Add($guesserProgressLabel)
$BitGuesserGUI.Controls.Add($guesserProgressBar)
$BitGuesserGUI.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$BitGuesserGUI.MaximizeBox = $false
$BitGuesserGUI.Name = "BitGuesserGUI"
$BitGuesserGUI.Text = "BitLocker-Key-Guesser"
$BitGuesserGUI.Icon = ".\Images\logo.ico"

$BitGuesserGUI.Add_Shown({$BitGuesserGUI.Activate()})
$BitGuesserGUI.ShowDialog()
# Release the Form
$BitGuesserGUI.Dispose()