# watch-and-push.ps1
# Real-time git auto-push watcher for Obsidian vault E:\starstore
# Listens to file changes and pushes to remote after 5s of debounce silence.
#
# NOTE: Register-ObjectEvent runs the action scriptblock in a separate
# event-job scope, so ordinary script-scope variables ($Timer, $VaultRoot,
# etc.) are NOT visible there. We bridge the gap by putting the shared
# state under $global:StarStoreWatcher.

$ErrorActionPreference = 'Continue'

# --- Configuration ----------------------------------------------------------
$VaultRoot       = 'E:\starstore'
$Remote          = 'origin'
$Branch          = 'master'
$DebounceSeconds = 5

# Shared ignore patterns (string regexes). Used by both main thread and
# the OnChange event action via $global:StarStoreWatcher.
$global:StarStoreWatcher = [hashtable]::Synchronized(@{
    VaultRoot    = $VaultRoot
    Remote       = $Remote
    Branch       = $Branch
    IgnoreRegex  = @(
        '(?i)[\\/]\.git([\\/]|$)',                       # .git folder or anything inside
        '(?i)[\\/]scripts[\\/]push-bot[\\/]logs([\\/]|$)', # our own logs
        '(?i)[\\/]scripts[\\/]push-bot[\\/]\.auto-push-task\.md$',
        '(?i)[\\/]scripts[\\/]push-bot[\\/]stdout\.log$',
        '(?i)[\\/]scripts[\\/]push-bot[\\/]stderr\.log$',
        '(?i)\.log$',                                     # any .log file
        '(?i)~lock\..*\.md$',                             # Obsidian lock files
        '(?i)[\\/]\.obsidian[\\/]workspace\.json$',
        '(?i)[\\/]\.obsidian[\\/]cache([\\/]|$)',
        '(?i)[\\/]\.trash([\\/]|$)'
    )
    LogFile      = $null
    PushInProgress = $false
})

# --- Logging -----------------------------------------------------------------
$LogDir = Join-Path $VaultRoot 'scripts\push-bot\logs'
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
}
$LogFile = Join-Path $LogDir ('watcher-' + (Get-Date -Format 'yyyyMMdd') + '.log')
$global:StarStoreWatcher.LogFile = $LogFile

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','WARN','ERR','OK')]$Level = 'INFO')
    $ts   = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$ts] [$Level] $Message"
    try { Add-Content -Path $global:StarStoreWatcher.LogFile -Value $line -Encoding UTF8 } catch {}
    Write-Host $line
}

function Test-Ignored {
    param([string]$FullPath)
    foreach ($p in $global:StarStoreWatcher.IgnoreRegex) {
        if ($FullPath -match $p) { return $true }
    }
    return $false
}

# --- Push logic --------------------------------------------------------------
function Invoke-AutoPush {
    param([string]$Reason)

    if ($global:StarStoreWatcher.PushInProgress) {
        Write-Log "Skipped ($Reason): push already in progress" 'WARN'
        return
    }
    $global:StarStoreWatcher.PushInProgress = $true
    try {
        Push-Location -LiteralPath $VaultRoot
        try {
            $status = git status --porcelain 2>&1
            if (-not $status) {
                Write-Log "No changes ($Reason)"
                return
            }

            $ts  = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $msg = "auto: watcher @ $ts"

            git add -A 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) { Write-Log 'git add failed' 'ERR'; return }

            $commitOut = git commit -m $msg 2>&1
            if ($LASTEXITCODE -ne 0) {
                if ($commitOut -match 'nothing to commit') {
                    Write-Log "Nothing to commit ($Reason)"
                } else {
                    Write-Log "git commit failed: $commitOut" 'ERR'
                }
                return
            }

            $pushOut = git push $Remote $Branch 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Log "git push failed: $pushOut" 'ERR'
                return
            }

            Write-Log "PUSH OK ($Reason): $msg" 'OK'
        } finally {
            Pop-Location
        }
    } catch {
        Write-Log "Exception during push: $_" 'ERR'
    } finally {
        $global:StarStoreWatcher.PushInProgress = $false
    }
}

# --- Debounce timer (owned by main runspace) -------------------------------
$Timer = New-Object System.Timers.Timer
$Timer.Interval  = $DebounceSeconds * 1000
$Timer.AutoReset = $false

$TimerAction = {
    try { Write-Log 'TIMER ELAPSED - calling Invoke-AutoPush' } catch {}
    Invoke-AutoPush -Reason 'watcher'
}
Register-ObjectEvent -InputObject $Timer -EventName Elapsed -Action $TimerAction | Out-Null
$global:StarStoreWatcher.Timer = $Timer

# --- FileSystemWatcher -------------------------------------------------------
$Watcher = New-Object System.IO.FileSystemWatcher
$Watcher.Path                  = $VaultRoot
$Watcher.IncludeSubdirectories = $true
$Watcher.NotifyFilter           = [System.IO.NotifyFilters]::FileName,
                                 [System.IO.NotifyFilters]::DirectoryName,
                                 [System.IO.NotifyFilters]::LastWrite,
                                 [System.IO.NotifyFilters]::Size,
                                 [System.IO.NotifyFilters]::CreationTime
$Watcher.InternalBufferSize     = 65536

# OnChange is invoked in a separate event-job scope. The only way to
# communicate with the main runspace is via $global: state.
$OnChange = {
    try {
        $ea  = $Event.SourceEventArgs
        $path = $ea.FullPath
        if (Test-Ignored $path) { return }

        Write-Log ('CHANGE: ' + $ea.ChangeType + ' ' + $path)
        $t = $global:StarStoreWatcher.Timer
        if ($t) {
            $t.Stop()
            $t.Start()
        }
    } catch {
        # swallow — never let an event handler kill the watcher
    }
}
foreach ($ev in 'Changed','Created','Renamed','Deleted') {
    Register-ObjectEvent -InputObject $Watcher -EventName $ev -Action $OnChange | Out-Null
}
$Watcher.EnableRaisingEvents = $true
$global:StarStoreWatcher.Watcher = $Watcher

# --- Graceful shutdown -------------------------------------------------------
$Shutdown = {
    Write-Log '=== Shutdown signal received ==='
    $global:StarStoreWatcher.Watcher.EnableRaisingEvents = $false
    $global:StarStoreWatcher.Watcher.Dispose()
    $global:StarStoreWatcher.Timer.Dispose()
    Get-EventSubscriber | Where-Object {
        $_.SourceObject -is [System.IO.FileSystemWatcher] -or
        $_.SourceObject -is [System.Timers.Timer]
    } | ForEach-Object {
        Unregister-Event -SubscriptionId $_.SubscriptionId -Force -ErrorAction SilentlyContinue
    }
    Write-Log '=== WATCHER STOPPED ==='
    exit 0
}
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action $Shutdown | Out-Null
try { [Console]::TreatControlCAsInput = $false } catch { }

# --- Banner & keep-alive -----------------------------------------------------
Write-Log '=== WATCHER STARTED ==='
Write-Log "Vault:    $VaultRoot"
Write-Log "Remote:   $Remote / $Branch"
Write-Log "Debounce: ${DebounceSeconds}s"
Write-Log "Log:      $LogFile"
Write-Log 'Press Ctrl+C to stop.'

try {
    while ($true) { Start-Sleep -Seconds 30 }
} catch {
    & $Shutdown
}
