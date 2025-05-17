state("scummvm") {}
/*
	// Main variables
	int Room: 0x017AE444, 0xA4, 0x20, 0x8, 0x4;
	ushort CapturedIxupi: 0x17AE444, 0x100, 0x88, 0x1A2;

	// Life Essence
	byte Life: 0x17AE444, 0x100, 0x88, 0x1B6;

	// Skull Dials
	byte SkullDialNest: 0x17AE444, 0x100, 0x88, 0x522;
	byte SkullDialMaze: 0x17AE444, 0x100, 0x88, 0x526;
	byte SkullDialWerewolf: 0x17AE444, 0x100, 0x88, 0x52A;
	byte SkullDialChina: 0x17AE444, 0x100, 0x88, 0x52E;
	byte SkullDialEgypt: 0x17AE444, 0x100, 0x88, 0x532;
	byte SkullDialLyre: 0x17AE444, 0x100, 0x88, 0x536;

	// Puzzle States
	// Atlantis Globe (5), Organ (6), Theater Curtain (2), Marble Pinball (4)
	byte PuzzleGroupA: 0x17AE444, 0x100, 0x88, 0x346;
	// Gears (7), Stonehenge (6)
	byte PuzzleGroupB: 0x17AE444, 0x100, 0x88, 0x347;

	// Maze Door (0), Theater Door (3), Geoffrey Door (1), Horse Puzzle (5), Red Door (7)
	byte PuzzleGroupC: 0x17AE444, 0x100, 0x88, 0x34A;
	// Columns of Ra (6), Burial Door (5), Shaman (1), Lyre (0)
	byte PuzzleGroupD: 0x17AE444, 0x100, 0x88, 0x34B;

	// Library Statue (7)
	byte PuzzleGroupE: 0x17AE444, 0x100, 0x88, 0x34E;

	// Alchemy (5)
	byte PuzzleGroupF: 0x17AE444, 0x100, 0x88, 0x352;

	// Skull Dial Door (1), Beth's Body Page (7), Guillotine (6)
	byte PuzzleGroupG: 0x17AE444, 0x100, 0x88, 0x356;
	// Workshop Drawers (7), UFO (3), Jukebox (5), Mastermind (6)
	byte PuzzleGroupH: 0x17AE444, 0x100, 0x88, 0x357;
	
	// Clock Chains (5), Anansi (7)
	byte PuzzleGroupI: 0x17AE444, 0x100, 0x88, 0x35A;
	// Chinese Solitaire (4), Gallows (6)
	byte PuzzleGroupJ: 0x17AE444, 0x100, 0x88, 0x35B;
*/

