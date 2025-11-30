state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("Groovie");
	
	vars.ScummVM.LogChangedWatchers();
	vars.ScummVM.LogResolvedPaths();

	const int RIDDLE = 1;
	const int PUZZLE = 2;

	vars.Splits = new Dictionary<int, Dictionary<string, Tuple<int, int>>> {
		{ 1, new Dictionary<string, Tuple<int, int>> {
			{ "Tonic water",   Tuple.Create(RIDDLE, 1)    },
			{ "CASH REGISTER", Tuple.Create(PUZZLE, 0xF8) },
			{ "Cork",          Tuple.Create(RIDDLE, 2)    },
			{ "KNIGHTS",       Tuple.Create(PUZZLE, 0xFB) },
			{ "Satyr",         Tuple.Create(RIDDLE, 3)    },
			{ "BOOKCASE",      Tuple.Create(PUZZLE, 0xEE) },
			{ "Globe",         Tuple.Create(RIDDLE, 4)    },
			{ "MOUSE",         Tuple.Create(PUZZLE, 0xEF) },
			{ "Pill bottle",   Tuple.Create(RIDDLE, 5)    },
			{ "Robin",         Tuple.Create(RIDDLE, 6)    },
		}},
		{ 2, new Dictionary<string, Tuple<int, int>> {
			{ "Desk drawers",            Tuple.Create(RIDDLE, 1)    },
			{ "Torso",                   Tuple.Create(RIDDLE, 2)    },
			{ "Champagne bottle",        Tuple.Create(RIDDLE, 3)    },
			{ "POOL BALLS",              Tuple.Create(PUZZLE, 0xFF) },
			{ "Setter",                  Tuple.Create(RIDDLE, 4)    },
			{ "Clock face",              Tuple.Create(RIDDLE, 5)    },
			{ "SPIDERS",                 Tuple.Create(PUZZLE, 0xFF) },
			{ "Razor",                   Tuple.Create(RIDDLE, 6)    },
			{ "Orange",                  Tuple.Create(RIDDLE, 7)    },
			{ "MIRROR",                  Tuple.Create(PUZZLE, 0xFF) },
			{ "Picture above fireplace", Tuple.Create(RIDDLE, 8)    },
			{ "Great Dane",              Tuple.Create(RIDDLE, 9)    },
		}},
		{ 3, new Dictionary<string, Tuple<int, int>> {
			{ "Broken TV",      Tuple.Create(RIDDLE, 1)    },
			{ "Pipe organ",     Tuple.Create(RIDDLE, 2)    },
			{ "TOY TRAINS",     Tuple.Create(PUZZLE, 0xFF) },
			{ "Rook",           Tuple.Create(RIDDLE, 3)    },
			{ "Torch",          Tuple.Create(RIDDLE, 4)    },
			{ "PLATES",         Tuple.Create(PUZZLE, 0xFF) },
			{ "Cheese grater",  Tuple.Create(RIDDLE, 5)    },
			{ "7th Guest disc", Tuple.Create(RIDDLE, 6)    },
			{ "Toothpaste",     Tuple.Create(RIDDLE, 7)    },
			{ "DICE CUBE",      Tuple.Create(PUZZLE, 0xFF) },
			{ "Guillotine",     Tuple.Create(RIDDLE, 8)    },
			{ "White flower",   Tuple.Create(RIDDLE, 9)    },
			{ "PYRAMID",        Tuple.Create(PUZZLE, 0xFF) },
			{ "Red rose",       Tuple.Create(RIDDLE, 10)   },
			{ "JEWELRY BOX",    Tuple.Create(PUZZLE, 0xFF) },
			{ "Earring",        Tuple.Create(RIDDLE, 11)   },
			
		}},
		{ 4, new Dictionary<string, Tuple<int, int>> {
			{ "FURNITURE",   Tuple.Create(PUZZLE, 0xFF) },
			{ "Harp",        Tuple.Create(RIDDLE, 1)    },
			{ "Toy Soldier", Tuple.Create(RIDDLE, 2)    },
			{ "Eyeball",     Tuple.Create(RIDDLE, 3)    },
			{ "Dagger",      Tuple.Create(RIDDLE, 4)    },
			{ "Train",       Tuple.Create(RIDDLE, 5)    },
			{ "Bed Sheets",  Tuple.Create(RIDDLE, 6)    },
			{ "Cleaver",     Tuple.Create(RIDDLE, 7)    },
		}},
		{ 5, new Dictionary<string, Tuple<int, int>> {
			{ "Lion statue",      Tuple.Create(RIDDLE, 1)    },
			{ "Glass of port",    Tuple.Create(RIDDLE, 2)    },
			{ "BISHOPS",          Tuple.Create(PUZZLE, 0xFF) },
			{ "Baby rattle",      Tuple.Create(RIDDLE, 3)    },
			{ "XI on the clock",  Tuple.Create(RIDDLE, 4)    },
			{ "Inkstand",         Tuple.Create(RIDDLE, 5)    },
			{ "DOLL HOUSE PENTE", Tuple.Create(PUZZLE, 0xFF) },
		}}
	};

	vars.ChapterSplits = new Dictionary<string, int> {
		{ "MODERN ART", 1 },
		{ "TRIANGLE",   2 },
		{ "BEEHIVE",    3 },
		{ "DESSERT",    4 }
	};

	settings.Add("Splits", true, "Splits");
	foreach (var kv in vars.Splits) {
		var chapter = kv.Key;
		var splits = kv.Value;
		settings.Add(chapter.ToString(), true, "Chapter " + chapter.ToString(), "Splits");

		foreach (var split in splits) {
			var splitName = split.Key;

			settings.Add(splitName, false, splitName, chapter.ToString());
		}
	}
	foreach (var kv in vars.ChapterSplits) {
		var puzzle = kv.Key;
		var chapter = kv.Value.ToString();

		settings.Add(puzzle, false, puzzle + " (Finish chapter " + chapter + ")", chapter);
	}
	
	settings.Add("End", true, "Pick a door (Trigger an ending)", "5");

	vars.Info = (Action<string>)((msg) => {
		print("[The 11th Hour ASL] " + msg);
	});
}

