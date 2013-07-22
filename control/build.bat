luac.exe -o tmp.out control.wlua
glue.exe wsrlua.exe tmp.out control.exe
del tmp.out
