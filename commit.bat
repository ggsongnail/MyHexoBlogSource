@echo off
echo ">>>>>>>>>>�ύ���µ� git@github.com:ggsongnail/MyHexoBlogSource.git>>>>>>>>>>>>>>>>"
git add source
git commit -m "�������ύ����"
git push -u origin hexo
echo ">>>>>>>>>>hexo ������ʼ>>>>>>>>>>>>>>>>"
hexo d -g
pause