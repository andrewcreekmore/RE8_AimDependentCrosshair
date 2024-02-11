# RE8 Aim-Dependent Crosshair
REFramework script for Resident Evil Village.  
Prevents the crosshair reticle from being drawn unless configurable conditions are met.  
First and Third-Person perspective supported.  
Main campaign and Shadows of Rose DLC supported.

## Usage
The following options are available (in/out of combat, or both):
 - disable crosshair whenever not aiming (mod default out of combat)
 - disable crosshair only when sprinting (mod default in combat)
   
Options are configurable from the REFramework script-generated UI.  

Note that mantling over obstacles disables the crosshair until the player aims. This behavior is present in the vanilla game and is not affected by this mod.

## Installation
- download [REFramework](https://github.com/praydog/REFramework/releases) for RE8
- extract the REFramework `RE8.zip` to your local game directory (where RE8.exe is located). if using Steam, this can be found by right-clicking the game in your library and selecting "Manage"->"Browse local files"
- download `RE8_AimDependentCrosshair.zip` from [releases](https://github.com/andrewcreekmore/RE8_AimDependentCrosshair/releases)
- install mod manually <strong> OR </strong> using [FluffyModManager](https://www.nexusmods.com/residentevilvillage/mods/18)

#### Manual Install:
- extract <strong>only</strong> the script file, `RE8_AimDependentCrosshair.lua`, and place it into your game directory's new `reframework/autorun` folder

#### Using FluffyModManager:
- place the entire .zip file into `ModManager/Games/RE8/Mods`
- toggle on/off Aim-Dependent Crosshair from the mod manager's GUI menu

## Acknowledgements
- praydog for both REFramework and assistance
