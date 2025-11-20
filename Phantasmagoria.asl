state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("SCI");

	vars.ScummVM.LogChangedWatchers();
	//vars.ScummVM.LogResolvedPaths();

	settings.Add("ResetOnMainMenu", true, "Reset timer on main menu");

	settings.Add("Splits", true, "Splits");
		//
		settings.Add("Chapter 1", true, "Chapter 1", "Splits");
			settings.Add("invMatch", false, "Match", "Chapter 1");
			settings.Add("invPoker", false, "Poker", "Chapter 1");
			settings.Add("invHammer", false, "Hammer", "Chapter 1");
			settings.Add("invLibKey", false, "Library Key", "Chapter 1");
			settings.Add("invFigurine", false, "Figurine (Letter Opener)", "Chapter 1");
		//
		settings.Add("Chapter 2", true, "Chapter 2", "Splits");
			settings.Add("2", true, "Start Chapter 2", "Chapter 2");
			settings.Add("invMoney", false, "Money", "Chapter 2");
			settings.Add("invDrainCln", false, "Drain Cleaner", "Chapter 2");
			settings.Add("invDogBone", false, "Dog Bone", "Chapter 2");
		//
		settings.Add("Chapter 3", true, "Chapter 3", "Splits");
			settings.Add("3", true, "Start Chapter 3", "Chapter 3");
			settings.Add("invNail", false, "Nail", "Chapter 3");
			settings.Add("invStairKey", false, "Stair Key", "Chapter 3");
			settings.Add("invVampBook", false, "Vampire Book", "Chapter 3");
		//
		settings.Add("Chapter 4", true, "Chapter 4", "Splits");
			settings.Add("4", true, "Start Chapter 4", "Chapter 4");
			settings.Add("invLensPiece", false, "Lens", "Chapter 4");
			settings.Add("invBrooch", false, "Brooch", "Chapter 4");
		//
		settings.Add("Chapter 5", true, "Chapter 5", "Splits");
			settings.Add("5", true, "Start Chapter 5", "Chapter 5");
			settings.Add("invPhoto", false, "Photo", "Chapter 5");
		//
		settings.Add("Chapter 6", true, "Chapter 6", "Splits");
			settings.Add("6", true, "Start Chapter 6", "Chapter 6");
			settings.Add("invCrucifix", false, "Crucifix", "Chapter 6");
		//
		settings.Add("Chapter 7", true, "Chapter 7", "Splits");
			settings.Add("7", true, "Start Chapter 7", "Chapter 7");
			settings.Add("invCutter", false, "Glass Shard", "Chapter 7");
			settings.Add("invXmasOrn", false, "Snowman", "Chapter 7");
			settings.Add("invSpellBook", false, "Spell Book", "Chapter 7");
			settings.Add("invStone", false, "Stone", "Chapter 7");
			settings.Add("End", true, "Trigger Final Cutscene", "Chapter 7");
		
		// not used in the run
		// settings.Add("invNewspaper", false, "Newspaper", "Items");
		// settings.Add("invTarot", false, "Tarot", "Items");
		// settings.Add("invBeads", false, "Beads", "Items");

		vars.Info = (Action<string>)((msg) => {
			print("[Phantasmagoria ASL] " + msg);
		});
}

