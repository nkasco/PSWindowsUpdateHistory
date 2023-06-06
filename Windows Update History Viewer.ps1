###########################################
# Windows Update History Viewer           #
# Written by: Nathan Kasco                #
# Date: 6/6/2023                          #
###########################################

#This script is similar to PSWindowsUpdate, but doesn't rely on the module dll in case some can't/don't want to download
#It will also return similar results to NirSoft's Windows Update History Viewer tool

param(
    [int]
    $Limit = 99999, #Control the amount of results returned

    [string]
    $Title, #This can be a full or partial string that is applied against results

    [DateTime]
    $StartDate #Set a start date filter
)

try{
    $updateSession = New-Object -ComObject Microsoft.Update.Session -ErrorAction Stop
    
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    
    #QueryHistory(startIndex,count) - https://learn.microsoft.com/en-us/windows/win32/api/wuapi/nf-wuapi-iupdatesearcher-queryhistory
    $result = $updateSearcher.QueryHistory(0,$Limit)
    
    $returnedResults = @()

    foreach($r in $result){
        #Resolve Result Codes
        switch ($r.ResultCode) {
            0 {
                $resultCode = "NotStarted"
            }
            1 {
                $resultCode = "InProgress"
            }
            2 {
                $resultCode = "Succeeded"
            }
            3 {
                $resultCode = "SucceededWithErrors"
            }
            4 {
                $resultCode = "Failed"
            }
            5 {
                $resultCode = "Aborted"
            }
            Default {
                $resultCode = "Unknown"
            }
        }
        
        #Resolve Operation Codes
        switch($r.Operation){
            1 {
                $operation = "Installation"
            }
            2 {
                $operation = "Uninstallation"
            }
            Default {
                $operation = "Unknown"
            }
        }

        #Resolve category info
        $categories = ($r.categories | Select-Object *).Name

        #Append results to a custom object
        $returnedResults += [PSCustomObject]@{
            Title = $r.Title
            Description = $r.Description
            InstallDate = $r.Date
            Operation = $operation
            SupportURL = $r.SupportUrl
            UninstallationNotes = $r.UninstallationNotes
            Categories = $categories
            ClientApplicationID = $r.ClientApplicationID
            ResultCode = $resultCode
        }
    }

    if($returnedResults){
        $finalResults = $returnedResults

        if($Title){
            $escapedTitle = [regex]::Escape($Title) #We need to escape any special characters because no human should have to remember to do this
            if($escapedTitle){
                $finalResults = $finalResults | Where-Object Title -match $escapedTitle
            } else {
                #If that failed, at least try to get some results with original input
                $finalResults = $finalResults | Where-Object Title -match $Title
            }
        }

        if($StartDate){
            #To account for common user error, default the provided date to midnight
            $StartDate = (Get-Date -Date $StartDate -ErrorAction Stop).Date

            $finalResults = $finalResults | Where-Object InstallDate -ge $StartDate
        }

        $finalResults
    } else {
        throw "Unknown error or no history exists for this machine"
    }
} catch {
    Write-Error "Unable to retrieve Windows Update History - $_"
}