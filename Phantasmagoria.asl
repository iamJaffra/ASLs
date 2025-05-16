state("scummvm") {}

startup {
	settings.Add("ResetOnMainMenu", true, "Reset timer on main menu");
	settings.Add("Main", true, "Main splits");
		settings.Add("2", true, "Start Chapter 2", "Main");
		settings.Add("3", true, "Start Chapter 3", "Main");
		settings.Add("4", true, "Start Chapter 4", "Main");
		settings.Add("5", true, "Start Chapter 5", "Main");
		settings.Add("6", true, "Start Chapter 6", "Main");
		settings.Add("7", true, "Start Chapter 7", "Main");
		settings.Add("End", true, "Trigger Final Cutscene", "Main");
	settings.Add("Items", false, "Item splits. Split on picking up...");
		settings.Add("invLibKey", false, "Library Key", "Items");
		settings.Add("invMoney", false, "Money", "Items");
		settings.Add("invNail", false, "Nail", "Items");
		settings.Add("invNewspaper", false, "Newspaper", "Items");
		settings.Add("invPoker", false, "Poker", "Items");
		settings.Add("invHammer", false, "Hammer", "Items");
		settings.Add("invStairKey", false, "Stair Key", "Items");
		settings.Add("invVampBook", false, "Vampire Book", "Items");
		settings.Add("invMatch", false, "Match", "Items");
		settings.Add("invTarot", false, "Tarot", "Items");
		settings.Add("invBrooch", false, "Brooch", "Items");
		settings.Add("invPhoto", false, "Photo", "Items");
		settings.Add("invLensPiece", false, "Lens Piece", "Items");
		settings.Add("invDrainCln", false, "Drain Cleaner", "Items");
		settings.Add("invCrucifix", false, "Crucifix", "Items");
		settings.Add("invBeads", false, "Beads", "Items");
		settings.Add("invSpellBook", false, "Spell Book", "Items");
		settings.Add("invXmasOrn", false, "Christmas Ornament (Snowman)", "Items");
		settings.Add("invStone", false, "Stone", "Items");
		settings.Add("invCutter", false, "Glass Shard", "Items");
		settings.Add("invDogBone", false, "Dog Bone", "Items");
		settings.Add("invFigurine", false, "Figurine", "Items");
}

init {
#region Scan Functions
	vars.Scan = (Func<SigScanTarget, IntPtr>)(trg => {
		var ptr = IntPtr.Zero;

		foreach (var page in game.MemoryPages(true)) {
			var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
			ptr = scanner.Scan(trg);

			if (ptr != IntPtr.Zero) {
				return ptr;
			}
		}

		return ptr;
	});

	vars.ScanAll = (Func<SigScanTarget, IEnumerable<IntPtr>>)(trg => {
		var results = new List<IntPtr>();

		foreach (var page in game.MemoryPages(true)) {
			var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
			var matches = scanner.ScanAll(trg);

			results.AddRange(matches);
		}

		return results;
	});
#endregion

#region Globals Scan
	var globals =
		"1C 00 D7 07"+
		"01 00 67 39"+
		"?? ?? ?? ??"+
		"15 00 02 00"+
		"00 00 00 00"+
		"06 00 4B 15"+
		"06 00 17 16"+
		"06 00 31 16"+
		"06 00 E9 15"+
		"1E 00 73 07";

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
			print("Changing address found: " + ptr.ToString("X"));
			break;
		}
	}

	if (realGlobalsPtr == IntPtr.Zero) {
		throw new Exception("No changing address found. Retrying...");
	}
#endregion

