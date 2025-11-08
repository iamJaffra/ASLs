// Credits:
// Original ASL by Gelly
// Ported to ScummVM-Help by Jaffra in order to make it work on all versions of ScummVM
// (also added reset{})

state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("Mohawk_Myst");

	settings.Add("pages", true, "Split on handing in all non-library pages.");
		settings.Add("libpages", false, "Include library pages.", "pages");
	
	settings.Add("any", false, "Any% splits");
		settings.Add("fireplace", false, "Split on closing of the fireplace.", "any");
		settings.Add("clockbridge", false, "Split on raising of the clocktower bridge.", "any");
		settings.Add("switches", false, "Split on every marker switch being flipped.", "any");
	
	settings.Add("link", true, "Split when linking to another Age.");
		settings.Add("firstLink", true, "...but only the very first.", "link");
		settings.Add("returnToMyst", false, "...but only when linking back to Myst Island.", "link");
}

init {
	vars.ScummVM.Init();

	vars.ScummVM["cardID"] = vars.ScummVM.Version == "2.0.0"
		? vars.ScummVM.Watch<ushort>("_curCard")
		: vars.ScummVM.Watch<ushort>("_card", "_pointer", "_id");
	
	vars.ScummVM["age"] = vars.ScummVM.Version == "2.0.0"
		? vars.ScummVM.Watch<ushort>("_curStack")
		: vars.ScummVM.Watch<ushort>("_stack", "_pointer", "_stackId");

	vars.ScummVM["heldPage"] = vars.ScummVM.Watch<int>("_gamestate", "_globals", 0x8);
	vars.ScummVM["clockBridge"] = vars.ScummVM.Watch<int>("_gamestate", "_myst", 0x2C);
	vars.ScummVM["markerSwitches"] = vars.ScummVM.WatchBytes(32, "_gamestate", "_myst", 0x0);
	vars.ScummVM["sfxID"] = vars.ScummVM.Watch<ushort>("_sound", "_effectId");

	// Flags
	vars.firstLink = 0;
	vars.enteredFireplace = 0;
	vars.markerSwitchManager = 0;
}

update {
	vars.ScummVM.Update();
}

split {
	if (settings["pages"]) {
		// Held page changed on Myst Island, didn't drop white page
		if (current.age == 2 && old.heldPage != 0 && old.heldPage != 13 && current.heldPage == 0) {
			// Skip the library pages if user doesn't want to split for them
			if (settings["libpages"] || (old.heldPage != 1 && old.heldPage != 7)) {
				return true;
			}
		}
	}
	
	if (settings["link"]) {
		// Age transition, excluding menu; we only check transitions *to* K'veer since runs will always end there
		if (old.age != current.age && old.age <= 4 && current.age <= 6 && current.age != 5) {
			if (vars.firstLink == 0 && (!settings["returnToMyst"] || current.age == 2)) {
				if (settings["firstLink"]) vars.firstLink = 1;
				return true;
			}
		}
	}
	
	if (settings["any"]) {
		if (settings["fireplace"] && current.age == 2 && old.cardID != 4162 && current.cardID == 4162 && vars.enteredFireplace == 0) {
			vars.enteredFireplace = 1;
			return true;
		}	
	
		if (settings["clockbridge"] && old.clockBridge == 0 && current.clockBridge == 1) {
			return true;
		}
	
		if (settings["switches"]) {
			// this is the only time i've managed to be sorta clever
			// marker switch flip state is stored in an int
			for (int i = 0; i < 8; i++) {
				if (((vars.markerSwitchManager & (1 << i)) == 0) && current.markerSwitches[4 * i] == 1) {
					vars.markerSwitchManager |= (1 << i);
					return true;
				}	
			}
		}
	}
		
	// Always split upon handing in white page in K'veer
	if (old.heldPage == 13 && current.heldPage == 0 && current.age == 6) {
		return true;
	}
}

start {
	if (current.cardID == 5 && old.sfxID == 0 && current.sfxID == 5) {
		vars.firstLink = 0;
		vars.enteredFireplace = 0;
		vars.markerSwitchManager = 0;
		return true;
	}
}

reset {
	// Reset on clicking New Game
	return old.age == 12 && current.age == 4 &&
	       old.cardID == 1000 && current.cardID == 1;
}
