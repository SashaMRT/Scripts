Add-Type -AssemblyName PresentationFramework
$everythingDownloadUrl="https://www.voidtools.com/Everything-1.4.1.1028.x86-Setup.exe"
$everythingInstallerPath="$env:TEMP\Everything-Setup.exe"
$everythingIniPath="$env:APPDATA\Everything\Everything.ini"
$powerRunDownloadUrl="https://github.com/SashaMRT/Scripts/raw/refs/heads/main/PowerRun_x64.exe"
$powerRunFolderPath="$env:TEMP\PowerRunFolder"
$registryScriptPath="$env:TEMP\RegistryModifications.ps1"
$powerRunExePath=Join-Path $powerRunFolderPath "PowerRun_x64.exe"
$powerRunIniPath=Join-Path $powerRunFolderPath "PowerRun.ini"
$windowsOldFolderPath="$env:SystemDrive\Windows.old"

Invoke-WebRequest -Uri $everythingDownloadUrl -OutFile $everythingInstallerPath
Start-Process -FilePath $everythingInstallerPath -ArgumentList "/S" -Wait
Start-Sleep -Seconds 5

if(Test-Path $everythingIniPath){
  (Get-Content $everythingIniPath) -replace '^normal_background_color=.*','normal_background_color=#353535' `
                                  -replace '^normal_foreground_color=.*','normal_foreground_color=#ffffff' `
                                  -replace '^single_click_open=.*','single_click_open=2' `
                                  -replace '^hide_empty_search_results=.*','hide_empty_search_results=1' `
                                  -replace '^double_click_path=.*','double_click_path=1' `
                                  -replace '^show_mouseover=.*','show_mouseover=1' `
                                  -replace '^show_number_of_results_with_selection=.*','show_number_of_results_with_selection=1' `
                                  -replace '^tooltips=.*','tooltips=0' `
                                  -replace '^search_history_enabled=.*','search_history_enabled=0' `
                                  -replace '^run_history_enabled=.*','run_history_enabled=0' `
                                  -replace '^index_date_modified=.*','index_date_modified=0' `
                                  -replace '^exclude_list_enabled=.*','exclude_list_enabled=0' `
                                  -replace '^language=.*','language=1033' | Set-Content $everythingIniPath
}else{
  Write-Warning "Everything.ini not found. Please run Everything once manually."
}

Remove-Item -Path $everythingInstallerPath -Force -ErrorAction SilentlyContinue
Start-Process -FilePath "dism.exe" -ArgumentList "/Online /Disable-Feature /FeatureName:SearchEngine-Client-Package" -Wait -NoNewWindow

