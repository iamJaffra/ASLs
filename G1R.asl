/*

   ______      __  __    _          ____                       __             ___   _____ __ 
  / ____/___  / /_/ /_  (_)____    / __ \___  ____ ___  ____ _/ /_____       /   | / ___// / 
 / / __/ __ \/ __/ __ \/ / ___/   / /_/ / _ \/ __ `__ \/ __ `/ //_/ _ \     / /| | \__ \/ /  
/ /_/ / /_/ / /_/ / / / / /__    / _, _/  __/ / / / / / /_/ / ,< /  __/    / ___ |___/ / /___
\____/\____/\__/_/ /_/_/\___/   /_/ |_|\___/_/ /_/ /_/\__,_/_/|_|\___/    /_/  |_/____/_____/

by: Jaffra

*/

state("G1R-Win64-Shipping") {}

startup {
	#region Splits and Settings
	
	vars.Splits = new List<Tuple<string, string, string>> {
		//           name,                           type,            className / number
		Tuple.Create("Scavenger Whistle",            "Item",          "ItMs_ScavengerWhistle"),

		Tuple.Create("Focus 1",                      "Item",          "ItMs_Focus_01"),
		Tuple.Create("Focus 2",                      "Item",          "ItMs_Focus_02"),
		Tuple.Create("Focus 3",                      "Item",          "ItMs_Focus_03"),
		Tuple.Create("Focus 4",                      "Item",          "ItMs_Focus_04"),
		Tuple.Create("Focus 5",                      "Item",          "ItMs_Focus_05"),

		Tuple.Create("Prime Tongue of Fire",         "Item",          "ItAt_Firelizard_05"),
		Tuple.Create("Horn of a Great Shadowbeast",  "Item",          "ItAt_Shadow_05"),
		Tuple.Create("Teeth of a Swampshark Mother", "Item",          "ItAt_Swampshark_04"),
		Tuple.Create("Prime Troll Tusk",             "Item",          "ItAt_Troll_03"),

		Tuple.Create("Ulu-Mulu",                     "Item",          "ItMw_2H_Staff_Ulumulu"),
		
		Tuple.Create("Uriziel Gem 1",                "Item",          "ItMi_UrizielGem_01"),
		Tuple.Create("Uriziel Gem 2",                "Item",          "ItMi_UrizielGem_02"),
		Tuple.Create("Uriziel Gem 3",                "Item",          "ItMi_UrizielGem_03"),
		Tuple.Create("Uriziel Gem 4",                "Item",          "ItMi_UrizielGem_04"),
		Tuple.Create("Uriziel Gem 5",                "Item",          "ItMi_UrizielGem_05"),

		Tuple.Create("Strange Sword",                "Item",          "ItMw_2H_Sword_Uriziel_01"),

		Tuple.Create("Chapter 2",                    "Chapter",       "2"),
		Tuple.Create("Chapter 3",                    "Chapter",       "3"),
		Tuple.Create("Chapter 4",                    "Chapter",       "4"),
		Tuple.Create("Chapter 5",                    "Chapter",       "5"),
		Tuple.Create("Chapter 6",                    "Chapter",       "6"),

		Tuple.Create("Whistler's Sword (Start)",     "QuestStart",    "Instance_Quest_OldCamp_OCCHAPTER1_WHISTLER_BUYMYSWORD"),
		Tuple.Create("Whistler's Sword (Complete)",  "QuestComplete", "Instance_Quest_OldCamp_OCCHAPTER1_WHISTLER_BUYMYSWORD"),
		Tuple.Create("Chromanin",                    "QuestComplete", "Instance_Quest_ValleyOfMines_CHROMANIN"),
		
		Tuple.Create("Hänno",                        "Kill",          "State_NC_SLD_Haenno"), // State_NC_SLD_Haenno

		Tuple.Create("End",                          "Cinematic",     "ExtroCinematic"),
	};

	settings.Add("Reset", true, "Reset");
		settings.Add("ResetNewGame", false, "Reset on New Game screen", "Reset");
		settings.Add("ResetMainMenu", false, "Reset on returning to the Main Menu", "Reset");

	settings.Add("Splits", true, "Splits");	
		settings.Add("End", true, "End", "Splits");
		settings.Add("ChapterSplits", true, "Chapters", "Splits");
		settings.Add("ItemSplits", true, "Items", "Splits");
		settings.Add("QuestSplits", true, "Quests", "Splits");
		settings.Add("KillSplits", true, "Kill", "Splits");

	foreach (var split in vars.Splits) {
		string name = split.Item1;
		string type = split.Item2;
		string arg  = split.Item3;

		if (type == "Item") {
			settings.Add(name, false, name, "ItemSplits");
		} 
		else if (type == "QuestStart") {
			settings.Add(name, false, name, "QuestSplits");
		}
		else if (type == "QuestComplete") {
			settings.Add(name, false, name, "QuestSplits");
		}
		else if (type == "Chapter") {
			settings.Add(name, false, name, "ChapterSplits");
		}
		else if (type == "Kill") {
			settings.Add(name, false, name, "KillSplits");
		}
	}
	
	#endregion

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
		var timingMessage = MessageBox.Show (
			"[Diego] I'm Diego. \n"+ 
			"[You] I'm... \n"+ 
			"[Diego] I'm not interested in who you are. \n"+ 
			"[Diego] Removing loads requires comparing against Game Time\n"+
			"[Diego] Would you like to switch to it?",
			"LiveSplit | Gothic 1 Remake",
			MessageBoxButtons.YesNo
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
}

init {
#region Attaching to the right process
	if (File.Exists(Path.Combine(
		Path.GetDirectoryName(modules[0].FileName),
		"G1R", "Binaries", "Win64", "G1R-Win64-Shipping.exe"
	))) {
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
		return;
	}
#endregion

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

	vars.FNameToString = (Func<ulong, string>)(fName => {
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
				0x218,    // ~GameState Subsystems~
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				11 * 0x18 // [11] 
				+ 0x8,    // Value (StorySubSystem)
				0x50      // Chapter
			))
		},
		{ "KIRGO_REMATCH_RUNNING", // See if any of the story variables are useful
			new MemoryWatcher<int>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x218,    // ~GameState Subsystems~
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				11 * 0x18 // [11] 
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
				0x378,    // AbilitySystemComponent
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
				0x218,    // ~GameState Subsystems~ 
				0 * 0x8,  // [0] (GameStateSubsystemComponent) 
				0xA8,     // ??TMap 
				10 * 0x18 // [10] 
				+ 0x8,    // .Value (GothicCinematicManagerSubsystem)
				0x61      // m_CurrentCinematicState

			// Possible values:
			// None = 0
			// Initializing = 1
			// Loading = 2
			// Playing = 3
			// Unloading = 4
			))
		},
		{ "CinematicFName",
			new MemoryWatcher<ulong>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x218,    // ~GameState Subsystems~ 
				0 * 0x8,  // [0] (GameStateSubsystemComponent) 
				0xA8,     // ??TMap 
				10 * 0x18 // [10] 
				+ 0x8,    // .Value (GothicCinematicManagerSubsystem)
				0x70,     // m_Cinematic
				0x18      // NamePrivate
			))
		},
		{ "ActiveNotifications",
			new MemoryWatcher<int>(new DeepPointer(
				gWorld, 
				0x158,     // AuthorityGameMode
				0x3C0,     // m_PlayerControllers
				0 * 0x8,   // [0] (PlayerController)
				0x340,     // MyHUD
				0x380,     // m_Controllers
				14 * 0x38  // [14] 
				+ 0x28,    // Value (UHUDNotificationController)
				0x60,      // m_NotificationMainWidget
				0x468,     // m_AreaWidgets
				4 * 0x8,   // [4] (W_NotificationArea_Right)
				0x370      // m_ActiveNotifications
				+ 0x8      // ArrayNum
			))
		},
		{ "ViewTarget",
			new MemoryWatcher<ulong>(new DeepPointer(
				gWorld, 
				0x158,     // AuthorityGameMode
				0x3C0,     // m_PlayerControllers
				0 * 0x8,   // [0] (PlayerController)
				0x348,     // PlayerCameraManager
				0x320      // ViewTarget
				+ 0x0,     // Target
				0x18       // NamePrivate
			))
		},
		{ "MainMenuDisplayedWidget",
			new MemoryWatcher<ulong>(new DeepPointer(
			gWorld, 
			0x30,      // PersistentLevel
			0xF0,      // LevelScriptActor
			0x2B0,     // MainMenu
			0x430,     // Stack_FrontEnd
			0x1A0,     // WidgetList
			0 * 0x8,   // [0] (CommonActivatableWidget)
			0x588,     // Stack_Parent
			0x1B0,     // DisplayedWidget
			0x18       // NamePrivate
			))
		}
	};

	vars.Watchers["CinematicFName"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
#endregion

#region Inventory
	vars.PlayerHasItem = (Func<string, bool>)((item) => {
		IntPtr itemsPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0] (CharacterState)
				0x380,    // DataModuleComponent
				0xA0,     // m_DataModules
				4 * 0x8,  // [4] (DataModule_Container)
				0x40      // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
			)
			.Deref<ulong>(game);
		
		IntPtr inventoryPtr = (IntPtr)
			game.ReadValue<ulong>(
				itemsPtr    // Items
				+ 6 * 0x88  // [6] (main inventory)
				+ 0x48      // m_Slots
			);
		
		var inventorySize = 
			game.ReadValue<int>(
				itemsPtr    // Items
				+ 6 * 0x88  // [6] (main inventory)
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

	vars.PrintCarriedItems = (Action)(() => {
		IntPtr itemsPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0] (CharacterState)
				0x380,    // DataModuleComponent
				0xA0,     // m_DataModules
				4 * 0x8,  // [4] (DataModule_Container)
				0x40      // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
			)
			.Deref<ulong>(game);
		
		IntPtr inventoryPtr = (IntPtr)
			game.ReadValue<ulong>(
				itemsPtr    // Items
				+ 6 * 0x88  // [6] (main inventory)
				+ 0x48      // m_Slots
			);
		
		var inventorySize = 
			game.ReadValue<int>(
				itemsPtr    // Items
				+ 6 * 0x88  // [6] (main inventory)
				+ 0x48      // m_Slots
				+ 0xC       // ArrayMax
			);

		vars.Info("Listing currently carried items:");
		for (int i = 0; i < inventorySize; i++) {
			IntPtr slotPtr = (IntPtr)game.ReadValue<ulong>(inventoryPtr + (i * 0xB0) + 0x8);
			if (slotPtr == IntPtr.Zero) continue;

			var idFName = game.ReadValue<ulong>(slotPtr + 0x18);
			var id = vars.FNameToString(idFName);

			vars.Info(" - " + id);
		}
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
				0x218,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [6] 
				+ 0x8,    // Value (QuestSubsystem)
				0x90      // AllQuestInstances
			)
			.Deref<ulong>(game);

		var questInstancesArraySize = 
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x218,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [6] 
				+ 0x8,    // Value (QuestSubsystem)
				0x90      // AllQuestInstances
				+ 0x8     // Num
			)
			.Deref<int>(game);

		for (int i = 0; i < questInstancesArraySize; i++) { 
			IntPtr questPtr = (IntPtr)game.ReadValue<ulong>(questInstancesArrayPtr + (i * 0x8));

			var idFName = new DeepPointer(questPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			if (id == quest) {
				return new DeepPointer(questPtr + 0x50).Deref<byte>(game);
			}
		}

		return -1;
	});

	vars.PrintAllQuests = (Action)(() => {
		IntPtr questInstancesArrayPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x218,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [6] 
				+ 0x8,    // Value (QuestSubsystem)
				0x90      // AllQuestInstances
			)
			.Deref<ulong>(game);

		var questInstancesArraySize = 
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x218,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [6] 
				+ 0x8,    // Value (QuestSubsystem)
				0x90      // AllQuestInstances
				+ 0x8     // Num
			)
			.Deref<int>(game);

		vars.Info("Listing every quest:");
		for (int i = 0; i < questInstancesArraySize; i++) { 
			IntPtr questPtr = (IntPtr)game.ReadValue<ulong>(questInstancesArrayPtr + (i * 0x8));

			var idFName = new DeepPointer(questPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			vars.Info(" - " + id);
		}
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

			if (id == npc) {
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
							+ 0x4D8,   // AIAbility
							0x568      // CurrentStateStack
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

	vars.PrintAllNPCs = (Action)(() => {
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

		vars.Info("Listing every NPC:");
		for (int i = 1; i < npcArraySize; i++) { 
			IntPtr npcPtr = game.ReadValue<IntPtr>(npcArrayPtr + (i * 0x8));
			if (npcPtr == IntPtr.Zero) continue;

			var idFName = new DeepPointer(npcPtr + 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			vars.Info(" - " + id);	
		}
	});

#endregion

	current.world = old.world = "";
	current.cinematic = old.cinematic = "";
	current.mainMenuDisplayedWidget = current.mainMenuDisplayedWidget = "";
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

	if (vars.Watchers["ActiveNotifications"].Changed) {
		vars.Info("Active Notifications: -> " + vars.Watchers["ActiveNotifications"].Current);
	}

	if (vars.Watchers["ViewTarget"].Changed) {
		vars.Info("View Target -> " + vars.FNameToString(vars.Watchers["ViewTarget"].Current));
	}

	if (vars.timerPaused) {
		if (vars.Watchers["LoadingScreen"].Old && !vars.Watchers["LoadingScreen"].Current) {
			vars.timerPaused = false;
		}
	}

	current.cinematic = vars.FNameToString(vars.Watchers["CinematicFName"].Current);
	if (current.cinematic != old.cinematic) {
		vars.Info("Cinematic: -> " + current.cinematic);
	}

	if (vars.Watchers["Exp"].Changed) {
		vars.Info("Exp -> " + vars.Watchers["Exp"].Current);
	}

	current.mainMenuDisplayedWidget = vars.FNameToString(vars.Watchers["MainMenuDisplayedWidget"].Current);
	if (current.mainMenuDisplayedWidget != old.mainMenuDisplayedWidget) {
		vars.Info("Menu -> " + current.mainMenuDisplayedWidget);
	}
}

reset {
	if (current.world == "MenuMap") {
		if (current.mainMenuDisplayedWidget != old.mainMenuDisplayedWidget) {
			return settings["ResetNewGame"];
		}
	}

	if (current.world != old.world && current.world == "MenuMap") {
		return settings["ResetMainMenu"];
	}
}

start {
	if (old.cinematic == "IntroPt2Cinematic" && current.cinematic == "None") {
		return true;
	}	
}

onStart {
	vars.completedSplits.Clear();
}

split {
	foreach (var split in vars.Splits) {
		string name = split.Item1;
		string type = split.Item2;
		string arg  = split.Item3;

		if (!settings[name] || vars.completedSplits.Contains(name)) continue;

		bool shouldSplit = false;
		if (type == "Item") {
			shouldSplit = vars.Watchers["ActiveNotifications"].Changed && vars.PlayerHasItem(arg);
		} 
		else if (type == "QuestStart") {
			shouldSplit = vars.Watchers["ActiveNotifications"].Changed && vars.QuestState(arg) == 2;
		}
		else if (type == "QuestComplete") {
			shouldSplit = vars.Watchers["ActiveNotifications"].Changed && vars.QuestState(arg) == 4;
		}
		else if (type == "Cinematic") {
			shouldSplit = current.cinematic != old.cinematic && current.cinematic == arg;
		}
		else if (type == "Chapter") {
			int chapter = int.Parse(arg);
			shouldSplit = vars.Watchers["Chapter"].Changed && vars.Watchers["Chapter"].Current == chapter;
		}
		else if (type == "Kill") {
			shouldSplit = vars.Watchers["Exp"].Current > vars.Watchers["Exp"].Old && vars.IsDead(arg);
		}

		if (shouldSplit) {
			vars.Info("Split: " + name + " " + arg);
			vars.completedSplits.Add(name);
			return true;
		}
	}
}

onSplit {
	//vars.PrintAllQuests();
	//vars.PrintCarriedItems();
	//vars.PrintAllNPCs();
}

isLoading {
	return vars.Watchers["LoadingScreen"].Current || 
		   vars.timerPaused;
}

exit {
	timer.IsGameTimePaused = true;
	vars.timerPaused = true;
}