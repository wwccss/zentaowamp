@echo off
set "HKLMU=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
::::: 判断系统是否已经安装了 Visual C++ 2008 （包括所有版本）       bbs.bathome.net By：FastSLZ
::::: 代码能实现判断X86、X64、IA64各版本的Visual C++ 2008，正确率99%除非微软发布新版本Visual C++ 2008
::::: 有就跳过安装Visual C++ 2008，没有则先安装。
reg query %HKLMU%\{FF66E9F6-83E7-3A3E-AF14-8DE9A809A6A4}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 Redistributable X86
reg query %HKLMU%\{9A25302D-30C0-39D9-BD6F-21E6EC160475}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 SP1 Redistributable X86
reg query %HKLMU%\{1F1C2DFC-2D24-3E06-BCB8-725134ADF989}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 SP1 Redistributable ATL Security Update X86
reg query %HKLMU%\{350AA351-21FA-3270-8B7A-835434E766AD}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 Redistributable X64
reg query %HKLMU%\{8220EEFE-38CD-377E-8595-13398D740ACE}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 SP1 Redistributable X64
reg query %HKLMU%\{4B6C7001-C7D6-3710-913E-5BC23FCE91E6}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 SP1 Redistributable ATL Security Update X64
reg query %HKLMU%\{2B547B43-DB50-3139-9EBE-37D419E0F5FA}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 Redistributable IA64
reg query %HKLMU%\{5827ECE1-AEB0-328E-B813-6FC68622C1F9}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 SP1 Redistributable IA64
reg query %HKLMU%\{977AD349-C2A8-39DD-9273-285C08987C7B}>nul 2>nul&&set VC2008=Microsoft Visual C++ 2008 SP1 Redistributable ATL Security Update IA64
if defined VC2008 (echo INSTALLED: %VC2008% &ping -n 3 127.1>nul) else (goto 2008Install)