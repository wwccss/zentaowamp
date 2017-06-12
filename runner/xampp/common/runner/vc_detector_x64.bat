@echo off
set "HKLMU=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies"
::::: 判断系统是否已经安装了 Visual C++ 2015 
reg query %HKLMU%\{BC958BD2-5DAC-3862-BB1A-C1BE0790438D}>nul 2>nul&&set VC=Microsoft Visual C++ 2015 x64 Additional Runtime
reg query %HKLMU%\{0D3E9E15-DE7A-300B-96F1-B4AF12B96488}>nul 2>nul&&set VC=Microsoft Visual C++ 2015 x64 Minimum Runtime
reg query %HKLMU%\{e46eca4f-393b-40df-9f49-076faf788d83}>nul 2>nul&&set VC=Microsoft Visual C++ 2015 Redistributable x64
reg query %HKLMU%\{f1e7e313-06df-4c56-96a9-99fdfd149c51}>nul 2>nul&&set VC=Microsoft Visual C++ 2017 Redistributable x64
reg query "%HKLMU%\,,amd64,14.0,bundle">nul 2>nul&&set VC=Microsoft Visual C++ 2017 Redistributable x64
if defined VC (echo INSTALLED: %VC%)
