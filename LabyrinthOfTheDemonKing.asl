state("Shinigami-Win64-Shipping") {}

startup {
#region Splits and Settings
	vars.splittableTransitions = new List<string[]> {	
		new string[] { "ForestCave_001"               , "Castle_Exterior_Entrance_001"  , "Arrive at Castle Exterior"        },
		new string[] { "Castle_Exterior_Entrance_001" , "CastleKeep_T001_F001"          , "Enter Tower Of Repetition"        },
		new string[] { "CastleKeep_T001_B001"         , "CastleKeep_T001_F001"          , "Revive after collecting Red Gem"  },
		new string[] { "CastleKeep_T001_F003"         , "CastleKeep_T001_F001"          , "Revive after defeating Ubume"     },
		new string[] { "CastleKeep_Corridor_T1_T2"    , "Castle_Exterior_Courtyard_001" , "Exit Tower Of Repetition"         },
		new string[] { "CastleKeep_Corridor_T2_T3"    , "CastleKeep_T002_F001"          , "Enter Tower of Lamentation"       },
		new string[] { "CastleKeep_T002_WardenRoom"   , "SafeRoom_001"                  , "Teleport to Teahouse after defeating Nuppeppo" },
		new string[] { "CastleKeep_Corridor_T2_T3"    , "CastleKeep_T003_B001"          , "Enter Tower of Crushing Assembly" },
		new string[] { "CastleKeep_T003_F001"         , "CastleKeep_Corridor_T3_T4"     , "Exit room after defeating Warden" },
		new string[] { "CastleKeep_T004_Spiral"       , "CastleKeep_T004_Stage"         , "Enter final boss room"            },
	};

	vars.splittableItems = new Dictionary<string, string> {
		// Tower of Repetition
		{ "DoorPiece_T1F1_001"      , "Strange Gem (Black)" },
		{ "DoorPiece_T1F1_002"      , "Strange Gem (Blue)"  },
		{ "DoorPiece_T1F1_003"      , "Strange Gem (Red)"   },
		{ "DoorPiece_T1F1_004"      , "Strange Gem (White)" },
		{ "Katana_004"              , "Rusty Katana"        },
		{ "T1F1_ButsudanStatue_001" , "Buddha Statue from butsudan" },
		{ "key_002"                 , "Pantry Key"          },
		{ "salt_sack"               , "Salt"                },
		{ "biwa_001"                , "Biwa"           },

		// Tower of Lamentation
		{ "water_puzzle_wheel_005"       , "Brown Gem Wheel"      },
		{ "water_puzzle_wheel_006_inner" , "Rusted Wheel - Inner" },
		{ "water_puzzle_wheel_003"       , "Yellow Gem Wheel"     },
		{ "water_puzzle_wheel_006_ring"  , "Rusted Wheel - Outer" },
		
		// Tower of Crushing Assembly
		{ "meathook_001"     , "Meat Hook"         },
		{ "hangmanrope_001"  , "Hanged Man's Rope" },
		{ "key_WardenChest"  , "Warden's Key"      },
		{ "bellHammer_001"   , "Bell Hammer"       },
	};

	vars.splittableCutscenes = new Dictionary<string, string> {
		{ "Intro_Nuribotoke_001" , "Nuribotoke appears" },
		{ "Death_Ubume_001"      , "Ubume dies"         },
		{ "Death_Nuppeppo_001"   , "Nuppeppo dies"      },
		{ "Death_Warden_001"     , "Warden dies"        },
	};
	
	settings.Add("StartNewGame", true, "Start timer on starting a New Game from the main menu");

	settings.Add("Transitions", false, "Split on transitions");
	foreach (var transition in vars.splittableTransitions) {
		settings.Add(transition[0] + " -> " + transition[1], false, transition[2], "Transitions");
	};

	settings.Add("Items", false, "Split on collecting items");
	foreach (var item in vars.splittableItems) {
		settings.Add(item.Key, false, item.Value, "Items");
	};

	settings.Add("Cutscenes", false, "Split on cutscenes");
	foreach (var cutscene in vars.splittableCutscenes) {
		settings.Add(cutscene.Key, false, cutscene.Value, "Cutscenes");
	};

	settings.Add("Credits", true, "Split on End Credits");

	settings.Add("ResetMainMenu", true, "Reset timer on main menu");
#endregion
}

init {
#region Scans
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);
	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);

	var gWorldTrg = new SigScanTarget(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01") { OnFound = onFound };
	var gWorld = scanner.Scan(gWorldTrg);
	vars.gWorld = gWorld;

	var gEngineTrg = new SigScanTarget(3, "48 8B 0D ???????? 66 0F 5A C9 E8") { OnFound = onFound };
	var gEngine = scanner.Scan(gEngineTrg);

	var fNamePoolTrg = new SigScanTarget(7, "8B D9 74 ?? 48 8D 15 ???????? EB") { OnFound = onFound };
	// Demo:
	// var fNamePoolTrg = new SigScanTarget(13, "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15") { OnFound = onFound };
	var fNamePool = scanner.Scan(fNamePoolTrg);

	if (fNamePool == IntPtr.Zero || gWorld == IntPtr.Zero || gEngine == IntPtr.Zero ) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}
#endregion	

#region FNameToString()
	var fNamePoolCache = new Dictionary<ulong, string>() {{0, "None"}};

	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var number     = (fName & 0xFFFFFFFF00000000) >> 0x20;
		var nameLookup = (fName & 0x00000000FFFFFFFF) >> 0x00;

		string name;
		if (fNamePoolCache.ContainsKey(nameLookup)) {
			name = fNamePoolCache[nameLookup];
		} 
		else {
			var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
			var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;

			var chunk = game.ReadPointer(fNamePool + 0x10 + (int)chunkIdx * 0x8);
			var nameEntry = chunk + (int)nameIdx * 0x2;

			var length = game.ReadValue<short>(nameEntry) >> 6;
			name = game.ReadString(nameEntry + 0x2, length);

			fNamePoolCache[nameLookup] = name;
		}

		return number == 0 ? name : name + "_" + number;
	});
