copy /y ".\config\config.lua" ".\config.lua"
copy /y ".\lang\zh-cn.lua" ".\zh-cn.lua"
copy /y ".\lang\en.lua" ".\en.lua"
luac.exe -o tmp.out control.wlua
glue.exe wsrlua.exe tmp.out control.exe
del tmp.out
