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
		//           name,                              type,            className / number
		Tuple.Create("Storm Of Fire Scroll",            "Item",          "ItAr_Scroll_StormOfFire"),
		Tuple.Create("Essence of Spirit",               "Item",          "ItFo_Potion_Mana_Perma_01"),
		
		Tuple.Create("Bloodfly Scroll",                 "Item",          "ItAr_Scroll_TransformBloodfly"),
		Tuple.Create("Scavenger Whistle",               "Item",          "ItMs_ScavengerWhistle"),

		Tuple.Create("Almanac",                         "Item",          "ItWr_Book_Focus"),

		Tuple.Create("Focus 1 (Ocean Cliff)",           "Item",          "ItMs_Focus_01"),
		Tuple.Create("Focus 2 (Troll Canyon)",          "Item",          "ItMs_Focus_02"),
		Tuple.Create("Focus 3 (Mountain Fortress)",     "Item",          "ItMs_Focus_03"),
		Tuple.Create("Focus 4 (Monastery Ruins)",       "Item",          "ItMs_Focus_04"),
		Tuple.Create("Focus 5 (Stone Circle)",          "Item",          "ItMs_Focus_05"),

		Tuple.Create("Prime Tongue of Fire",            "Item",          "ItAt_Firelizard_05"),
		Tuple.Create("Horn of a Great Shadowbeast",     "Item",          "ItAt_Shadow_05"),
		Tuple.Create("Teeth of a Swampshark Mother",    "Item",          "ItAt_Swampshark_04"),
		Tuple.Create("Prime Troll Tusk",                "Item",          "ItAt_Troll_03"),

		Tuple.Create("Ulu-Mulu",                        "Item",          "ItMw_2H_Staff_Ulumulu"),
		
		Tuple.Create("Uriziel Gem 1",                   "Item",          "ItMi_UrizielGem_01"),
		Tuple.Create("Uriziel Gem 2",                   "Item",          "ItMi_UrizielGem_02"),
		Tuple.Create("Uriziel Gem 3",                   "Item",          "ItMi_UrizielGem_03"),
		Tuple.Create("Uriziel Gem 4",                   "Item",          "ItMi_UrizielGem_04"),
		Tuple.Create("Uriziel Gem 5",                   "Item",          "ItMi_UrizielGem_05"),

		Tuple.Create("Strange Sword",                   "Item",          "ItMw_2H_Sword_Uriziel_01"),

		Tuple.Create("Chapter 2",                       "Chapter",       "2"),
		Tuple.Create("Chapter 3",                       "Chapter",       "3"),
		Tuple.Create("Chapter 4",                       "Chapter",       "4"),
		Tuple.Create("Chapter 5",                       "Chapter",       "5"),
		Tuple.Create("Chapter 6",                       "Chapter",       "6"),

		Tuple.Create("<Placeholder> (tell me which quests you'd like)",  
		                                                "QuestStart",    "Quest_PLACEHOLDER"),
		
		Tuple.Create("Torrez",                          "Talk",          "State_OC_KDF_Torrez"),
		Tuple.Create("Sharky",                          "Talk",          "State_NC_ORG_Sharky"),

		Tuple.Create("Hänno",                           "Kill",          "State_NC_SLD_Haenno"),

		Tuple.Create("Transform into Bloodfly",         "ViewTarget",    "CharacterCanTransformInto_Bloodfly_C"),
		Tuple.Create("Go to bed",                       "ViewTarget",    "Interactive_Bed"),
		
		Tuple.Create("Sleeper Temple Entrance Barrier", "Cinematic",     "SleeperTempleOpeningCinematic"),
		Tuple.Create("Sleeper Temple Final Barrier",    "ViewTarget",    "Interactive_DestroyFinalBarrier_C_UAID_30D042EE632F23B802"),

		Tuple.Create("Harpies",                         "Location",      "82197.8904851777, 116451.914252969"),
		Tuple.Create("Orcs",                            "Location",      "32259.6609909562, -271337.753909156"),
		Tuple.Create("Mud",                             "Location",      "241192.734211706, 90228.5344752588"),
		Tuple.Create("Diego",                           "Location",      "32799.2340540829, -340264.296803568"),
		Tuple.Create("Gorn",                            "Location",      "257228.480389017, -247995.238136612"),
		Tuple.Create("Milten",                          "Location",      "18169.1992098076, 113774.093393691"),
		Tuple.Create("Lester",                          "Location",      "17879.8228228579, 65681.1945283479"),
		Tuple.Create("Xardas",                          "Location",      "80294.8305271158, -363925.52740662"),
		Tuple.Create("Cor Kalom",                       "Location",      "147409.323357549, -385632.48318534"),

		Tuple.Create("End",                             "Cinematic",     "ExtroCinematic"),
	};

	settings.Add("Reset", true, "Reset");
		settings.Add("ResetNewGame", false, "Reset on New Game screen", "Reset");
		settings.Add("ResetMainMenu", false, "Reset on returning to the Main Menu", "Reset");

	settings.Add("Splits", true, "Splits");	
		settings.Add("End", true, "End", "Splits");
		settings.Add("ChapterSplits", true, "Chapters", "Splits");
		settings.Add("DreamSplits", true, "Sleeper Fight (splits on entering each phase)", "Splits");
		settings.Add("ItemSplits", true, "Items", "Splits");
		settings.Add("QuestSplits", true, "Quests", "Splits");
		settings.Add("TransformSplits", true, "Transform into ...", "Splits");
			settings.Add("Transform into Bloodfly", false, "Bloodfly", "TransformSplits");
		settings.Add("TalkSplits", true, "Talk to ...", "Splits");
		settings.Add("KillSplits", true, "Kill", "Splits");
		settings.Add("Other", true, "Other", "Splits");
			settings.Add("Go to bed", false, "Go to bed", "Other");
		settings.Add("BarrierSplits", true, "Barriers", "Splits");
			settings.Add("Sleeper Temple Entrance Barrier", false, "Sleeper Temple Entrance Barrier", "BarrierSplits");
			settings.Add("Sleeper Temple Final Barrier", false, "Sleeper Temple Final Barrier", "BarrierSplits");

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
		else if (type == "Talk") {
			settings.Add(name, false, name, "TalkSplits");
		}
		else if (type == "Location") {
			settings.Add(name, false, name, "DreamSplits");
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
		"48 8D 15 ????????",    // lea rdx,[G1R-Win64-Shipping.exe+________]    <--- GNames
		"EB"                    // jmp G1R-Win64-Shipping.exe.+________
	) { OnFound = onFound };

	var gWorldTrg = new SigScanTarget(3, 
		"48 8B 1D ????????",    // mov rbx,[G1R-Win64-Shipping.exe+________]    <--- GWorld
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
		"8B 15 ????????"        // mov edx,[G1R-Win64-Shipping.exe+________]    <--- Loading screen
	) { OnFound = onFound };

	var moviePlayerTrg = new SigScanTarget(21, 
		"80 3D ???????? 00",    // cmp byte ptr ["G1R-Win64-Shipping.exe"+________],00
		"74 22",                // je "G1R-Win64-Shipping.exe"+________
		"80 3D ???????? 00",    // cmp byte ptr ["G1R-Win64-Shipping.exe"+________],00
		"75 19",                // jne "G1R-Win64-Shipping.exe"+________
		"48 8B 0D ????????",    // mov rcx,["G1R-Win64-Shipping.exe"+________]  <--- MoviePlayer
		"33 D2"                 // xor edx,edx
	) { OnFound = onFound };

	var gNames = scanner.Scan(gNamesTrg);
	var gWorld = scanner.Scan(gWorldTrg);
	var loadingScreen = scanner.Scan(loadingScreenTrg);
	var moviePlayer = scanner.Scan(moviePlayerTrg);
	
	if (gNames == IntPtr.Zero) {
		throw new InvalidOperationException("FNamePool not found. Trying again.");
	}
	if (gWorld == IntPtr.Zero) {
		throw new InvalidOperationException("GWorld not found. Trying again.");
	}
	if (loadingScreen == IntPtr.Zero) {
		throw new InvalidOperationException("Loading screen not found. Trying again.");
	}
	if (moviePlayer == IntPtr.Zero) {
		throw new InvalidOperationException("MoviePlayer not found. Trying again.");
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
		{ "SyncMechanism",
			new MemoryWatcher<IntPtr>(new DeepPointer(
				moviePlayer,
				0xA0      // SyncMechanism
			))
		},
		{ "X",
			new MemoryWatcher<double>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0]
				0x428,    // OwnedCharacter
				0x1A0,    // RootComponent
				0x1F0     // RelativeLocation
				+ 0x0     // X
			))
		},
		{ "Y",
			new MemoryWatcher<double>(new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0]
				0x428,    // OwnedCharacter
				0x1A0,    // RootComponent
				0x1F0     // RelativeLocation
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
		IntPtr dataModuleContainerPtr =
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0] (CharacterState)
				0x380,    // DataModuleComponent
				0xA0,     // m_DataModules
				4 * 0x8   // [4] (DataModule_Container)
			)
			.Deref<IntPtr>(game);

		if (dataModuleContainerPtr == IntPtr.Zero) return false;
		
		IntPtr itemsPtr =
			new DeepPointer(
				dataModuleContainerPtr
				+ 0x40    // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
			)
			.Deref<IntPtr>(game);
		
		int itemsArrayNum =
			new DeepPointer(
				dataModuleContainerPtr
				+ 0x40    // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
				+ 0x8     // ArrayNum
			)
			.Deref<int>(game);
		
		for (int i = 0; i < itemsArrayNum; i++) {
			IntPtr inventoryPtr = game.ReadValue<IntPtr>(itemsPtr + (i * 0x88) + 0x48);

			if (inventoryPtr == IntPtr.Zero) continue;

			int inventorySize = game.ReadValue<int>(itemsPtr + (i * 0x88) + 0x48 + 0xC);

			for (int j = 0; j < inventorySize; j++) {
				IntPtr slotPtr = (IntPtr)game.ReadValue<ulong>(inventoryPtr + (j * 0xB0) + 0x8);

				if (slotPtr == IntPtr.Zero) continue;

				var idFName = game.ReadValue<ulong>(slotPtr + 0x18);
				var id = vars.FNameToString(idFName);

				if (item == id) {
					return true;
				}
			}
		}

		return false;
	});

	vars.PrintCarriedItems = (Action)(() => {
		IntPtr dataModuleContainerPtr =
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0 * 0x8,  // [0] (CharacterState)
				0x380,    // DataModuleComponent
				0xA0,     // m_DataModules
				4 * 0x8   // [4] (DataModule_Container)
			)
			.Deref<IntPtr>(game);

		if (dataModuleContainerPtr == IntPtr.Zero) return ;
		
		IntPtr itemsPtr =
			new DeepPointer(
				dataModuleContainerPtr
				+ 0x40    // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
			)
			.Deref<IntPtr>(game);
		
		int itemsArrayNum =
			new DeepPointer(
				dataModuleContainerPtr
				+ 0x40    // m_Inventory 
				+ 0x20    // m_Values
				+ 0x108   // Items
				+ 0x8     // ArrayNum
			)
			.Deref<int>(game);
		
		for (int i = 0; i < itemsArrayNum; i++) {
			IntPtr inventoryPtr = game.ReadValue<IntPtr>(itemsPtr + (i * 0x88) + 0x48);

			if (inventoryPtr == IntPtr.Zero) continue;

			byte inventoryType = game.ReadValue<byte>(itemsPtr + (i * 0x88) + 0x58);
			vars.Info("Inventory " + inventoryType);

			int inventorySize = game.ReadValue<int>(itemsPtr + (i * 0x88) + 0x48 + 0xC);
			
			for (int j = 0; j < inventorySize; j++) {
				IntPtr slotPtr = (IntPtr)game.ReadValue<ulong>(inventoryPtr + (j * 0xB0) + 0x8);

				if (slotPtr == IntPtr.Zero) continue;

				var idFName = game.ReadValue<ulong>(slotPtr + 0x18);
				var id = vars.FNameToString(idFName);

				vars.Info(" - " + id);
			}
		}
	});
