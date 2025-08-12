// ASL by Jaffra

state("t7g", "GOG") {
	// The 25th anniversary edition runs on a modified version of ScummVM
	// and was given a new interface using HTML Renderer. 

	// The Groovie engine uses a byte array of size 1024 to store its gamestate variables
	// We use these to track which puzzles have been completed.
	
	// GroovieEngine.Script._variables[i]  (0x1A4 + i)
	bool cake:       0x004486D4, 0x58, 0x27A;
	bool cans:       0x004486D4, 0x58, 0x262; 
	bool grate:      0x004486D4, 0x58, 0x2A6; 
	bool coffins:    0x004486D4, 0x58, 0x24E; 
	bool queens:     0x004486D4, 0x58, 0x274; 
	bool bed:        0x004486D4, 0x58, 0x250; 
	bool spiders:    0x004486D4, 0x58, 0x287;
	byte bishops:    0x004486D4, 0x58, 0x295;
	bool telescope:  0x004486D4, 0x58, 0x266;
	bool dollroom:   0x004486D4, 0x58, 0x241;
	bool blocks:     0x004486D4, 0x58, 0x253;
	bool knights:    0x004486D4, 0x58, 0x268;
	bool heartmaze:  0x004486D4, 0x58, 0x25E;
	bool cards:      0x004486D4, 0x58, 0x23E;
	bool coins:      0x004486D4, 0x58, 0x278;
	byte chapel:     0x004486D4, 0x58, 0x297;
	bool piano:      0x004486D4, 0x58, 0x271;
	
	// The room variable only keeps track of which room the player is currently in, 
	// but not the position within that room.
	byte room: 0x004486D4, 0x58, 0x231;
	
	// We also monitor the memory address that stores the reference "id" of the current video
	// GroovieEngine.Script._videoRef
	short video: 0x004486D4, 0x58, 0x784;

	byte instruction: 0x004486D4, 0x58, 0x19B;
}

state("t7g", "Steam") {
	// GroovieEngine.Script._variables[i]  (0x1A4 + i)
	bool cake:       0x0044731C, 0x58, 0x27A;
	bool cans:       0x0044731C, 0x58, 0x262; 
	bool grate:      0x0044731C, 0x58, 0x2A6; 
	bool coffins:    0x0044731C, 0x58, 0x24E; 
	bool queens:     0x0044731C, 0x58, 0x274; 
	bool bed:        0x0044731C, 0x58, 0x250; 
	bool spiders:    0x0044731C, 0x58, 0x287;
	byte bishops:    0x0044731C, 0x58, 0x295;
	bool telescope:  0x0044731C, 0x58, 0x266;
	bool dollroom:   0x0044731C, 0x58, 0x241;
	bool blocks:     0x0044731C, 0x58, 0x253;
	bool knights:    0x0044731C, 0x58, 0x268;
	bool heartmaze:  0x0044731C, 0x58, 0x25E;
	bool cards:      0x0044731C, 0x58, 0x23E;
	bool coins:      0x0044731C, 0x58, 0x278;
	bool chapel:     0x0044731C, 0x58, 0x297;
	bool piano:      0x0044731C, 0x58, 0x271;
	
	// The room variable only keeps track of which room the player is currently in, 
	// but not the position within that room.
	byte room: 0x0044731C, 0x58, 0x231;
	
	// We also monitor the memory address that stores the reference "id" of the current video
	// GroovieEngine.Script._videoRef
	short video: 0x0044731C, 0x58, 0x784;

	byte instruction: 0x0044731C, 0x58, 0x19B;
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
	settings.Add("End", true, "Split on turning left at the mirror in the attic (Final input)");
}

init {
	string hash;

	using (var md5 = System.Security.Cryptography.MD5.Create())
	using (var fs = File.OpenRead(modules.First().FileName))
		hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

	print(hash);
	
	if (hash == "9131097EC35B25831061C8CBB84AC2AF") {
		version = "GOG";
	} 
	else if (hash == "00FA6418CE08F55B5B54296C54D98F7A") {
		version = "Steam";
	} 
	else {
		version = "Unknown";
	}

	vars.LogPuzzle = (Action<string>)((puzzle) => {
		print("[T7G ASL] Split due to completing the " + puzzle + " Puzzle.");
	});

	vars.completedSplits = new HashSet<string>();

	refreshRate = 120;
}