startup {
	// Settings
	settings.Add("Misc", false, "Miscellaneous checkpoints");
		settings.Add("Light", false, "Turn on light in Green Tunnel", "Misc");
		settings.Add("FirstBlood", false, "First Blood", "Misc");
		settings.Add("Office", false, "Reach Office", "Misc");
		settings.Add("Beth", false, "Beth's Body Page", "Misc");
		settings.Add("Guillotine", false, "Guillotine", "Misc");
	settings.Add("Ixupi", true, "Split when capturing Ixupi");
		settings.Add("Sand", true, "Sand", "Ixupi");
		settings.Add("Crystal", true, "Ash", "Ixupi");
		settings.Add("Metal", true, "Metal", "Ixupi");
		settings.Add("Tar", true, "Tar", "Ixupi");
		settings.Add("Wood", true, "Wood", "Ixupi");
		settings.Add("Lightning", true, "Lightning", "Ixupi");
		settings.Add("Ash", true, "Ash", "Ixupi");
		settings.Add("Water", true, "Water", "Ixupi");
		settings.Add("Cloth", true, "Cloth", "Ixupi");
		settings.Add("Wax", true, "Wax", "Ixupi");
	settings.Add("Puzzles", false, "Puzzles");
		settings.Add("AtlantisGlobe", false, "Solve Atlantis Globe", "Puzzles");
		settings.Add("Organ", false, "Solve Organ", "Puzzles");
		settings.Add("TheaterCurtain", false, "Solve Theater Curtain", "Puzzles");
		settings.Add("MarblePinball", false, "Solve Marble Pinball", "Puzzles");
		settings.Add("Gears", false, "Solve Gears", "Puzzles");
		settings.Add("Stonehenge", false, "Solve Stonehenge", "Puzzles");
		settings.Add("MazeDoor", false, "Solve Maze Door", "Puzzles");
		settings.Add("TheaterDoor", false, "Solve Theater Door", "Puzzles");
		settings.Add("GeoffreyDoor", false, "Solve Geoffrey Door", "Puzzles");
		settings.Add("HorsePuzzle", false, "Solve Horse Puzzle", "Puzzles");
		settings.Add("RedDoor", false, "Solve Red Door", "Puzzles");
		settings.Add("ColumnsOfRa", false, "Solve Columns of Ra", "Puzzles");
		settings.Add("BurialDoor", false, "Solve Burial Door", "Puzzles");
		settings.Add("Shaman", false, "Solve Shaman", "Puzzles");
		settings.Add("Lyre", false, "Solve Lyre", "Puzzles");
		settings.Add("LibraryStatue", false, "Solve Library Statue", "Puzzles");
		settings.Add("Alchemy", false, "Solve Alchemy", "Puzzles");
		settings.Add("SkullDialDoor", false, "Solve Skull Dial Door", "Puzzles");
		settings.Add("WorkshopDrawers", false, "Solve Workshop Drawers", "Puzzles");
		settings.Add("UFO", false, "Solve UFO", "Puzzles");
		settings.Add("Jukebox", false, "Solve Jukebox", "Puzzles");
		settings.Add("Mastermind", false, "Solve Mastermind", "Puzzles");
		settings.Add("ClockChains", false, "Solve Clock Chains", "Puzzles");
		settings.Add("Anansi", false, "Solve Anansi", "Puzzles");
		settings.Add("Solitaire", false, "Solve Solitaire", "Puzzles");
		settings.Add("Gallows", false, "Solve Gallows", "Puzzles");
		settings.Add("SkullDials", false, "Skull Dials", "Puzzles");
			settings.Add("SkullDialNest", false, "Nest", "SkullDials");
			settings.Add("SkullDialMaze", false, "Maze", "SkullDials");
			settings.Add("SkullDialWerewolf", false, "Werewolf", "SkullDials");
			settings.Add("SkullDialChina", false, "China", "SkullDials");
			settings.Add("SkullDialEgypt", false, "Egypt", "SkullDials");
			settings.Add("SkullDialLyre", false, "Lyre", "SkullDials");

	// Flags
	vars.completedSplits = new HashSet<string>();
}

