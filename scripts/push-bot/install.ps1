# install.ps1
# Registers two Windows scheduled tasks for the starstore auto-push system.
# Must be run as Administrator.

$ErrorActionPreference = 'Stop'

$ScriptDir  = $PSScriptRoot
$WatcherPs1 = Join-Path $ScriptDir 'watch-and-push.ps1'
$HourlyPs1  = Join-Path $ScriptDir 'hourly-push.ps1'

if (-not (Test-Path $WatcherPs1)) { throw "Missing: $WatcherPs1" }
if (-not (Test-Path $HourlyPs1))  { throw "Missing: $HourlyPs1" }

$PsExe = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
if (-not (Test-Path $PsExe)) { $PsExe = 'powershell.exe' }

function Register-PushTask {
    param(
        [string]$TaskName,
        [string]$ScriptPath,
        [bool]$HideWindow = $false
    )

    # Remove existing task with the same name (idempotent install)
    if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        Write-Host "Removed existing task: $TaskName"
    }

    $action = New-ScheduledTaskAction `
        -Execute $PsExe `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`"" `
        -WorkingDirectory $ScriptDir

    $principal = New-ScheduledTaskPrincipal `
        -UserId $env:USERNAME `
        -LogonType S4U `
        -RunLevel Highest

    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -RestartCount 3 `
        -RestartInterval (New-TimeSpan -Minutes 1) `
        -ExecutionTimeLimit (New-TimeSpan -Hours 0)  # unlimited

    if ($TaskName -eq 'StarStore-AutoPush-Watcher') {
        # Trigger: at user logon
        $triggers = @(
            New-ScheduledTaskTrigger -AtLogOn
        )
    } else {
        # Trigger: daily at 00:00, repeat every 1 hour indefinitely.
        # PowerShell 5.1 New-ScheduledTaskTrigger only exposes
        # -RepetitionInterval/-RepetitionDuration on the Once parameter
        # set, so anchor -At to the next midnight and rely on repetition.
        $nextMidnight = (Get-Date).AddDays(1).Date
        $triggers = @(
            New-ScheduledTaskTrigger -Once -At $nextMidnight `
                -RepetitionInterval (New-TimeSpan -Hours 1) `
                -RepetitionDuration (New-TimeSpan -Days 3650)
        )
    }

    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $action `
        -Trigger $triggers `
        -Principal $principal `
        -Settings $settings `
        -Description "Auto-push script for E:\starstore ($TaskName)" `
        | Out-Null

    Write-Host "Registered: $TaskName"
}

Write-Host "=== Installing starstore auto-push tasks ==="
Register-PushTask -TaskName 'StarStore-AutoPush-Watcher' -ScriptPath $WatcherPs1
Register-PushTask -TaskName 'StarStore-AutoPush-Hourly'  -ScriptPath $HourlyPs1

Write-Host "`n=== Verifying ==="
Get-ScheduledTask | Where-Object { $_.TaskName -like 'StarStore*' } |
    Format-Table TaskName, State, TaskPath -AutoSize

Write-Host "`n=== Done. To start the watcher now (optional): ==="
Write-Host "  Start-ScheduledTask -TaskName 'StarStore-AutoPush-Watcher'"
Write-Host "`n=== Logs at: ==="
Write-Host "  E:\starstore\scripts\push-bot\logs\"