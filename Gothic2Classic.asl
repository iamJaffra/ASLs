state("Gothic2") {}

startup {
	vars.Splits = new List<Tuple<string, string, string, string, string>> {
		//           name,                     type,           arg1,                   arg2,               description                                           
		// Chapter
		Tuple.Create("Chapter2",               "Global",       "KAPITEL",              "2",                "Reach Chapter 2"                                     ),
		Tuple.Create("Chapter3",               "Global",       "KAPITEL",              "3",                "Reach Chapter 3"                                     ),
		Tuple.Create("Chapter4",               "Global",       "KAPITEL",              "4",                "Reach Chapter 4"                                     ),
		Tuple.Create("Chapter5",               "Global",       "KAPITEL",              "5",                "Reach Chapter 5"                                     ),
		// World
		Tuple.Create("EnterValley",            "World",        "OLDWORLD",             "",                 "Enter the Valley of Mines"                           ),
		Tuple.Create("EnterValleyFieldraider", "World+Item",   "OLDWORLD",             "ITSC_TRFGIANTBUG", "Enter the Valley of Mines (with Fieldraider Scroll)" ),
		Tuple.Create("EnterIrdorath",          "World",        "DRAGONISLAND",         "",                 "Enter Irdorath"                                      ),
		// Item
		Tuple.Create("RuneTeleportPass",       "Item",         "ITRU_TELEPORTPASSOW",  "",                 "Rune: Teleport to Pass (Valley of Mines)"            ),
		Tuple.Create("RuneTeleportCastle",     "Item",         "ITRU_TELEPORTOC",      "",                 "Rune: Teleport to Castle"                            ),
		Tuple.Create("RuneTeleportTavern",     "Item",         "ITRU_TELEPORTTAVERNE", "",                 "Rune: Teleport to Orlan's Tavern"                    ),
		Tuple.Create("RuneTeleportOnar",       "Item",         "ITRU_TELEPORTFARM",    "",                 "Rune: Teleport to Onar's Farm"                       ),
		Tuple.Create("Firerain",               "Item",         "ITSC_FIRERAIN",        "",                 "Scroll: Rain of Fire"                                ),
		Tuple.Create("SeaMap",                 "Item",         "ITWR_SEAMAP_IRDORATH", "",                 "Sea Map to Irdorath"                                 ),
		// Kill
		Tuple.Create("KillRockDragon",         "Kill",         "DRAGON_ROCK",          "",                 "Kill the Rock Dragon"                                ),
		Tuple.Create("KillSwampDragon",        "Kill",         "DRAGON_SWAMP",         "",                 "Kill the Swamp Dragon"                               ),
		Tuple.Create("KillFireDragon",         "Kill",         "DRAGON_FIRE",          "",                 "Kill the Fire Dragon"                                ),
		Tuple.Create("KillIceDragon",          "Kill",         "DRAGON_ICE",           "",                 "Kill the Ice Dragon"                                 ),
		Tuple.Create("KillUndeadDragon",       "Global",       "UNDEADDRAGONISDEAD",   "1",                "Kill the Undead Dragon"                              ),
		// Talk
		Tuple.Create("TalkToZuris",            "Talk",         "VLK_409_ZURIS",        "",                 "Talk to Zuris"                                       ),
		Tuple.Create("TalkToIgnaz",            "Talk",         "VLK_498_IGNAZ",        "",                 "Talk to Ignaz"                                       ),
		Tuple.Create("TalkToVatrasCh3",        "Talk+Chapter", "VLK_439_VATRAS",       "3",                "Talk to Vatras in Chapter 3"                         ),
		Tuple.Create("TalkToPyrokarCh3",       "Talk+Chapter", "KDF_500_PYROKAR",      "3",                "Talk to Pyrokar in Chapter 3"                        ),
		Tuple.Create("TalkToXardasCh3",        "Talk+Chapter", "VLK_439_VATRAS",       "3",                "Talk to Xardas in Chapter 3"                         ),
		// Guild
		Tuple.Create("GuildMilitia",           "Guild",        "2",                    "",                 "Join the Militia"                                    ),
		Tuple.Create("GuildPaladin",           "Guild",        "1",                    "",                 "Join the Paladins"                                   ),
		// Teleport
		Tuple.Create("TeleportToCastle",       "Teleport",     "1012.7",               "893.4",            "Teleport to the Castle"                              ),
		Tuple.Create("TeleportToXardasTower",  "Teleport",     "-11382.5",             "3695.3",           "Teleport to the Old Demon Tower"                     ),
		Tuple.Create("TeleportToTavern",       "Teleport",     "39127.6",              "3900.8",           "Teleport to Onar's Tavern"                           ),
		// Global Variables
		Tuple.Create("OpenCastleGate",         "Global",       "MIS_OCGATEOPEN",       "1",                "Open the castle gate"                                ),
		Tuple.Create("RecruitTorlof",          "Global",       "TORLOFISCAPTAIN",      "1",                "Make Torlof your captain"                            ),
		// Interactables
		Tuple.Create("IrdorathSwitch1",        "Interactable", "EVT_RIGHT_ROOM_01_MSG_SWITCH", "",         "Irdorath: Activate the 1st Switch."                  ),
		Tuple.Create("IrdorathSwitch2",        "Interactable", "EVT_LEFT_ROOM_01_MSG_SWITCH", "",          "Irdorath: Activate the 2nd Switch."                  ),
		Tuple.Create("IrdorathSwitch3",        "Interactable", "EVT_RIGHT_ROOM_02_MSG_SWITCH", "",         "Irdorath: Activate the 3rd Switch."                  ),
		Tuple.Create("IrdorathSwitch4",        "Interactable", "EVT_LEFT_ROOM_02_MSG_SWITCH", "",          "Irdorath: Activate the 4th Switch."                  ),
		Tuple.Create("IrdorathFinalSwitch",    "Interactable", "EVENT_TRIGGERLIST_FOR_LOCK_FINAL", "",     "Irdorath: Activate the Final Switch."                ),
		// End
		Tuple.Create("End",                    "End",          "",                     "",                 "Finish the Game"                                     ),
	};

	settings.Add("NewGameStart", true, "Start timer on New Game");
	settings.Add("NewGameReset", true, "Reset timer on New Game");

	settings.Add("Splits", true, "Splits");
		settings.Add("End",            true, "Finish the game.", "Splits");

		settings.Add("ChapterSplits",      true, "Chapters",         "Splits");
		settings.Add("WorldSplits",        true, "Worlds",           "Splits");
		settings.Add("ItemSplits",         true, "Items",            "Splits");
		settings.Add("KillSplits",         true, "Kill",             "Splits");
		settings.Add("TalkSplits",         true, "Talk",             "Splits");
		settings.Add("GuildSplits",        true, "Guild",            "Splits");
		settings.Add("GlobalSplits",       true, "Global Variables", "Splits");
		settings.Add("TeleportSplits",     true, "Teleport",         "Splits");
		settings.Add("InteractableSplits", true, "Interactables",    "Splits");
	
	foreach (var split in vars.Splits) {
		string name        = split.Item1;
		string type        = split.Item2;
		string description = split.Item5;
		
		string parent = type + "Splits";

		if (name == "End") continue;

		if (type.StartsWith("World")) {
			parent = "WorldSplits";
		}
		else if (type.StartsWith("Talk")) {
			parent = "TalkSplits";
		}
		else if (name.StartsWith("Chapter")) {
			parent = "ChapterSplits";
		}
		else if (name.StartsWith("Kill")) {
			parent = "KillSplits";
		}
		
		settings.Add(name, false, description, parent);
	}

	vars.Info = (Action<string>)((msg) => {
		print("[Gothic 2 ASL] " + msg);
	});

	vars.CompletedSplits = new HashSet<string>();

	// Variable to save IGT in case the game crashes or softlocks
	vars.TimeKeeper = new TimeSpan();
}

