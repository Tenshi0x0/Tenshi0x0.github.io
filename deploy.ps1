$ErrorActionPreference = 'Stop'

# 始终在脚本所在目录（blog/）内执行，避免误操作外层仓库
$scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) {
  $PSScriptRoot
} else {
  Split-Path -LiteralPath $MyInvocation.MyCommand.Path -Parent
}
Push-Location $scriptDir
try {
  # 确保在 source 分支并与远端同步
  git fetch --all --prune

  $current = (git rev-parse --abbrev-ref HEAD).Trim()
  if ($current -ne 'source') {
    git show-ref --verify --quiet refs/heads/source
    if ($LASTEXITCODE -eq 0) {
      git checkout source
    } else {
      git checkout -b source origin/source
    }
  }

  # 若工作区有改动，先暂存，避免 rebase 被拒
  $stashed = $false
  $stashName = "deploy-temp-{0:yyyyMMddHHmmss}" -f (Get-Date)
  git diff --quiet
  $hasTrackedChanges = $LASTEXITCODE -ne 0
  $hasUntracked = -not [string]::IsNullOrWhiteSpace((git ls-files --others --exclude-standard | Select-Object -First 1))
  if ($hasTrackedChanges -or $hasUntracked) {
    Write-Host "Working tree not clean; stashing changes ($stashName) before pull..." -ForegroundColor Yellow
    git stash push -u -m $stashName | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "git stash push failed" }
    $stashed = $true
  }

  git pull --rebase origin source
  if ($LASTEXITCODE -ne 0) { throw "git pull --rebase origin source failed" }

  if ($stashed) {
    git stash pop
    if ($LASTEXITCODE -ne 0) { throw "git stash pop failed; please resolve conflicts manually." }
  }

  # 提交源码改动（若有）
  git add -A
  git diff --staged --quiet
  if ($LASTEXITCODE -ne 0) {
    git commit -m "Update blog source"
  } else {
    Write-Host "No source changes to commit" -ForegroundColor Yellow
  }

  git push -u origin source

  # 生成并部署站点
  Write-Host "Script directory: $scriptDir"
  $hexoCmd = [IO.Path]::Combine($scriptDir, 'node_modules', '.bin', 'hexo.cmd') # Use project-local Hexo to avoid PATH issues
  Write-Host "Using Hexo binary: $hexoCmd"
  if ([string]::IsNullOrWhiteSpace($hexoCmd) -or -not (Test-Path -LiteralPath $hexoCmd)) {
    Write-Host "Hexo binary missing. Running npm install..." -ForegroundColor Yellow
    npm install
    if (-not (Test-Path -LiteralPath $hexoCmd)) {
      throw "Hexo binary not found after npm install. Check dependencies in $scriptDir."
    }
  }

  & $hexoCmd clean
  & $hexoCmd generate
  & $hexoCmd deploy

  Write-Host "Blog deployed successfully!" -ForegroundColor Green
}
finally {
  Pop-Location
}
