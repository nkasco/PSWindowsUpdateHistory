# PSWindowsUpdateHistory
A quick way to obtain Windows Update history without external dependencies

## Examples:
`.\'Windows Update History Viewer.ps1'`

```
$Today = Get-Date
.\'Windows Update History Viewer.ps1' -StartDate $Today
```

```
$Today = Get-Date
.\'Windows Update History Viewer.ps1' -StartDate $Today -Title "2023-03"
```