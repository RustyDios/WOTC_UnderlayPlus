You created an XCOM 2 Mod Project!

WooHoo yet another one done!

===============================
--- Steam Desc ---	https://steamcommunity.com/sharedfiles/filedetails/?id=1935171063
===============================
This mod exposes the Purifier Autopsy '[b]Reinforced Underlay Breakthrough[/b]' to the whims of config.

The breakthrough really doesn't do much and is generally like every other breakthrough, fire and forget. However weapon breakthrough's at least show the bonuses in the shot HUD wings, the Underlay Breakthrough has no further reminders that you've done it.

This mod aims to correct that by giving you a Passive Icon during tactical that reminds you if a unit has an item granting the breakthrough. It can also sweep every 'defense' item in your game that the breakthrough applies to and adds an icon to the Armoury load out.

The default game has this breakthrough set to give a useless +1 HP. I have changed this in the config files to instead give a +1 Ablative/Shield HP. It's neat that it applies to [i]every[/i] 'defense' item. 
The config however has options for you to make this breakthrough give whatever you want from the following options;

[h1] Config Options [/h1]
[list]
[*]Health
[*]Aim
[*]Mobility
[*]Will
[*]Dodge
[*]Defense
[*]Hack
[*]Psionic Offense
[*]Crit Chance
[*]Flanking Crit Chance
[*]Flanking Aim
[*]Sight Radius
[*]Armour Pips
[*]Ablative / Shields
[*]Icons On/Off
[/list]

[h1] Known Issues [/h1]
The mod negates this entry in XComGameCore;
[XComGame.X2Ability_XPackAbilitySet]
PURIFIER_AUTOPSY_VEST_HEALTH_BONUS=1.0

[h1] Compatibility [/h1]
Should be safe to add mid-campaign, strategy save. Maybe not mid-tactical.

The mod likely pairs nicely with other stat change mods for configuring 'individual' items, like;
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=1129753213] Armour and Vest Config [/url]
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2086473567] Iridars Defensive Items Overhaul [/url]

Should work with the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1300588366] RM Synthoids [/url] that adds 1 HP and 2 shield HP to all 'defense' items.
Works with the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1219412982] Useful Purifier Autopsy [/url] and [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1958853933] CX Purifier Revamp [/url]
Works with [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2307111535] Lago's Research Rework [/url]

Overrides the function run on completion of the Purifier Autopsy that gives the breakthrough bonus, doesn't break anything that I know of... bug reports welcome.

[h1] Credits And Thanks [/h1]
Mod requested by Flamngcheesepe on the XCOM2 Modders discord

Many thanks to paledbrook for help with the UIAlert Localization and 
Xymanek/Astral Descend, Iridar, Mr.Nice and generally all the helpful people on the XCOM2 Modders discord!

~ Enjoy [b]!![/b] and please [url=https://www.buymeacoffee.com/RustyDios] buy me a Cuppa Tea[/url]

=============================
List of stuff from playtesting is affected by reinforced underlay
;Base Game Vests
;	Nanoscale Vest					:: Template:  NanofiberVest
;	Plated Vest						:: Template:  PlatedVest
;	Hazmat Suit						:: Template:  HazmatVest
;	Stasis Vest						:: Template:  StasisVest
;	Hellweave						:: Template:  Hellweave
;Metal Over Flesh Items
;	Nanoweave Plate					:: Template:  Nanoweave
;	Codex Module					:: Template:  CodexModule
;CX Archons
;	Archon Vest						:: Template:  ArchonVest
;CX Valentines Viper
;	Valentines Vest					:: Template:  ValentinesVest
;Ashlynne_Lees Flame Viper
;	Flame Scale Vest				:: Template:  UtilityItem_AshFlameScaleVest
;CX Psi Ops
;	Wraith Vest						:: Template:  WraithVest
;CX Children of the King
;	Frost Scale Vest				:: Template:  FrostScaleVest
;Alien Elite Pack
;	Personal shield Vest			:: Template:  PersonalShield_Xcom
;ADVENT Drones
;	Anti stun Vest					:: Template:  DroneVest_Xcom
;Bio Division 2.0
;	Bio Nanoscale Vest				:: Template:  BioNanoScaleVest
;	Bio Viper Scale Vest			:: Template:  BioViperScaleVest
;	Advanced Bio Viper Scale Vest	:: Template:  AdvancedBioViperScaleVest
;Bitterfrost Protocol
;	Frostweave						:: Template:  MZIceVest
;Pathfinders
;	UltraLight Vest					:: Template:  XcomUltraLightVest
;Corrupt Avatar
;	Phantom Vest					:: Template:  PsiVest
;Musashi's Walker Servos (the ini setting for 'servo' will do nothing!, so these are still 'defense')
;	Walker Servos					:: Template:  WalkerServos
=============================
