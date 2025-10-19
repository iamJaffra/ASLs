state("Huntsman-Win64-Shipping") {}

startup {
	// itch.io
	settings.Add("itch.io", false, "itch.io version");
		settings.Add("itch.ioSplits", true, "Split on ...", "itch.io");
			settings.Add("itch.ioItems", true, "Collecting Items:", "itch.ioSplits");
				settings.Add("HydrogenPeroxide", true, "Hydrogen Peroxide", "itch.ioItems");
				settings.Add("Blue Keycard", true, "Blue Keycard", "itch.ioItems");
				settings.Add("Red Keycard", true, "Red Keycard", "itch.ioItems");
				settings.Add("Bleach", true, "Bleach", "itch.ioItems");
				settings.Add("Purple Keycard", true, "Purple Keycard", "itch.ioItems");
				settings.Add("Salt", true, "Salt", "itch.ioItems");
				settings.Add("ReactiveAgent", false, "Reactive Agent", "itch.ioItems");
				settings.Add("ToxicSolution", true, "Toxic Solution", "itch.ioItems");
			settings.Add("itch.ioEnd", true, "Locating the dead spider", "itch.ioSplits");

	// Steam
	settings.Add("Steam", false, "Steam version");
		settings.Add("SteamSplits", true, "Split on ...", "Steam");
			settings.Add("Maintenance Key", true, "Collecting the Maintenance Key", "SteamSplits");
			settings.Add("Steam Demo End", true, "Finishing the demo", "SteamSplits");
}

init {
	vars.version = modules[0].FileVersionInfo.FileVersion.Contains("UE5+Release-5.6")
		? "Steam"
		: "itch.io";
	print("Huntsman version = " + vars.version);

	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);
	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
	
	var gWorldTrg = new SigScanTarget(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01") { OnFound = onFound };
	var gEngineTrg = vars.version == "Steam"
		? new SigScanTarget(3, "48 8B 0D ???????? 48 8B 89 ???????? E8") { OnFound = onFound }
		: new SigScanTarget(3, "48 8B 0D ???????? 66 0F 5A C9 E8") { OnFound = onFound };		
	var fNamePoolTrg = new SigScanTarget(7, "8B D9 74 ?? 48 8D 15 ???????? EB") { OnFound = onFound };

	var gWorld = scanner.Scan(gWorldTrg);
	var gEngine = scanner.Scan(gEngineTrg);
	var fNamePool = scanner.Scan(fNamePoolTrg);
	
	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNamePool == IntPtr.Zero) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}


	// GWorld.URL
	vars.world = new StringWatcher(new DeepPointer(gWorld, (vars.version == "Steam" ? 0x6A8 : 0x5C8), 0x0), ReadStringType.UTF16, 100);
	
	vars.numberOfItems = vars.version == "itch.io"
		// GEngine.GameInstance.PickedUpItems[].ArraySize
		? new MemoryWatcher<int>(new DeepPointer(gEngine, 0x10A8, 0x2C0 + 0x8))
		// GEngine.GameInstance.LocalPlayers[0].PlayerController.AcknowledgedPawn.As Horror Engine.PlayerInventory.Num
		: new MemoryWatcher<int>(new DeepPointer(gEngine, 0x1248, 0x38, 0x0, 0x30, 0x350, 0x1918, 0x6A8 + 0x8));
	
	// GEngine.GameInstance.Debug
	vars.debug = new MemoryWatcher<int>(new DeepPointer(gEngine, (vars.version == "itch.io" ? 0x10A8 : 0x1248), 0x2B8));
	
	// GEngine.GameInstance.Loading
	vars.loading = new MemoryWatcher<bool>(new DeepPointer(gEngine, (vars.version == "itch.io" ? 0x10A8 : 0x1248), 0x1C8));

	// GEngine.GameInstance.LocalPlayers[0].PlayerController.AHorrorEngineCharacter_C.YouWin_NewTrack
	vars.spiderHasBeenEliminated = new MemoryWatcher<float>(new DeepPointer(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x2E0, 0x698));

	// GEngine.GameInstance.LocalPlayers[0].PlayerController.AcknowledgedPawn.As Horror Engine.Dead
	vars.dead = new MemoryWatcher<bool>(new DeepPointer(gEngine, 0x1248, 0x38, 0x0, 0x30, 0x350, 0x1918, 0x7F8));
	// GEngine.GameInstance.LocalPlayers[0].PlayerController.AcknowledgedPawn.As Horror Engine.EndOfDemo?
	vars.endOfDemo = new MemoryWatcher<bool>(new DeepPointer(gEngine, 0x1248, 0x38, 0x0, 0x30, 0x350, 0x1918, 0x890));


	vars.LastItem = (Func<string>)(() => {
		var numberOfItems = vars.version == "itch.io"
			// GWorld.GameInstance.PickedUpItems[].ArraySize
			? new DeepPointer(gWorld, 0x1D8, 0x2C0 + 0x8).Deref<int>(game)
			// GEngine.LocalPlayers[0].PlayerController.AcknowledgedPawn.As Horror Engine.PlayerInventory.Num
			: new DeepPointer(gEngine, 0x1248, 0x38, 0x0, 0x30, 0x350, 0x1918, 0x6A8 + 0x8).Deref<int>(game);
		
		var itemsPtr = vars.version == "itch.io"
			? new DeepPointer(gWorld, 0x1D8, 0x2C0).Deref<IntPtr>(game)
			: new DeepPointer(gEngine, 0x1248, 0x38, 0x0, 0x30, 0x350, 0x1918, 0x6A8).Deref<IntPtr>(game);

		return vars.version == "itch.io"
			? game.ReadString(game.ReadPointer(itemsPtr + (numberOfItems - 1) * 0x10), ReadStringType.UTF16, 100)
			: new DeepPointer(itemsPtr + (numberOfItems - 1) * 0x8, 0x508, 0x20, 0x0).DerefString(game, ReadStringType.UTF16, 100);
	});


	vars.completedSplits = new HashSet<string>();

	vars.delay = new Stopwatch();
}

