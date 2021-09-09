call conda deactivate
call conda env remove --name PrintVsDigital
call conda create --yes --name PrintVsDigital python=3.7 beautifulsoup4 pandas matplotlib
call conda activate PrintVsDigital
call conda env export --name PrintVsDigital > PrintVsDigital.yml