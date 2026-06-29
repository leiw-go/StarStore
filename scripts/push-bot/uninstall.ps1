# uninstall.ps1
# Removes the two starstore auto-push scheduled tasks.

$ErrorActionPreference = 'Continue'

$tasks = @('StarStore-AutoPush-Watcher', 'StarStore-AutoPush-Hourly')

foreach ($t in $tasks) {
    if (Get-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue) {
        # Stop first if running
        $info = Get-ScheduledTask -TaskName $t
        if ($info.State -eq 'Running') {
            Stop-ScheduledTask -TaskName $t -ErrorAction SilentlyContinue
            Write-Host "Stopped: $t"
        }
        Unregister-ScheduledTask -TaskName $t -Confirm:$false
        Write-Host "Removed: $t"
    } else {
        Write-Host "Not present: $t"
    }
}

Write-Host "`n=== Remaining StarStore tasks (should be empty) ==="
Get-ScheduledTask | Where-Object { $_.TaskName -like 'StarStore*' } |
    Format-Table TaskName, State, TaskPath -AutoSize