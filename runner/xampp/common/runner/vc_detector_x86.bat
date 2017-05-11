@echo off
set "HKLMU=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Dependencies"
::::: 判断系统是否已经安装了 Visual C++ 2015 
reg query %HKLMU%\{A2563E55-3BEC-3828-8D67-E5E8B9E8B675}>nul 2>nul&&set VC2015=Microsoft Visual C++ 2015 x86 Minimum Runtime
reg query %HKLMU%\{74d0e5db-b326-4dae-a6b2-445b9de1836e}>nul 2>nul&&set VC2015=Microsoft Visual C++ 2015 Redistributable X86
if defined VC2015 (echo INSTALLED: %VC2015% &ping -n 3 127.1>nul)