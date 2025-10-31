state("G1R-Win64-Shipping") {}

startup {
#region Splits and Settings
	/* 
	// Full Game Splits

	vars.splitData = new Dictionary<string, Tuple<string, string, string>> { 
		{ "Ch1_Beer", 
			Tuple.Create("Item",         "ItFo_Potion_Beer",            "Collect beer."                      ) 
		}, 
		{ "Ch1_Beer_Finish", 
			Tuple.Create("FinishQuest",  "Quest_Main_G1RDemo_OrryBeer", "Complete Orry's beer quest."        ) 
		},
		{ "Ch1_TalkToKirgo", 
			Tuple.Create("Dialogue",     "G1R_Demo_0050_OC_Kirgo_0050", "Talk to Kirgo."                     ) 
		}, 
		{ "Ch1_Kirgo", 
			Tuple.Create("Kill",         "G1R_Demo_0050_OC_Kirgo_0050", "Kill Kirgo."                        ) 
		},
		{ "Ch1_EnterFreeMine", 
			Tuple.Create("World",        "G1R_FreeMineMap",             "Enter the Free Mine."               ) 
		},
		{ "Ch1_ExitFreeMine",
			Tuple.Create("ExitFreeMine", "",                            "Exit the Free Mine."                ) 
		},
	};

	for (int i = 2; i < 7; i++) {
		string chapterNum = i.ToString();
		vars.splitData["Ch" + chapterNum + "_StartChapter"] = Tuple.Create(
			"Chapter", chapterNum, "Start Chapter " + chapterNum + ".");
	} 

	settings.Add("Main", false, "Main Splits");

	for (int i = 1; i < 7; i++) {
		string chapter = "Chapter " + i.ToString();
		settings.Add(chapter, true, chapter, "Main");
	}

	foreach (var kv in vars.splitData) {
		var splitName = kv.Key;
		var splitDesc = kv.Value.Item3;
		
		if (splitName.StartsWith("Ch") && splitName.Length > 2 && char.IsDigit(splitName[2])) {
			settings.Add(splitName, true, splitDesc, "Chapter " + splitName[2]);
		}
	}
	*/
	
	vars.splitData = new Dictionary<string, Tuple<string, string, string>>();

	// Nyras Prologue Splits

	vars.splitDataNyrasPrologue = new Dictionary<string, Tuple<string, string, string>> {
		{ "Nyras_TalkToDrax", 
			Tuple.Create("Dialogue",            "G1R_Demo_0040_NC_Drax_0040", "Talk to Drax."             ) 
		}, 
		{ "Nyras_MysteriousNote", 
			Tuple.Create("Item",                "ItWr_Scroll_Mysteriousnote", "Find the mysterious note." ) 
		},
		{ "Nyras_End", 
			Tuple.Create("FinishNyrasPrologue", "",                           "Finish the demo."          ) 
		},
	};

	settings.Add("Nyras", false, "Nyras Prologue Splits");

	foreach (var kv in vars.splitDataNyrasPrologue) {
		var splitName = kv.Key;
		var splitDesc = kv.Value.Item3;
		
		settings.Add(splitName, true, splitDesc, "Nyras");
	}
#endregion

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
		var timingMessage = MessageBox.Show (
			"[Diego] I'm Diego. \n"+ 
			"[You] I'm... \n"+ 
			"[Diego] I'm not interested in who you are. \n"+ 
			"[Diego] Your Livesplit is set to Real Time (RTA), \n"+
			"[Diego] but this game uses Load Removed Time (LRT). \n"+
			"[Diego] Would you like to switch to Game Time?",
			"LiveSplit | Gothic 1 Remake",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		
		if (timingMessage == DialogResult.Yes) {
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}

	vars.Info = (Action<string>)((msg) => {
		print("[Gothic 1 Remake ASL] " + msg);
	});

	// Flags
	vars.completedSplits = new HashSet<string>();
	vars.timerPaused = false;

	// List of in-world maps
	vars.worlds = new HashSet<string> {
		"G1R_MainMap",
		"G1RNyrasPrologue_MainMap",
		"G1R_SleeperTemple",
		"G1R_OrcGraveyard",
		"G1R_OrcCity",
		"G1R_OldMine",
		"G1R_NewMine",
	};

	// 
	vars.NyrasPrologue_X =  98555.7733905069d;
	vars.NyrasPrologue_Y = -56429.3303492728d;
	vars.X =  98555.7733905069d;
	vars.Y = -56429.3303492728d;
}

init {
#region Signature scanning
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);

	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
	
	var gNamesTrg = new SigScanTarget(7, 
		"8B D9",                // mov ebx,ecx
		"74 ??",                // je G1R-Win64-Shipping.exe.+________
		"48 8D 15 ????????",    // lea rdx,[G1R-Win64-Shipping.exe+________]  <--- GNames
		"EB"                    // jmp G1R-Win64-Shipping.exe.+________
	) { OnFound = onFound };

	var gWorldTrg = new SigScanTarget(3, 
		"48 8B 1D ????????",    // mov rbx,[G1R-Win64-Shipping.exe+________]  <--- GWorld
		"48 85 DB",             // test rbx,rbx
		"74 ??",                // je G1R-Win64-Shipping.exe+________
		"41 B0 01"              // mov r8l,01
	) { OnFound = onFound };

	var loadingScreenTrg = new SigScanTarget(20, 
		"48 83 EB 10",          // sub rbx,10
		"48 83 EF 01",          // sub rdi,01
		"79 D2",                // jns G1R-Win64-Shipping.exe+________
		"8B 0D ????????",       // mov ecx,[G1R-Win64-Shipping.exe+________]
		"33 DB",                // xor ebx,ebx
		"8B 15 ????????"        // mov edx,[G1R-Win64-Shipping.exe+________]  <--- Loading screen
	) { OnFound = onFound };

	var gNames = scanner.Scan(gNamesTrg);
	var gWorld = scanner.Scan(gWorldTrg);
	var loadingScreen = scanner.Scan(loadingScreenTrg);
	
	if (gNames == IntPtr.Zero || gWorld == IntPtr.Zero || loadingScreen == IntPtr.Zero ) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}
