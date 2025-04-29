state("Riven-Win64-Shipping") {}

startup {
	// Settings

	settings.Add("Link", true, "Split when linking to another age");
	settings.Add("Ride", true, "Split when arriving on another island via Maglev or minecart");
	settings.Add("SE", true, "Split when entering or exiting Starry Expanse");
	settings.Add("Ending", true, "Split when opening the fissure");
}

init {
	// Sig Scanning

	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);

	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
	
	var fNamePoolTrg = new SigScanTarget(7, 
		"8B D9",                // mov ebx,ecx
		"74 ??",                // je Riven-Win64-Shipping.exe+D6954
		"48 8D 15 ????????",    // lea rdx,[Riven-Win64-Shipping.exe+7EC8880]   <--- FNamePool
		"EB"                    // jmp Riven-Win64-Shipping.exe+D69560
	) { OnFound = onFound };

	var gWorldTrg = new SigScanTarget(3, 
		"48 8B 1D ????????",    // mov rbx,[Riven-Win64-Shipping.exe+80E15A8]   <--- GWorld
		"48 85 DB",             // test rbx,rbx
		"74 ??",                // je Riven-Win64-Shipping.exe+3786914
		"41 B0 01"              // mov r8l,01
	) { OnFound = onFound };

	var fNamePool = scanner.Scan(fNamePoolTrg);
	var gWorld = scanner.Scan(gWorldTrg);
	
	if (fNamePool == IntPtr.Zero || gWorld == IntPtr.Zero )
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");


	// FNamePool

	var fNamePoolCache = new Dictionary<ulong, string>() {{0, "None"}};

	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var number   	= (fName & 0xFFFFFFFF00000000) >> 0x20;
		var nameLookup	= (fName & 0x00000000FFFFFFFF) >> 0x00;

		string name;
		if (fNamePoolCache.ContainsKey(nameLookup)) {
			name = fNamePoolCache[nameLookup];
		} 
		else {
			var chunkIdx	= (fName & 0x00000000FFFF0000) >> 0x10;
			var nameIdx 	= (fName & 0x000000000000FFFF) >> 0x00;

			var chunk = game.ReadPointer(fNamePool + 0x10 + (int)chunkIdx * 0x8);
			var nameEntry = chunk + (int)nameIdx * 0x2;

			var length = game.ReadValue<short>(nameEntry) >> 6;
			name = game.ReadString(nameEntry + 0x2, length);

			fNamePoolCache[nameLookup] = name;
		}

		return number == 0 ? name : name + "_" + number;
	});


	// GameState

	vars.GetIndexOfBoolGamestate = (Func<string, int>)(stateName => {
		IntPtr BoolGameStateMapPtr;
		//              GWorld.BP_RivenGameState_C.BoolGameStateTMap[]
		new DeepPointer(gWorld, 0x170, 0x4F8).Deref(game, out BoolGameStateMapPtr);
		//                                         GWorld.BP_RivenGameState_C.BoolGameStateTMap[].MapSize
		var BoolGameStateMapSize = new DeepPointer(gWorld, 0x170, 0x4F8 + 0xC).Deref<int>(game);

		for (int i = 0; i < BoolGameStateMapSize; i++) {
			var idFName = game.ReadValue<ulong>(BoolGameStateMapPtr + i * 0x50 + 0x8 + 0x10);
			var id = vars.FNameToString(idFName);

			if (id == stateName) {
				return i;
			}
		}
		throw new InvalidOperationException("Couldn't find index for " + stateName + "!");
	});

	vars.GetIndexOfIntGamestate = (Func<string, int>)(stateName => {
		IntPtr IntGameStateMapPtr;
		//              GWorld.BP_RivenGameState_C.IntGameStateTMap[]
		new DeepPointer(gWorld, 0x170, 0x548).Deref(game, out IntGameStateMapPtr);
		//                                        GWorld.BP_RivenGameState_C.IntGameStateTMap[].MapSize
		var IntGameStateMapSize = new DeepPointer(gWorld, 0x170, 0x548 + 0xC).Deref<int>(game);

		for (int i = 0; i < IntGameStateMapSize; i++) {
			var idFName = game.ReadValue<ulong>(IntGameStateMapPtr + i * 0x50 + 0x8 + 0x10);
			var id = vars.FNameToString(idFName);

			if (id == stateName) {
				return i;
			}
		}
		throw new InvalidOperationException("Couldn't find index for " + stateName + "!");
	});

	vars.GetIndexOfFloatGamestate = (Func<string, int>)(stateName => {
		IntPtr FloatGameStateMapPtr;
		//              GWorld.BP_RivenGameState_C.FloatGameStateTMap[]
		new DeepPointer(gWorld, 0x170, 0x5E8).Deref(game, out FloatGameStateMapPtr);
		//                                          GWorld.BP_RivenGameState_C.FloatGameStateTMap[].MapSize
		var FloatGameStateMapSize = new DeepPointer(gWorld, 0x170, 0x5E8 + 0xC).Deref<int>(game);

		for (int i = 0; i < FloatGameStateMapSize; i++) {
			var idFName = game.ReadValue<ulong>(FloatGameStateMapPtr + i * 0x50 + 0x8 + 0x10);
			var id = vars.FNameToString(idFName);

			if (id == stateName) {
				return i;
			}
		}
		throw new InvalidOperationException("Couldn't find index for " + stateName + "!");
	});


	// i can hash cheezburger?  

	string hash;

	using (var md5 = System.Security.Cryptography.MD5.Create())
	using (var fs = File.OpenRead(modules.First().FileName))
		hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));


	switch (hash) {
		// Steam 1.0 
		case "7C60B0A72F70178F3B94B34E034D2179": 
			vars.CurrentlyOnRideOffset = 0xF31;       // bool bCurrentlyOnRide;
			vars.PlayerInDomeOffset = 0xEF4;          // bool bFMDLinking;
			vars.NewGameOffset = 0xEF0;               // bool bProcessingGameChange;
			vars.NewGameFromMainMenuOffset = 0xF50;   // bool bForceMenuCheckInvisible;
			vars.NewGameFromInGameOffset = 0xEF2;     // bool bNewGameFiredOffFromInGame;
			vars.LoadSaveOffset = 0xEF3;              // bool bLoadGameFiredOffFromInGame;
			break;

		// Steam 1.1 
		case "9064284A7FCB34B3F48BB46D924A3A04": 
			vars.CurrentlyOnRideOffset = 0xF41;
			vars.PlayerInDomeOffset = 0xEF4;
			vars.NewGameOffset = 0xEF0;
			vars.NewGameFromMainMenuOffset = 0xF50;
			vars.NewGameFromInGameOffset = 0xEF2;
			vars.LoadSaveOffset = 0xEF3;
			break;

		// Steam 1.2 
		case "2E9C92BAA78676E2FB5B47F56A289865": 
			vars.CurrentlyOnRideOffset = 0xF61;
			vars.PlayerInDomeOffset = 0xF34;
			vars.NewGameOffset = 0xF30;
			vars.NewGameFromMainMenuOffset = 0xF90;
			vars.NewGameFromInGameOffset = 0xF32;
			vars.LoadSaveOffset = 0xF33;
			break;

		// Steam 1.3 (and later?)
		case "D8FAAF543DF8ABDA32AB697875478B32":
		default:
			vars.CurrentlyOnRideOffset = 0xF61;
			vars.PlayerInDomeOffset = 0xF34;
			vars.NewGameOffset = 0xF30;
			vars.NewGameFromMainMenuOffset = 0xF90;
			vars.NewGameFromInGameOffset = 0xF32;
			vars.LoadSaveOffset = 0xF33;
			break;
	}


	// Memory Watchers

	vars.Watchers = new MemoryWatcherList {
		// GWorld.PersistentLevel.Riven_MasterMap_C.BP_RivenLevelPager_C.b??
		new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x30, 0xE8, 0x348, 0x3F3)) { Name = "Linking" },	// Note: this is 0 while linking, and 1 otherwise
		// GWorld.PersistentLevel.Riven_MasterMap_C.BP_RivenLevelPager_C.bIsNewGame
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x30, 0xE8, 0x348, 0x3E8)) { Name = "KveerIntro" },
		new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x30, 0xE8, 0x348, 0x524)) { Name = "Status" },
		
		// BoolGameState Pointers
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("MaglevTempleLocation") * 0x50 + 0x8 + 0x39)) { Name = "MaglevTempleLocation" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("MaglevJungleLocation") * 0x50 + 0x8 + 0x39)) { Name = "MaglevJungleLocation" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("MaglevBoilerLocation") * 0x50 + 0x8 + 0x39)) { Name = "MaglevBoilerLocation" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("MineCartAtBoilerIsland") * 0x50 + 0x8 + 0x39)) { Name = "MineCartAtBoilerIsland" },

		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("PrisonFiremarbleDomeOpen") * 0x50 + 0x8 + 0x39)) { Name = "PrisonFiremarbleDomeOpen" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("TempleFiremarbleDomeOpen") * 0x50 + 0x8 + 0x39)) { Name = "TempleFiremarbleDomeOpen" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("BoilerFiremarbleDomeOpen") * 0x50 + 0x8 + 0x39)) { Name = "BoilerFiremarbleDomeOpen" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("JungleFiremarbleDomeOpen") * 0x50 + 0x8 + 0x39)) { Name = "JungleFiremarbleDomeOpen" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("SurveyFiremarbleDomeOpen") * 0x50 + 0x8 + 0x39)) { Name = "SurveyFiremarbleDomeOpen" },

		new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x170, 0x4F8, vars.GetIndexOfBoolGamestate("CraneControlsSpinnerLeverLocation") * 0x50 + 0x8 + 0x39)) { Name = "CraneControlsSpinnerLeverLocation" },

		// IntGameState Pointers
		new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x170, 0x548, vars.GetIndexOfIntGamestate("CraneControlsLeverLocation") * 0x50 + 0x8 + 0x3C)) { Name = "CraneControlsLeverLocation" },

		// FloatGameState Pointers
		new MemoryWatcher<float>(new DeepPointer(gWorld, 0x170, 0x5E8, vars.GetIndexOfFloatGamestate("PlateauCraneLocation") * 0x50 + 0x8 + 0x3C)) { Name = "PlateauCraneLocation" },
		new MemoryWatcher<float>(new DeepPointer(gWorld, 0x170, 0x5E8, vars.GetIndexOfFloatGamestate("PlateauCraneHeight") * 0x50 + 0x8 + 0x3C)) { Name = "PlateauCraneHeight" },

		// Other Pointers
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x1D0, 0x38, 0x0, 0x30, 0x378, vars.CurrentlyOnRideOffset)) { Name = "CurrentlyOnRide" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x1D0, 0x38, 0x0, 0x30, vars.PlayerInDomeOffset)) { Name = "PlayerInDome" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x1D0, 0x38, 0x0, 0x30, vars.NewGameOffset)) { Name = "NewGame" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x1D0, 0x38, 0x0, 0x30, vars.NewGameFromMainMenuOffset)) { Name = "NewGameFromMainMenu" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x1D0, 0x38, 0x0, 0x30, vars.NewGameFromInGameOffset)) { Name = "NewGameFromInGame" },
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x1D0, 0x38, 0x0, 0x30, vars.LoadSaveOffset)) { Name = "LoadSave" },
	};

	vars.TargetAgeName = new StringWatcher(new DeepPointer(gWorld, 0x30, 0xE8, 0x348, 0x410, 0x0), ReadStringType.UTF16, 10);
	

	// Flags
	vars.LoadingSaveGame = false;
	vars.isPostMaglevLoad = false;
	vars.startingNewGameFromInGame = false;
	vars.isLoading = false;
	vars.booting = true;
}