#endregion

#region Watchers
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		// GWorld.FName
		{ "GWorldFName"      , new MemoryWatcher<ulong>(new DeepPointer(gWorld, 0x18)) },

		// GEngine.GameInstance.LoadingFrom...
		{ "LoadingFromDoor"  , new MemoryWatcher<bool>(new DeepPointer(gEngine, 0xD28, 0x464)) }, // demo: 0x43C
		{ "LoadingFromSave"  , new MemoryWatcher<bool>(new DeepPointer(gEngine, 0xD28, 0x465)) }, // demo: 0x43D
		{ "LoadingFromDeath" , new MemoryWatcher<bool>(new DeepPointer(gEngine, 0xD28, 0x466)) }, // demo: 0x43E

		// GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.CurrentOpenWidget==PrerenderedCutscene.CutsceneToPlay.URL
		{ "Cutscene"         , new StringWatcher(new DeepPointer(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x9E8, 0x288, 0x88, 0x0), 200) },

		// GEngine.GameInstance.LocalPlayers[0].PlayerController.Character.InventoryComponent.InventoryArray
		{ "Inventory"        , new MemoryWatcher<ulong>(new DeepPointer(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x628, 0xC0)) },
		{ "NumberOfItems"    , new MemoryWatcher<int>(new DeepPointer(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x628, 0xC0 + 0x8)) },
	};
#endregion

	vars.completedSplits = new HashSet<string>();
	vars.foundMainMenu = false;
	vars.triggeredFinalCutscene = false;
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}
	
	var world = vars.FNameToString(vars.Watchers["GWorldFName"].Current);

	if (world != "None") {
		current.world = world;
	}

	if (current.world != old.world) {
		print("World transition: " + old.world + " -> " + current.world);
	}

	// Find UI_MainMenu widget and create watcher for fade animation
	if (current.world == "MainMenu") {
		if (!vars.foundMainMenu) {
			// GWorld.PersistentLevel.LevelScriptActor.??TMap
			// contains a reference to UI_MainMenu_C somewhere
			var mapPtr = new DeepPointer(vars.gWorld, 0x30, 0xE8, 0x228).Deref<IntPtr>(game);

			for (int i = 0; i < 10; i++) {
				var fName = new DeepPointer(mapPtr + i * 0x8, 0x18).Deref<ulong>(game);
				var name = vars.FNameToString(fName);
				
				if (name.StartsWith("UI_MainMenu_C")) {
					// GWorld.PersistentLevel.LevelScriptActor.??TMap[].UI_MainMenu.ActiveSequencePlayers[0].Animation.FName
					vars.fadeFName = new MemoryWatcher<ulong>(new DeepPointer(vars.gWorld, 0x30, 0xE8, 0x228, i * 0x8, 0x1A0, 0x0, 0x260, 0x18));
					vars.foundMainMenu = true;					
					break;
				}
			}
		}
	}	
}

start {
	// Start timer on starting a new game from the main menu
	if (settings["StartNewGame"] && vars.foundMainMenu) {
		vars.fadeFName.Update(game);
		var fade = vars.FNameToString(vars.fadeFName.Current);
		if (fade == "StartNewGame_INST") {
			return true;
		}
	}
}

onStart {
	vars.completedSplits.Clear();
	vars.foundMainMenu = false;
	vars.triggeredFinalCutscene = false;
}

reset {
	return settings["ResetMainMenu"] && current.world == "MainMenu" && old.world != "MainMenu";
}

split {
	// Final split 
	if (current.world == "ForestCave_002" && settings["Credits"] && !vars.triggeredFinalCutscene) {
		if (Path.GetFileNameWithoutExtension(vars.Watchers["Cutscene"].Current) == "FinalCredits") {
			vars.triggeredFinalCutscene = true;
			return true;
		}
	}
	
	// World transition splits
	if (current.world != old.world) {
		foreach (var transition in vars.splittableTransitions) {
			if (old.world == transition[0] && current.world == transition[1]) {
				var trns = transition[0] + " -> " + transition[1];
				if (settings.ContainsKey(trns) && settings[trns]) {
					print("Split due to transition: " + old.world + " -> " + current.world);
					return true;
				}
			}
		}
	}
	
	// Item splits
	if (settings["Items"] && current.world != "MainMenu") {
		for(int i = 0; i < vars.Watchers["NumberOfItems"].Current; i++) {
			var itemFName = game.ReadValue<ulong>((IntPtr)vars.Watchers["Inventory"].Current + i * 0x10);
			var item = vars.FNameToString(itemFName);
			if (settings.ContainsKey(item) && settings[item] && !vars.completedSplits.Contains(item)) {
				print("Split due to collecting item: " + item);
				vars.completedSplits.Add(item);
				return true;
			}
		}
	}

	// Cutscene splits
	if (vars.Watchers["Cutscene"].Changed) {
		var cutscene = Path.GetFileNameWithoutExtension(vars.Watchers["Cutscene"].Current);
		if (settings.ContainsKey(cutscene) && settings[cutscene] && !vars.completedSplits.Contains(cutscene)) {
			print("Split due to cutscene: " + cutscene);
			vars.completedSplits.Add(cutscene);
			return true;
		}
	}
}

isLoading {
	return vars.Watchers["LoadingFromDoor"].Current 
	    || vars.Watchers["LoadingFromSave"].Current 
	    || vars.Watchers["LoadingFromDeath"].Current
	    || current.world == "None";
}