init {
	#region Statics

	const int WORLD        = 0x008C380C;   // zCWorld*& zCMenu::world
	const int PLAYER       = 0x009831DC;   // oCNpc*& oCNpc::player
	const int GAME_MANAGER = 0x008B4398;   // CGameManager*& gameMan
	const int GAME         = 0x009813DC;   // oCGame*& ogame
	const int PARSER       = 0x00984C08;   // zCParser* parser = (zCParser* )

	#endregion

	#region Offsets

	// oCGame : zSession
	const int WORLD_OFFSET              = 0x8;      // zCWorld* world;
	const int IN_LOAD_SAVEGAME_OFFSET   = 0x28;     // int inLoadSaveGame; 
	const int IN_LEVEL_CHANGE_OFFSET    = 0x2C;     // int inLevelChange;

	// oCWorld
	const int WORLD_NAME_OFFSET         = 0x6268;   // zSTRING worldName;
	const int VOBLIST_NPC_OFFSET        = 0x6280;   // zCListSort<oCNpc>* voblist_npcs;

	// zCObject
	const int OBJECT_NAME_OFFSET        = 0x10;     // zSTRING objectName;

	// zString
	const int ZSTRING_VECTOR_OFFSET     = 0x8;      // char* vector;

	// oCNpc
	const int ATTRIBUTE_OFFSET          = 0x1A4;    // int attribute[NPC_ATR_MAX];
	const int GUILD_OFFSET              = 0x21C;    // int guild;
	const int AI_SCRIPT_VARS_OFFSET     = 0x274;    // int aiscriptvars[70];
	const int EXPERIENCE_POINTS_OFFSET  = 0x3A0;    // unsigned long experience_points;
	const int INVENTORY2_OFFSET         = 0x5DC;    // oCNpcInventory inventory2;
	const int BODYSTATE_OFFSET          = 0x6E0;    // int bodyState : 19;
	const int INTERACT_MOB_OFFSET       = 0x8D0;    // oCMobInter* interactMob; 
	
	// oCMOB
	const int MOB_TRIGGER_TARGET_OFFSET = 0x190;    // zSTRING triggerTarget;
	const int MOB_STATE_OFFSET          = 0x1F4;    // int state; 

	// zCVideoPlayer
	const int M_VIDEO_FILENAME_OFFSET   = 0x04;     // zSTRING mVideoFilename;
	const int M_PLAYING_OFFSET          = 0x20;     // int mPlaying;
	const int VIDEO_PLAYER_OFFSET       = 0x78;     // oCBinkPlayer* videoPlayer;

	// zCParser
	const int SYMTAB_OFFSET             = 0x10;     // zCPar_SymbolTable symtab;

	// zCPar_SymbolTable
	const int TABLE_OFFSET              = 0x8;      // zCArray<zCPar_Symbol*> table;

	// zCPar_Symbol
	const int SYMBOL_DATA_OFFSET        = 0x18;     // int* intdata;

	// zCArray
	const int NUM_ALLOC_OFFSET          = 0x4;      // int numAlloc;
	const int NUM_IN_ARRAY_OFFSET       = 0x8;      // int numInArray;

	// oCItemContainer
	const int CONTENTS_OFFSET           = 0x4;      // zCListSort<oCItem>* contents;

	// zCListSort
	const int ZCLISTSORT_DATA_OFFSET    = 0x4;      // T* data;
	const int ZCLISTSORT_NEXT_OFFSET    = 0x8;      // zCListSort* next;

	// zMAT4 trafoObjToWorld;
	const int TRAFO_OBJ_TO_WORLD_OFFSET = 0x3C;     // zMAT4 trafoObjToWorld;
	
	const int ZMAT4_COL_SIZE            = 0x4;
	const int ZMAT4_ROW_LENGTH          = 0x10;

	const int VOB_WORLD_POS_X_OFFSET = TRAFO_OBJ_TO_WORLD_OFFSET + 0 * ZMAT4_ROW_LENGTH + 3 * ZMAT4_COL_SIZE;
	const int VOB_WORLD_POS_Y_OFFSET = TRAFO_OBJ_TO_WORLD_OFFSET + 1 * ZMAT4_ROW_LENGTH + 3 * ZMAT4_COL_SIZE;
	const int VOB_WORLD_POS_Z_OFFSET = TRAFO_OBJ_TO_WORLD_OFFSET + 2 * ZMAT4_ROW_LENGTH + 3 * ZMAT4_COL_SIZE;
	
	#endregion

	#region Constants

	const int BS_DEAD = 23;

	#endregion

	#region Global Variables

	vars.Globals = new Dictionary<string, MemoryWatcher>();

	var requiredGlobals = new HashSet<string>();

	foreach (var split in vars.Splits) {
		string type = split.Item2;

		if (type == "Global") {
			string global = split.Item3;
			requiredGlobals.Add(global);
		}
	}

	IntPtr tablePtr = game.ReadPointer((IntPtr)PARSER + SYMTAB_OFFSET + TABLE_OFFSET);
	int tableSize = game.ReadValue<int>((IntPtr)PARSER + SYMTAB_OFFSET + TABLE_OFFSET + NUM_ALLOC_OFFSET);
	
	for (int i = 0; i < tableSize; i++) {
		IntPtr symbolPtr = game.ReadPointer(tablePtr + i * 0x4); 
		
		string name = new DeepPointer(symbolPtr + ZSTRING_VECTOR_OFFSET, 0x0).DerefString(game, 100); 
		
		foreach (var global in requiredGlobals) {
			if (name == global) {
				IntPtr dataAddr = symbolPtr + SYMBOL_DATA_OFFSET;

				vars.Info(name + " = table[" + i + "] at 0x" + dataAddr.ToString("X"));

				vars.Globals[global] = new MemoryWatcher<int>(new DeepPointer(dataAddr));
			}
		} 
	}

	foreach (var global in requiredGlobals) {
		if (!vars.Globals.ContainsKey(global)) {
			throw new InvalidOperationException("Global " + global + " not found. Trying again.");
		}
	}

	vars.Info("  => All globals found.");

	#endregion

	#region oCBinkPlayer / zCVideoPlayer

	vars.EndingCutscenes = new HashSet<string> {
		"EXTRO_XARDAS",
		"CREDITS_EXTRO"
	};
	
	vars.GetCurrentCutscene = (Func<string>)(() => {
		IntPtr videoPlayer = (IntPtr)new DeepPointer((IntPtr)GAME_MANAGER, VIDEO_PLAYER_OFFSET).Deref<int>(game);
		if (videoPlayer == IntPtr.Zero) return "";
		
		bool isVideoPlaying = game.ReadValue<bool>((IntPtr)videoPlayer + M_PLAYING_OFFSET);

		if (isVideoPlaying) {	
			string cutscenePath = new DeepPointer((IntPtr)videoPlayer + M_VIDEO_FILENAME_OFFSET + ZSTRING_VECTOR_OFFSET, 0x0).DerefString(game, 1000);
			string cutscene = Path.GetFileNameWithoutExtension(cutscenePath);

			return cutscene;
		}
		
		return "";
	});

	#endregion

	#region Inventory

	vars.OwnedItems = new HashSet<string>();

	vars.UpdateItems = (Action)(() => {
		vars.OwnedItems.Clear();

		IntPtr itemPtr = (IntPtr)new DeepPointer((IntPtr)PLAYER, INVENTORY2_OFFSET + CONTENTS_OFFSET, ZCLISTSORT_NEXT_OFFSET).Deref<int>(game);

		while (itemPtr != IntPtr.Zero) {
			IntPtr itemDataPtr = game.ReadPointer(itemPtr + ZCLISTSORT_DATA_OFFSET);

			string itemName = game.ReadString(game.ReadPointer(itemDataPtr + OBJECT_NAME_OFFSET + ZSTRING_VECTOR_OFFSET), 20);
			
			if (!string.IsNullOrEmpty(itemName)) {
				vars.OwnedItems.Add(itemName);
			}
	
			itemPtr = game.ReadPointer(itemPtr + ZCLISTSORT_NEXT_OFFSET);
		}
	});

	vars.PlayerHasItem = (Func<string, bool>)(itemName => {
		return vars.OwnedItems.Contains(itemName);
	});

	vars.IsInventoryOpen = (Func<bool>)(() => {
		// oCItemContainer
		// virtual int IsOpen()        zCall( 0x006AB710 );
		// Gothic2.exe+2AB710 - A1 281B9800  - mov eax,[Gothic2.exe+581B28] <-- pointer to list of open inventories
		return game.ReadValue<int>((IntPtr)0x00981B28) != 0;
	});

	#endregion

	#region NPCs

	vars.IsInDialogue = (Func<string, bool>)((targetName) => {
		IntPtr npcPtr = (IntPtr)new DeepPointer((IntPtr)GAME, WORLD_OFFSET, VOBLIST_NPC_OFFSET, ZCLISTSORT_NEXT_OFFSET).Deref<int>(game);

		while (npcPtr != IntPtr.Zero) {
			IntPtr npcDataPtr = game.ReadPointer(npcPtr + ZCLISTSORT_DATA_OFFSET);

			string name = game.ReadString(game.ReadPointer(npcDataPtr + OBJECT_NAME_OFFSET + ZSTRING_VECTOR_OFFSET), 20);
			int isInDialogue = game.ReadValue<int>(npcDataPtr + AI_SCRIPT_VARS_OFFSET + 4 * 0x4); // aiscriptvars[4]
			
			if (name == targetName && isInDialogue == 1) {
				return true;
			}
	
			npcPtr = game.ReadPointer(npcPtr + ZCLISTSORT_NEXT_OFFSET);
		}

		return false;
	});

	vars.IsDead = (Func<string, bool>)((targetName) => {
		IntPtr npcPtr = (IntPtr)new DeepPointer((IntPtr)GAME, WORLD_OFFSET, VOBLIST_NPC_OFFSET, ZCLISTSORT_NEXT_OFFSET).Deref<int>(game);

		while (npcPtr != IntPtr.Zero) {
			IntPtr npcDataPtr = game.ReadPointer(npcPtr + ZCLISTSORT_DATA_OFFSET);

			string name = game.ReadString(game.ReadPointer(npcDataPtr + OBJECT_NAME_OFFSET + ZSTRING_VECTOR_OFFSET), 20);
			int bodystateField = game.ReadValue<int>(npcDataPtr + BODYSTATE_OFFSET);
			int bodystate = bodystateField & 0x7F;
			
			if (name == targetName && bodystate == BS_DEAD) {
				return true;
			}
	
			npcPtr = game.ReadPointer(npcPtr + ZCLISTSORT_NEXT_OFFSET);
		}

		return false;
	});

	#endregion

	#region Teleport

	vars.PlayerTeleported = (Func<string, string, bool>)((arg1, arg2) => {
		float x = float.Parse(arg1, System.Globalization.CultureInfo.InvariantCulture);
		float y = float.Parse(arg2, System.Globalization.CultureInfo.InvariantCulture);
		
		bool isIn = 
			Math.Sqrt(
				Math.Pow(x - vars.Watchers["X"].Current, 2) + 
				Math.Pow(y - vars.Watchers["Y"].Current, 2)
			) 
			< 200;

		bool wasOut = 
			Math.Sqrt(
				Math.Pow(x - vars.Watchers["X"].Old, 2) + 
				Math.Pow(y - vars.Watchers["Y"].Old, 2)
			) 
			> 500;
		
		return isIn && wasOut;
	});

	#endregion

	#region Mobs

	vars.LastInteractable = IntPtr.Zero;

	vars.UpdateInteractable = (Action)(() => {
		bool inLevelChange  = new DeepPointer((IntPtr)GAME, IN_LEVEL_CHANGE_OFFSET).Deref<bool>(game);
		bool inLoadSaveGame = new DeepPointer((IntPtr)GAME, IN_LOAD_SAVEGAME_OFFSET).Deref<bool>(game);
		
		if (inLevelChange || inLoadSaveGame) {
			vars.LastInteractable = IntPtr.Zero;
		}

		IntPtr mob = (IntPtr)new DeepPointer((IntPtr)PLAYER, INTERACT_MOB_OFFSET).Deref<int>(game);

		if (mob == IntPtr.Zero) {
			return ;
		}

		vars.LastInteractable = mob;
	});

	vars.GetMobTarget = (Func<IntPtr, string>)((mob) => {
		return game.ReadString(game.ReadPointer(mob + MOB_TRIGGER_TARGET_OFFSET + ZSTRING_VECTOR_OFFSET), 32);
	});

	vars.GetMobState = (Func<IntPtr, int>)((mob) => {
		return game.ReadValue<int>(mob + MOB_STATE_OFFSET);
	});

	#endregion

	#region HandleSelAction() Hook

	const int COUNTER_ADDR = 0x008B4C00;
	const int MESSAGE_ADDR = 0x008B4C04;
	const int HOOK_ADDR    = 0x004DA1F6;
	const int DETOUR_ADDR  = 0x0081FFA0;

	byte[] newGameMessage = { 0x4E, 0x45, 0x57, 0x5F, 0x47, 0x41, 0x4D, 0x45 };	 // NEW_GAME
	game.WriteBytes((IntPtr)MESSAGE_ADDR, newGameMessage);

	byte[] detour = {
		0x8B, 0xB4, 0x24, 0xCC, 0x00, 0x00, 0x00,  // mov esi,[esp+000000CC]
		0x60,                                      // pushad 
		0x9C,                                      // pushfd 
		0x8B, 0x46, 0x0C,                          // mov eax,[esi+0C]
		0x83, 0xF8, 0x08,                          // cmp eax,08 { 8 }
		0x75, 0x1A,                                // jne Gothic2.exe+42D82B
		0x56,                                      // push esi
		0x8B, 0x76, 0x08,                          // mov esi,[esi+08]
		0x8D, 0x3D, 0x04, 0x4C, 0x8B, 0x00,        // lea edi,[MESSAGE_ADDR] { ("NEW_GAME") }
		0xB9, 0x08, 0x00, 0x00, 0x00,              // mov ecx,00000008 { 8 }
		0xF3, 0xA6,                                // repe cmpsb 
		0x5E,                                      // pop esi
		0x75, 0x06,                                // jne Gothic2.exe+42D82B
		0xFF, 0x05, 0x00, 0x4C, 0x8B, 0x00,        // inc [COUNTER_ADDR] { (0) }
		0x9D,                                      // popfd 
		0x61,                                      // popad 
		0xE9, 0x2A, 0xA2, 0xCB, 0xFF               // jmp HOOK_ADDR+7
	};
	game.WriteBytes((IntPtr)DETOUR_ADDR, detour);

	byte[] hook = { 0xE9, 0xA5, 0x5D, 0x34, 0x00, 0x90, 0x90 };
	game.WriteBytes((IntPtr)HOOK_ADDR, hook);

	vars.Info("Applied HandleSelAction() hook.");

	#endregion

	#region Watchers

	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		{ "IGT",                new MemoryWatcher<long>(new DeepPointer("ZSPEEDRUNTIMER.DLL", 0x19F70)) },
		// World
		{ "World",              new StringWatcher(new DeepPointer((IntPtr)WORLD, WORLD_NAME_OFFSET + ZSTRING_VECTOR_OFFSET, 0x0), 20) },
		// Player
		{ "Exp",                new MemoryWatcher<int>  (new DeepPointer((IntPtr)PLAYER, EXPERIENCE_POINTS_OFFSET)) }, 
		{ "Guild",              new MemoryWatcher<int>  (new DeepPointer((IntPtr)PLAYER, GUILD_OFFSET)) },
		{ "IsPlayerInDialogue", new MemoryWatcher<int>  (new DeepPointer((IntPtr)PLAYER, AI_SCRIPT_VARS_OFFSET + 4 * 0x4)) },
		{ "X",                  new MemoryWatcher<float>(new DeepPointer((IntPtr)PLAYER, VOB_WORLD_POS_X_OFFSET)) }, 
		{ "Y",                  new MemoryWatcher<float>(new DeepPointer((IntPtr)PLAYER, VOB_WORLD_POS_Y_OFFSET)) }, 
		// New Game
		{ "NewGameCounter",     new MemoryWatcher<int>(new DeepPointer((IntPtr)COUNTER_ADDR)) }, 
	};

	#endregion

	vars.IsNewGame = false;
	current.cutscene = old.cutscene = "";
	current.interactable = old.interactable = IntPtr.Zero;
}
	