update {
	vars.Watchers.UpdateAll(game);	
	vars.TargetAgeName.Update(game);


	// Prevent game from considering loading a save as linking for the purpose of splitting

	if (!vars.LoadingSaveGame) {
		if (vars.Watchers["LoadSave"].Current && !vars.Watchers["LoadSave"].Old) {
			vars.LoadingSaveGame = true;
		}
	}
	if (vars.LoadingSaveGame) {
		if (vars.Watchers["Linking"].Current == 1 && vars.Watchers["Linking"].Old == 0) {
			vars.LoadingSaveGame = false;
		}
	}
   

	// Handle post-Maglev loads

	if (vars.Watchers["CurrentlyOnRide"].Current && vars.Watchers["Linking"].Current == 1) {
		if (!vars.isPostMaglevLoad && (
				vars.Watchers["MaglevTempleLocation"].Changed 
				|| vars.Watchers["MaglevJungleLocation"].Changed 
				|| vars.Watchers["MaglevBoilerLocation"].Changed
				|| vars.Watchers["MineCartAtBoilerIsland"].Changed ) ) {
			vars.isPostMaglevLoad = true;
		}
	}
	if (vars.isPostMaglevLoad && !vars.Watchers["CurrentlyOnRide"].Current && vars.Watchers["CurrentlyOnRide"].Old) {
		vars.isPostMaglevLoad = false;
	}


	// Resume timer after "linking" back into main menu after closing game mid-run

	if (timer.IsGameTimePaused && vars.Watchers["Linking"].Old == 0 && vars.Watchers["Linking"].Current == 1) {
		 timer.IsGameTimePaused = false;
	}


	// New game from in game

	if (vars.Watchers["NewGameFromInGame"].Current) {
		if (!vars.Watchers["NewGame"].Current && vars.Watchers["NewGame"].Old) {
			vars.startingNewGameFromInGame = true;
			return true;
		}  
	}


	// Don't count fades as loads

	if (!vars.Watchers["PlayerInDome"].Current && !vars.Watchers["CurrentlyOnRide"].Current) {
		if (!vars.isLoading && vars.Watchers["Linking"].Current == 0) {
			if (vars.Watchers["Status"].Current == 11 && vars.Watchers["Status"].Changed) {
				vars.isLoading = true;
			}
		}
		if (vars.isLoading && vars.Watchers["Linking"].Current == 0) {
			if (vars.Watchers["Status"].Current == 9 && vars.Watchers["Status"].Changed) {
				vars.booting = false;
				vars.isLoading = false;
			}
		}
	}
	if (vars.Watchers["PlayerInDome"].Current || vars.Watchers["CurrentlyOnRide"].Current || vars.booting) {
		vars.isLoading = vars.Watchers["Linking"].Current == 0;
	}
}