#endregion

#region Quests
	// Quest state values:
	// Started = 2
	// Completed = 4

	vars.QuestCache = new Dictionary<string, IntPtr>();
	vars.CachedQuestInstancesPtr = IntPtr.Zero;

	vars.UpdateQuestCache = (Action)(() => {
		IntPtr questSubsystemPtr =
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x218,    // ??Array
				0 * 0x8,  // [0] (GameStateSubsystemComponent)
				0xA8,     // ??TMap
				8 * 0x18  // [6] 
				+ 0x8     // Value (QuestSubsystem)
			)
			.Deref<IntPtr>(game);

		IntPtr questInstancesArrayPtr =
			new DeepPointer(
				questSubsystemPtr
				+ 0x90    // AllQuestInstances
			)
			.Deref<IntPtr>(game);

		if (questInstancesArrayPtr == vars.CachedQuestInstancesPtr) return ;
		if (questInstancesArrayPtr == IntPtr.Zero) return ;

		vars.Info("Quest instances array pointer changed: -> 0x" + questInstancesArrayPtr.ToString("X"));
		vars.Info("(Re-)building Quest Cache...");

		vars.QuestCache.Clear();
		vars.CachedQuestInstancesPtr = questInstancesArrayPtr;

		var questInstancesArraySize = 
			new DeepPointer(
				questSubsystemPtr
				+ 0x90    // AllQuestInstances
				+ 0x8     // Num
			)
			.Deref<int>(game);

		for (int i = 0; i < questInstancesArraySize; i++) {
			IntPtr questPtr = game.ReadValue<IntPtr>(questInstancesArrayPtr + (i * 0x8));
			if (questPtr == IntPtr.Zero) continue;

			var idFName = new DeepPointer(questPtr + 0x10, 0x18).Deref<ulong>(game);
			var id = vars.FNameToString(idFName);

			if (!string.IsNullOrEmpty(id)) {
				vars.QuestCache[id] = questPtr;
			}
		}

		vars.Info("  => Built quest dictionary with " + vars.QuestCache.Count + " keys.");
	});

	vars.QuestState = (Func<string, int>)((quest) => {
		IntPtr questPtr;
		if (!vars.QuestCache.TryGetValue(quest, out questPtr)) return -1;
		return new DeepPointer(questPtr + 0x50).Deref<byte>(game);
	});

	vars.PrintAllQuests = (Action)(() => {
		vars.Info("Listing every quest:");

		foreach (var questPtr in vars.QuestCache.Values) { 
			var idFName = new DeepPointer(questPtr + 0x10, 0x18).Deref<ulong>(game);
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
				var gameplayEffectsPtr = (IntPtr)
					new DeepPointer(
						npcPtr 
						+ 0x378,   // AbilitySystemComponent
						0x9A8      // ActiveGameplayEffects
					)
					.Deref<ulong>(game);

				var gameplayEffectsNum =
					new DeepPointer(
						npcPtr 
						+ 0x378,   // AbilitySystemComponent
						0x9A8      // ActiveGameplayEffects
						+ 0x8      // ArrayNum
					)
					.Deref<int>(game);

				for (int j = 0; j < gameplayEffectsNum; j++) {					
					IntPtr gameplayEffectPtr = game.ReadValue<IntPtr>(
						gameplayEffectsPtr 
						+ (j * 0x360 + 0x18)   // GameplayEffects_Internal.Spec.Def
					); 

					if (gameplayEffectPtr == IntPtr.Zero) continue;

					var gameplayEffectFName = new DeepPointer(gameplayEffectPtr + 0x18).Deref<ulong>(game);
					var gameplayEffect = vars.FNameToString(gameplayEffectFName);
					
					if (gameplayEffect == "Default__GE_Death") {
						return true;
					}
				}
			}
		}
		
		return false;
	});

	vars.IsInConversation = (Func<string, bool>)((npc) => {
		IntPtr abilitySystemComponentPtr = (IntPtr)
			new DeepPointer(
				gWorld, 
				0x160,    // GameState
				0x2A8,    // PlayerArray
				0x0,      // [0]
				0x378     // AbilitySystemComponent
			)
			.Deref<ulong>(game);

		IntPtr allReplicatedInstancedAbilitiesPtr = game.ReadValue<IntPtr>(abilitySystemComponentPtr + 0x538);
		int allReplicatedInstancedAbilitiesNum = game.ReadValue<int>(abilitySystemComponentPtr + 0x538 + 0x8);

		for (int i = 0; i < allReplicatedInstancedAbilitiesNum; i++) { 
			IntPtr gameplayAbilityPtr = game.ReadValue<IntPtr>(allReplicatedInstancedAbilitiesPtr + (i * 0x8));
			var gameplayAbilityFName = game.ReadValue<ulong>(gameplayAbilityPtr + 0x18);
			var gameplayAbility = vars.FNameToString(gameplayAbilityFName);

			if (gameplayAbility == "GA_Human_Conversation_WithUI") {
				IntPtr conversationGroupPtr = game.ReadValue<IntPtr>(gameplayAbilityPtr + 0x530);
				IntPtr characterIdealTransformMapPtr = game.ReadValue<IntPtr>(conversationGroupPtr + 0x190);
				int characterIdealTransformMapNum = game.ReadValue<int>(conversationGroupPtr + 0x190 + 0x8);

				for (int j = 0; j < characterIdealTransformMapNum; j++) {
					IntPtr participantPtr = game.ReadValue<IntPtr>(characterIdealTransformMapPtr + (j * 0x80));
					var participantFName = new DeepPointer(participantPtr + 0x2B0, 0x18).Deref<ulong>(game);
					var participant = vars.FNameToString(participantFName);
					
					if (participant == npc) {
						return true;
					}
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

	vars.PrintPlayerGameplayEffects = (Action)(() => {
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

		IntPtr npcPtr = game.ReadValue<IntPtr>(npcArrayPtr + (0 * 0x8));

		var idFName = new DeepPointer(npcPtr + 0x18).Deref<ulong>(game);
		var id = vars.FNameToString(idFName);

		var gameplayEffectsPtr = (IntPtr)
			new DeepPointer(
				npcPtr 
				+ 0x378,   // AbilitySystemComponent
				0x9A8      // ActiveGameplayEffects
			)
			.Deref<ulong>(game);

		var gameplayEffectsNum =
			new DeepPointer(
				npcPtr 
				+ 0x378,   // AbilitySystemComponent
				0x9A8      // ActiveGameplayEffects
				+ 0x8      // ArrayNum
			)
			.Deref<int>(game);

		for (int j = 0; j < gameplayEffectsNum; j++) {					
			IntPtr gameplayEffectPtr = game.ReadValue<IntPtr>(
				gameplayEffectsPtr 
				+ (j * 0x360 + 0x18)   // GameplayEffects_Internal.Spec.Def
			); 

			if (gameplayEffectPtr == IntPtr.Zero) continue;

			var gameplayEffectFName = new DeepPointer(gameplayEffectPtr + 0x18).Deref<ulong>(game);
			var gameplayEffect = vars.FNameToString(gameplayEffectFName);
			vars.Info("GameplayEffect["+j+"] = " + gameplayEffect);
		}
	});

	vars.PrintPlayerGameplayAbilities = (Action)(() => {
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

		IntPtr npcPtr = game.ReadValue<IntPtr>(npcArrayPtr + (0 * 0x8));

		var idFName = new DeepPointer(npcPtr + 0x18).Deref<ulong>(game);
		var id = vars.FNameToString(idFName);

		var gameplayEffectsPtr = (IntPtr)
			new DeepPointer(
				npcPtr 
				+ 0x378,   // AbilitySystemComponent
				0x538      // ActiveGameplayEffects
			)
			.Deref<ulong>(game);

		var gameplayEffectsNum =
			new DeepPointer(
				npcPtr 
				+ 0x378,   // AbilitySystemComponent
				0x538      // ActiveGameplayEffects
				+ 0x8      // ArrayNum
			)
			.Deref<int>(game);

		for (int j = 0; j < gameplayEffectsNum; j++) {					
			IntPtr gameplayEffectPtr = game.ReadValue<IntPtr>(
				gameplayEffectsPtr + (j * 0x8)   // AllReplicatedInstancedAbilities
			); 

			if (gameplayEffectPtr == IntPtr.Zero) continue;

			var gameplayEffectFName = new DeepPointer(gameplayEffectPtr + 0x18).Deref<ulong>(game);
			var gameplayEffect = vars.FNameToString(gameplayEffectFName);
			vars.Info("GameplayEffect["+j+"] = " + gameplayEffect);

			var tagsArray = new DeepPointer(gameplayEffectPtr + 0xA8).Deref<IntPtr>(game);
			var tagsArraySize = new DeepPointer(gameplayEffectPtr + 0xB0).Deref<int>(game);

			for (int i = 0; i < tagsArraySize; i++) {
				var tagFName = game.ReadValue<ulong>(tagsArray + (i * 0x8));
				var tag = vars.FNameToString(tagFName);
				vars.Info(" Tag " + i + ": " + tag);
			}
		}
	});

#endregion

	current.world = old.world = "";
	current.cinematic = old.cinematic = "";
	current.mainMenuDisplayedWidget = current.mainMenuDisplayedWidget = "";
}

update {
	vars.UpdateQuestCache();

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

	if (vars.Watchers["SyncMechanism"].Changed) {
		vars.Info("SyncMechanism -> 0x" + vars.Watchers["SyncMechanism"].Current.ToString("X"));
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
			shouldSplit = vars.PlayerHasItem(arg);
		} 
		else if (type == "QuestStart") {
			shouldSplit = 
				vars.Watchers["ActiveNotifications"].Changed && vars.QuestState(arg) == 2;
		}
		else if (type == "QuestComplete") {
			shouldSplit = 
				vars.Watchers["ActiveNotifications"].Changed && vars.QuestState(arg) == 4;
		}
		else if (type == "Cinematic") {
			shouldSplit = current.cinematic != old.cinematic && current.cinematic == arg;
		}
		else if (type == "Chapter") {
			int chapter = int.Parse(arg);
			shouldSplit = vars.Watchers["Chapter"].Changed && vars.Watchers["Chapter"].Current == chapter;
		}
		else if (type == "Kill") {
			shouldSplit = 
				vars.Watchers["Exp"].Current > vars.Watchers["Exp"].Old 
				&& vars.IsDead(arg);
		}
		else if (type == "Talk") {
			shouldSplit = 
				vars.FNameToString(vars.Watchers["ViewTarget"].Current).StartsWith("Conversation")
				&& vars.IsInConversation(arg);
		}
		else if (type == "ViewTarget") {
			shouldSplit = vars.FNameToString(vars.Watchers["ViewTarget"].Current).StartsWith(arg);
		}
		else if (type == "Location") {
			string input = arg;
			string[] parts = input.Split(',');
			double x = double.Parse(parts[0].Trim(), System.Globalization.CultureInfo.InvariantCulture);
			double y = double.Parse(parts[1].Trim(), System.Globalization.CultureInfo.InvariantCulture);
			
			shouldSplit = 
				Math.Sqrt(
					Math.Pow(x - vars.Watchers["X"].Current, 2) + 
					Math.Pow(y - vars.Watchers["Y"].Current, 2)
				) 
				< 500;
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
	//vars.PrintPlayerGameplayEffects();
	//vars.PrintPlayerGameplayAbilities();
	//vars.Info("(X, Y): " + vars.Watchers["X"].Current + ", " + vars.Watchers["Y"].Current);

	//vars.SetQuestState("Instance_Quest_SwampCamp_SCCHAPTER2_FINDINGCAINE", 4);
}

isLoading {
	return 
		vars.Watchers["LoadingScreen"].Current
		|| vars.Watchers["SyncMechanism"].Current != IntPtr.Zero
		|| vars.timerPaused;
}

exit {
	timer.IsGameTimePaused = true;
	vars.timerPaused = true;
}