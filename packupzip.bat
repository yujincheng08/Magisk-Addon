@echo off
title Magisk Module Quick packing (by Howard)
For /f "tokens=1-2 delims==" %%i in (module.prop) do (
If /i "%%i"=="name" set name=%%j
If /i "%%i"=="versionCode" set versionCode=%%j
)
set filename=%name%-%versionCode%.zip
IF EXIST "%filename%" DEL /Q /S "%filename%"
7z a "%filename%" META-INF/** system/** common/** mods/** *.prop *.sh *.md *.rule LICENSE
pause
