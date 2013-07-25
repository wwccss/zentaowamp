cd control\control
start .\build.bat
start .\delete.bat
cd ../../
7z a control.7z  control & copy /b E:\installedSoft\7z\7z.sfx + control.txt + control.7z control.exe 
del control.7z
