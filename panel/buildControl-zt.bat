cd control\control
start .\build-zt.bat
start .\delete.bat
cd ../../
7z a control-zt.7z  control & copy /b E:\installedSoft\7z\7z.sfx + control.txt + control-zt.7z control-zt.exe 
del control-zt.7z 
