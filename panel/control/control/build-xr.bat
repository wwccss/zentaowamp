copy /y ".\config\config-xr.lua" ".\config.lua"
copy /y ".\lang\zh-cn-xr.lua" ".\zh-cn.lua"
copy /y ".\lang\en-xr.lua" ".\en.lua"
luac.exe -o tmp.out control.wlua
glue.exe wsrlua.exe tmp.out control.exe
del tmp.out