#endregion

#region FNameToString()
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
#endregion

#region Memory Watchers
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		{ "GWorldFName",
			new MemoryWatcher<ulong>(new DeepPointer(
				gWorld,
				0x18      // NamePrivate
			)) 
		},
		{ "LoadingScreen",
			new MemoryWatcher<bool>(new DeepPointer(
				loadingScreen
			))
		},
		{ "X",
			new MemoryWatcher<double>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0]
				0x3E8,    // OwnedCharacter
				0x328,    // CapsuleComponent
				0x128     // RelativeLocation
				+ 0x0     // X
			))
		},
		{ "Y",
			new MemoryWatcher<double>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0]
				0x3E8,    // OwnedCharacter
				0x328,    // CapsuleComponent
				0x128     // RelativeLocation
				+ 0x8     // Y
			))
		},
		{ "Chapter", 
			new MemoryWatcher<int>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x1F8,    // ~GameState Subsystems~
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [8] 
				+ 0x8,    // Value (StorySubSystem)
				0x50      // Chapter
			))
		},
		{ "KIRGO_REMATCH_RUNNING", // See if any of the story variables are useful
			new MemoryWatcher<int>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x1F8,    // ~GameState Subsystems~
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [8] 
				+ 0x8,    // Value (StorySubSystem)
				0x144     // KIRGO_REMATCH_RUNNING
			))
		},
		{ "Exp",
			new MemoryWatcher<float>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0] (CharacterState)
				0x370,    // AbilitySystemComponent
				0x1090,   // SpawnedAttributes
				2 * 0x8,  // [2] (AttributeSet_LevelProgression)
				0x50      // Experience
				+ 0xC     // CurrentValue
			))
		},
		{ "CinematicState",
			new MemoryWatcher<byte>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x1F8,    // ~GameState Subsystems~ 
				0 * 0x8,  // [0] (GameStateSubsystemComponent) 
				0xA8,     // ??TMap 
				0 * 0x18  // [0] 
				+ 0x8,    // Value (GothicCinematicManagerSubsystem)
				0x30      // m_CinematicState

			// Possible values:
			// None = 0
			// Initializing = 1
			// Loading = 2
			// Playing = 3
			// Unloading = 4
			))
		},
		{ "ActiveNotifications",
			new MemoryWatcher<int>(new DeepPointer(
				gWorld, 
				0x158,     // AuthorityGameMode
				0x3B0,     // m_PlayerControllers
				0 * 0x8,   // [0] (PlayerController)
				0x340,     // MyHUD
				0x380,     // m_Controllers
				14 * 0x38  // [14] 
				+ 0x28,    // Value (UHUDNotificationController)
				0x38,      // m_NotificationMainWidget
				0x450,     // m_AreaWidgets
				3 * 0x8,   // [3] (W_NotificationArea_Right)
				0x370      // m_ActiveNotifications
				+ 0x8      // ArrayNum
			))
		},
		{ "ViewTarget",
			new MemoryWatcher<ulong>(new DeepPointer(
				gWorld, 
				0x158,     // AuthorityGameMode
				0x3B0,     // m_PlayerControllers
				0 * 0x8,   // [0] (PlayerController)
				0x348,     // PlayerCameraManager
				0x320      // ViewTarget
				+ 0x0,     // Target
				0x18       // NamePrivate
			))
		},
		{ "NyrasFade",
			new MemoryWatcher<float>(new DeepPointer("G1R-Win64-Shipping.exe", 0x959946C))
		},
	};

	vars.MainMenuDisplayedWidget = new MemoryWatcher<ulong>(
		new DeepPointer(
			gWorld, 
			0x30,      // PersistentLevel
			0xF0,      // LevelScriptActor
			0x2B0,     // MainMenu
			0x448,     // Stack_FrontEnd
			0x1A0,     // WidgetList
			0 * 0x8,   // [0] (CommonActivatableWidget)
			0x548,     // Stack_Parent
			0x1B0,     // DisplayedWidget
			0x18       // NamePrivate
		)
	);
