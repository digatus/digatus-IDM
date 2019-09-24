<#
Version: 1.1
Author: Oliver Kieselbach
Script: IntunePSTemplate.ps1

Description:
Intune Management Extension - PowerShell script template with logging,
error codes, standard error output handling and x64 PowerShell execution.

Release notes:
Version 1.0: Original published version. 
Version 1.1: Added standard error output handling. 

The script is provided "AS IS" with no warranties.
#>

$exitCode = 0

if (![System.Environment]::Is64BitProcess)
{
    # start new PowerShell as x64 bit process, wait for it and gather exit code and standard error output
    $sysNativePowerShell = "$($PSHOME.ToLower().Replace("syswow64", "sysnative"))\powershell.exe"

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $sysNativePowerShell
    $pinfo.Arguments = "-ex bypass -file `"$PSCommandPath`""
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.CreateNoWindow = $true
    $pinfo.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null

    $exitCode = $p.ExitCode

    $stderr = $p.StandardError.ReadToEnd()

    if ($stderr) { Write-Error -Message $stderr }
}
else
{
    # start logging to TEMP in file "scriptname".log
    Start-Transcript -Path "$env:TEMP\$($(Split-Path $PSCommandPath -Leaf).ToLower().Replace(".ps1",".log"))" | Out-Null

    $ChocoPackages_install = @("foxitreader","pdfcreator","notepadplusplus.install","7zip.install","vlc")
    $ChocoPackages_uninstall = @("choco-upgrade-all-at-startup")
    $ChocoInstall = Join-Path ([System.Environment]::GetFolderPath("CommonApplicationData")) "Chocolatey\bin\choco.exe"

    if (!(Test-Path $ChocoInstall)) {
        try {
            Invoke-Expression ((New-Object net.webclient).DownloadString("https://chocolatey.org/install.ps1")) -ErrorAction Stop
        }
        catch {
            Write-Error -Message "Failed to install $Chocolatey" -Category OperationStopped
            $exitCode = -1
        }       
    }

    foreach($Package in $ChocoPackages_uninstall) {
        try {
            Invoke-Expression "cmd.exe /c $ChocoInstall Uninstall $Package -y" -ErrorAction Stop
        }
        catch {
            Write-Error -Message "Failed to uninstall $Package" -Category OperationStopped
            $exitCode = -1
        }
    }

    foreach($Package in $ChocoPackages_install) {
        try {
            Invoke-Expression "cmd.exe /c $ChocoInstall Install $Package -y" -ErrorAction Stop
        }
        catch {
            Write-Error -Message "Failed to install $Package" -Category OperationStopped
            $exitCode = -1
        }
    }

    Stop-Transcript | Out-Null
}

exit $exitCode
