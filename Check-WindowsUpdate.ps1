# Check the Windows Update service status
$ServiceName = "wuauserv"

try
{
    $WindowsUpdateService = Get-Service -Name $ServiceName -ErrorAction Stop

    Write-Host "Windows Update service status: $($WindowsUpdateService.Status)" -ForegroundColor White

    if ($WindowsUpdateService.Status -eq "Running")
    {
        Write-Host "Windows Update is running." -ForegroundColor Green
    }
    elseif ($WindowsUpdateService.Status -eq "Stopped")
    {
        Write-Host "Windows Update is stopped. Attempting to start it..." -ForegroundColor Yellow

        try
        {
            Start-Service -Name $ServiceName -ErrorAction Stop
            $WindowsUpdateService.WaitForStatus(
                [System.ServiceProcess.ServiceControllerStatus]::Running,
                [TimeSpan]::FromSeconds(10)
            )

            $WindowsUpdateService = Get-Service -Name $ServiceName -ErrorAction Stop

            if ($WindowsUpdateService.Status -eq "Running")
            {
                Write-Host "Windows Update started successfully." -ForegroundColor Green
            }
            else
            {
                Write-Host "Windows Update failed to start. Current status: $($WindowsUpdateService.Status)" -ForegroundColor Red
            }
        }
        catch
        {
            Write-Host "Windows Update failed to start." -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
    else
    {
        Write-Host "Windows Update is not running. Current status: $($WindowsUpdateService.Status)" -ForegroundColor Yellow
    }
}
catch
{
    Write-Host "Unable to find or query the Windows Update service." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}