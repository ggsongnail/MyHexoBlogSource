@echo off
echo ">>>>>>>>>>提交更新到 git@github.com:ggsongnail/MyHexoBlogSource.git>>>>>>>>>>>>>>>>"
git add source
git commit -m "批处理提交更新"
git push -u origin hexo
echo ">>>>>>>>>>hexo 发布开始>>>>>>>>>>>>>>>>"
hexo d -g
pause