#endregion

#region Inventory
	vars.PlayerHasItem = (Func<string, bool>)((item) => {		
		IntPtr itemsPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0] (CharacterState)
				0x378,    // DataModuleComponent
				0xA0,     // m_DataModules
				5 * 0x8,  // [5] (DataModule_Container)
				0x40      // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
			)
			.Deref<ulong>(game);
		
		IntPtr inventoryPtr = (IntPtr)
			game.ReadValue<ulong>(
				itemsPtr    // Items
				+ 1 * 0x88  // [1] (main inventory)
				+ 0x48      // m_Slots
			);
		
		var inventorySize = 
			game.ReadValue<int>(
				itemsPtr    // Items
				+ 1 * 0x88  // [1] (main inventory)
				+ 0x48      // m_Slots
				+ 0xC       // ArrayMax
			);

		for (int i = 0; i < inventorySize; i++) {
			IntPtr slotPtr = (IntPtr)game.ReadValue<ulong>(inventoryPtr + (i * 0xB0) + 0x8);
			if (slotPtr == IntPtr.Zero) continue;

			var idFName = game.ReadValue<ulong>(slotPtr + 0x18);
			var id = vars.FNameToString(idFName);

			if (item == id) {
				return true;
			}
		}

		return false;
	});

	/*
	## Mission Items
	- ItMs_Axe_Bran
	- ItMs_ExplosionBarrel
	- ItMs_ExplosionScroll
	- ItMs_FakeDiggerClothes
	- ItMs_Focus_01
	- ItMs_Focus_02
	- ItMs_Focus_03
	- ItMs_Focus_04
	- ItMs_Focus_05
	- ItMs_Plants_OrcSpore
	- ItMs_Lightbringer
	- ItMs_Demonprank
	- ItMs_Spellblade
	- ItMs_Timeblade
	- ItMs_Worldsplitter
	- ItMs_Uriziel
	*/
#endregion