start {
	if (vars.Watchers["NewGameFromMainMenu"].Current) {
		if (!vars.Watchers["NewGame"].Current && vars.Watchers["NewGame"].Old) {
			timer.IsGameTimePaused = true;
			return true;
		}
	}
	if (vars.startingNewGameFromInGame) {
		if (vars.Watchers["Linking"].Old == 0 && vars.Watchers["Linking"].Current == 1) {
			return true;
		}
	}
}
onStart {
	vars.startingNewGameFromInGame = false;
}

split {
	if (vars.LoadingSaveGame) {
		return false;
	}


	// Split when linking to another age

	if (settings["Link"] && !vars.Watchers["CurrentlyOnRide"].Current && !vars.Watchers["PlayerInDome"].Current) {
		if (vars.Watchers["KveerIntro"].Current && vars.TargetAgeName.Current == "TPL" && vars.TargetAgeName.Old == "DNI") {
			return true;
		}
		if (!vars.Watchers["KveerIntro"].Current && vars.TargetAgeName.Changed && vars.TargetAgeName.Old != "DNI") {
			return true;
		}
	}


	// Split when arriving on a different island via Maglev or minecart

	if (settings["Ride"] && vars.Watchers["CurrentlyOnRide"].Current) {
		if (vars.Watchers["MaglevTempleLocation"].Changed 
				|| vars.Watchers["MaglevJungleLocation"].Changed 
				|| vars.Watchers["MaglevBoilerLocation"].Changed
				|| vars.Watchers["MineCartAtBoilerIsland"].Changed) {
			return true;
		}
	}
	

	// Split when a firemarble dome closes while the player is inside

	if (settings["SE"]) {
		if (vars.Watchers["PlayerInDome"].Current) {
			if ((vars.Watchers["TempleFiremarbleDomeOpen"].Old && !vars.Watchers["TempleFiremarbleDomeOpen"].Current)
					|| (vars.Watchers["PrisonFiremarbleDomeOpen"].Old && !vars.Watchers["PrisonFiremarbleDomeOpen"].Current)
					|| (vars.Watchers["BoilerFiremarbleDomeOpen"].Old && !vars.Watchers["BoilerFiremarbleDomeOpen"].Current)
					|| (vars.Watchers["JungleFiremarbleDomeOpen"].Old && !vars.Watchers["JungleFiremarbleDomeOpen"].Current)
					|| (vars.Watchers["SurveyFiremarbleDomeOpen"].Old && !vars.Watchers["SurveyFiremarbleDomeOpen"].Current) ) {
				return true;
			}
		}
		if (!vars.Watchers["TempleFiremarbleDomeOpen"].Current
				&& !vars.Watchers["PrisonFiremarbleDomeOpen"].Current
				&& !vars.Watchers["BoilerFiremarbleDomeOpen"].Current
				&& !vars.Watchers["JungleFiremarbleDomeOpen"].Current
				&& !vars.Watchers["SurveyFiremarbleDomeOpen"].Current) {
			if (!vars.Watchers["PlayerInDome"].Old && vars.Watchers["PlayerInDome"].Current) {
				return true;
			}
		}
	}


	// Ending split

	if (settings["Ending"] 
			&& vars.Watchers["PlateauCraneLocation"].Current == 0 
			&& vars.Watchers["PlateauCraneHeight"].Current == 0 
			&& vars.Watchers["CraneControlsLeverLocation"].Old == 1 
			&& vars.Watchers["CraneControlsSpinnerLeverLocation"].Current == 0
			&& vars.Watchers["CraneControlsLeverLocation"].Current == 0) {
		return true;
	}	
}


isLoading {
	return vars.isPostMaglevLoad || vars.isLoading;
}


exit {
	timer.IsGameTimePaused = true;
}