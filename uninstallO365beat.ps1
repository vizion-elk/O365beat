Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser	
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope Process

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$ServiceName = "o365beat"

if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Set-ExecutionPolicy Unrestricted

    $currentLocation = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    If ( -Not (Test-Path -Path "$currentLocation\o365beat-master\o365beat"))
    {
        Write-Host -Object "Path $currentLocation\o365beat-master\o365beat does not exit, exiting..." -ForegroundColor Red
        Exit 1
    }
    Else
    {
        Set-Location -Path "$currentLocation\o365beat-master\o365beat"
		$Target = "$currentLocation\o365beat-master"
    }

    #Stops o365beat from running
    Stop-Service -Force $ServiceName

    #Get The o365beat Status
    Get-Service $ServiceName
	
	Get-Service $ServiceName
    C:\Windows\System32\sc.exe delete $ServiceName

    #Change Directory to o365beat5
    Set-Location -Path 'c:\'

    "`nUninstalling O365beat Now..."

    Get-ChildItem -Path $Target -Recurse -force |
        Where-Object { -not ($_.pscontainer)} |
            Remove-Item -Force -Recurse

    Remove-Item -Recurse -Force $Target

    "`nO365beat Uninstall Successful."

    #Close Powershell window
    Stop-Process -Id $PID
}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}