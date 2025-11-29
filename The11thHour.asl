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
			{ "Desk drawers",   Tuple.Create(RIDDLE, 1)    },
		}}
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
	settings.Add("Modern art", false, "Modern art (Finish chapter 1)", "1");

	settings.Add("End", true, "Pick a door (Trigger an ending)", "2");

	/*
	vars.RiddlesChapter1 = new Dictionary<int, Tuple<string, int>> {
		{ "Winter coat worn for a mixer?",                1 },
		{ "Rolling rock, bottle cap",                     2 },
		{ "Artsy, excited lecher",                        3 },
		{ "A heart attack could put you into the ground", 4 },
		{ "BattleGround",                                 5 },
		{ "Bars deter cuckoo bird",                       6 },
		{ "Modern art flourishes under the sun",          7 },
	};
	
	vars.RiddlesChapter2 = new Dictionary<string, int> {
		{ "SkedAddled", },
		{ "Part of the body examined in doctor's office", },
		{ "Libation for an affectionate puppy called Sounder", },
		{ "Animal sullied street", },
		{ "Jfcr vx qctf...", },
		{ "Zu gotdy od ...", },
		{ "Fruit Loop on stove", },
		{ "Dreams abound of arming the rebels? What of nocturnal horses schedules?", },
		{ "A distant, ancient castle keep ...", },
		{ "A man-horse on the fly sounds like a wounded bull's eye.", },
	};

	vars.RiddlesChapter3 = new Dictionary<string, int> {
		{ "Put an olive in a stein, mix it up ...", },
		{ "A vital, instrumental part", },
		{ "22233642-736846873", },
		{ "Light piece from great orchestra", },
		{ "Cheesy gadget that sounds larger", },
		{ "500=100=0", },
		{ "Blend a TEAPOT SHOT and the pearlies won't rot", },
		{ "Slyness holding shipment in choppe?", },
		{ "Poor drainage could still produce a flower", },
		{ "Sounds like it got higher from wine", },
		{ "What kind of jewelry is angrier?", },
		{ "You might hear a well-mannered Cockney with a 60's hairstyle", },
	};

	vars.RiddlesChapter4 = new Dictionary<string, int> {
		{ "Instrument is sharp, but is missing its head", },
		{ "A defective truck with a crane makes for a ball-busting ballet.", },
		{ "Look at key missing 1st misprinted label", },
		{ "Disabled cutting edge", },
		{ "Unreasonable reason", },
		{ "Paper used in unusual theses", },
		{ "Adroit holding a sharp instrument", },
		{ "A desserted Arthropod", },
	};

	vars.RiddlesChapter5 = new Dictionary<string, int> {
		{ "663 264625 46 2 6455466", },
		{ "Drink left at sea", },
		{ "Snake, baby, trap", },
		{ "A letter from Greece is quite a number in Rome", },
		{ "This eight letter word has 'kst' in the middle ...", },
	};
	*/

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
		var type = split.Value.Item1;

		if (type == 1) { // RIDDLE
			var riddle = split.Value.Item2;
			var name = split.Key;

			if (vars.SolvedRiddle(riddle)) {
				vars.Info("SPLIT: Solved riddle: " + name);
				return true;
			}
		}
		else if (type == 2) { // PUZZLE
			var puzzle = split.Value.Item2;
			var name = split.Key;

			if (vars.ScummVM[name].Changed && vars.ScummVM[name].Current >= 0x05) {
				vars.Info("SPLIT: Solved puzzle: " + name);
				return true;
			}
		}
	}
	if (old.chapter == 1 && current.chapter == 2) {
		vars.Info("SPLIT: Solved riddle: Modern art & Completed Chapter 1");
		return true;
	}
}