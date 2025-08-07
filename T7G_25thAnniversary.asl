// ASL by Jaffra

state("t7g") {
	// The 25th anniversary edition runs on a modified version of ScummVM
	// and was given a new interface using HTML Renderer. 

	// The Groovie engine uses a byte array of size 1024 to store its gamestate variables
	// We use these to track which puzzles have been completed.
	
	// GroovieEngine.Script._variables[i]  (0x1A4 + i)
	bool cake:       0x004486D4, 0x58, 0x27A;
	bool cans:       0x004486D4, 0x58, 0x262; 
	bool grate:      0x004486D4, 0x58, 0x2A6; 
	bool queens:     0x004486D4, 0x58, 0x274; 
	bool bed:        0x004486D4, 0x58, 0x250; 
	bool spiders:    0x004486D4, 0x58, 0x287;
	bool telescope:  0x004486D4, 0x58, 0x266;
	bool dollroom:   0x004486D4, 0x58, 0x241;
	bool blocks:     0x004486D4, 0x58, 0x253;
	bool knights:    0x004486D4, 0x58, 0x268;
	bool heartmaze:  0x004486D4, 0x58, 0x25E;
	bool cards:      0x004486D4, 0x58, 0x23E;
	bool coins:      0x004486D4, 0x58, 0x278;
	bool piano:      0x004486D4, 0x58, 0x271;
	
	// The room variable only keeps track of which room the player is currently in, 
	// but not the position within that room.
	byte room: 0x004486D4, 0x58, 0x231;
	
	// We also monitor the memory address that stores the reference "id" of the current video
	// GroovieEngine.Script._videoRef
	short video: 0x004486D4, 0x58, 0x784;
}

startup {
	settings.Add("Puzzles",             false, "Puzzle splits");
		settings.Add("Cake",            false, "Cake",            "Puzzles");
		settings.Add("Cans",            false, "Cans",            "Puzzles");
		settings.Add("Grate",           false, "Grate",           "Puzzles");
		settings.Add("Maze",            false, "Maze",            "Puzzles");
		settings.Add("Coffins",         false, "Coffins",         "Puzzles");
		settings.Add("Queens",          false, "Queens",          "Puzzles");
		settings.Add("Bishops",         false, "Bishops",         "Puzzles");
		settings.Add("Bed",             false, "Martine's Bed",   "Puzzles");
		settings.Add("Spiders",         false, "Spiders",         "Puzzles");
		settings.Add("Telescope",       false, "Telescope",       "Puzzles");
		settings.Add("Doll Room",       false, "Doll Room",       "Puzzles");
		settings.Add("Spelling Blocks", false, "Spelling Blocks", "Puzzles");
		settings.Add("Knights",         false, "Knights",         "Puzzles");
		settings.Add("Heart Maze",      false, "Heart Maze",      "Puzzles");
		settings.Add("Cards",           false, "Cards",           "Puzzles");
		settings.Add("Coins",           false, "Coins",           "Puzzles");
		settings.Add("Chapel",          false, "Chapel",          "Puzzles");
		settings.Add("Microscope",      false, "Microscope",      "Puzzles");
		settings.Add("Gallery",         false, "Gallery",         "Puzzles");
		settings.Add("Piano",           false, "Piano",           "Puzzles");
		settings.Add("Knives",          false, "Knives",          "Puzzles");
		settings.Add("Attic",           false, "Attic",           "Puzzles");
	settings.Add("End", false, "Split on turning left at the mirror in the attic (Final input)");
}

init {
	vars.LogPuzzle = (Action<string>)((puzzle) => {
		print("[T7G ASL] Split due to completing the " + puzzle + " Puzzle.");
	});

	vars.completedSplits = new HashSet<string>();
}

start {
	// Time starts on first movement, i.e. on one of these transitions:
	if (current.video == 0x1422 // turn left
	 || current.video == 0x1401 // to left door
	 || current.video == 0x1403 // up the stairs
	 || current.video == 0x1402 // right door
	 || current.video == 0x1427 // turn right 
	) {
		return old.video == 0x0000;
	}
}

onStart {
	vars.completedSplits.Clear();
}


reset {
	return current.video == 0x1C02 && old.video != 0x1C02;
}