#region Quests
	// Quest state values:
	// Started = 2
	// Completed = 4

	vars.QuestState = (Func<string, int>)((quest) => {
		IntPtr questInstancesArrayPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x208,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				6 * 0x18  // [6] 
				+ 0x8,    // Value (QuestSubsystem)
				0x90      // AllQuestInstances
			)
			.Deref<ulong>(game);

		var questInstancesArraySize = 
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x208,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				6 * 0x18  // [6] 
				+ 0x8,    // Value (QuestSubsystem)
				0x90      // AllQuestInstances
				+ 0x8     // Num
			)
			.Deref<int>(game);

		for (int i = 0; i < questInstancesArraySize; i++) { 
			IntPtr questPtr = (IntPtr)game.ReadValue<ulong>(questInstancesArrayPtr + (i * 0x8));

			var idFName = new DeepPointer(questPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			if (id == "Instance_" + quest) {
				return new DeepPointer(questPtr + 0x50).Deref<byte>(game);
			}
		}

		return -1;
	});
#endregion

#region NPC Functions
	vars.IsDead = (Func<string, bool>)((npc) => {
		IntPtr npcArrayPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8     // PlayerArray
			)
			.Deref<ulong>(game);

		var npcArraySize = 
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8     // PlayerArray
				+ 0xC     // ArrayMax
			)
			.Deref<int>(game);

		for (int i = 1; i < npcArraySize; i++) { 
			IntPtr npcPtr = game.ReadValue<IntPtr>(npcArrayPtr + (i * 0x8));
			if (npcPtr == IntPtr.Zero) continue;

			var idFName = new DeepPointer(npcPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			if (id == "State_" + npc) {
				var hp = 
					new DeepPointer(
						npcPtr 
						+ 0x370,   // AbilitySystemComponent
						0x1090,    // SpawnedAttributes
						0 * 0x8,   // [0] (AttributeSet_Health)
						0x40       // Health
						+ 0xC      // CurrentValue
					)
					.Deref<float>(game);

				if (hp == 0) {
					// Human NPCs don't die when their health reaches zero.
					// They are only knocked out for a while. 
					// Therefore, we perform an additional check:
					// The pointer to an NPC's AI states becomes zero when they are fully dead. 
					// I haven't found a simpler isDead flag so far.

					var statePtr = (IntPtr)
						new DeepPointer(
							npcPtr 
							+ 0x480,   // AIAbility
							0x540      // CurrentStateStack
						)
						.Deref<ulong>(game);

					if (statePtr == IntPtr.Zero) {
						return true;
					}
				}
			}
		}
		
		return false;
	});

	vars.IsInConversation = (Func<string, bool>)((npc) => {
		IntPtr npcArrayPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8     // PlayerArray
			)
			.Deref<ulong>(game);

		var npcArraySize = 
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8     // PlayerArray
				+ 0xC     // ArrayMax
			)
			.Deref<int>(game);

		for (int i = 1; i < npcArraySize; i++) { 
			IntPtr npcPtr = game.ReadValue<IntPtr>(npcArrayPtr + (i * 0x8));
			if (npcPtr == IntPtr.Zero) continue;

			var idFName = new DeepPointer(npcPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			if (id == "State_" + npc) {
				var currentStateFName = 
					new DeepPointer(
						npcPtr 
						+ 0x480,  // GameplayAbility_CharacterAI
						0x540,    // CurrentStateStack
						0 * 0x8,  // [0]
						0x18      // NamePrivate
					)
					.Deref<ulong>(game);

				var currentState = vars.FNameToString(currentStateFName);

				if (currentState == "AIState_Conversation") {
					return true;
				}
			}
		}
		
		return false;
	});
#endregion

