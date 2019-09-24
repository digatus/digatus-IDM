Set-ExecutionPolicy Unrestricted -force
Save-Script -Name Get-WindowsAutoPilotInfo -Path .
Install-Script -Name Get-WindowsAutoPilotInfo
.\Get-WindowsAutoPilotInfo.ps1 -ComputerName MYCOMPUTER -OutputFile .\MyComputer.csv
Set-ExecutionPolicy RemoteSigned -force