update {
	vars.world.Update(game);
	vars.numberOfItems.Update(game);
	vars.debug.Update(game);
	vars.loading.Update(game);
	vars.spiderHasBeenEliminated.Update(game);
	vars.dead.Update(game);
	vars.endOfDemo.Update(game);

	if (vars.world.Changed) {
		print("World: " + vars.world.Current);
	}
}

start {	
	if (vars.debug.Current == vars.debug.Old + 1) {
		return vars.world.Current == "/Game/Development/Maps/Hunstman_Level" ||
		       vars.world.Current == "/Game/Development/Maps/L_Facility";
	}
}

onStart {
	vars.completedSplits.Clear();
}

reset {
	return vars.world.Current == "/Game/HorrorEngine/Maps/MenuLevel" &&
	       vars.world.Changed;
}

split {
	// End of game
	// itch.io: text "Spider has been Eliminated" appears on screen
	if (settings["itch.ioEnd"] && vars.spiderHasBeenEliminated.Current > 0 && vars.spiderHasBeenEliminated.Old == 0) {
		return true;
	}
	// Steam: demo end screen appears after getting killed by the spider
	if (settings["Steam Demo End"] && vars.endOfDemo.Current && vars.dead.Current && vars.dead.Changed) {
		vars.delay.Start();
		print("Died after End of Demo. Started timer.");
	}
	if (vars.delay.ElapsedMilliseconds >= 6900 && vars.completedSplits.Add("endOfDemo")) {
		vars.delay.Reset();
		print("Timer is up. Split.");
		return true;
	}

	// Items splits
	if (vars.numberOfItems.Current > vars.numberOfItems.Old) {
		var item = vars.LastItem();
		print("Picked up " + item);
		return settings[item] && vars.completedSplits.Add(item);
	}
}

isLoading {
	return vars.loading.Current;
}