#region Splits
	var splits = new Dictionary<string, Func<bool>>();

	foreach (var kv in vars.splitDataNyrasPrologue) {
		vars.splitData[kv.Key] = kv.Value;
	}

	foreach (var kv in (Dictionary<string, Tuple<string, string, string>>)vars.splitData) {
		var splitName = kv.Key;
		var type = kv.Value.Item1;
		var arg = kv.Value.Item2;

		if (type == "StartQuest") {
			splits[splitName] = () => vars.Watchers["ActiveNotifications"].Changed && vars.QuestState(arg) == 2;
		}
		else if (type == "FinishQuest") {
			splits[splitName] = () => vars.Watchers["ActiveNotifications"].Changed && vars.QuestState(arg) == 4;
		}
		else if (type == "Item") {
			splits[splitName] = () => vars.Watchers["ActiveNotifications"].Changed && vars.PlayerHasItem(arg);
		}
		else if (type == "Kill") {
			splits[splitName] = () => vars.Watchers["Exp"].Changed && vars.IsDead(arg);
		}
		else if (type == "Dialogue") {
			splits[splitName] = () => vars.FNameToString(vars.Watchers["ViewTarget"].Current).StartsWith("Conversation") && 
			                          vars.IsInConversation(arg);
		}
		else if (type == "World") {
			splits[splitName] = () => vars.FNameToString(vars.Watchers["GWorldFName"].Current) == arg;
		}
		else if (type == "Chapter") {
			splits[splitName] = () => vars.Watchers["Chapter"].Current.ToString() == arg;
		}
		else if (type == "FinishNyrasPrologue") {
			splits[splitName] = () => vars.FNameToString(vars.Watchers["ViewTarget"].Current) == "CineCameraActor" && 
			                          vars.Watchers["NyrasFade"].Old < 1.0f && vars.Watchers["NyrasFade"].Current == 1.0f;
		} 
		/*
		else if (type == "ExitFreeMine") {
			splits[splitName] = () => vars.Watchers["someVar"].Current == 12345 &&
			                          vars.FNameToString(vars.Watchers["GWorldFName"].Current) == "G1R_MainMap";
		}
		*/
	}

	vars.splits = splits;
#endregion

	current.world = "";
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

	if (vars.Watchers["ActiveNotifications"].Current == vars.Watchers["ActiveNotifications"].Old + 1) {
		vars.Info("Notification");
	}

	if (vars.Watchers["ViewTarget"].Changed) {
		vars.Info("View Target -> " + vars.FNameToString(vars.Watchers["ViewTarget"].Current));
	}

	if (vars.timerPaused) {
		if (vars.worlds.Contains(current.world)) { 	
			if (vars.Watchers["loadingScreen"].Old && !vars.Watchers["loadingScreen"].Current) {
				vars.timerPaused = false;
			}
		}
	}
}

reset {
	if (current.world == "G1R_MainMenu_C" || current.world == "G1RNyrasPrologue_MenuMap") {
		vars.MainMenuDisplayedWidget.Update(game);

		if (vars.MainMenuDisplayedWidget.Changed) {
			vars.Info("Menu -> " + vars.FNameToString(vars.MainMenuDisplayedWidget.Current));
		}
		
		if (vars.FNameToString(vars.MainMenuDisplayedWidget.Current) == "NewGame") {
			return true;
		}

		if (current.world == "G1RNyrasPrologue_MenuMap" && old.world != "G1RNyrasPrologue_MenuMap") {
			return true;
		}
	}
}

start {
	if (current.world == "G1R_MainMap") {
		if (Math.Abs(vars.Watchers["X"].Current - vars.X) < 0.000000001 &&
		    Math.Abs(vars.Watchers["Y"].Current - vars.Y) < 0.000000001) {
			if (vars.Watchers["LoadingScreen"].Old && !vars.Watchers["LoadingScreen"].Current) {
				return true;
			}
		}
	}

	if (current.world == "G1RNyrasPrologue_MainMap") {
		if (Math.Abs(vars.Watchers["X"].Current - vars.NyrasPrologue_X) < 0.000000001 &&
		    Math.Abs(vars.Watchers["Y"].Current - vars.NyrasPrologue_Y) < 0.000000001) {
			if (vars.Watchers["LoadingScreen"].Old && !vars.Watchers["LoadingScreen"].Current) {
				return true;
			}
		}
	}
}

onStart {
	vars.completedSplits.Clear();
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

isLoading {
	return vars.Watchers["LoadingScreen"].Current || 
	       vars.Watchers["CinematicState"].Current == 3 || 
	       vars.timerPaused;
}

exit {
	timer.IsGameTimePaused = true;
	vars.timerPaused = true;
}