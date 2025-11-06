state("Gothic-Win64-Shipping") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();

	vars.splitData = new Dictionary<string, Tuple<string, string, string>> { 
		{ "Ch6_EnterSleeperTemple", 
			Tuple.Create("World",        "Orc_Tempel",           "Enter the Sleeper Temple.") 
		},
		{ "Ch6_Sword1", 
			Tuple.Create("Item",         "BP_Lichtbringer_C",    "Collect 1st Priest's Sword.") 
		}, 
		{ "Ch6_Sword2", 
			Tuple.Create("Item",         "BP_Weltenspalter_C",   "Collect 2nd Priest's Sword.") 
		}, 
		{ "Ch6_Sword3", 
			Tuple.Create("Item",         "BP_Zeitenklinge_C",    "Collect 3rd Priest's Sword.") 
		}, 
		{ "Ch6_Sword4", 
			Tuple.Create("Item",         "BP_Daemonenstreich_C", "Collect 4th Priest's Sword.") 
		}, 
		{ "Ch6_Sword5", 
			Tuple.Create("Item",         "BP_Bannklinge_C",      "Collect 5th Priest's Sword.") 
		}, 
		{ "Ch6_Ending",
			Tuple.Create("Ending",       "",                     "Trigger the Ending Cutscene.") 
		},
	};

	/*
	for (int i = 2; i < 7; i++) {
		string chapterNum = i.ToString();
		vars.splitData["Ch" + chapterNum + "_StartChapter"] = Tuple.Create(
			"Chapter", chapterNum, "Start Chapter " + chapterNum + ".");
	} 
	*/

	settings.Add("Main", false, "Any% Splits");
	//settings.Add("Chapter 6", true, "Chapter 6", "Main");
	/*
	for (int i = 1; i < 7; i++) {
		string chapter = "Chapter " + i.ToString();
		settings.Add(chapter, true, chapter, "Main");
	}
	*/

	foreach (var kv in vars.splitData) {
		var splitName = kv.Key;
		var splitDesc = kv.Value.Item3;
		
		settings.Add(splitName, true, splitDesc, "Main");
	}

	vars.Info = (Action<string>)((msg) => {
		print("[Gothic 1 Remaster ASL] " + msg);
	});

	vars.completedSplits = new HashSet<string>();
	vars.TimerModel = new TimerModel { CurrentState = timer };
	vars.timerPaused = false;
}

