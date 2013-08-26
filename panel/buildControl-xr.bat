cd control\control
start .\build-xr.bat
start .\delete.bat
del delete.bat
cd ../../
7z a control-xr.7z  control & copy /b E:\installedSoft\7z\7z.sfx + control.txt + control-xr.7z control-xr.exe 
del control-xr.7z 
