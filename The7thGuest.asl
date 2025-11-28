state("scummvm") {}
state("t7g") {}
// The 25th Anniversary Edition (t7g.exe) is actually a custom ScummVM in a trenchcoat,
// or rather, ScummVM wrapped in HTML Renderer. Thanks to the library, the below code 
// is able to handle both the normal ("Legacy") versions and the 25th Anniversary Edition.

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("Groovie");
	
	vars.ScummVM.LogChangedWatchers();
	vars.ScummVM.LogResolvedPaths();

	vars.Puzzles = new Dictionary<string, int> {
		// Name,             Index
		{ "Cake",             0xFA },
		{ "Cans",             0xF9 },
		{ "Grate",            0xF8 },
		{ "Maze",               -1 },
		{ "Coffins",          0xF4 },
		{ "Queens",           0xF0 },
		{ "Bishops",          0xF1 },
		{ "Bed",              0xEF },
		{ "Spiders",          0xFB },
		{ "Telescope",        0xF5 },
		{ "Doll_Room",        0xEE },
		{ "Spelling_Blocks",  0xF7 },
		{ "Knights",          0xEC },
		{ "Heart_Maze",       0xE8 },
		{ "Cards",            0xEA },
		{ "Coins",            0xE9 },
		{ "Chapel",           0xF3 },
		{ "Microscope",       0xEB },
		{ "Gallery_Portrait", 0xED },
		{ "Piano",            0xF6 },
		{ "Knives",           0xF2 },
	//	{ "Attic",            0xE7 },
	};

	settings.Add("Splits", true, "Splits");
		settings.Add("Puzzles", true, "Puzzles", "Splits");

	foreach (var puzzle in vars.Puzzles.Keys) {
		settings.Add(puzzle, false, puzzle.Replace("_", " "), "Puzzles");
	}
	vars.Puzzles.Remove("Maze");

	settings.Add("End", true, "Turn left at the mirror in the attic (Final input)", "Splits");

	vars.Info = (Action<string>)((msg) => {
		print("[The 7th Guest ASL] " + msg);
	});
}

init {
	vars.ScummVM.Init();

	vars.ScummVM["video"] = vars.ScummVM.Watch<short>("_script", "_videoRef");
	vars.ScummVM["room"] = vars.ScummVM.Watch<short>("_script", "_variables", 0x8C);
	vars.ScummVM["cursor"] = vars.ScummVM.Watch<byte>("_script", "_lastCursor");

	foreach (var puzzle in vars.Puzzles) {
		var puzzleName = puzzle.Key;
		var index = puzzle.Value;

		vars.ScummVM[puzzleName] = vars.ScummVM.Watch<byte>("_script", "_variables", index);
	}

	vars.StartTransitions = new HashSet<int> { 
		0x1422, // turn left
		0x1401, // move to the left door
		0x1403, // move up the stairs
		0x1402, // move to the right door
		0x1427  // turn right 
	};

	vars.completedSplits = new HashSet<string>();
}

update {
	vars.ScummVM.Update();
}

start {
	// Time starts on first movement, i.e. on one of the start transitions
	return (old.video == 0 || old.video == -1) && vars.StartTransitions.Contains(current.video);
}

onStart {
	vars.completedSplits.Clear();
}

reset {
	return (vars.ScummVM["g_engine"].Changed && vars.ScummVM["g_engine"].Current == 0) ||
	       (current.video == 0x1C02 && old.video != 0x1C02); // intro 
}

split {
	// FINAL SPLIT
	// turn left at the mirror in the attic
	if (current.room == 0x0102 && current.cursor == 0x01 && current.video == 0x0007) {
		if (settings["End"] && vars.completedSplits.Add("End")) {
			vars.Info("SPLIT: Final input.");
			return true;
		}
	}

	// PUZZLE SPLITS
	foreach (var puzzle in vars.Puzzles.Keys) {
		if (vars.ScummVM[puzzle].Changed && vars.ScummVM[puzzle].Current == 0x31) {
			// Solved puzzles are set to 0x31. 
			// Why? Because it's the ASCII code for '1'.
			if (settings[puzzle] && vars.completedSplits.Add(puzzle)) {	
				vars.Info("SPLIT: Solved " + puzzle + ".");
				return true;
			}
		}
	}

	// MAZE
	if (old.room == 0x0500 && current.room == 0x0600) {
		if (settings["Maze"] && vars.completedSplits.Add("Maze")) {
			vars.Info("SPLIT: Completed the Maze.");
			return true;
		}
	}
}