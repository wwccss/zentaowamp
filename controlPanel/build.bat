luac.exe -o tmp.out controlPanel.wlua
glue.exe wsrlua.exe tmp.out controlPanel.exe
del tmp.out
