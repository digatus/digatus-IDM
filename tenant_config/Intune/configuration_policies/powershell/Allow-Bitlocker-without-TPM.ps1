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

    # === variant 1: use try/catch with ErrorAction stop -> use write-error to signal Intune failed execution
    # example:
    # try
    # {
    #     Set-ItemProperty ... -ErrorAction Stop
    # }
    # catch
    # {   
    #     Write-Error -Message "Could not write registry value" -Category OperationStopped
    #     $exitCode = -1
    # }

    # === variant 2: ErrorVariable and check error variable -> use write-error to signal Intune failed execution
    # example:
    # Start-Process ... -ErrorVariable err -ErrorAction SilentlyContinue
    # if ($err)
    # {
    #     Write-Error -Message "Could not write registry value" -Category OperationStopped
    #     $exitCode = -1
    # }

    try
    {
       $models = @("Parallels", "VirtualBox", "VMware", "Hyper-V")
       $model = (Get-WmiObject Win32_Computersystem).Model
       $tpmPresent = (Get-Tpm).TpmPresent

		$editions = @{
		    0  ='Undefined'
		    1  ='Ultimate Edition'
		    2  ='Home Basic Edition'
		    3  ='Home Premium Edition'
		    4  ='Enterprise Edition'
		    5  ='Home Basic N Edition'
		    6  ='Business Edition'
		    7  ='Standard Server Edition'
		    8  ='Datacenter Server Edition'
		    9  ='Small Business Server Edition'
		   10  ='Enterprise Server Edition'
		   11  ='Starter Edition'
		   12  ='Datacenter Server Core Edition'
		   13  ='Standard Server Core Edition'
		   14  ='Enterprise Server Core Edition'
		   15  ='Enterprise Server Edition for Itanium-Based Systems'
		   16  ='Business N Edition'
		   17  ='Web Server Edition'
		   18  ='Cluster Server Edition'
		   19  ='Home Server Edition'
		   20  ='Storage Express Server Edition'
		   21  ='Storage Standard Server Edition'
		   22  ='Storage Workgroup Server Edition'
		   23  ='Storage Enterprise Server Edition'
		   24  ='Server For Small Business Edition'
		   25  ='Small Business Server Premium Edition'
		   29  ='Web Server Server Core'
		   39  ='Datacenter Edition without Hyper-V Server Core'
		   40  ='Standard Edition without Hyper-V Server Core'
		   41  ='Enterprise Edition without Hyper-V Server Core'
		   42  ='Hyper-V Server'
           48  ='Professional'
		}
        $sku = (Get-WmiObject Win32_OperatingSystem).OperatingSystemSKU

       if (($tpmPresent -eq $false) -or ($null -ne ($models | ? { $model -match $_ }))) {
         New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft -Name "FVE" -ErrorAction Stop -Force
         New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseAdvancedStartup" -Value "00000001" -PropertyType DWORD -ErrorAction Stop -Force
         New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "EnableBDEWithNoTPM" -Value "00000001" -PropertyType DWORD -ErrorAction Stop -Force
         New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPM" -Value "00000000" -PropertyType DWORD -ErrorAction Stop -Force
         New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMPIN" -Value "00000001" -PropertyType DWORD -ErrorAction Stop -Force
         New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKey" -Value "00000000" -PropertyType DWORD -ErrorAction Stop -Force
         New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\FVE" -Name "UseTPMKeyPIN" -Value "00000000" -PropertyType DWORD -ErrorAction Stop -Force
       }
    }
    catch
    {
       Write-Error -Message "Could not write registry value" -Category OperationStopped
       $exitCode = -1
    }

    Stop-Transcript | Out-Null
}

exit $exitCode
