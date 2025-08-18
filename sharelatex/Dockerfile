# 使用最新版本的sharelatex基础镜像
FROM sharelatex/sharelatex:latest

# 配置TeX Live镜像源为国内镜像，更新tlmgr并安装完整方案
RUN tlmgr option repository https://mirrors.cernet.edu.cn/CTAN/systems/texlive/tlnet && \
    tlmgr update --self && \
    tlmgr install scheme-full && \
    tlmgr path add
