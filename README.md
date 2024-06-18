# BitLocker-Key-Guesser
PowerShell script to guess the BitLocker key for a Bit Locked drive.

## Running the Program
Powershell 7 or higher is required to be [installed](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4) on your system.  
Allow [scripts to be run](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4) from powershell 7. **Or** unblock the specific script files, see below.  
Download the [latest zip file](https://github.com/DiadNetworks/BitLocker-Key-Guesser/releases/latest).  
Run `BitGuesser.bat`, preferably as an administrator.  
Refer to the [controls section](https://github.com/DiadNetworks/BitLocker-Key-Guesser#controls) below for an explanation of the GUI controls.

## Controls
![Local Image](Images/gui-image.png)  
  
**Bit Locked Drive Letter:** Use this dropdown to select the bit locked drive that you want to guess the key for.  
  
**Refresh Drives:** Use this button to refresh the list of drives. Use this if you ran the program before plugging in the bit locked drive.  

**Parallel Guesses:** This determines how many guesses the script will make in parallel. The value is prefilled with the number of cores in your system. You can experiment with making this 2 or 3 times the default, but be careful of going too high or the program may crash.  
  
**Mode:** Here you can choose whether to attempt random guesses or to generate keys in order.  
  
**Info Window:** For future use.  
  
**Start:** Click this when you're ready to start guessing the key. It will start the process using the drive letter that you specified. A powershell window will open up showing info.  
  
**Stop:** Click this if you want to close the running process. This will only work if you ran `BitGuesser.bat` as an administrator, otherwise you will need to close out the powershell window manually.  
  
**Progress Bar:** Just for show.  

## Unblock only the necessary script files:  
If you prefer not to change your script execution policy, you can unblock just the files you need to by opening a Powershell 7 terminal in the `Scripts` folder and typing this command: `Unblock-File *`.  

## What happens if it guesses correctly?  
If one of the processes guesses the correct key, it will unlock the drive and output the key to `SuccessfulKey.txt` in the `Scripts` folder.  

**Note:** The program won't permanently decrypt the drive, so make sure you go to control panel and do that if that's what you want. If you plan on leaving the drive encrypted, then save the key from `SuccessfulKey.txt`.
