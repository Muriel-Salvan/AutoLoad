@echo off

REM Set default values
IF NOT DEFINED gameDir (
  set "gameDir=C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition"
)
IF NOT DEFINED gameExe (
  set gameExe=skse64_loader.exe
)
IF NOT DEFINED autoHotkeyCmd (
  set "autoHotkeyCmd=C:\Program Files\AutoHotkey\AutoHotkey.exe"
)

REM Run AHK in parallel, waiting for the game to load the saved game
START /B "%autoHotkeyCmd%" "%gameDir%\Data\AHK\AutoLoad.ahk" %1
REM Run the game
cd "%gameDir%"
"%gameExe%"