init {
	vars.ScanAll = (Func<SigScanTarget, IEnumerable<IntPtr>>)(trg => {
		var results = new List<IntPtr>();

		foreach (var page in game.MemoryPages(true)) {
			var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
			var matches = scanner.ScanAll(trg);

			results.AddRange(matches);
		}

		return results;
	});

#region Globals Scan
	var globals =
		"00 00 00 00"+
		"01 00 5D 21"+
		"?? ?? ?? ??"+
		"11 00 05 00"+
		"00 00 00 00"+
		"05 00 4B 15"+
		"05 00 17 16"+
		"05 00 31 16"+
		"03 00 F0 09"+
		"00 00 00 00";

	// gGameTime
	var gGameTimeOffset = 88 * 0x4 + 0x2;

	// The global variables block can appear in multiple places in memory,
	// but only the variables of one of the blocks keep updating.
	// To identify the true block, we can use the gGameTime variable.
	// If this variable doesn't constantly change, it's the wrong block.
	
	var realGlobalsPtr = IntPtr.Zero;
	
	var globalsTrg = new SigScanTarget(0, globals);
	var globalsCandidates = vars.ScanAll(globalsTrg);
	
	foreach (var addr in globalsCandidates) {
		print("Candidate address: " + addr.ToString("X"));
	}
	
	// Store the two bytes at each candidate's gGameTime offset
	var firstScanMap = new Dictionary<IntPtr, byte[]>();

	foreach (var ptr in globalsCandidates) {
		var gameTime = game.ReadBytes((IntPtr)ptr + gGameTimeOffset, 2);
		firstScanMap[ptr] = gameTime;
	}

	// Wait before second scan
	Thread.Sleep(50); 

	foreach (var ptr in globalsCandidates) {
		var currentBytes = game.ReadBytes((IntPtr)ptr + gGameTimeOffset, 2);
		var oldBytes = firstScanMap[ptr];

		if (currentBytes[0] != oldBytes[0] || currentBytes[1] != oldBytes[1]) {
			realGlobalsPtr = ptr;
			print("Real globals address found: " + ptr.ToString("X"));
			break;
		}
	}

	if (realGlobalsPtr == IntPtr.Zero) {
		throw new Exception("No changing address found. Retrying...");
	}
#endregion

#region Watchers
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		// + 0x2 because, unlike objects, variables only use the last two bytes of the SCI address format (SSSS:OOOO)

		{ "Room",              new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr +  11 * 0x4 + 2)) },
		{ "Captures",          new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 104 * 0x4 + 2)) },
		{ "Life",              new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 109 * 0x4 + 2)) },

		// Group A Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		// Gears  Stone  Tunnel                                           Organ  Globe  Pinball       Curtain                 
		//        henge  light
		{ "PuzzleGroupA",      new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 209 * 0x4 + 2)) },

		// Group B Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//        Columns Burial                     Shaman Lyre   Red Door      Horse         Theater    Geoffrey  Maze
		//        of Ra   Door                                                   Puzzle        Door       Door      Door   
		{ "PuzzleGroupB",      new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 210 * 0x4 + 2)) },

		// Group C Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//                                                         Library
		//                                                         Statue
		{ "PuzzleGroupC",      new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 211 * 0x4 + 2)) },

		// Group D Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//                                                                       Alchemy
		// 
		{ "PuzzleGroupD",      new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 212 * 0x4 + 2)) },

		// Group E Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		// Work  Master  Jukebox       UFO                         Beth's  Guillotine                         Skull 
		// shop  mind                                             Body Page                                   Door
		{ "PuzzleGroupE",      new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 213 * 0x4 + 2)) },
		
		// Group F Bits
		//  15     14     13     12     11     10     09     08  |  07     06     05     04     03     02     01     00
		// ──────────────────────────────────────────────────────┼──────────────────────────────────────────────────────
		//       Gallows       Chinese                             Anansi        Clock 
		//                    Solitaire                                          Chains
		{ "PuzzleGroupF",      new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 214 * 0x4 + 2)) },

		// Skull Dials
		{ "SkullDialNest",     new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 328 * 0x4 + 2)) },
		{ "SkullDialMaze",     new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 329 * 0x4 + 2)) },
		{ "SkullDialWerewolf", new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 330 * 0x4 + 2)) },
		{ "SkullDialChina",    new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 331 * 0x4 + 2)) },
		{ "SkullDialEgypt",    new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 332 * 0x4 + 2)) },
		{ "SkullDialLyre",     new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 333 * 0x4 + 2)) },
	};
#endregion
}

