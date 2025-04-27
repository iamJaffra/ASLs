state("Firmament-Win64-Shipping") {}

startup {
    // Enter your USERNAME here:
    vars.filePath = @"c:\Users\[USERNAME]\AppData\Local\Firmament\Saved\SaveGames\Slot0GameState.sav";

	// Settings

    settings.Add("Link", true, "Split on pod transitions");
        settings.Add("SkipSwan", false, "Exclude transitions from Swan (Any%)", "Link");

    settings.Add("Spires", true, "Spires");
        settings.Add("GlacialSpireRaised", true, "Raised Curievale Spire", "Spires");
        settings.Add("CoastalSpireRaised", true, "Raised Juleston Spire", "Spires");
        settings.Add("OrchardSpireRaised", true, "Raised St. Andrew Spire", "Spires");

    settings.Add("Embraces", true, "Embraces");
        settings.Add("GlacialSpireBridge", true, "Initiated Curievale Embrace", "Embraces");
        settings.Add("CoastalSpireBridge", true, "Initiated Juleston Embrace", "Embraces");
        settings.Add("OrchardSpireBridge", true, "Initiated St. Andrew Embrace", "Embraces");
    
    settings.Add("Upgrades", true, "Upgrades");
        settings.Add("MultiSocketUpgrade", true, "Obtained Multi-Socket Upgrade", "Upgrades");
        settings.Add("ExtendedTetherUpgrade", true, "Obtained Extended Tether Upgrade", "Upgrades");
        settings.Add("TorqueUpgrade", true, "Obtained Torque Upgrade", "Upgrades");

    settings.Add("RealmSubsplits", false, "Additional subsplits (please suggest some)");
        settings.Add("CurievaleSplits", true, "Curievale subsplits", "RealmSubsplits");
            settings.Add("Curievale1", true, "...", "CurievaleSplits");
        settings.Add("StAndrewSplits", true, "St. Andrew subsplits", "RealmSubsplits");
            settings.Add("StAndrew1", true, "...", "StAndrewSplits");
        settings.Add("JulestonSplits", true, "Juleston subsplits", "RealmSubsplits");
            settings.Add("Juleston1", true, "...", "JulestonSplits");

    settings.Add("Ending", true, "Ending");

    settings.Add("AutosaveTimer", false, "Display Time Since Last Autosave (Any%) - put file path in your ASL!");


    // Autosave Stuff

    vars.lastModified = File.GetLastWriteTime(vars.filePath);
    vars.autosave = 0;

    // Create Text Component

    var lcCache = new Dictionary<string, LiveSplit.UI.Components.ILayoutComponent>();
    vars.SetText = (Action<string, object>)((text1, text2) => {
        LiveSplit.UI.Components.ILayoutComponent lc;
        if (!lcCache.TryGetValue(text1, out lc))
            lcCache[text1] = lc = LiveSplit.UI.Components.ComponentManager.LoadLayoutComponent("LiveSplit.Text.dll", timer);

        if (!timer.Layout.LayoutComponents.Contains(lc))
            timer.Layout.LayoutComponents.Add(lc);

        dynamic tc = lc.Component;
        tc.Settings.Text1 = text1;
        tc.Settings.Text2 = text2.ToString();
    });

    vars.RemoveAllTexts = (Action)(() => {
        foreach (var lc in lcCache.Values)
            timer.Layout.LayoutComponents.Remove(lc);

        lcCache.Clear();
    });


    // Flags

    vars.reBooting = false;
    vars.completedSplits = new List<string>();
}