init {
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);
	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
	
	var gNamesTrg = new SigScanTarget(7, "8B D9 74 ?? 48 8D 15 ???????? EB") { OnFound = onFound };
	var gEngineTrg = new SigScanTarget(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24") { OnFound = onFound };
	var gWorldTrg = new SigScanTarget(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01" ) { OnFound = onFound };

	var gNames = scanner.Scan(gNamesTrg);
	var gEngine = scanner.Scan(gEngineTrg);
	var gWorld = scanner.Scan(gWorldTrg);
	
	if (gNames == IntPtr.Zero || gEngine == IntPtr.Zero || gWorld == IntPtr.Zero) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}

	var gNamesCache = new Dictionary<ulong, string>() {{0, "None"}};
	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var number     = (fName & 0xFFFFFFFF00000000) >> 0x20;
		var nameLookup = (fName & 0x00000000FFFFFFFF) >> 0x00;

		string name;
		if (gNamesCache.ContainsKey(nameLookup)) {
			name = gNamesCache[nameLookup];
		} 
		else {
			var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
			var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;

			var chunk = game.ReadPointer(gNames + 0x10 + (int)chunkIdx * 0x8);
			var nameEntry = chunk + (int)nameIdx * 0x2;

			var length = game.ReadValue<short>(nameEntry) >> 6;
			name = game.ReadString(nameEntry + 0x2, length);

			gNamesCache[nameLookup] = name;
		}

		return name;
		//return number == 0 ? name : name + "_" + number;
	});

	vars.PlayerHasItem = (Func<string, bool>)((item) => {		
		IntPtr inventoryComponentPtr = (IntPtr)
			new DeepPointer(
				gEngine, 
				0x10A8,    // GameInstance
				0x38,      // LocalPlayers
				0 * 0x8,   // [0] (LocalPlayer)
				0x30,      // PlayerController
				0x338,     // AcknowledgedPawn
				0x6B8      // InventoryComponent
			)
			.Deref<ulong>(game);

		IntPtr slotsPtr = (IntPtr)
			game.ReadValue<ulong>(
				inventoryComponentPtr
				+ 0x260     // Slots
			);
		
		var slotsNum = 
			game.ReadValue<int>(
				inventoryComponentPtr
				+ 0x260    // Slots
				+ 0x8      // ArrayNum
			);

		for (int i = 0; i < slotsNum; i++) {
			IntPtr slotPtr = (IntPtr)game.ReadValue<ulong>(slotsPtr + i * 0x60);
			if (slotPtr == IntPtr.Zero) continue;

			var idFName = game.ReadValue<ulong>(slotPtr + 0x18);
			var id = vars.FNameToString(idFName);

			if (item == id) {
				return true;
			}
		}

		return false;
	});

	vars.QuestState = (Func<string, int>)((quest) => {
		IntPtr questsPtr = (IntPtr)
			new DeepPointer(
				gEngine, 
				0x10A8,    // GameInstance
				0x38,      // LocalPlayers
				0 * 0x8,   // [0] (LocalPlayer)
				0x30,      // PlayerController
				0x868,     // Quest Component
				0xA8       // Quests
			)
			.Deref<ulong>(game);

		var questsArraySize = 
			new DeepPointer(
				gEngine, 
				0x10A8,    // GameInstance
				0x38,      // LocalPlayers
				0 * 0x8,   // [0] (LocalPlayer)
				0x30,      // PlayerController
				0x868,     // Quest Component
				0xA8       // Quests
				+ 0x8      // Num
			)
			.Deref<int>(game);

		for (int i = 0; i < questsArraySize; i++) { 
			IntPtr questPtr = (IntPtr)game.ReadValue<ulong>(questsPtr + (i * 0x50));

			var idFName = new DeepPointer(questPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			if (id == quest) {
				return new DeepPointer(questsPtr + i * 0x50 + 0x13).Deref<byte>(game);
			}
		}

		return -1;
	});

	vars.IsInDialogue = (Func<string, bool>)((npc) => {
		var actorPtr = (IntPtr) new DeepPointer(
			gEngine, 
			0x10A8,  // GameInstance
			0x38,    // LocalPlayers
			0 * 0x8, // [0] (LocalPlayer)
			0x30,    // PlayerController
			0x338,   // AcknowledgedPawn
			0xBB8    // TargetActor
		)
		.Deref<ulong>(game);

		var actor = new DeepPointer(
			actorPtr 
			+ 0x6F0  // NPC_Info
			+ 0x88,  // NPC_Name
			0x28,    // DisplayString
			0x0
		)
		.DerefString(game, ReadStringType.UTF16, 64);

		if (actor == npc) {
			var state = game.ReadValue<byte>(actorPtr + 0xB99); // ~some unreflected byte that seems to work~

			if (state == 1) {
				return true;
			}
		}
		
		return false;
	});

	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		{ "Loading",
			new MemoryWatcher<int>(new DeepPointer(
				gEngine, 
				0x10A8,  // GameInstance
				0x108,   // ~GameInstanceSubsystems~
				0x20,    // [2].Value (SaveGameSubsystem)
				0x2F8,   // LoadScreen
				0x100,   // ~fuck knows~
				0x8      // ~counts things?~
			)) 
		},
		{ "GWorldFName",
			new MemoryWatcher<ulong>(new DeepPointer(
				gWorld,
				0x18     // NamePrivate
			)) 
		},	
		{ "Focus",
			new StringWatcher(new DeepPointer(
				gEngine, 
				0x10A8,  // GameInstance
				0x38,    // LocalPlayers
				0 * 0x8, // [0] (LocalPlayer)
				0x30,    // PlayerController
				0x870,   // InteractComponent
				0xB0     // InteractInfo
				+ 0x0,   // Focus
				0x6F0    // NPC_Info
				+ 0x88,  // NPC_Name
				0x28,    // DisplayString
				0x0
			), ReadStringType.UTF16, 64)
		},
		{ "InDialogue",
			new MemoryWatcher<bool>(new DeepPointer(
				gEngine, 
				0x10A8,  // GameInstance
				0x38,    // LocalPlayers
				0 * 0x8, // [0] (LocalPlayer)
				0x30,    // PlayerController
				0x338,   // AcknowledgedPawn
				0xB99    // ~some unreflected byte that seems to work~
			))
		},	
		{ "NewGame()",
			new MemoryWatcher<ulong>(new DeepPointer(
				vars.Events.FunctionFlag("W_MainMenu_C", "W_MainMenu_C", 
					"BndEvt__W_MainMenu_W_NEWGAME_K2Node_ComponentBoundEvent_4_On Clicked__DelegateSignature"
				)
			)) 
		},
		{ "StartMovie()",
			new MemoryWatcher<ulong>(new DeepPointer(
				vars.Events.FunctionFlag("W_Movies_C", "W_Movies_C", "Start")
			)) 
		},	
		{ "OnAddItem()",
			new MemoryWatcher<ulong>(new DeepPointer(
				vars.Events.FunctionFlag("W_Message_Widget_C", "W_Message_Widget", "On Add Item")
			)) 
		},	
		{ "Message()",
			new MemoryWatcher<ulong>(new DeepPointer(
				vars.Events.FunctionFlag("W_Message_Widget_C", "W_Message_Widget", "AddMessage")
			)) 
		},		
		{ "Chapter",
			new MemoryWatcher<int>(new DeepPointer(
				vars.Events.InstancePtr("W_Chepter_C", "W_Chepter_C"),
				0x318  // Chapter Number
			)) 
		},	
	};