$registryEntries=@(
  @{Path="HKCU:\Software\Voidtools\Everything";Name="CheckForUpdate";Type="DWord";Value=0},
  @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers";Name="HwSchMode";Type="DWord";Value=2},
  @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl";Name="Win32PrioritySeparation";Type="DWord";Value=36},
  @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power";Name="HiberbootEnabled";Type="DWord";Value=0},
  @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling";Name="PowerThrottlingOff";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\Windows\DWM";Name="ColorizationColor";Type="DWord";Value=3292809298},
  @{Path="HKCU:\Software\Microsoft\Windows\DWM";Name="ColorizationAfterglow";Type="DWord";Value=3292809298},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";Name="StartColorMenu";Type="DWord";Value=4282793274},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent";Name="AccentColorMenu";Type="DWord";Value=4283582532},
  @{Path="HKCU:\Software\Microsoft\GameBar";Name="AllowAutoGameMode";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\GameBar";Name="AutoGameModeEnabled";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize";Name="AppsUseLightTheme";Type="DWord";Value=0},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize";Name="ColorPrevalence";Type="DWord";Value=0},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize";Name="EnableTransparency";Type="DWord";Value=0},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize";Name="SystemUsesLightTheme";Type="DWord";Value=0},
  @{Path="HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes";Name="UWPAppsUseLightTheme";Type="DWord";Value=0},
  @{Path="HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes";Name="SystemUsesLightTheme";Type="DWord";Value=0},
  @{Path="HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes";Name="AppsUseLightTheme";Type="DWord";Value=0},
  @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search";Name="PreventIndexOnBattery";Type="DWord";Value=1},
  @{Path="HKLM:\Software\Microsoft\Windows Search\Gather\Windows\SystemIndex";Name="RespectPowerModes";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences";Name="WholeFileSystem";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences";Name="SystemFolders";Type="DWord";Value=0},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences";Name="AutoWildCard";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences";Name="EnableNaturalQuerySyntax";Type="DWord";Value=0},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences";Name="ArchivedFiles";Type="DWord";Value=0},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Search\PrimaryProperties\UnindexedLocations";Name="SearchOnly";Type="DWord";Value=1},
  @{Path="HKLM:\SYSTEM\CurrentControlSet\Services\WSearch";Name="Start";Type="DWord";Value=4},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu";Name="{645FF040-5081-101B-9F08-00AA002F954E}";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel";Name="{645FF040-5081-101B-9F08-00AA002F954E}";Type="DWord";Value=1},
  @{Path="HKCU:\Software\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}";Name="System.IsPinnedToNameSpaceTree";Type="DWord";Value=0},
  @{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";Name="LaunchTo";Type="DWord";Value=1},
  @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer";Name="HubMode";Type="DWord";Value=1},
  @{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy";Name="01";Type="DWord";Value=0},
  @{Path="HKLM:\Software\Policies\Microsoft\Windows\StorageSense";Name="AllowStorageSenseGlobal";Type="DWord";Value=0},
  @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System";Name="EnableFirstLogonAnimation";Type="DWord";Value=0},
  @{Path="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon";Name="EnableFirstLogonAnimation";Type="DWord";Value=0},
  @{Path="HKCU:\Control Panel\Desktop\WindowMetrics";Name="MinAnimate";Type="String";Value="0"},
  @{Path="HKCU:\Control Panel\Desktop\WindowMetrics";Name="MaxAnimate";Type="String";Value="0"},
  @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";Name="TaskbarAnimations";Type="String";Value="0"},
  @{Path="HKCU:\SOFTWARE\Policies\Microsoft\Windows\DWM";Name="DisallowAnimations";Type="DWord";Value=0}
)

$registryScript={
  param($entries)
  foreach($entry in $entries){
    try {
      if(-not (Test-Path $entry.Path)){
        New-Item -Path $entry.Path -Force | Out-Null
      }
      New-ItemProperty -Path $entry.Path -Name $entry.Name -Value $entry.Value -PropertyType $entry.Type -Force
      Write-Host "Applied: $($entry.Path) -> $($entry.Name) = $($entry.Value)"
    }
    catch {
      Write-Warning "Failed to apply: $($entry.Path) -> $($entry.Name): $_"
    }
  }
  $accentKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
  if(-not (Test-Path $accentKey)){
    New-Item -Path $accentKey -Force | Out-Null
  }
  $palette = [byte[]](0x64,0x6a,0x79,0xff,0x57,0x5c,0x68,0xff,0x4d,0x52,0x5d,0xff,0x44,0x48,0x52,0xff,0x3a,0x3d,0x46,0xff,0x30,0x33,0x3b,0xff,0x23,0x25,0x2a,0xff,0x88,0x17,0x98,0x00)
  Set-ItemProperty -Path $accentKey -Name "AccentPalette" -Value $palette -Type Binary
  Get-Process dwm -ErrorAction SilentlyContinue | Stop-Process -Force
  Start-Sleep -Seconds 1
  Start-Process dwm.exe
  Write-Host "Registry changes applied. Press Enter to exit..."
  Read-Host
}

$registryScriptContent = $registryScript.ToString()
Set-Content -Path $registryScriptPath -Value $registryScriptContent

if(-not (Test-Path $powerRunFolderPath)){
  New-Item -ItemType Directory -Path $powerRunFolderPath | Out-Null
}

Invoke-WebRequest -Uri $powerRunDownloadUrl -OutFile $powerRunExePath
"[Main]`nAllowCommandLine=1" | Out-File -FilePath $powerRunIniPath -Encoding ASCII
$proc = Start-Process -FilePath $powerRunExePath -WorkingDirectory $powerRunFolderPath -PassThru
[System.Windows.MessageBox]::Show("Please enable 'Allow Command Line' from the File menu in the PowerRun window, then close PowerRun to continue.","Action Required",'OK','Warning') | Out-Null
$proc.WaitForExit()
Start-Process -FilePath $powerRunExePath -ArgumentList $registryScriptPath -WorkingDirectory $powerRunFolderPath -Wait
Write-Host "Registry modifications applied."
Remove-Item -Path $powerRunFolderPath -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $registryScriptPath -Force -ErrorAction SilentlyContinue

if(Test-Path $windowsOldFolderPath){
  Start-Process -FilePath "takeown.exe" -ArgumentList "/f `"$windowsOldFolderPath`" /a /r /d Y" -Wait
  Start-Process -FilePath "icacls.exe" -ArgumentList "`"$windowsOldFolderPath`" /grant Administrators:F /t /c /q" -Wait
  Remove-Item -LiteralPath $windowsOldFolderPath -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "Windows.old cleanup completed."
}else{
  Write-Host "Windows.old folder not found; skipping cleanup."
}

Write-Host "All done."
