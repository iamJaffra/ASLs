state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("SCI");

	vars.splits = new Dictionary<string, Tuple<string, int, string>> { 
		// Misc
		{ "Misc:Light",      Tuple.Create("A",      13, "Turn on the light in the Green Tunnel") },
		{ "Misc:FirstBlood", Tuple.Create("Life",   90, "First Blood") },
		{ "Misc:Office",     Tuple.Create("Room", 5110, "Reach the Office") },
		{ "Misc:Beth",       Tuple.Create("E",       7, "Beth's Body Page") },
		{ "Misc:Guillotine", Tuple.Create("E",       6, "Guillotine") },

		// Ixupi Captures
		{ "Ixupi:Sand",      Tuple.Create("Ixupi", 0, "Sand") },
		{ "Ixupi:Crystal",   Tuple.Create("Ixupi", 1, "Crystal") },
		{ "Ixupi:Metal",     Tuple.Create("Ixupi", 2, "Metal") },
		{ "Ixupi:Tar",       Tuple.Create("Ixupi", 3, "Tar") },
		{ "Ixupi:Wood",      Tuple.Create("Ixupi", 4, "Wood") },
		{ "Ixupi:Lightning", Tuple.Create("Ixupi", 5, "Lightning") },
		{ "Ixupi:Ash",       Tuple.Create("Ixupi", 6, "Ash") },
		{ "Ixupi:Water",     Tuple.Create("Ixupi", 7, "Water") },
		{ "Ixupi:Cloth",     Tuple.Create("Ixupi", 8, "Cloth") },
		{ "Ixupi:Wax",       Tuple.Create("Ixupi", 9, "Wax") },

		// Puzzles
		{ "Puzzles:Gears",           Tuple.Create("A", 15, "Gears") },
		{ "Puzzles:Stonehenge",      Tuple.Create("A", 14, "Stonehenge") },
		{ "Puzzles:AtlantisGlobe",   Tuple.Create("A",  5, "Atlantis Globe") },
		{ "Puzzles:Organ",           Tuple.Create("A",  6, "Organ") },
		{ "Puzzles:TheaterCurtain",  Tuple.Create("A",  2, "Theater Curtain") },
		{ "Puzzles:MarblePinball",   Tuple.Create("A",  4, "Marble Pinball") },
		{ "Puzzles:MazeDoor",        Tuple.Create("B",  0, "Maze Door") },
		{ "Puzzles:TheaterDoor",     Tuple.Create("B",  3, "Theater Door") },
		{ "Puzzles:GeoffreyDoor",    Tuple.Create("B",  1, "Geoffrey Door") },
		{ "Puzzles:HorsePuzzle",     Tuple.Create("B",  5, "Horse Puzzle") },
		{ "Puzzles:RedDoor",         Tuple.Create("B",  7, "Red Door") },
		{ "Puzzles:ColumnsOfRa",     Tuple.Create("B", 14, "Columns Of Ra") },
		{ "Puzzles:BurialDoor",      Tuple.Create("B", 13, "Burial Door") },
		{ "Puzzles:Shaman",          Tuple.Create("B",  9, "Shaman") },
		{ "Puzzles:Lyre",            Tuple.Create("B",  8, "Lyre") },
		{ "Puzzles:LibraryStatue",   Tuple.Create("C",  7, "Library Statue") },
		{ "Puzzles:Alchemy",         Tuple.Create("D",  5, "Alchemy") },
		{ "Puzzles:WorkshopDrawers", Tuple.Create("E", 15, "Workshop Drawers") },
		{ "Puzzles:UFO",             Tuple.Create("E", 11, "UFO") },
		{ "Puzzles:Jukebox",         Tuple.Create("E", 13, "Jukebox") },
		{ "Puzzles:Mastermind",      Tuple.Create("E", 14, "Mastermind") },
		{ "Puzzles:ClockChains",     Tuple.Create("F",  5, "Clock Chains") },
		{ "Puzzles:Anansi",          Tuple.Create("F",  7, "Anansi") },
		{ "Puzzles:Solitaire",       Tuple.Create("F", 12, "Solitaire") },
		{ "Puzzles:Gallows",         Tuple.Create("F", 14, "Gallows") },
		{ "Puzzles:SkullDialDoor",   Tuple.Create("E",  1, "Skull Door") },

		// Skull Dials
		{ "SkullDials:Nest",     Tuple.Create("SkullDialNest",     0, "Nest") },
		{ "SkullDials:Maze",     Tuple.Create("SkullDialMaze",     2, "Maze") },
		{ "SkullDials:Werewolf", Tuple.Create("SkullDialWerewolf", 3, "Werewolf") },
		{ "SkullDials:China",    Tuple.Create("SkullDialChina",    0, "China") },
		{ "SkullDials:Egypt",    Tuple.Create("SkullDialEgypt",    1, "Egypt") },
		{ "SkullDials:Lyre",     Tuple.Create("SkullDialLyre",     3, "Lyre") },
		
	};

	settings.Add("Misc", false, "Miscellaneous checkpoints");
	settings.Add("Ixupi", true, "Split when capturing Ixupi");
	settings.Add("Puzzles", false, "Puzzles");
	settings.Add("SkullDials", false, "Skull Dials");

	foreach (var kv in vars.splits) {
		var splitName = kv.Key;
		var splitDescription = kv.Value.Item3;
		var parent = splitName.Split(new[] { ":" }, StringSplitOptions.None)[0];

		settings.Add(splitName, true, splitDescription, parent);
	}

	vars.Info = (Action<string>)((msg) => {
		print("[Shivers ASL] " + msg);
	});

	vars.completedSplits = new HashSet<string>();
}