#region Splits
	var splits = new Dictionary<string, Func<bool>>();

	foreach (var kv in (Dictionary<string, Tuple<string, string, string>>)vars.splitData) {
		var splitName = kv.Key;
		var type = kv.Value.Item1;
		var arg = kv.Value.Item2;

		if (type == "StartQuest") {
			splits[splitName] = () => vars.Watchers["Message()"].Changed && vars.Watchers["Message()"].Current != 0 &&
			                          vars.QuestState(arg) == 0;
		}
		else if (type == "FinishQuest") {
			splits[splitName] = () => vars.Watchers["Message()"].Changed && vars.Watchers["Message()"].Current != 0 &&
			                          vars.QuestState(arg) == 1;
		}
		else if (type == "Item") {
			splits[splitName] = () => vars.Watchers["OnAddItem()"].Changed && vars.Watchers["OnAddItem()"].Current != 0 &&
			                          vars.PlayerHasItem(arg);
		}
		else if (type == "Dialogue") {
			splits[splitName] = () => vars.Watchers["InDialogue"].Current && vars.IsInDialogue(arg);
		}
		else if (type == "World") {
			splits[splitName] = () => vars.FNameToString(vars.Watchers["GWorldFName"].Current) == arg;
		}
		else if (type == "Ending") {
			splits[splitName] = () => vars.FNameToString(vars.Watchers["GWorldFName"].Current) == "Orc_Tempel" && 
									  vars.Watchers["StartMovie()"].Changed && vars.Watchers["StartMovie()"].Current != 0;
		}
	}

	vars.splits = splits;
#endregion

	current.world = "";
	vars.loadingScreen = false;
}

start {
	return false;
}
reset {
	return false;
}
onStart {
	vars.completedSplits.Clear();
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	var world = vars.FNameToString(vars.Watchers["GWorldFName"].Current);
	if (!string.IsNullOrEmpty(world) && world != "None") {
		current.world = world;
	}
	
	if (old.world != current.world) {
		vars.Info("World: " + old.world + " -> " + current.world);
	}

	if (vars.Watchers["Loading"].Changed) {
		vars.Info("Loading: " + vars.Watchers["Loading"].Current);
	}
	
	if (vars.Watchers["Chapter"].Changed) {
		vars.Info("Chapter -> " + vars.Watchers["Chapter"].Current);
	}

	if (vars.Watchers["Focus"].Changed) {
		vars.Info("Focus -> " + vars.Watchers["Focus"].Current);
	}

	if (vars.Watchers["InDialogue"].Changed) {
		vars.Info("InDialogue -> " + vars.Watchers["InDialogue"].Current);
	}

	// CRASH HANDLING
	if (vars.timerPaused) {
		if (current.world != "" && current.world != "L_MainMenu") { 	
			if (vars.Watchers["Loading"].Changed && vars.Watchers["Loading"].Current == 0) {
				vars.timerPaused = false;
			}
		}
	}

	// START/RESET
	if (vars.Watchers["NewGame()"].Changed && vars.Watchers["NewGame()"].Current != 0) {
		var phase = timer.CurrentPhase;
		bool startEnabled = settings.StartEnabled;
		bool resetEnabled = settings.ResetEnabled;
		
		if (phase == TimerPhase.NotRunning && startEnabled) {
			timer.IsGameTimePaused = true;
			
			vars.TimerModel.Start();
		}
		else if (phase == TimerPhase.Running && resetEnabled) {
			vars.TimerModel.Reset();

			if (startEnabled) {
				timer.IsGameTimePaused = true;
				
				vars.TimerModel.Start();
			}
		}
	}
}

isLoading {
	return vars.Watchers["Loading"].Current > 0 || vars.timerPaused;
}

exit {
	timer.IsGameTimePaused = true;
	vars.timerPaused = true;
}

split {
	foreach (var kv in vars.splits) {
		var splitName = kv.Key;
		var condition = kv.Value;

		if (settings[splitName] && !vars.completedSplits.Contains(splitName) && condition()) {
			vars.completedSplits.Add(splitName);
			vars.Info("SPLIT: " + splitName);
			return true;
		}
	}
}