#region Inventory Scan
	var invBytes =
		"00 00 34 12"+ // SCI magic number 0x1234
		"00 00 40 00"+ // -size-
		"1E 00 ?? ??"+ // -propDict-
		"00 00 ?? ??"+ // -methDict-
		"00 00 1C 00"+ // -classScript-
		"00 00 FF FF"+ // -script-
		"1E 00 BB 07"+ // -super-   <-- getting all the instances of ScaryInventory
		"?? ?? ?? ??"+ // -info-
		"1E 00";       // <------------ name
		               // owner property at +(59 * 0x4)

	vars.invItems = new Dictionary<string, string> {
		{"invLibKey",    invBytes + "8A 15"},
		{"invMoney",     invBytes + "94 15"},
		{"invNail",      invBytes + "9D 15"},
		{"invNewspaper", invBytes + "A5 15"},
		{"invPoker",     invBytes + "B2 15"},
		{"invHammer",    invBytes + "BB 15"},
		{"invStairKey",  invBytes + "C5 15"},
		{"invVampBook",  invBytes + "D1 15"},
		{"invMatch",     invBytes + "DD 15"},
		{"invTarot",     invBytes + "E6 15"},
		{"invBrooch",    invBytes + "EF 15"},
		{"invPhoto",     invBytes + "F9 15"},
		{"invLensPiece", invBytes + "02 16"},
		{"invDrainCln",  invBytes + "0F 16"},
		{"invCrucifix",  invBytes + "1B 16"},
		{"invBeads",     invBytes + "27 16"},
		{"invSpellBook", invBytes + "30 16"},
		{"invXmasOrn",   invBytes + "3D 16"},
		{"invStone",     invBytes + "48 16"},
		{"invCutter",    invBytes + "51 16"},
		{"invDogBone",   invBytes + "5B 16"},
		{"invFigurine",  invBytes + "66 16"}
	};
	
	var invTrgs = new Dictionary<string, SigScanTarget>();
	
	foreach (var item in vars.invItems) {
		invTrgs[item.Key] = new SigScanTarget(0, item.Value);
	}
	
	var invPtrs = new Dictionary<string, IntPtr>();

	foreach (var trg in invTrgs) {
		print("Scanning for " + trg.Key + " address...");
		var ptr = vars.Scan(trg.Value);
		if (ptr == IntPtr.Zero) {
			throw new Exception("Failed to find pointer for " + trg.Key);
		}
		else {
			invPtrs[trg.Key] = ptr;
			print(trg.Key + " address = " + ptr.ToString("X"));
		}
	}
#endregion

#region Locals Part 1
	var locals =
			"?? 00 96 2C"+ // sChaseBegin
			"00 00 00 00"+
			"00 00 3E 17"+ // video 5950
			"00 00 00 00"+
			"00 00 00 00"+
			"00 00 00 00"+
			"00 00 00 00"+
			"00 00 ?? 00";

	// Put this in vars because we will only resolve it later
	vars.localsTrg = new SigScanTarget(0, locals);
#endregion

#region Watchers
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		// + 0x2 because, unlike objects, variables only use the last two bytes of the SCI address format (SSSS:OOOO)
		{ "Room",    new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr +  11 * 0x4 + 2)) }, 
		{ "Chapter", new MemoryWatcher<ushort>(new DeepPointer(realGlobalsPtr + 106 * 0x4 + 2)) }
	};
	
	foreach (var entry in invPtrs) {
		// owner property ~ item.properties[59]
		vars.Watchers[entry.Key] = new MemoryWatcher<short>(new DeepPointer(entry.Value + 59 * 0x4 + 0x2));
	};
#endregion

	vars.bFoundLocals = false;
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	current.room = vars.Watchers["Room"].Current;
	current.chapter = vars.Watchers["Chapter"].Current;

	if (current.room != old.room) {
		print("Room changed: " + old.room  + " -> " + current.room);
	}
	if (current.chapter != old.chapter) {
		print("Chapter changed: " + old.chapter  + " -> " + current.chapter);
	}

#region Locals Part 2
	// Start scanning for locals when in chapter 7 and entering the darkroom
	if (!vars.bFoundLocals && current.chapter == 7 && current.room == 45950) {
		var localsPtr = vars.Scan(vars.localsTrg);

		if (localsPtr != IntPtr.Zero) {
			vars.Watchers["Video"] = new MemoryWatcher<ushort>(new DeepPointer(localsPtr + 2 * 0x4 + 0x2));
			vars.bFoundLocals = true;
			print("Found locals at " + localsPtr.ToString("X"));
		}
	}
#endregion
}

reset {
	// Reset on main menu
	if (settings["ResetOnMainMenu"] && current.room == 91 && old.room != 91) {
		return true;
	}
}

start {
	if (old.room == 902 && current.room == 900) {
		return true;
	}
}

split {
	// End of game
	// When video 2640 is loaded into local variable [2] of script 40100
	// then the final cutscene is playing and the run is over
	if (settings["End"] && vars.bFoundLocals && current.room == 40100 && vars.Watchers["Video"].Current == 2640 && vars.Watchers["Video"].Changed) {
		return true;
	}
	// Chapter splits
	if (current.chapter > 1 && current.chapter == old.chapter + 1 && settings[current.chapter.ToString()]) {
		return true;
	}
	// Item splits
	if (settings["Items"]) { // no need to loop if the player doesn't have any item splits
		foreach (var item in vars.invItems.Keys) {
			// item.owner is -1 by default, and -2 when gEgo is the owner
			if (settings[item] && vars.Watchers[item].Current == -2 && vars.Watchers[item].Changed) {
				return true;
			}
		}
	}
}