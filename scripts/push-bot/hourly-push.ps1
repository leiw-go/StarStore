# hourly-push.ps1
# One-shot git push for vault E:\starstore.
# Pull --rebase --autostash first to avoid conflicts, then push any unpushed commits.
# Intended to be run by Windows Task Scheduler every hour.

$ErrorActionPreference = 'Continue'

$VaultRoot = 'E:\starstore'
$Remote    = 'origin'
$Branch    = 'master'

$LogDir = Join-Path $VaultRoot 'scripts\push-bot\logs'
if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Force -Path $LogDir | Out-Null }
$LogFile = Join-Path $LogDir ("hourly-" + (Get-Date -Format 'yyyyMMdd') + ".log")

function Write-Log {
    param([string]$Message, [ValidateSet('INFO','WARN','ERR','OK')] $Level = 'INFO')
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$ts] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

Push-Location -LiteralPath $VaultRoot
try {
    # Pull first to sync remote (rebase to keep history linear, autostash any local edits)
    $pullOut = git pull --rebase --autostash $Remote $Branch 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "git pull failed: $pullOut" ERR
        exit 1
    }

    # Check if there are unpushed commits
    $unpushed = git log "$Remote/$Branch..HEAD" --oneline 2>&1
    if ($LASTEXITCODE -ne 0) {
        # branch doesn't track yet or no upstream — push to set upstream
        Write-Log "No upstream tracking, pushing to set upstream"
        $pushOut = git push --set-upstream $Remote $Branch 2>&1
        if ($LASTEXITCODE -ne 0) { Write-Log "push failed: $pushOut" ERR; exit 1 }
        Write-Log "PUSH OK (upstream set)" OK
        exit 0
    }

    if (-not $unpushed) {
        Write-Log "No unpushed commits"
        exit 0
    }

    Write-Log "Found unpushed commits: $($unpushed -join ' / ')"
    $pushOut = git push $Remote $Branch 2>&1
    if ($LASTEXITCODE -ne 0) { Write-Log "push failed: $pushOut" ERR; exit 1 }
    Write-Log "PUSH OK" OK
}
finally {
    Pop-Location
}