init {
    // Scanner

    var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);

	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
    

    // Check version

    string hash;

    using (var md5 = System.Security.Cryptography.MD5.Create())
    using (var fs = File.OpenRead(modules.First().FileName))
        hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    print(hash);
    
    switch (hash) {
        // Steam 1.0.6
        case "A0A152187D4EB8555E7349ABEFB8EECD": 
            vars.fNamePoolSignature = "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15";
            vars.fNamePoolOffset = 13;

            vars.LevelPagerOffset = 0x2F0;              // class ALEVELPAGER* LEVELPAGER;
                vars.LinkingOffset = 0x4D0;             // bTransportPodLinking
                vars.StatusOffset = 0x45C;              // ?
                vars.NewGameOffset = 0x350;             // bIsNewGame
                vars.TargetAgeNameOffset = 0x468;       // FString TargetAgeName;

            vars.GameInstanceOffset = 0x198;
                vars.NewGameFromInGameOffset = 0x930;   // bNewGameFiredOffFromInGame
                vars.LoadingSaveGameOffset = 0x931;     // bLoadGameFiredOffFromInGame
                vars.GameChangeOffset = 0x932;          // bProcessingGameChange

            vars.GameStateOffset = 0x138;
                vars.BoolGameStatesOffset = 0x450;      // TMap<class FName, class FBoolGameState> BoolGameStates

            break;

        // Steam 2.0.6
        case "1EC9EA4EBE788CE0AC827228C9003BC8":
            vars.fNamePoolSignature = "8B D9 74 ?? 48 8D 15 ???????? EB";
            vars.fNamePoolOffset = 7;

            vars.LevelPagerOffset = 0x378;              // class ALEVELPAGER* LEVELPAGER;
                vars.LinkingOffset = 0x5D0;             // bTransportPodLinking
                vars.StatusOffset = 0x524;              // ?
                vars.NewGameOffset = 0x3E8;             // bIsNewGame
                vars.TargetAgeNameOffset = 0x410;       // FString TargetAgeName;

            vars.GameInstanceOffset = 0x1D0;
                vars.NewGameFromInGameOffset = 0xF18;   // bNewGameFiredOffFromInGame
                vars.LoadingSaveGameOffset = 0xF19;     // bLoadGameFiredOffFromInGame
                vars.GameChangeOffset = 0xF1A;          // bProcessingGameChange

            vars.GameStateOffset = 0x170;
                vars.BoolGameStatesOffset = 0x4F8;      // TMap<class FName, class FBoolGameState> BoolGameStates

            break;

        default : throw new InvalidOperationException("Unknown version!"); break;
    }

    var fNamePoolTrg = new SigScanTarget(vars.fNamePoolOffset, vars.fNamePoolSignature) { OnFound = onFound };


    // GWorld is the same for all versions (so far)

	var gWorldTrg = new SigScanTarget(3, 
		"48 8B 1D ????????",	// mov rbx,[Firmament-Win64-Shipping.exe+5BCBBE8]   <--- GWorld
		"48 85 DB",				// test rbx,rbx
		"74 ??",				// je Firmament-Win64-Shipping.exe+8F6534
		"41 B0 01"				// mov r8l,01
	) { OnFound = onFound };

    
    // Sig Scan

	var fNamePool = scanner.Scan(fNamePoolTrg);
	var gWorld = scanner.Scan(gWorldTrg);
	
	if (fNamePool == IntPtr.Zero || gWorld == IntPtr.Zero )
		throw new InvalidOperationException("Not all signatures resolved.");

    print("Found all signatures!");


	// FNamePool

	vars.FNameToString = (Func<ulong, string>)(fName =>	{
		var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;

		var chunk = game.ReadPointer(fNamePool + 0x10 + (int)chunkIdx * 0x8);
		var nameEntry = chunk + (int)nameIdx * 0x2;

		var length = game.ReadValue<short>(nameEntry) >> 6;
		var name = game.ReadString(nameEntry + 0x2, length);

		return number == 0 ? name : name + "_" + number;
	});


    // GameState

    vars.GetIndexOfBoolGamestate = (Func<string, int>)(stateName => {
        IntPtr BoolGameStateMapPtr;
        //              GWorld.BP_FirmamentGameState_C.BoolGameStateTMap[]
        new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset).Deref(game, out BoolGameStateMapPtr);
        //                                         GWorld.BP_FirmamentGameState_C.BoolGameStateTMap[].MapSize
        var BoolGameStateMapSize = new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset + 0xC).Deref<int>(game);

        for (int i = 0; i < BoolGameStateMapSize; i++) {
            var idFName = game.ReadValue<ulong>(BoolGameStateMapPtr + i * 0x50 + 0x8 + 0x10);
            var id = vars.FNameToString(idFName);

            if (id == stateName) {
                return i;
            }
        }
        throw new InvalidOperationException("Couldn't find index for " + stateName + "!");
    });


    // Memory Watchers

	vars.Watchers = new MemoryWatcherList {
		// GWorld.PersistentLevel.Firmament_MasterMap_C.BP_FirmamentLevelPager_C.bTransportPodLinking
		new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x30, 0xE8, vars.LevelPagerOffset, vars.LinkingOffset)) { Name = "Linking" },
        // GWorld.PersistentLevel.Firmament_MasterMap_C.BP_FirmamentLevelPager_C.Status
        new MemoryWatcher<byte>(new DeepPointer(gWorld, 0x30, 0xE8, vars.LevelPagerOffset, vars.StatusOffset)) { Name = "Status" },
        // GWorld.PersistentLevel.Firmament_MasterMap_C.BP_FirmamentLevelPager_C.bIsNewGame
        new MemoryWatcher<bool>(new DeepPointer(gWorld, 0x30, 0xE8, vars.LevelPagerOffset, vars.NewGameOffset)) { Name = "NewGame" },

        // GWorld.GameInstance.LocalPlayer.BP_FirmamentController_C...
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameInstanceOffset, 0x38, 0x0, 0x30, vars.NewGameFromInGameOffset)) { Name = "NewGameFromInGame" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameInstanceOffset, 0x38, 0x0, 0x30, vars.LoadingSaveGameOffset)) { Name = "LoadingSaveGame" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameInstanceOffset, 0x38, 0x0, 0x30, vars.GameChangeOffset)) { Name = "GameChange" },
        
		// BoolGameState Pointers
        // GWorld.BP_FirmamentGameState_C.BoolGameStates
		new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("MultiSocketUpgrade") * 0x50 + 0x8 + 0x39)) { Name = "MultiSocketUpgrade" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("ExtendedTetherUpgrade") * 0x50 + 0x8 + 0x39)) { Name = "ExtendedTetherUpgrade" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("TorqueUpgrade") * 0x50 + 0x8 + 0x39)) { Name = "TorqueUpgrade" },

        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("GlacialSpireRaised") * 0x50 + 0x8 + 0x39)) { Name = "GlacialSpireRaised" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("CoastalSpireRaised") * 0x50 + 0x8 + 0x39)) { Name = "CoastalSpireRaised" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("OrchardSpireRaised") * 0x50 + 0x8 + 0x39)) { Name = "OrchardSpireRaised" },

        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("GlacialSpireBridge") * 0x50 + 0x8 + 0x39)) { Name = "GlacialSpireBridge" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("CoastalSpireBridge") * 0x50 + 0x8 + 0x39)) { Name = "CoastalSpireBridge" },
        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("OrchardSpireBridge") * 0x50 + 0x8 + 0x39)) { Name = "OrchardSpireBridge" },

        new MemoryWatcher<bool>(new DeepPointer(gWorld, vars.GameStateOffset, vars.BoolGameStatesOffset, vars.GetIndexOfBoolGamestate("DisableEndGameFinalDoors") * 0x50 + 0x8 + 0x39)) { Name = "DisableEndGameFinalDoors" },
	};

    vars.TargetAgeName = new StringWatcher(new DeepPointer(gWorld, 0x30, 0xE8, vars.LevelPagerOffset, vars.TargetAgeNameOffset, 0x0), ReadStringType.UTF16, 10);
    

    // Flags
    vars.LoadingSaveGame = false;
    vars.isLoading = false;
    vars.isLinking = false;
    vars.linkingPhase = 0;
    vars.newGame = false;
    vars.finalTime = 0;
}

