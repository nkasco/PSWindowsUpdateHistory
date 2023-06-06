# PSWindowsUpdateHistory
A quick way to obtain Windows Update history without external dependencies.

This includes more information beyond Get-Hotfix such as Defender definitions, driver installations, etc.

## Examples:
```
.\'Windows Update History Viewer.ps1'

Title               : Security Intelligence Update for Microsoft Defender Antivirus - KB2267602 (Version 1.391.667.0)
Description         : Install this update to revise the files that are used to detect viruses, spyware, and other potentially unwanted software.
                      Once you have installed this item, it cannot be removed.
InstallDate         : 6/6/2023 6:54:23 PM
Operation           : Installation
SupportURL          : https://go.microsoft.com/fwlink/?LinkId=52661
UninstallationNotes :
Categories          : Microsoft Defender Antivirus
ClientApplicationID : Windows Defender
ResultCode          : Succeeded
```

```
$Today = Get-Date
.\'Windows Update History Viewer.ps1' -StartDate $Today
```

```
#Full or partial title can be used
.\'Windows Update History Viewer.ps1' -Title "2023-03"
```

```
$Today = Get-Date
.\'Windows Update History Viewer.ps1' -StartDate $Today -Title "2023-03"
```