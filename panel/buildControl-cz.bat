cd control\control
start .\build-cz.bat
start .\delete.bat
cd ../../
7z a control-cz.7z  control & copy /b E:\installedSoft\7z\7z.sfx + control.txt + control-cz.7z control-cz.exe 
del control-cz.7z 
