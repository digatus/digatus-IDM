# Source: https://blog.danic.net/how-windows-10-pro-installs-unwanted-apps-candy-crush-and-how-you-stop-it/
#

# Disabling Suggestions for new users (only works with admin rights!)
reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
reg save HKU\Default_User C:\Users\Default\NTUSER.DAT
reg unload HKU\Default_User

# Disabling Suggestions for existing user
#TODO

# Disabling dynamically inserted app tiles (unwanted apps)
reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
reg save HKU\Default_User C:\Users\Default\NTUSER.DAT
reg unload HKU\Default_User

# Removing provisioned app packages
$appsToRemove = @(
		"Microsoft.Advertising.Xaml",
		"Microsoft.DesktopAppInstaller",
		"Microsoft.GetHelp",
		"Microsoft.Getstarted",
		"Microsoft.Messaging",
		"Microsoft.Microsoft3DViewer",
		"Microsoft.MicrosoftOfficeHub",
		"Microsoft.MicrosoftStickyNotes",
		"Microsoft.Office.OneNote",
		"Microsoft.OneConnect",
		"Microsoft.People",
		"Microsoft.Print3D",
		"Microsoft.Services.Store.Engagement",
		"Microsoft.SkypeApp",
		"Microsoft.WindowsAlarms",
		"Microsoft.WindowsCalculator",
		"Microsoft.WindowsCamera",
		"microsoft.windowscommunicationsapps",
		"Microsoft.WindowsFeedbackHub",
		"Microsoft.WindowsMaps",
		"Microsoft.WindowsSoundRecorder",
		"Microsoft.Xbox.TCUI",
		"Microsoft.XboxApp",
		"Microsoft.XboxGameOverlay",
		"Microsoft.XboxSpeechToTextOverlay",
		"Microsoft.ZuneMusic",
		"Microsoft.ZuneVideo",
    "Microsoft.Appconnector",
    "Microsoft.BingFinance",
    "Microsoft.BingNews",
    "Microsoft.CommsPhone",
    "Microsoft.ConnectivityStore",
    "Microsoft.DesktopAppInstaller",
    "Microsoft.Getstarted",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Sway",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.StorePurchaseApp",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsCommunicationsApps",
    "Microsoft.WindowsPhone",
    "Microsoft.WindowsSoundRecorder",
)
# The *-AppxProvisionedPackage cmdlet do not work as startup and shutdown scripts.
Get-AppxProvisionedPackage -Online | % { if($_.DisplayName -in $appsToRemove){ Remove-AppxProvisionedPackage } }
