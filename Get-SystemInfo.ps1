# ===================================
# Script Name: Get-Systeminfo.ps1
# Author: Daniel Conaway
# Date: 9/5/26
# ===================================

param(
    [int]$MinimumFreeSpaceGB = 10
)

# Variables
$ComputerName = $env:COMPUTERNAME
$CurrentUser = $env:USERNAME
$Today = Get-Date -Format "MM/dd/yy HH:mm"

try
{
    $Drives = Get-PSDrive -PSProvider FileSystem -ErrorAction Stop | Select-Object Name, Used, Free
    $OS = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop | Select-Object Caption, LastBootUpTime, TotalVisibleMemorySize
    $StoppedServices = Get-Service -ErrorAction Stop | Where-Object {$_.Status -eq "Stopped"} | Select-Object Name, Status
    $TotalMemoryGB = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
}
catch
{
    Write-Host "Unable to collect system information." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Display Information
Write-Host "Server Name: $ComputerName" -ForegroundColor White
Write-Host "Reported by: $CurrentUser" -ForegroundColor White
Write-Host "Report Time: $Today" -ForegroundColor White

Write-Host "Operating System: $($OS.Caption)"
Write-Host "Last Reboot: $($os.LastBootUpTime)"
Write-Host "Total Memory: $TotalMemoryGB GB" -ForegroundColor Green

$Drives | 
    Select-Object Name, 
        @{Name = "Used (GB)"; Expression = {[math]::Round($_.Used / 1GB, 2)}}, 
        @{Name = "Free (GB)"; Expression = {[math]::Round($_.Free / 1GB, 2)}} | 
    Format-Table -AutoSize

$StoppedServices | Format-Table -AutoSize

foreach ($drive in $Drives)
{
    $FreeGB = [math]::Round($drive.Free / 1GB, 2)
    
    if ($FreeGB -lt $MinimumFreeSpaceGB)
    {
        Write-Host "Drive $($drive.Name) free space: $FreeGB GB ***Low Disk Space!***"
    }
    
    else 
    {
        Write-Host "Drive $($drive.Name) free space: $FreeGB GB"
    }
}

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "Report generated: $Today"                            -ForegroundColor Gray
Write-Host "Run On: $ComputerName"                               -ForegroundColor Gray
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Script completed successfully." -ForegroundColor Green