update {
    vars.Watchers.UpdateAll(game);	
    vars.TargetAgeName.Update(game);


    // Loading a save
    
    if (!vars.LoadingSaveGame) {
        if (vars.Watchers["LoadingSaveGame"].Current && !vars.Watchers["LoadingSaveGame"].Old) {
            vars.LoadingSaveGame = true;
        }
    }

    if (vars.LoadingSaveGame) {
        if (!vars.isLoading && 2 < vars.Watchers["Status"].Current && (vars.Watchers["Status"].Current < 8 || vars.Watchers["Status"].Current == 11) && vars.Watchers["Status"].Changed) {
            vars.isLoading = true;
        }
        if (vars.isLoading && (vars.Watchers["Status"].Current == 9 || vars.Watchers["Status"].Current == 0) && vars.Watchers["Status"].Changed) {
            vars.isLoading = false;
            vars.LoadingSaveGame = false;
        }
    }


    // Resume timer on main menu after rebooting

    if (vars.reBooting) {
        if (vars.Watchers["Status"].Current == 9 && vars.Watchers["Status"].Changed) {
            vars.reBooting = false;
        }
    }


    // Handle Spodding (for glitched runs)
    // The game considers the player to be linking indefinitely, so we additionally check the status

    if (!vars.isLinking && vars.Watchers["Linking"].Current && vars.Watchers["Linking"].Changed) {
        vars.isLinking = true;
    }
    if (vars.isLinking) {
        if (vars.linkingPhase == 0) {
            if (vars.Watchers["Status"].Current == 5) {
                vars.linkingPhase = 1;
            }
        }
        if (vars.linkingPhase == 1) {
            if (vars.Watchers["Status"].Old >= 5 && vars.Watchers["Status"].Current < 5) {
                vars.linkingPhase = 0;
                vars.isLinking = false;
            }
        }
    }


    // Final split

    if (vars.finalTime == 0 && vars.Watchers["DisableEndGameFinalDoors"].Current && vars.Watchers["DisableEndGameFinalDoors"].Changed) {
        // The subtitle "(futuristic-sounding chime) Scanning..." appears 28 frames after DisableEndGameFinalDoors is set to true
        vars.finalTime = timer.CurrentTime.GameTime.Value.TotalMilliseconds + 466.666667;
    }


    // Display Time since last Autosave
    if (settings["AutosaveTimer"]) {
        var lastWrite = File.GetLastWriteTime(vars.filePath);

        if (lastWrite != vars.lastModified) {
            vars.lastModified = lastWrite;
            vars.autosave = 0;
        }
        else {
            var elapsed = DateTime.Now - vars.lastModified;
            vars.autosave = elapsed.TotalSeconds;
        }

        vars.SetText("Last Autosave:", vars.autosave.ToString("0.0", System.Globalization.CultureInfo.InvariantCulture));
    }
}


