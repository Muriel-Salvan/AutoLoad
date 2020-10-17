# AutoLoad

Windows command file that *automatically loads saved games upon game launch* in Bethesda games.

* You want to create shortcuts on your dekstop to launch some saves automatically, without getting through the initial game load menu?
* You want to automatically re-launch the game with your latest save after a CTD?
* You want to perform automated tasks on your game, and need to make sure the game can start, load a game, and run without human intervention?

If you answered yes to at least 1 of those questions, then AutoLoader is for you.

The list of games that are eligible to this tool (non-exhaustive list):
* Skyrim Special Edition - Tested successfully.
* Skyrim - Not tested yet - Feedback welcome!
* Fallout 4 - Not tested yet - Feedback welcome!

Unfortunately there is no easy way to perform such a simple task. Therefore this solution has been developed.

## Requirements

2 tools and 1 mod are needed for AutoLoad to work:
* [AutoHotKey](https://www.autohotkey.com/) (aka AHK) - You have to install it on your Windows system. This is needed to batch key strokes to the game to load a saved game.
* [SKSE](https://skse.silverlock.org/) - You have to install on your Bethesda game. This is needed for the PapyrusUtil requirement.
* [PapyrusUtil](https://www.nexusmods.com/skyrimspecialedition/mods/13048) - You have to get this mod installed in your Bethesda game. This is needed to save load game statuses in JSON files.

## Installation

AutoLoad packages are downloadable from [Nexus Mods](https://www.nexusmods.com/skyrimspecialedition/mods/41478).

Once requirements are installed, you can use AutoLoad either by copying its package content to your Bethesda game's Data folder, or by using its packaged content with a mod manager like [ModOrganizer](https://www.nexusmods.com/skyrimspecialedition/mods/6194).

## Usage

Once installed, you can use the `AutoLoad.cmd` Windows command file to execute your game and automatically load a saved game, given as an argument to the command file.

Example, to load the save named `my_save`
```bat
AutoLoad.cmd my_save
```

Save names can be found in your game's saves directory (for standard Skyrim SE installation, look into `~\Documents\My Games\Skyrim Special Edition\Saves`).
You can create easily a new save with the name you want in-game using the console (`~` key) and using the `save` command.

Example, to create a save named `my_save` from the game console:
```
save my_save
```

## Configuration

By default AutoLoad is configured to work with Skyrim SE installed using steam in default installation paths, and laucnhed using SKSE.

If you want to adapt it for other games or installation setups, you'll need to change 2 things:
* The name of your game's exe file, in `AHK/AutoLoad.ahk`: look for the line `gameExe := "SkyrimSE.exe"` and change `SkyrimSE.exe` to the corresponding executable file name that is executing the game (it's not the launcher executable: even if you use `skse_loader.exe` to launch your game, the game executable that runs is still `SkyrimSE.exe`).
* The paths to the game and AHK, as well as the launcher in `AutoLoad.cmd`: look for the following variables and adapt them to your liking:
  * `gameDir`: Directory where your game is installed (path to the directory containing the `Data` folder).
  * `gameExe`: Name of the launcher executed to run the game (can be `skse_loader.exe` if using SKSE).
  * `autoHotkeyCmd`: Full AHK command line with path.

## Compatibility

This mode is compatible with all mods without conflict.

## How does it work?

The solution design is a bit tricky given the simplicity of the requirement it addresses, but Bethesda launchers don't have ways to perform such a simple task.
Therefore the solution uses AHK to simulate key strokes while in game: it invokes the console and types in `load <save_name>`, which loads the save in-game.
However 2 issues arise:
* AHK has no way to know when the game is ready to accept such commands. Therefore it will try repeatedly to send the key strokes to load the game until the game is loaded.
* AHK has no way to know if the command was executed and the saved game has been loaded. Therefore AHK will communicate with the game engine using a JSON file (`Data\SKSE\Plugins\StorageUtilData\AutoLoad_Status.json`): as soon as the game is loaded, a Papyrus script will update the content of this file, so that AHK knows the game has been loaded and that it should stop sending key strokes to load the game. Hence the addtional Papyrus scripts present in this mod, and the `AutoLoad.esp` file that will just register those scripts so that they trigger on each saved game being loaded.

Here is a sequence diagram of an example of the events involved between AHK and the game to load automatically a saved game from `AutoLoad.cmd`.
![Sequence diagram](https://raw.githubusercontent.com/Muriel-Salvan/AutoLoad/master/docs/sequence.png)

## Troubleshooting

When run, the AHK script dump logs in a file named `AHK\AutoLoad.log`.
The Papyrus script does not log anything on disk except the status in the JSON file `Data\SKSE\Plugins\StorageUtilData\AutoLoad_Status.json`. It will change the status `Waiting` into `Loaded`. It will notify the player in-game with a small notification on the upper-left corner of the screen, that reads `Game auto-loaded successfully`.

The AHK script can also be run without using `AutoLoad.cmd`, given that the saved game name is given as an argument to it. In this case it runs in the background (with a small icon in the notification area), and waits for the game to starts. It is then possible to run the game later.

The `AHK\AutoLoad.ahk` and `AutoLoad.cmd` can be modified to your liking, and modifications are taken into account immediately. However the Papyrus scripts need recompilation upon modification.

## Contributions

Don't hesitate to fork the [Github repository](https://github.com/Muriel-Salvan/AutoLoad) and contribute with Pull Requests.
