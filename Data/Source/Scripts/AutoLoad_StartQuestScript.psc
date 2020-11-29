ScriptName AutoLoad_StartQuestScript extends Quest
{
  Quest Script that will trigger once for all the LoadEventAction.
  This script is meant to be attached to a quest that starts on boot.
  Dependencies:
  * PapyrusUtils for JsonUtil (https://www.nexusmods.com/skyrimspecialedition/mods/13048)
}

; Callback triggered only once when the quest is starting for the first time
Event OnInit()
  LoadEventAction()
EndEvent

; Mark the game as being loaded in the JSON file
Function LoadEventAction()
  ; Make sure we are part of an auto-load mechanism, otherwise do nothing
  if JsonUtil.GetStringValue("AutoLoad_Status.json", "game_status") == "Waiting"
    ; Just be aware that the value written will have its first letter converted as upper-case.
    JsonUtil.SetStringValue("AutoLoad_Status.json", "game_status", "Loaded")
    JsonUtil.Save("AutoLoad_Status.json")
    Debug.Notification("$GameAutoLoadedSuccessfully")
  endIf
EndFunction
