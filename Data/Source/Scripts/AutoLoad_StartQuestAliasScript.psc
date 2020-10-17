ScriptName AutoLoad_StartQuestAliasScript extends ReferenceAlias
{
  ReferenceAlias Script that will trigger once per loaded game the LoadEventAction.
  This script is meant to be attached to a ReferenceAlias on Player that is defined for the same quest that uses AutoLoad_StartQuestScript, and with its property bound to the quest itself.
  Dependencies:
  * None.
}

AutoLoad_StartQuestScript Property QuestScript Auto

Event OnPlayerLoadGame()
  QuestScript.LoadEventAction()
EndEvent