init {
	vars.ScummVM.Init();

#region Inventory Scan
	vars.itemNames = new Dictionary<int, string> {
		{ 0x158A001E, "invLibKey"    },
		{ 0x1594001E, "invMoney"     },
		{ 0x159D001E, "invNail"      },
		//{ 0x15A5001E, "invNewspaper" },
		{ 0x15B2001E, "invPoker"     },
		{ 0x15BB001E, "invHammer"    },
		{ 0x15C5001E, "invStairKey"  },
		{ 0x15D1001E, "invVampBook"  },
		{ 0x15DD001E, "invMatch"     },
		//{ 0x15E6001E, "invTarot"     },
		{ 0x15EF001E, "invBrooch"    },
		{ 0x15F9001E, "invPhoto"     },
		{ 0x1602001E, "invLensPiece" },
		{ 0x160F001E, "invDrainCln"  },
		{ 0x161B001E, "invCrucifix"  },
		//{ 0x1627001E, "invBeads"     },
		{ 0x1630001E, "invSpellBook" },
		{ 0x163D001E, "invXmasOrn"   },
		{ 0x1648001E, "invStone"     },
		{ 0x1651001E, "invCutter"    },
		{ 0x165B001E, "invDogBone"   },
		{ 0x1666001E, "invFigurine"  } 
	};

	int PTRSIZE = game.Is64Bit() ? 0x8 : 0x4;

	var foundItems = new Dictionary<int, int>();

	var capacity = vars.ScummVM.Read<int>(
		"_gamestate", "_segMan", "_heap", "_capacity"
	);

	int segmentIndex = 0;

	for (int i = 1; i < capacity; i++) {
		var type = vars.ScummVM.Read<int>(
			"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_type"
		);
		var nr = vars.ScummVM.Read<int>(
			"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_nr"
		);

		//vars.Info("Type: " + type + ", Nr: " + nr);

		if (type == 1 && nr == 28) {
			vars.Info("Found Script 28.");
			// Now look for the inventory objects
			segmentIndex = i;

			vars.Info("Locating inventory objects...");

			int mask = vars.ScummVM.Read<int>(
				"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_objects", "_mask"
			);

			for (int j = 0; j < mask; j++) {
				int name = vars.ScummVM.Read<int>(
					"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_objects", "_storage", j * PTRSIZE, "_value", "_name"
				);
				if (vars.itemNames.ContainsKey(name)) {
					foundItems[name] = j;				
					vars.Info("Found item: " + vars.itemNames[name]);
				}
			}

			break;
		}
	}
#endregion

#region Watchers
	vars.InventoryWatchers = new Dictionary<string, MemoryWatcher>();
	foreach (var kv in vars.itemNames) {
		string itemName = kv.Value;

		int index;
		if (!foundItems.TryGetValue(kv.Key, out index)) {
			throw new Exception("String " + itemName + " not found.");
		}
		
		// owner property at +(59 * 0x4)
		// owner is -1 by default, and -2 when gEgo is the owner
		vars.InventoryWatchers[itemName] = vars.ScummVM.Watch<short>(
			"_gamestate", "_segMan", "_heap", "_storage", segmentIndex * PTRSIZE, "_objects", "_storage", index * PTRSIZE, "_value", "_variables", "_storage", 59 * 0x4 + 0x2
		);
	}

	// + 0x2 because, unlike objects, variables only use the last two bytes of
	// the SCI address format (SSSS:OOOO)
	
	// Globals
	vars.ScummVM["room"] = vars.ScummVM.Watch<ushort>(
		"_gamestate", "variables", 0 * PTRSIZE,  11 * 0x4 + 0x2
	);
	vars.ScummVM["chapter"] = vars.ScummVM.Watch<ushort>(
		"_gamestate", "variables", 0 * PTRSIZE, 106 * 0x4 + 0x2
	);

	// Locals
	vars.ScummVM["video"] = vars.ScummVM.Watch<ushort>(
		"_gamestate", "variables", 1 * PTRSIZE, 2 * 0x4 + 0x2
	);
#endregion

	vars.completedSplits = new HashSet<string>();
	vars.watching902 = false;
}

update {
	vars.ScummVM.Update();

	foreach (var watcher in vars.InventoryWatchers.Values) {
		watcher.Update(game);
	}
	
	if (vars.watching902 && current.room != 902) {
		vars.watching902 = false;
	}	
}

reset {
	// Reset on main menu
	if (settings["ResetOnMainMenu"] && current.room == 91 && old.room != 91) {
		return true;
	}
}

start {
	// When on the chapter select screen, go through the heap segments 
	// to find script 902, then create a watcher for local 200 of said script.

	int PTRSIZE = game.Is64Bit() ? 0x8 : 0x4;
	
	if (current.room == 902) {
		if (!vars.watching902) {
			var capacity = vars.ScummVM.Read<int>(
				"_gamestate", "_segMan", "_heap", "_capacity"
			);

			// Starting at 1 because the first segment is always empty.
			for (int i = 1; i < capacity; i++) {
				var type = vars.ScummVM.Read<int>(
					"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_type"
				);
				var nr = vars.ScummVM.Read<int>(
					"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_nr"
				);
				
				if (type == 1 && nr == 902) {
					vars.ScummVM["clickedChapterSelectButton"] = 
						vars.ScummVM.Watch<short>(
							"_gamestate", "_segMan", "_heap", "_storage", i * PTRSIZE, "_localsBlock", "_locals", "_storage", 200 * 0x4 + 0x2
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
}

onStart {
	vars.completedSplits.Clear();
}

split {
	// End of game
	if (settings["End"] && current.room == 40100 && current.video != old.video && (current.video == 2640 || current.video == 2630)) {
		vars.Info("Split: Triggered final cutscene.");
		return true;
	}
	// Chapter splits
	if (current.chapter > 1 && current.chapter == old.chapter + 1 && settings[current.chapter.ToString()]) {
		vars.Info("Split: Changed chapter.");
		return true;
	}
	// Item splits
	foreach (var item in vars.itemNames.Values) {
		// item.owner is -1 by default, and -2 when gEgo is the owner
		if (settings[item] && vars.InventoryWatchers[item].Changed && vars.InventoryWatchers[item].Current == -2 && vars.completedSplits.Add(item)) {
			vars.Info("Split: Picked up " + item);
			return true;
		}
	}
}