init {
	vars.ScummVM.Init();

	// GENERAL WATCHERS
	vars.ScummVM["video"] = vars.ScummVM.Watch<short>("_script", "_videoRef");

	vars.ScummVM["chapter"] = vars.ScummVM.Watch<byte>("_script", "_variables", 0x8F);
	vars.ScummVM["riddle"] = vars.ScummVM.Watch<byte>("_script", "_variables", 0x90);

	vars.ScummVM["room"] = vars.ScummVM.Watch<short>("_script", "_variables", 0x8C);
	
	vars.ScummVM["bytes"] = vars.ScummVM.WatchBytes(10, "_script", "_variables", 0x0);

	// PUZZLE WATCHERS
	foreach (var kv in vars.Splits) {
		var splits = kv.Value;

		foreach (var split in splits) {
			var splitName = split.Key;
			var type = split.Value.Item1;
			var offset = split.Value.Item2;

			if (type == 2) { // PUZZLE
				vars.ScummVM[splitName] = vars.ScummVM.Watch<byte>("_script", "_variables", offset);
			}
		}
	}

	vars.StartTransitions = new HashSet<int> { 
		0x124F, // turn left
		0x124A, // move to the left door
		0x1205, // move up the stairs
		0x1218, // move to the right door
		0x1206  // turn right 
	};

	vars.EndingCutscenes = new HashSet<int> {
		0x100F, // Door 1 (Marie) 
		0x100E, // Door 2 (Samantha) 
		0x100D  // Door 3 (Robin) 
	};

	vars.GameBook = (Func<bool>)(() => {
		if (vars.ScummVM["bytes"].Changed) {
			byte[] bytes = vars.ScummVM["bytes"].Current;

			return bytes.SequenceEqual(
				new byte[] {0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01}
			);
		}
		
		return false;
	});

	vars.SolvedRiddle = (Func<int, bool>)((riddle) => {
		if (vars.ScummVM["riddle"].Old == riddle) {
			if (vars.ScummVM["riddle"].Current == vars.ScummVM["riddle"].Old + 1) {
				return true;
			}
		}
		return false;
	});

	vars.completedSplits = new HashSet<string>();
}

update {
	vars.ScummVM.Update();
}

start {
	// Time starts on first movement, i.e. on one of the start transitions
	if ((old.video == 0 || old.video == -1) && vars.StartTransitions.Contains(current.video)) {
		return true;
	}
	// Or on opening the Game Book
	if (current.room == 0x0100 && vars.GameBook()) {
		return true;
	}
}

onStart {
	vars.completedSplits.Clear();
}

reset {
	// Reset on returning to the ScummVM launcher
	return vars.ScummVM["g_engine"].Changed && vars.ScummVM["g_engine"].Current == 0;
}

split {
	// FINAL SPLIT
	// Pick one of the doors
	if (current.room == 0x0902 && vars.EndingCutscenes.Contains(current.video)) {
		if (settings["End"] && vars.completedSplits.Add("End")) {
			vars.Info("SPLIT: Triggered one of the endings.");
			return true;
		}
	}

	// RIDDLES AND PUZZLES
	foreach (var split in vars.Splits[current.chapter]) {
		var name = split.Key;
		var type = split.Value.Item1;

		if (type == 1) { // RIDDLE
			var riddle = split.Value.Item2;

			if (vars.SolvedRiddle(riddle)) {
				vars.Info("SPLIT: Solved riddle: " + name);
				return true;
			}
		}
		else if (type == 2) { // PUZZLE	
			if (vars.ScummVM[name].Changed && vars.ScummVM[name].Current >= 0x05) {
				vars.Info("SPLIT: Solved puzzle: " + name);
				return true;
			}
		}
	}

	// CHAPTERS
	foreach (var split in vars.ChapterSplits) {
		var puzzle = split.Key;
		var chapter = split.Value;

		if (old.chapter == chapter && current.chapter == old.chapter + 1) {
			vars.Info("SPLIT: Solved " + puzzle + " & completed Chapter " + chapter);
			return true;
		}
	}
}