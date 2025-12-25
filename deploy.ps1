$ErrorActionPreference = 'Stop'

# 始终在脚本所在目录（blog/）内执行，避免误操作外层仓库
Push-Location $PSScriptRoot
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

  git pull --rebase origin source

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
  $hexoCmd = Join-Path $PSScriptRoot 'node_modules/.bin/hexo.cmd' # Use project-local Hexo to avoid PATH issues
  if (-not (Test-Path $hexoCmd)) {
    throw "Hexo binary not found. Run 'npm install' in $PSScriptRoot."
  }

  & $hexoCmd clean
  & $hexoCmd generate
  & $hexoCmd deploy

  Write-Host "Blog deployed successfully!" -ForegroundColor Green
}
finally {
  Pop-Location
}
