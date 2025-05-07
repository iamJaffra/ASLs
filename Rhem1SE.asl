// An ASL for the first game of what is probably the greatest game series ever made in Macromedia Director.

state("RHEM_I_SE") {
	int card:       "proj.dll", 0x0001588C, 0x20, 0x0, 0x28, 0x0, 0x70;
	string20 stack: "proj.dll", 0x0001588C, 0x20, 0x7D;
	// I'm calling these variables "card" and "stack" in analogy to Riven.
	// Unlike Riven, however, where the stack variable is just an integer, 
	// the stacks in Rhem are actual Macromedia Director .DXR files,
	// which contain all the images and movies of the game.
	// Each of the various areas of Rhem is stored in its own separate .DXR file;
	// When moving from one area to another, there is a brief but very noticeable 
	// period of time during which the player has to wait for Windows to load the 
	// new .DRX file and during which the Windows "loading cursor" appears.
	// We don't count those loads as game time.
}

startup {
	settings.Add("options", true, "Options");
		settings.Add("resetNewGame", true, "Reset on selecting New Game", "options");

	settings.Add("splits", true, "Splits");
		settings.Add("reachCutscene", true, "Reach Kales cutscene", "splits");
		settings.Add("finishCutscene", true, "Finish watching Kales cutscene", "splits");
		settings.Add("activateWater", true, "Activate water in pumping station", "splits");
		settings.Add("medallion", true, "( Medallion% splits )", "splits");
			settings.Add("enterBonusArea", true, "Enter SE Bonus Area", "medallion");
			settings.Add("leaveBonusArea", true, "Leave SE Bonus Area", "medallion");
		settings.Add("blockPipe", true, "Turn wheel to block water pipe", "splits");
		settings.Add("reservoirFragment", true, "Collect Reservoir Fragment", "splits");
		settings.Add("iconDoor", true, "Unlock Icon Door near rotating bridge", "splits");
		settings.Add("radioFragment", true, "Collect Radio Fragment", "splits");
		settings.Add("pentagonFragment", true, "Collect Pentagon Fragment", "splits");
		settings.Add("stoneBarnFragment", true, "Collect Stone Barn Fragment", "splits");
		settings.Add("leaveRhem", true, "Leave Rhem", "splits");
}

start {
	// Start new game on first movement
	if (current.stack == "FILMA01.dxr" && old.card == 5 && (current.card == 4 || current.card == 2)) {
		print("Started run on first movement.");
		return true;
	}
}

reset {
	// Reset on selecting New Game
	if (settings["resetNewGame"] && old.stack == "MAIN.dxr" && current.stack == "INTR.dxr") {
		return true;
	}
}

split {
	if (old.card != current.card) {
		if(settings["reachCutscene"] && current.stack == "FILMB01.dxr" && (old.card == 197 || old.card == 188) && current.card == 192) {
			print("Split: Reached Kales cutscene");
			return true;
		}
		else if(settings["finishCutscene"] && current.stack == "FILMB01.dxr" && old.card == 3211 && current.card == 3212) {
			print("Split: Finished watching cutscene");
			return true;
		}
		else if(settings["activateWater"] && current.stack == "FILME01.dxr" && old.card == 78 && current.card == 80) {
			print("Split: Turned on water in pumping room");
			return true;
		}
		else if(settings["enterBonusArea"] && current.stack == "FILMR01.dxr" && old.card == 3 && current.card == 5){
			print("Split: Entering SE Bonus Area");
			return true;
		}
		else if(settings["leaveBonusArea"] && current.stack == "FILMR01.dxr" && old.card == 54 && current.card == 55){
			print("Split: Leaving SE Bonus Area");
			return true;
		}
		else if(settings["blockPipe"] && current.stack == "FILML01.dxr" && old.card == 128 && current.card == 132){
			print("Split: Turned wheel to block water");
			return true;
		}
		else if(settings["reservoirFragment"] && current.stack == "FILMK01.dxr" && old.card == 618 && current.card == 641){
			print("Split: Collected Reservoir Fragment");
			return true;
		}
		else if(settings["iconDoor"] && current.stack == "FILMM01.dxr" && old.card == 232 && current.card == 243){
			print("Split: Unlocked Icon Door");
			return true;
		}
		else if(settings["radioFragment"] && current.stack == "FILMF01.dxr"  && old.card == 750 && current.card == 751){
			print("Split: Collected Radio Fragment");
			return true;
		}
		else if(settings["pentagonFragment"] && current.stack == "FILMN01.dxr" && old.card == 117 && current.card == 118){ 	
			print("Split: Collected Pentagon Fragment");
			return true;
		}
		else if(settings["stoneBarnFragment"] && current.stack == "FILMC01.dxr" && old.card == 270 && current.card == 272){
			print("Split: Collected Barn Fragment");
			return true;
		}
		else if(settings["leaveRhem"] && current.stack == "FILMC01.dxr" && old.card == 334 && current.card == 335){
			print("Split: Leaving Rhem");
			return true;
		}
	}
}

isLoading {
	// Waiting for the .DXR file to load...
	return (IntPtr)current.card == IntPtr.Zero;
}