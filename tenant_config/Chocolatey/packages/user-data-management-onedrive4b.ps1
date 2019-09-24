# User Data backup to OneDrive for Business
#


Function New-Popup {
<#
.Synopsis
Display a Popup Message
.Description
This command uses the Wscript.Shell PopUp method to display a graphical message
box. You can customize its appearance of icons and buttons. By default the user
must click a button to dismiss but you can set a timeout value in seconds to 
automatically dismiss the popup. 

The command will write the return value of the clicked button to the pipeline:
  OK     = 1
  Cancel = 2
  Abort  = 3
  Retry  = 4
  Ignore = 5
  Yes    = 6
  No     = 7

If no button is clicked, the return value is -1.
.Example
PS C:\> new-popup -message "The update script has completed" -title "Finished" -time 5

This will display a popup message using the default OK button and default 
Information icon. The popup will automatically dismiss after 5 seconds.
.Notes
Last Updated: April 8, 2013
Version     : 1.0

.Inputs
None
.Outputs
integer

Null   = -1
OK     = 1
Cancel = 2
Abort  = 3
Retry  = 4
Ignore = 5
Yes    = 6
No     = 7
#>

Param (
[Parameter(Position=0,Mandatory=$True,HelpMessage="Enter a message for the popup")]
[ValidateNotNullorEmpty()]
[string]$Message,
[Parameter(Position=1,Mandatory=$True,HelpMessage="Enter a title for the popup")]
[ValidateNotNullorEmpty()]
[string]$Title,
[Parameter(Position=2,HelpMessage="How many seconds to display? Use 0 require a button click.")]
[ValidateScript({$_ -ge 0})]
[int]$Time=0,
[Parameter(Position=3,HelpMessage="Enter a button group")]
[ValidateNotNullorEmpty()]
[ValidateSet("OK","OKCancel","AbortRetryIgnore","YesNo","YesNoCancel","RetryCancel")]
[string]$Buttons="OK",
[Parameter(Position=4,HelpMessage="Enter an icon set")]
[ValidateNotNullorEmpty()]
[ValidateSet("Stop","Question","Exclamation","Information" )]
[string]$Icon="Information"
)

#convert buttons to their integer equivalents
Switch ($Buttons) {
    "OK"               {$ButtonValue = 0}
    "OKCancel"         {$ButtonValue = 1}
    "AbortRetryIgnore" {$ButtonValue = 2}
    "YesNo"            {$ButtonValue = 4}
    "YesNoCancel"      {$ButtonValue = 3}
    "RetryCancel"      {$ButtonValue = 5}
}

#set an integer value for Icon type
Switch ($Icon) {
    "Stop"        {$iconValue = 16}
    "Question"    {$iconValue = 32}
    "Exclamation" {$iconValue = 48}
    "Information" {$iconValue = 64}
}

#create the COM Object
Try {
    $wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
    #Button and icon type values are added together to create an integer value
    $wshell.Popup($Message,$Time,$Title,$ButtonValue+$iconValue)
}
Catch {
    #You should never really run into an exception in normal usage
    Write-Warning "Failed to create Wscript.Shell COM object"
    Write-Warning $_.exception.message
}

} #end function

function Set-ToastMessage {
[CmdletBinding()]
param(
    [Parameter(Mandatory=$True)]
    [String]$Title,
    [Parameter(Mandatory=$True)]
    [String]$Message
)

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

$APP_ID = '6551cede-ac41-4ee5-8c93-c8b202c92dd1'

$template = @"
<toast duration="short">
    <visual>
        <binding template="ToastText04" branding="logo">
            <text id="1">$($Title)</text>
            <text id="2">$($Message)</text>
        </binding>
    </visual>
</toast>
"@

$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml($template)
$toast = New-Object Windows.UI.Notifications.ToastNotification $xml
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_ID).Show($toast)
}

function Get-TempPassword() {
Param(
[int]$length=10,
[string[]]$sourcedata
)


  For ($loop=1; $loop –le $length; $loop++) {
    $TempPassword+=($sourcedata | Get-Random)
  }
  return $TempPassword
}


$errors = @()