start {
    // New game from main menu
    if (vars.TargetAgeName.Current == "MENU" && vars.Watchers["NewGame"].Current && vars.Watchers["GameChange"].Current) {
        vars.newGame = true;
    }
    // New game from in game
    if (vars.Watchers["NewGameFromInGame"].Current) {
        vars.newGame = true;
    }

    // Timer starts when the loading screen ends and the game fades in
    if (vars.newGame && vars.Watchers["Status"].Current == 9 && vars.Watchers["Status"].Changed) {
        vars.newGame = false;
        return true;
    }
}
onStart {
	vars.completedSplits.Clear();
}


split {
    /*
    if (vars.LoadingSaveGame) {
        return false;
    }
    */

    // Split on pod transitions

    if (vars.Watchers["Linking"].Current && !vars.Watchers["Linking"].Old) {
        if (!(settings["SkipSwan"] && vars.TargetAgeName.Old == "HUB")) {
            return true;
        }
    }


    // Spires

    if (!vars.completedSplits.Contains("GlacialSpireRaised") && vars.Watchers["GlacialSpireRaised"].Current && !vars.Watchers["GlacialSpireRaised"].Old) {
        vars.completedSplits.Add("GlacialSpireRaised");
        return true;
    }
    if (!vars.completedSplits.Contains("CoastalSpireRaised") && vars.Watchers["CoastalSpireRaised"].Current && !vars.Watchers["CoastalSpireRaised"].Old) {
        vars.completedSplits.Add("CoastalSpireRaised");
        return true;
    }
    if (!vars.completedSplits.Contains("OrchardSpireRaised") && vars.Watchers["OrchardSpireRaised"].Current && !vars.Watchers["OrchardSpireRaised"].Old) {
        vars.completedSplits.Add("OrchardSpireRaised");
        return true;
    }


    // Embraces

    if (!vars.completedSplits.Contains("GlacialSpireBridge") && vars.Watchers["GlacialSpireBridge"].Current && !vars.Watchers["GlacialSpireBridge"].Old) {
        vars.completedSplits.Add("GlacialSpireBridge");
        return true;
    }
    if (!vars.completedSplits.Contains("CoastalSpireBridge") && vars.Watchers["CoastalSpireBridge"].Current && !vars.Watchers["CoastalSpireBridge"].Old) {
        vars.completedSplits.Add("CoastalSpireBridge");
        return true;
    }
    if (!vars.completedSplits.Contains("OrchardSpireBridge") && vars.Watchers["OrchardSpireBridge"].Current && !vars.Watchers["OrchardSpireBridge"].Old) {
        vars.completedSplits.Add("OrchardSpireBridge");
        return true;
    }


    // Upgrades

    if (!vars.completedSplits.Contains("MultiSocketUpgrade") && vars.Watchers["MultiSocketUpgrade"].Current && !vars.Watchers["MultiSocketUpgrade"].Old) {
        vars.completedSplits.Add("MultiSocketUpgrade");
        return true;
    }
    if (!vars.completedSplits.Contains("ExtendedTetherUpgrade") && vars.Watchers["ExtendedTetherUpgrade"].Current && !vars.Watchers["ExtendedTetherUpgrade"].Old) {
        vars.completedSplits.Add("ExtendedTetherUpgrade");
        return true;
    }
    if (!vars.completedSplits.Contains("TorqueUpgrade") && vars.Watchers["TorqueUpgrade"].Current && !vars.Watchers["TorqueUpgrade"].Old) {
        vars.completedSplits.Add("TorqueUpgrade");
        return true;
    }


    // Final split
    
    if (vars.finalTime > 0 && timer.CurrentTime.GameTime >= TimeSpan.FromMilliseconds(vars.finalTime)) {
        timer.SetGameTime(TimeSpan.FromMilliseconds(vars.finalTime));
        vars.finalTime = 0;
        return true;
    }
}


isLoading {
    return vars.isLinking || vars.isLoading || vars.reBooting;
}


shutdown
{
    vars.RemoveAllTexts();
}
exit {
	timer.IsGameTimePaused = true;
    vars.reBooting = true;

    vars.RemoveAllTexts();
}