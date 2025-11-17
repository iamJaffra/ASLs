state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("SCI");

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
	vars.ScummVM.Init();

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

#region Inventory Scan
	// I'm working on a more efficient replacement for this section

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

#region Watchers
	// + 0x2 because, unlike objects, variables only use the last two bytes of the SCI address format (SSSS:OOOO)
	var PTRSIZE = game.Is64Bit() ? 0x8 : 0x4;

	// Globals
	vars.ScummVM["room"] = vars.ScummVM.Watch<ushort>("_gamestate", "variables", 0 * PTRSIZE,  11 * 0x4 + 0x2);
	vars.ScummVM["chapter"] = vars.ScummVM.Watch<ushort>("_gamestate", "variables", 0 * PTRSIZE, 106 * 0x4 + 0x2);

	// Locals
	vars.ScummVM["video"] = vars.ScummVM.Watch<ushort>("_gamestate", "variables", 1 * PTRSIZE, 2 * 0x4 + 0x2);

	// Inventory Items
	vars.InventoryWatchers = new Dictionary<string, MemoryWatcher>();
	foreach (var entry in invPtrs) {
		// owner property ~ item.properties[59]
		vars.InventoryWatchers[entry.Key] = new MemoryWatcher<short>(new DeepPointer(entry.Value + 59 * 0x4 + 0x2));
	};
#endregion

	// vars.watching902 = false;
}

update {
	if (game.ReadPointer((IntPtr)vars.ScummVM.GEngine) == IntPtr.Zero) {
		var allComponents = timer.Layout.Components;
		if (timer.Run.AutoSplitter != null && timer.Run.AutoSplitter.Component != null) {
			allComponents = allComponents.Append(timer.Run.AutoSplitter.Component);
		}
		foreach (var component in allComponents) {
			var type = component.GetType();
			if (type.Name == "ASLComponent") {
				var script = type.GetProperty("Script").GetValue(component);
				script.GetType().GetField(
					"_game",
					BindingFlags.NonPublic | BindingFlags.Instance
				).SetValue(script, null);
			}
		}
	}

	vars.ScummVM.Update();

	foreach (var watcher in vars.InventoryWatchers.Values) {
		watcher.Update(game);
	}

	if (current.room != old.room) {
		print("Room changed: " + old.room  + " -> " + current.room);
	}
	if (current.chapter != old.chapter) {
		print("Chapter changed: " + old.chapter  + " -> " + current.chapter);
	}

	if (current.video != old.video && current.video != 0) {
		print("Current video: " + current.video);
	}

	/*
	if (vars.watching902 && current.room != 902) {
		vars.watching902 = false;
	}
	*/
}

reset {
	// Reset on main menu
	if (settings["ResetOnMainMenu"] && current.room == 91 && old.room != 91) {
		return true;
	}
}

start {
	if ((old.room == 902 && current.room == 900) ||
	    (old.room == 902 && current.room != 902 && current.room != 91 && current.room != 0)) {
		return true;
	}

	// When on the chapter select screen, iterate the heap segments to find script 902, 
	// then create a watcher for local 200 of said script.

	/*
	if (current.room == 902) {
		if (!vars.watching902) {
			var capacity = vars.ScummVM.Read<int>("_gamestate", "_segMan", "_heap", "_capacity");

			// Starting at 1 because the heap always starts with an empty segment
			for (int i = 1; i < capacity; i++) {
				var type = vars.ScummVM.Read<int>("_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_type")
				var nr = vars.ScummVM.Read<int>("_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_nr")
				
				if (type == 1 && nr == 902) {
					vars.ScummVM["clickedChapterSelectButton"] = vars.ScummVM.Watch<short>(
						"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_localsBlock", "_locals", 200 * 0x4 + 0x2
					);

					vars.watching902 = true;
					break;
				}
			}
		}
		else {
			return old.clickedChapterSelectButton == 0 && current.clickedChapterSelectButton == 1;
		}
	}
	*/
}

split {
	// End of game
	// When video 2640 is loaded into local variable [2] of script 40100
	// then the final cutscene is playing and the run is over
	if (settings["End"] && current.room == 40100 && current.video != old.video && current.video == 2640) {
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
			if (settings[item] && vars.InventoryWatchers[item].Current == -2 && vars.InventoryWatchers[item].Changed) {
				return true;
			}
		}
	}
}


/*

	var foundItems = new Dictionary<string, int>();
	var targetSet = new HashSet<string>(invItems);

	IntPtr 

	for (int i = 0; i < mask; i++) {
		string s = mask[i];
		if (targetSet.Contains(s)) {
			foundItems[s] = i;
		}
	}

	if (foundItems.Count != targetSet.Count) {
		var missing = targetSet.Except(foundItems.Keys);
		throw new Exception("Couldn't find addresses for: " + string.Join(", ", missing));
	}

	vars.InventoryWatchers = new Dictionary<string, MemoryWatcher>();
	foreach (var kv in foundItems) {
		var itemName = kv.Key;
		var index = kv.Value;

		// owner property ~ item.properties[59]
		vars.InventoryWatchers[itemName] = vars.ScummVM.Watch<short>(
			"_gamestate", "_segMan", "_heap", "_storage", index * PTRSIZE
			"", "", "", "", "", "" , 59 * 0x4 + 0x2
		);
	}

	// Inventory Items
	vars.InventoryWatchers = new Dictionary<string, MemoryWatcher>();
	foreach (var entry in invPtrs) {
		// owner property ~ item.properties[59]
		vars.InventoryWatchers[entry.Key] = new MemoryWatcher<short>(new DeepPointer(entry.Value + 59 * 0x4 + 0x2));
	};

*/