update {
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
	// Misc. Checkpoints
	if (settings["Light"] && current.room == 2340 && (vars.Watchers["PuzzleGroupA"].Current & (1 << 13)) != 0) {
		return vars.completedSplits.Add("Light");
	}
	else if (settings["FirstBlood"] && vars.Watchers["Life"].Current == vars.Watchers["Life"].Old - 10) {
		return vars.completedSplits.Add("FirstBlood");
	}
	else if (settings["Office"] && current.room == 5110) {
		return vars.completedSplits.Add("Office");
	}
	
	// Ixupi
	else if (settings["Sand"] && !vars.completedSplits.Contains("Sand") && (vars.Watchers["Captures"].Current & (1 << 0)) != 0) {
		return vars.completedSplits.Add("Sand");
	}
	else if (settings["Crystal"] && !vars.completedSplits.Contains("Crystal") && (vars.Watchers["Captures"].Current & (1 << 1)) != 0) {
		return vars.completedSplits.Add("Crystal");
	}
	else if (settings["Metal"] && !vars.completedSplits.Contains("Metal") && (vars.Watchers["Captures"].Current & (1 << 2)) != 0) {
		return vars.completedSplits.Add("Metal");
	}
	else if (settings["Tar"] && !vars.completedSplits.Contains("Tar") && (vars.Watchers["Captures"].Current & (1 << 3)) != 0) {
		return vars.completedSplits.Add("Tar");
	}
	else if (settings["Wood"] && !vars.completedSplits.Contains("Wood") && (vars.Watchers["Captures"].Current & (1 << 4)) != 0) {
		return vars.completedSplits.Add("Wood");
	}
	else if (settings["Lightning"] && !vars.completedSplits.Contains("Lightning") && (vars.Watchers["Captures"].Current & (1 << 5)) != 0) {
		return vars.completedSplits.Add("Lightning");
	}
	else if (settings["Ash"] && !vars.completedSplits.Contains("Ash") && (vars.Watchers["Captures"].Current & (1 << 6)) != 0) {
		return vars.completedSplits.Add("Ash");
	}
	else if (settings["Water"] && !vars.completedSplits.Contains("Water") && (vars.Watchers["Captures"].Current & (1 << 7)) != 0) {
		return vars.completedSplits.Add("Water");
	}
	else if (settings["Cloth"] && !vars.completedSplits.Contains("Cloth") && (vars.Watchers["Captures"].Current & (1 << 8)) != 0) {
		return vars.completedSplits.Add("Cloth");
	}
	else if (settings["Wax"] && !vars.completedSplits.Contains("Wax") && (vars.Watchers["Captures"].Current & (1 << 9)) != 0) {
		return vars.completedSplits.Add("Wax");
	}
	
	// Skull Dials
	else if (settings["SkullDialNest"] && !vars.completedSplits.Contains("SkullDialNest") && vars.Watchers["SkullDialNest"].Current == 0) {
		return vars.completedSplits.Add("SkullDialNest");
	}
	else if (settings["SkullDialMaze"] && !vars.completedSplits.Contains("SkullDialMaze") && vars.Watchers["SkullDialMaze"].Current == 2) {
		return vars.completedSplits.Add("SkullDialMaze");
	}
	else if (settings["SkullDialWerewolf"] && !vars.completedSplits.Contains("SkullDialWerewolf") && vars.Watchers["SkullDialWerewolf"].Current == 3) {
		return vars.completedSplits.Add("SkullDialWerewolf");
	}
	else if (settings["SkullDialChina"] && !vars.completedSplits.Contains("SkullDialChina") && vars.Watchers["SkullDialChina"].Current == 0) {
		return vars.completedSplits.Add("SkullDialChina");
	}
	else if (settings["SkullDialEgypt"] && !vars.completedSplits.Contains("SkullDialEgypt") && vars.Watchers["SkullDialEgypt"].Current == 1) {
		return vars.completedSplits.Add("SkullDialEgypt");
	}
	else if (settings["SkullDialLyre"] && !vars.completedSplits.Contains("SkullDialLyre") && vars.Watchers["SkullDialLyre"].Current == 3) {
		return vars.completedSplits.Add("SkullDialLyre");
	}
	
	// Puzzle Group A
	else if (settings["AtlantisGlobe"] && !vars.completedSplits.Contains("AtlantisGlobe") && (vars.Watchers["PuzzleGroupA"].Current & (1 << 5)) != 0) {
		return vars.completedSplits.Add("AtlantisGlobe");
	}
	else if (settings["Organ"] && !vars.completedSplits.Contains("Organ") && (vars.Watchers["PuzzleGroupA"].Current & (1 << 6)) != 0) {
		return vars.completedSplits.Add("Organ");
	}
	else if (settings["TheaterCurtain"] && !vars.completedSplits.Contains("TheaterCurtain") && (vars.Watchers["PuzzleGroupA"].Current & (1 << 2)) != 0) {
		return vars.completedSplits.Add("TheaterCurtain");
	}
	else if (settings["MarblePinball"] && !vars.completedSplits.Contains("MarblePinball") && (vars.Watchers["PuzzleGroupA"].Current & (1 << 4)) != 0) {
		return vars.completedSplits.Add("MarblePinball");
	}
	else if (settings["Gears"] && !vars.completedSplits.Contains("Gears") && (vars.Watchers["PuzzleGroupA"].Current & (1 << 15)) != 0) {
		return vars.completedSplits.Add("Gears");
	}
	else if (settings["Stonehenge"] && !vars.completedSplits.Contains("Stonehenge") && (vars.Watchers["PuzzleGroupA"].Current & (1 << 14)) != 0) {
		return vars.completedSplits.Add("Stonehenge");
	}
	
	// Puzzle Group B
	else if (settings["MazeDoor"] && !vars.completedSplits.Contains("MazeDoor") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 0)) != 0) {
		return vars.completedSplits.Add("MazeDoor");
	}
	else if (settings["TheaterDoor"] && !vars.completedSplits.Contains("TheaterDoor") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 3)) != 0) {
		return vars.completedSplits.Add("TheaterDoor");
	}
	else if (settings["GeoffreyDoor"] && !vars.completedSplits.Contains("GeoffreyDoor") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 1)) != 0) {
		return vars.completedSplits.Add("GeoffreyDoor");
	}
	else if (settings["HorsePuzzle"] && !vars.completedSplits.Contains("HorsePuzzle") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 5)) != 0) {
		return vars.completedSplits.Add("HorsePuzzle");
	}
	else if (settings["RedDoor"] && !vars.completedSplits.Contains("RedDoor") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 7)) != 0) {
		return vars.completedSplits.Add("RedDoor");
	}
	else if (settings["ColumnsOfRa"] && !vars.completedSplits.Contains("ColumnsOfRa") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 14)) != 0) {
		return vars.completedSplits.Add("ColumnsOfRa");
	}
	else if (settings["BurialDoor"] && !vars.completedSplits.Contains("BurialDoor") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 13)) != 0) {
		return vars.completedSplits.Add("BurialDoor");
	}
	else if (settings["Shaman"] && !vars.completedSplits.Contains("Shaman") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 9)) != 0) {
		return vars.completedSplits.Add("Shaman");
	}
	else if (settings["Lyre"] && !vars.completedSplits.Contains("Lyre") && (vars.Watchers["PuzzleGroupB"].Current & (1 << 8)) != 0) {
		return vars.completedSplits.Add("Lyre");
	}

	// Puzzle Group C
	else if (settings["LibraryStatue"] && !vars.completedSplits.Contains("LibraryStatue") && (vars.Watchers["PuzzleGroupC"].Current & (1 << 7)) != 0) {
		return vars.completedSplits.Add("LibraryStatue");
	}

	// Puzzle Group D
	else if (settings["Alchemy"] && !vars.completedSplits.Contains("Alchemy") && (vars.Watchers["PuzzleGroupD"].Current & (1 << 5)) != 0) {
		return vars.completedSplits.Add("Alchemy");
	}

	// Puzzle Group E
	else if (settings["SkullDialDoor"] && !vars.completedSplits.Contains("SkullDialDoor") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 1)) != 0) {
		return vars.completedSplits.Add("SkullDialDoor");
	}
	else if (settings["Beth"] && !vars.completedSplits.Contains("Beth") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 7)) != 0) {
		return vars.completedSplits.Add("Beth");
	}
	else if (settings["Guillotine"] && !vars.completedSplits.Contains("Guillotine") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 6)) != 0) {
		return vars.completedSplits.Add("Guillotine");
	}
	else if (settings["WorkshopDrawers"] && !vars.completedSplits.Contains("WorkshopDrawers") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 15)) != 0) {
		return vars.completedSplits.Add("WorkshopDrawers");
	}
	else if (settings["UFO"] && !vars.completedSplits.Contains("UFO") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 11)) != 0) {
		return vars.completedSplits.Add("UFO");
	}
	else if (settings["Jukebox"] && !vars.completedSplits.Contains("Jukebox") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 13)) != 0) {
		return vars.completedSplits.Add("Jukebox");
	}
	else if (settings["Mastermind"] && !vars.completedSplits.Contains("Mastermind") && (vars.Watchers["PuzzleGroupE"].Current & (1 << 14)) != 0) {
		return vars.completedSplits.Add("Mastermind");
	}

	// Puzzle Group F
	else if (settings["ClockChains"] && !vars.completedSplits.Contains("ClockChains") && (vars.Watchers["PuzzleGroupF"].Current & (1 << 5)) != 0) {
		return vars.completedSplits.Add("ClockChains");
	}
	else if (settings["Anansi"] && !vars.completedSplits.Contains("Anansi") && (vars.Watchers["PuzzleGroupF"].Current & (1 << 7)) != 0) {
		return vars.completedSplits.Add("Anansi");
	}
	else if (settings["Solitaire"] && !vars.completedSplits.Contains("Solitaire") && (vars.Watchers["PuzzleGroupF"].Current & (1 << 12)) != 0) {
		return vars.completedSplits.Add("Solitaire");
	}
	else if (settings["Gallows"] && !vars.completedSplits.Contains("Gallows") && (vars.Watchers["PuzzleGroupF"].Current & (1 << 14)) != 0) {
		return vars.completedSplits.Add("Gallows");
	}
}
