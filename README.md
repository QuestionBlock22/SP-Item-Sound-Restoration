## Special Item Sound Restoration

This is a gecko code that makes the game play a different sound effect (Mario Kart DS' special item sound) if the item's ID is out of a certain range.

Mario Kart Wii was the first game in the series to excise the special item sound effect after being used for two games. This mod restores the sound effect using the sound ripped and adjusted from Mario Kart 7 and applies it to all new items (except Thundercloud) and the returning items from Mario Kart DS. 

What sets this branch apart from the mainline branch is the fact that it now uses the startInfo method discovered by Melg. This allows distribution creators to more easily modify their BRSAR files without having to worry about triggering the offset bug by setting sound IDs. The main drawback to this method is that it sacrifices file-level complexity for code complexity, so now there's an execution cost each time a UI sound effect is played, however small.

The following items are affected by this mod.

* 	Lightning/Shock
* 	Star
* 	Golden/Dash Mushroom
* 	Mega Mushroom
* 	Blooper
* 	POW Block
* 	Bullet Bill
* 	Triple Sets (except Triple Mushrooms)

If you want to change the sound or fix bugs, all expanded resources are in the following locations in "revo_kart."

	Bank Index: 688 "GRP/RACE"
	Sequence Index: 392 "GRP/RACE"

You may only use PyiiASMH to build the final code. See "BUILDING.md" for more information.


### Credits
* _Ro - "[Play different item receive sound when receiving Shock, Star & Bullet](https://mariokartwii.com/showthread.php?tid=1937)" cheat code used as a base.
* MelgMKW and Brawlboxgaming - [Pulsar](https://www.github.com/MelgMKW/Pulsar), used as a reference.
* Ghidra Project - Function names and symbols.