update {
	foreach (var watcher in vars.Globals.Values) { watcher.Update(game); }
	foreach (var watcher in vars.Watchers.Values) {	watcher.Update(game); }
	vars.UpdateItems();
	vars.UpdateInteractable();
	
	current.cutscene = vars.GetCurrentCutscene();
	if (current.cutscene != old.cutscene) {
		if (!string.IsNullOrEmpty(current.cutscene)) {
			vars.Info("Cutscene -> " + current.cutscene);
		}
		else {
			vars.Info("Cutscene ended.");
		}
	}

	if (vars.Watchers["World"].Changed) {
		vars.Info("World: " + vars.Watchers["World"].Old + " -> " + vars.Watchers["World"].Current);
	}
	
	if (vars.Watchers["Exp"].Changed) {
		vars.Info("Exp -> " + vars.Watchers["Exp"].Current);
	}

	/*
	if (vars.Watchers["X"].Changed || vars.Watchers["Y"].Changed) {
		vars.Info("(X,Y) -> " + vars.Watchers["X"].Current + ", " + vars.Watchers["Y"].Current);
	}
	*/

	if (vars.Watchers["NewGameCounter"].Changed && vars.Watchers["NewGameCounter"].Current != 0) {
		vars.Info("Selected NEW_GAME.");
		vars.IsNewGame = true;
	}
}