update {
	if (version == "Unknown") {
		return false;
	}
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
	if (settings["Cake"] && !old.cake && current.cake && vars.completedSplits.Add("Cake")) {
		vars.LogPuzzle("Cake");
		return true;
	}
	else if (settings["Cans"] && !old.cans && current.cans && vars.completedSplits.Add("Cans")) {
		vars.LogPuzzle("Cans");
		return true;
	}
	else if (settings["Grate"] && current.room == 5 && !old.grate && current.grate && vars.completedSplits.Add("Grate")) { 
		// The "grate variable" is also used for other things, so we 
		// additionally check whether the player is currently in the maze (5)
		vars.LogPuzzle("Grate");
		return true;
	}
	else if (current.room == 6 && old.room == 5 && vars.completedSplits.Add("Maze") && settings["Maze"]) {
		vars.LogPuzzle("Maze");
		return true;
	}
	else if (settings["Coffins"] && current.coffins && !old.coffins && vars.completedSplits.Add("Coffins")) {
		vars.LogPuzzle("Coffins");
		return true;
	}
	else if (settings["Queens"] && !old.queens && current.queens && vars.completedSplits.Add("Queens")) {
		vars.LogPuzzle("Queens");
		return true;
	}
	else if (settings["Bishops"] && current.bishops == 49 && old.bishops != 49 && vars.completedSplits.Add("Bishops")) {
		vars.LogPuzzle("Bishops");
		return true;
	}
	else if (settings["Bed"] && !old.bed && current.bed && vars.completedSplits.Add("Bed")) {
		vars.LogPuzzle("Martine's Bed");
		return true;
	}
	else if (settings["Spiders"] && !old.spiders && current.spiders && vars.completedSplits.Add("Spiders")) {
		vars.LogPuzzle("Spiders");
		return true;
	}
	else if (settings["Telescope"] && !old.telescope && current.telescope && vars.completedSplits.Add("Telescope")) {
		vars.LogPuzzle("Telescope");
		return true;
	}
	else if (settings["Doll Room"] && !old.dollroom && current.dollroom && vars.completedSplits.Add("Doll Room")) {
		vars.LogPuzzle("Doll Room");
		return true;
	}
	else if (settings["Spelling Blocks"] && !old.blocks && current.blocks && vars.completedSplits.Add("Spelling Blocks")) {
		vars.LogPuzzle("Spelling Blocks");
		return true;
	}
	else if (settings["Knights"] && !old.knights && current.knights && vars.completedSplits.Add("Knights")) {
		vars.LogPuzzle("Knights");
		return true;
	}
	else if (settings["Heart Maze"] && !old.heartmaze && current.heartmaze && vars.completedSplits.Add("Heart Maze")) {
		vars.LogPuzzle("Heart Maze");
		return true;
	}
	else if (settings["Cards"] && !old.cards && current.cards && vars.completedSplits.Add("Cards")) {
		vars.LogPuzzle("Cards");
		return true;
	}
	else if (settings["Coins"] && !old.coins && current.coins && vars.completedSplits.Add("Coins")) {
		vars.LogPuzzle("Coins");
		return true;
	}
	else if (settings["Chapel"] && current.chapel == 49 && old.chapel != 49 && vars.completedSplits.Add("Chapel")) {
		vars.LogPuzzle("Chapel");
		return true;
	}
	else if (settings["Microscope"] && current.room == 7 && current.video == 0x3006 && old.video == 0x50A0 && vars.completedSplits.Add("Microscope")) {
		vars.LogPuzzle("Microscope");
		return true;
	}
	else if (settings["Gallery"] && current.video == 0x4829 && old.video != 0x4829 && vars.completedSplits.Add("Gallery")) {
		vars.LogPuzzle("Gallery Portrait");
		return true;
	}
	else if (settings["Piano"] && !old.piano && current.piano && vars.completedSplits.Add("Piano")) {
		vars.LogPuzzle("Piano");
		return true;
	}
	else if (settings["Knives"] && current.room == 2 && current.video == 0x14AD && old.video != 0x14AD && vars.completedSplits.Add("Knives")) {
		vars.LogPuzzle("Knives");
		return true;
	}
	else if (settings["End"] && current.room == 1 && current.video == 0x0007 && current.instruction != 0x37 && vars.completedSplits.Add("End")) {
		print("[T7G ASL] Split on final input -- The run is over.");
		return true;
	}
}