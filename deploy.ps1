# 保存源码
git add .
git commit -m "Update blog source"
git push

# 部署网站
hexo clean
hexo generate
hexo deploy

Write-Host "Blog deployed successfully!" -ForegroundColor Green