split {
	if (settings["Cake"] && !old.cake && current.cake) {
		vars.LogPuzzle("Cake");
		return vars.completedSplits.Add("Cake");
	}
	else if (settings["Cans"] && !old.cans && current.cans) {
		vars.LogPuzzle("Cans");
		return vars.completedSplits.Add("Cans");
	}
	else if (settings["Grate"] && current.room == 5 && !old.grate && current.grate) { 
		// The "grate variable" is also used for other things, so we 
		// additionally check whether the player is currently in the maze (5)
		vars.LogPuzzle("Grate");
		return vars.completedSplits.Add("Grate");
	}
	else if (settings["Maze"] && current.video == 0x5039 && old.video != 0x5039) {
		vars.LogPuzzle("Maze");
		return vars.completedSplits.Add("Maze");
	}
	else if (settings["Coffins"] && current.video == 0x3C6C && old.video != 0x3C6C) {
		vars.LogPuzzle("Coffins");
		return vars.completedSplits.Add("Coffins");
	}
	else if (settings["Queens"] && !old.queens && current.queens) {
		vars.LogPuzzle("Queens");
		return vars.completedSplits.Add("Queens");
	}
	else if (settings["Bishops"] && current.video == 0x2885 && old.video != 0x2885) {
		vars.LogPuzzle("Bishops");
		return vars.completedSplits.Add("Bishops");
	}
	else if (settings["Bed"] && !old.bed && current.bed) {
		vars.LogPuzzle("Martine's Bed");
		return vars.completedSplits.Add("Bed");
	}
	else if (settings["Spiders"] && !old.spiders && current.spiders) {
		vars.LogPuzzle("Spiders");
		return vars.completedSplits.Add("Spiders");
	}
	else if (settings["Telescope"] && !old.telescope && current.telescope) {
		vars.LogPuzzle("Telescope");
		return vars.completedSplits.Add("Telescope");
	}
	else if (settings["Doll Room"] && !old.dollroom && current.dollroom) {
		vars.LogPuzzle("Doll Room");
		return vars.completedSplits.Add("Doll Room");
	}
	else if (settings["Spelling Blocks"] && !old.blocks && current.blocks) {
		vars.LogPuzzle("Spelling Blocks");
		return vars.completedSplits.Add("Spelling Blocks");
	}
	else if (settings["Knights"] && !old.knights && current.knights) {
		vars.LogPuzzle("Knights");
		return vars.completedSplits.Add("Knights");
	}
	else if (settings["Heart Maze"] && !old.heartmaze && current.heartmaze) {
		vars.LogPuzzle("Heart Maze");
		return vars.completedSplits.Add("Heart Maze");
	}
	else if (settings["Cards"] && !old.cards && current.cards) {
		vars.LogPuzzle("Cards");
		return vars.completedSplits.Add("Cards");
	}
	else if (settings["Coins"] && !old.coins && current.coins) {
		vars.LogPuzzle("Coins");
		return vars.completedSplits.Add("Coins");
	}
	else if (settings["Chapel"] && current.video == 0x0811 && old.video != 0x0811) {
		vars.LogPuzzle("Chapel");
		return vars.completedSplits.Add("Chapel");
	}
	else if (settings["Microscope"] && current.room == 7 && current.video == 0x3006 && old.video == 0x50A0) {
		vars.LogPuzzle("Microscope");
		return vars.completedSplits.Add("Microscope");
	}
	else if (settings["Gallery"] && current.video == 0x4829 && old.video != 0x4829) {
		vars.LogPuzzle("Gallery Portrait");
		return vars.completedSplits.Add("Gallery");
	}
	else if (settings["Piano"] && !old.piano && current.piano) {
		vars.LogPuzzle("Piano");
		return vars.completedSplits.Add("Piano");
	}
	else if (settings["Knives"] && current.video == 0x14AD && old.video != 0x14AD) {
		vars.LogPuzzle("Knives");
		return vars.completedSplits.Add("Knives");
	}
	else if (settings["Attic"] && current.room == 1 && current.video == 0x50A0 && old.video != 0x50A0) {
		vars.LogPuzzle("Attic");
		return vars.completedSplits.Add("Attic");
	}
	else if (settings["End"] && current.room == 1 && current.video == 0x0007 && old.video != 0x0007) {
		// The final input has occured; the run is over.
		return true;
	}
}