start { 
	if (vars.IsNewGame && vars.Watchers["IGT"].Current < 500000 && vars.Watchers["IGT"].Current != 0) {
		vars.IsNewGame = false;
		return settings["NewGameStart"];
	}
}

onStart {
	vars.CompletedSplits.Clear();
	vars.TimeKeeper = TimeSpan.FromMilliseconds(0);

	vars.Info("--- START ---");
}

reset {		
	return vars.IsNewGame && settings["NewGameReset"];
}

onReset {
	vars.Info("--- RESET ---");
}

split {
	foreach (var split in vars.Splits) {
		string name         = split.Item1;
		string type         = split.Item2;
		string arg1         = split.Item3;
		string arg2         = split.Item4;

		if (!settings[name] || vars.CompletedSplits.Contains(name)) continue;

		bool shouldSplit = false;

		switch (type) {
			case "World": 
				shouldSplit = vars.Watchers["World"].Current == arg1;
				break;
			case "Global":
				shouldSplit = vars.Globals[arg1].Current == int.Parse(arg2) && vars.Watchers["IsPlayerInDialogue"].Current == 0;
				break;
			case "Item": 
				shouldSplit = vars.PlayerHasItem(arg1) && !vars.IsInventoryOpen();
				break;
			case "World+Item": 
				shouldSplit = vars.Watchers["World"].Current == arg1 && vars.PlayerHasItem(arg2);
				break;
			case "Talk":
				shouldSplit = vars.Watchers["IsPlayerInDialogue"].Current == 1 && vars.IsInDialogue(arg1);
				break;
			case "Talk+Chapter":
				shouldSplit = vars.Globals["KAPITEL"].Current == 3 && vars.Watchers["IsPlayerInDialogue"].Current == 1 && vars.IsInDialogue(arg1);
				break;
			case "Kill":
				shouldSplit = vars.Watchers["Exp"].Current > vars.Watchers["Exp"].Old && vars.IsDead(arg1);
				break;	
			case "Guild":
				shouldSplit = vars.Watchers["Guild"].Current == int.Parse(arg1);
				break;
			case "Teleport":
				shouldSplit = vars.PlayerTeleported(arg1, arg2);
				break;
			case "Interactable":
				IntPtr mob = vars.LastInteractable;
				shouldSplit = vars.GetMobTarget(mob) == arg1 && vars.GetMobState(mob) == 1;
				break;							
			case "End":
				shouldSplit = vars.EndingCutscenes.Contains(current.cutscene);
				break;
		}
			
		if (shouldSplit) {
			vars.Info("Split: " + name + " (" + (!string.IsNullOrEmpty(arg1) ? arg1 : "-") + ", " + (!string.IsNullOrEmpty(arg2) ? arg2 : "-") + ")");
			vars.CompletedSplits.Add(name);
			return true;
		}
	}
}

isLoading {
	return true;
}

gameTime {
	return (vars.TimeKeeper + TimeSpan.FromMilliseconds(vars.Watchers["IGT"].Current / 1000));
}

exit {
	vars.TimeKeeper = timer.CurrentTime.GameTime;
}