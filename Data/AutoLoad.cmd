@echo off
set gameDir=C:/Program Files (x86)/Steam/steamapps/common/Skyrim Special Edition
set gameExe=skse64_loader.exe
set autoHotkeyCmd=C:\Program Files\AutoHotkey\AutoHotkey.exe

REM Run AHK in parallel, waiting for the game to load the saved game
START /B "%autoHotkeyCmd%" "%gameDir%\Data\AHK\AutoLoad.ahk" %1
REM Run the game
cd "%gameDir%"
"%gameExe%"
