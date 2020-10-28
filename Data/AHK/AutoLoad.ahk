#Escapechar \
#CommentFlag //

// Use the great JSON lib from lordkrandel (licensed as BSD) from https://autohotkey.com/board/topic/61328-lib-json-ahk-l-json-object/

#include %A_ScriptDir%/json.ahk

// Expect the name of the save to be given as command line argument.
// If no name given, just load latest save.


// ===== Some global configuration =====

// The log file
logFileName := "AutoLoad.log"

// Set a key delay so that Skyrim does not miss some keystrokes
SetKeyDelay, 0, 100

// File that is read by our scripts in Skyrim to change the loaded game status.
// Its base name has to match what is defined in AutoLoad_StartQuestScript.psc.
// Its directory name is defined by the JsonUtil script of PapyrusUtil.
jsonFile := A_ScriptDir . "\\..\\SKSE\\Plugins\\StorageUtilData\\AutoLoad_Status.json"

// The executable name of the game
gameExe := "SkyrimSE.exe"

// The name of the save to be loaded
if (%0% > 0) {
  saveName = %1%
} else {
  saveName := "<Latest save>"
}

// The wait time (in milliseconds) before each attempt to auto-load the save
loadSaveWaitTime := 5000


// ===== Utility functions =====

// Log a message in the log file
//
// Parameters:
// * Msg: The message to log
Log(Msg)
{
  LogFile.write("[ " . A_YYYY . "-" . A_MM . "-" . A_DD . " " . A_Hour . ":" . A_Min . ":" . A_Sec . " ] - " . Msg . "\r")
  // Flush the log file so that we can follow it in real time
  LogFile.__Handle
}

// Get a JSON object from a file.
// Sets ErrorLevel to 1 in case of error.
//
// Parameters:
// * FileName: The file name
// Result:
// * Object: The JSON content
ReadJsonFrom(FileName)
{
  FileRead, jsonString, %FileName%
  if ErrorLevel {
    Log("Error reading file " . FileName)
    ErrorLevel := 1
    return
  }
  return JSON_from(jsonString)
}


// ===== The main script =====

global LogFile := FileOpen(logFileName, "a")
Log("AutoLoad script start: load game " . saveName)

json := ReadJsonFrom(jsonFile)
if (ErrorLevel == 0) {
  // Set the game status to its initial value
  json["string", "game_status"] := "Waiting"
  JSON_save(json, jsonFile)
  Log("Wait for " . gameExe . " to be active...")
  WinWait, ahk_exe %gameExe%
  if (ErrorLevel == 0) {
    // The game has started
    // Add a few seconds sleep before activating the window as otherwise the ENB menu might trigger upon WinActivate if an ENB is installed.
    sleep, 10000
    WinActivate, ahk_exe %gameExe%
    Log(gameExe . " active.")

    // Loop to wait for the save game to be loaded
    Loop {
      Sleep, %loadSaveWaitTime%
      // Before trying, check that the game is not loaded
      json := ReadJsonFrom(jsonFile)
      if (ErrorLevel == 0) {
        status := json["string", "game_status"]
        if (status == "Loaded") {
          Log("Save game loaded successfully")
          Break
        } else {
          Log("Status is " . status . ". Send command to load " . saveName . "...")
          // Wait for the game window to be active, just in case the user Alt+Tabbed it
          WinWaitActive, ahk_exe %gameExe%
          if (%0% > 0) {
            Send, ~{Enter}load %saveName%{Enter}
          } else {
            Send, {Enter}
            Sleep, 1000
            Send, {Enter}
          }
        }
      } else {
        // For whatever reason we can't access the JSON file anymore
        Log("JSON file has become unreachable. Cancel the operation.")
        Break
      }
    }

  }
}

Log("AutoLoad script end with ErrorLevel " . ErrorLevel)
LogFile.close()

Exit, %ErrorLevel%