init {
	vars.ScummVM.Init();

	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		// + 0x2 because, unlike objects, variables only use the last two bytes of the SCI address format (SSSS:OOOO)

		{ "Room",              vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0,  11 * 0x4 + 0x2) }, 
		{ "Ixupi",             vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 104 * 0x4 + 0x2) },
		{ "Life",              vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 109 * 0x4 + 0x2) },

		// Group A Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		// Gears  Stone  Tunnel                                           Organ  Globe  Pinball       Curtain                 
		//        henge  light
		{ "A",                 vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 209 * 0x4 + 0x2) },

		// Group B Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//        Columns Burial                     Shaman Lyre   Red Door      Horse         Theater    Geoffrey  Maze
		//        of Ra   Door                                                   Puzzle        Door       Door      Door   
		{ "B",                 vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 210 * 0x4 + 0x2) },

		// Group C Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//                                                         Library
		//                                                         Statue
		{ "C",                 vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 211 * 0x4 + 0x2) },

		// Group D Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//                                                                       Alchemy
		// 
		{ "D",                 vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 212 * 0x4 + 0x2) },

		// Group E Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		// Work  Master  Jukebox       UFO                         Beth's  Guillotine                         Skull 
		// shop  mind                                             Body Page                                   Door
		{ "E",                 vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 213 * 0x4 + 0x2) },
		
		// Group F Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//       Gallows       Chinese                             Anansi        Clock 
		//                    Solitaire                                          Chains
		{ "F",                 vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 214 * 0x4 + 0x2) },

		// Skull Dials
		{ "SkullDialNest",     vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 328 * 0x4 + 0x2) },
		{ "SkullDialMaze",     vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 329 * 0x4 + 0x2) },
		{ "SkullDialWerewolf", vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 330 * 0x4 + 0x2) },
		{ "SkullDialChina",    vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 331 * 0x4 + 0x2) },
		{ "SkullDialEgypt",    vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 332 * 0x4 + 0x2) },
		{ "SkullDialLyre",     vars.ScummVM.Watch<short>("_gamestate", "variables", 0x0, 333 * 0x4 + 0x2) },
	};
}

update {
	vars.ScummVM.Update();

	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	current.room = vars.Watchers["Room"].Current;
}

start {
	return (old.room == 1012 && (current.room == 1000 || current.room == 1010));
}

onStart {
	vars.completedSplits.Clear();
}

reset {
	// Reset on main menu
	if (current.room == 910 && old.room != 910) {
		return true;
	}
}

split {
	foreach (var kv in vars.splits) {
		var splitName = kv.Key;
		var watcherName = kv.Value.Item1;
		var x = kv.Value.Item2;

		Func<bool> condition;
		if (watcherName.StartsWith("SkullDial") || watcherName == "Room" || watcherName == "Life")
			condition = () => vars.Watchers[watcherName].Current == x;
		else
			condition = () => (vars.Watchers[watcherName].Current & (1 << x)) != 0;

		if (settings[splitName] && !vars.completedSplits.Contains(splitName) && condition()) {
			vars.completedSplits.Add(splitName);
			vars.Info("SPLIT: " + splitName);
			return true;
		}
	}
}