$OneDrives = $env:USERPROFILE + "\OneDrive - *"
Dir $OneDrives | % {
  $OneDrive = $_.FullName + "\" + $env:USERDOMAIN + "_UDM\" + $env:COMPUTERNAME

  # backup Chocolatey packages
  $srcDir = [System.Environment]::GetFolderPath("CommonApplicationData") + "\Chocolatey\bin\choco.exe"
  $dstDir = $OneDrive + "\Chocolatey"  
  if (Test-Path $srcDir) {
     $dstFile = $dstDir + "\packages.config"
     Write-Output "Backup of Chocolatey installed packages to $dstDir"
     New-Item -ItemType Directory -Path $dstDir -Force > $null
     Set-Content $dstFile "<?xml version=`"1.0`" encoding=`"UTF-8`?>"
     Add-Content $dstFile "<packages>"
     choco list -lo -r -y | % { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />" } | Add-Content $dstFile
     Add-Content $dstFile "</packages>"
  }

  # backup Internet Explorer bookmarks
  $srcDir = $env:USERPROFILE + "\Favorites"
  $dstDir = $OneDrive + "\Internet Explorer"
  if (Test-Path $srcDir) {
    if (Test-Path $dstDir) { Remove-Item -Recurse -Force $dstDir > $null }
    Write-Output "Backup of Internet Explorer bookmarks to $dstDir"
    New-Item -ItemType Directory -Path $dstDir -Force > $null
    Get-ChildItem $srcDir -Verbose:$false | Copy-Item -Destination "$dstDir" -Verbose:$false
  }

  # backup Chrome bookmarks
  $srcDir = [System.Environment]::GetFolderPath("LocalApplicationData") + "\Google\Chrome\User Data\Default\bookmarks*"
  $dstDir = $OneDrive + "\Google Chrome"
  if (Test-Path $srcDir) {
    Write-Output "Backup of Google Chrome bookmarks to $dstDir"
    New-Item -ItemType Directory -Path $dstDir -Force > $null
    Get-ChildItem $srcDir | Copy-Item -Destination "$dstDir" -Verbose:$false
  }

  # backup Firefox bookmarks
  $srcDir = [System.Environment]::GetFolderPath("ApplicationData") + "\Mozilla\Firefox\Profiles\*.default\places.sqlite"
  $dstDir = $OneDrive + "\Mozilla Firefox"
  if (Test-Path $srcDir) {
    Write-Output "Backup of Mozilla Firefox bookmarks to $dstDir"
    New-Item -ItemType Directory -Path $dstDir -force > $null
    Get-ChildItem $srcDir | Copy-Item -Destination "$dstDir" -Verbose:$false
  }

  # backup Outlook Signatures
  $srcDir = [System.Environment]::GetFolderPath("ApplicationData") + "\Microsoft\Signatures"
  $dstDir = $OneDrive + "\Outlook Signatures"
  if (Test-Path $srcDir) {
    if (Test-Path $dstDir) { Remove-Item -Recurse -Force $dstDir > $null }
    Write-Output "Backup of Outlook signatures to $dstDir"
    New-Item -ItemType Directory -Path $dstDir -force > $null
    Get-ChildItem $srcDir | Copy-Item -Destination "$dstDir" -Verbose:$false
  }

  # backup X509 certificates
  $srcDir = dir cert:\CurrentUser\My | Where-Object { $_.HasPrivateKey }
  $dstDir = $OneDrive + "\Personal Certificates"
  if ($srcDir) {
    New-Item -ItemType Directory -Path $dstDir -force > $null
    $srcDir | Foreach-Object {
      $dstFileTmp = $env:TEMP + "\" + $_.Thumbprint + ".pfx"
      $dstFile = $dstDir + "\" + $_.Thumbprint + ".pfx"
      if (!(Test-Path $dstFile)) {
        Set-ToastMessage "⚠ Digital ID backup pending" ("Your action is needed for a certificate with subject " + $_.Subject + ", issuer " + $_.Issuer)
        Start-Sleep -s 5
        $PWsrc = ("A","B","C","D","E","F","G","H","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","k","l","m","n","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9")
        $PW = (Get-TempPassword –length 4 –sourcedata $PWsrc) + "-" + ($PW = Get-TempPassword –length 4 –sourcedata $PWsrc) + "-" + ($PW = Get-TempPassword –length 4 –sourcedata $PWsrc) + "-" + ($PW = Get-TempPassword –length 4 –sourcedata $PWsrc)
        $SecurePW = ConvertTo-SecureString -String $PW -Force -AsPlainText
        Write-Host "Backup of X509 certificate" $_.Thumbprint " to $dstFile"
        Export-PfxCertificate –Cert $_ –FilePath $dstFileTmp -ChainOption EndEntityCertOnly -Force -NoProperties -Verbose:$false -Password $SecurePW > $null
        $success = $false
        if (Test-Path $dstFileTmp) {
            $title = $env:USERDOMAIN+" User Data Management - Personal Certificate"
            while ($true) {
              $r = New-Popup -message "Take a note of this recovery password:`n`n$PW`n`nDid you save the recovery password?" -title $title -buttons "YesNoCancel" -Icon Exclamation
              if ($r -eq 2) { break }
              elseif ($r -eq 7) { $r = New-Popup -message "It is imporant that you write down the recovery password to ensure you have it available when you need it. To make sure you have the correct password, we are asking you to enter it once now." -title $title -buttons "OK" -Icon Exclamation; continue }
              elseif ($r -ne 6) { continue }


              Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form 
$form.Text = $title
$form.Size = New-Object System.Drawing.Size(600,400) 
$form.StartPosition = "CenterScreen"
$form.MinimizeBox = $false
$form.MaximizeBox = $false

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(140,240)
$OKButton.Size = New-Object System.Drawing.Size(150,50)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(310,240)
$CancelButton.Size = New-Object System.Drawing.Size(150,50)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(25,40) 
$label.Size = New-Object System.Drawing.Size(480,100)
$label.Text = "Please type in the recovery password`nyou just wrote down:"
$form.Controls.Add($label) 

$textBox = New-Object System.Windows.Forms.TextBox 
$textBox.Location = New-Object System.Drawing.Point(25,150) 
$textBox.Size = New-Object System.Drawing.Size(260,120) 
$form.Controls.Add($textBox) 

$form.Topmost = $True

$form.Add_Shown({$textBox.Select()})
$r = $form.ShowDialog()

if ($r -eq [System.Windows.Forms.DialogResult]::OK -and $textBox.Text -eq $PW) {
  $success = $true
  Copy-Item -Path $dstFileTmp -Destination $dstFile
  break
}
$r = New-Popup -message "The passwords do not match, try again." -title $title -buttons "OK" -Icon Stop


            }
            Remove-Item -Recurse -Force $dstFileTmp > $null
        }
        if ($success) {
            Set-ToastMessage -title "✅ Digital ID backup complete" -message ("Certificate with subject "+ $_.Subject + ", issuer " + $_.Issuer + ", was successfully backed up.")
        } else {
            Set-ToastMessage -title "❌ Digital ID backup pending" -message ("Postponed backup for certificate with subject "+ $_.Subject + ", issuer " + $_.Issuer)
        }
      }
    }
  }

}
