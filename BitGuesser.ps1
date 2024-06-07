function RefreshDrives {
    $driveLetters = [System.IO.DriveInfo]::getdrives() | Where-Object {$_.DriveType -ne 'Network'} | Select-Object -Property Name | ForEach-Object { $_.Name -replace '\\', '' }
    $driveSelectBox.Items.Clear()
    $driveSelectBox.Items.AddRange($driveLetters)
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
#
# guesserProgressBar
#
$guesserProgressBar.ForeColor = [System.Drawing.SystemColors]::Info
$guesserProgressBar.Location = New-Object System.Drawing.Point(13, 226)
$guesserProgressBar.Name = "guesserProgressBar"
$guesserProgressBar.Size = New-Object System.Drawing.Size(359, 23)
$guesserProgressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
$guesserProgressBar.TabIndex = 6
#
# guesserProgressLabel
#
$guesserProgressLabel.AutoSize = $true
$guesserProgressLabel.Location = New-Object System.Drawing.Point(12, 200)
$guesserProgressLabel.Name = "guesserProgressLabel"
$guesserProgressLabel.Size = New-Object System.Drawing.Size(146, 13)
$guesserProgressLabel.TabIndex = 5
$guesserProgressLabel.Text = "Progress message goes here."
#
# driveSelectBox
#
$driveSelectBox.FormattingEnabled = $true
$driveSelectBox.Location = New-Object System.Drawing.Point(144, 14)
$driveSelectBox.Name = "driveSelectBox"
$driveSelectBox.Size = New-Object System.Drawing.Size(40, 21)
$driveSelectBox.TabIndex = 1
$driveSelectBox.DropDownStyle = "DropDownList"
RefreshDrives
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
$processAmountSelector.Location = New-Object System.Drawing.Point(167, 41)
#$processAmountSelector.Maximum = New-Object decimal(@(
#1410065407,
#2,
#0,
#0))
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
#
# BitGuesserGUI
#
$BitGuesserGUI.ClientSize = New-Object System.Drawing.Size(384, 261)
$BitGuesserGUI.Controls.Add($refreshButton)
$BitGuesserGUI.Controls.Add($processAmountSelector)
$BitGuesserGUI.Controls.Add($processAmountLabel)
$BitGuesserGUI.Controls.Add($driveLetterLabel)
$BitGuesserGUI.Controls.Add($driveSelectBox)
$BitGuesserGUI.Controls.Add($guesserProgressLabel)
$BitGuesserGUI.Controls.Add($guesserProgressBar)
$BitGuesserGUI.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$BitGuesserGUI.Name = "BitGuesserGUI"
$BitGuesserGUI.Text = "BitLocker-Key-Guesser"

$BitGuesserGUI.Add_Shown({$BitGuesserGUI.Activate()})
$BitGuesserGUI.ShowDialog()
# Release the Form
$BitGuesserGUI.Dispose()