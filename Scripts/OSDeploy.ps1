#======================================================================================
#	Load Registry Hives
#======================================================================================
$RegDefault = "$MountDirectory\Windows\System32\Config\Default"
if (Test-Path $RegDefault) {
	Write-Host "Loading $RegDefault" -ForegroundColor Cyan
	Start-Process reg -ArgumentList "load HKLM\MountDefault $RegDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
$RegDefaultUser = "$MountDirectory\Users\Default\ntuser.dat"
if (Test-Path $RegDefaultUser) {
	Write-Host "Loading $RegDefaultUser" -ForegroundColor Cyan
	Start-Process reg -ArgumentList "load HKLM\MountDefaultUser $RegDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
$RegSoftware = "$MountDirectory\Windows\System32\Config\Software"
if (Test-Path $RegSoftware) {
	Write-Host "Loading $RegSoftware" -ForegroundColor Cyan
	Start-Process reg -ArgumentList "load HKLM\MountSoftware $RegSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
$RegSystem = "$MountDirectory\Windows\System32\Config\System"
if (Test-Path $RegSystem) {
	Write-Host "Loading $RegSystem" -ForegroundColor Cyan
	Start-Process reg -ArgumentList "load HKLM\MountSystem $RegSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}

#======================================================================================
#	Registry Commands
#======================================================================================
$RegCommands =
'add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "10 59 118" /f',
'add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "" /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {018D5C66-4533-4307-9B53-224DE2ED1FE6} /t REG_DWORD /d 1 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 0 /f',
'add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer" /v DisableEdgeDesktopShortcutCreation /t REG_DWORD /d 1 /f',
'delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f'

foreach ($Command in $RegCommands) {
	if ($Command -like "*HKCU*") {
		$Command = $Command -replace "HKCU","HKLM\MountDefaultUser"
		Write-Host "reg $Command" -ForegroundColor Green
		Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
	} elseif ($Command -like "*HKLM\Software*") {
		$Command = $Command -replace "HKLM\Software","HKLM\MountSoftware"
		Write-Host "reg $Command" -ForegroundColor Green
		Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
	} elseif ($Command -like "*HKLM\System*") {
		$Command = $Command -replace "HKLM\System","HKLM\MountSystem"
		Write-Host "reg $Command" -ForegroundColor Green
		Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
	}
}

#======================================================================================
#	Unload Registry Hives
#======================================================================================
Start-Process reg -ArgumentList "unload HKLM\MountDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Process reg -ArgumentList "unload HKLM\MountDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Process reg -ArgumentList "unload HKLM\MountSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Process reg -ArgumentList "unload HKLM\MountSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

#======================================================================================
#	Remove Other Files
#======================================================================================
Remove-Item -Path "$MountDirectory\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force

#======================================================================================
#	Remove 4K Wallpaper
#======================================================================================
<# takeown /f "$MountDirectory\Windows\Web\4K\Wallpaper\Windows\*"
& icacls "$MountDirectory\Windows\Web\4K\Wallpaper\Windows\*.*" /grant "Administrators:(F)"
Remove-Item -Path "$MountDirectory\Windows\Web\4K\Wallpaper\Windows\*" -Force #>

#======================================================================================
#	Testing
#======================================================================================
#	[void](Read-Host 'Press Enter to continue')
