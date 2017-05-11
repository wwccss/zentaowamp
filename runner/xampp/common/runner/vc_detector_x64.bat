@echo off
set "HKLMU=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies"
::::: 判断系统是否已经安装了 Visual C++ 2015 
reg query %HKLMU%\{BC958BD2-5DAC-3862-BB1A-C1BE0790438D}>nul 2>nul&&set VC2015=Microsoft Visual C++ 2015 x64 Additional Runtime
reg query %HKLMU%\{0D3E9E15-DE7A-300B-96F1-B4AF12B96488}>nul 2>nul&&set VC2015=Microsoft Visual C++ 2015 x64 Minimum Runtime
reg query %HKLMU%\{e46eca4f-393b-40df-9f49-076faf788d83}>nul 2>nul&&set VC2015=Microsoft Visual C++ 2015 Redistributable (x64)
if defined VC2015 (echo INSTALLED: %VC2015% &ping -n 3 127.1>nul)