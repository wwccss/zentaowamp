copy /y ".\config\config-zt.lua" ".\config.lua"
copy /y ".\lang\zh-cn-zt.lua" ".\zh-cn.lua"
copy /y ".\lang\en-zt.lua" ".\en.lua"
luac.exe -o tmp.out control.wlua
glue.exe wsrlua.exe tmp.out control.exe
del tmp.out
