state("Huntsman-Win64-Shipping") {}

startup {
	settings.Add("Splits", true, "Split on ...");
		settings.Add("Items", false, "Collecting Items:", "Splits");
			settings.Add("HydrogenPeroxide", true, "Hydrogen Peroxide", "Items");
			settings.Add("Blue Keycard", true, "Blue Keycard", "Items");
			settings.Add("Red Keycard", true, "Red Keycard", "Items");
			settings.Add("Bleach", true, "Bleach", "Items");
			settings.Add("Purple Keycard", true, "Purple Keycard", "Items");
			settings.Add("Salt", true, "Salt", "Items");
			settings.Add("ReactiveAgent", false, "Reactive Agent", "Items");
			settings.Add("ToxicSolution", true, "Toxic Solution", "Items");
		settings.Add("End", true, "Locating the dead spider", "Splits");
}

init {
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);

	var gWorldTrg = new SigScanTarget(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01") { 
		OnFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr) 
	};
	var gEngineTrg = new SigScanTarget(3, "48 8B 0D ???????? 66 0F 5A C9 E8") { 
		OnFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr) 
	};

	var gWorld = scanner.Scan(gWorldTrg);
	var gEngine = scanner.Scan(gEngineTrg);
	
	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero ) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}


	// GWorld.URL
	vars.world = new StringWatcher(new DeepPointer(gWorld, 0x5C8, 0x0), ReadStringType.UTF16, 100);
	// GEngine.GameInstance.PickedUpItems[].ArraySize
	vars.numberOfItems = new MemoryWatcher<int>(new DeepPointer(gEngine, 0x10A8, 0x2C0 + 0x8));
	// GEngine.GameInstance.Debug
	vars.debug = new MemoryWatcher<int>(new DeepPointer(gEngine, 0x10A8, 0x2B8));
	// GEngine.GameInstance.Loading
	vars.loading = new MemoryWatcher<bool>(new DeepPointer(gEngine, 0x10A8, 0x1C8));
	// GEngine.GameInstance.LocalPlayers[0].PlayerController.AHorrorEngineCharacter_C.YouWin_NewTrack
	vars.spiderHasBeenEliminated = new MemoryWatcher<float>(new DeepPointer(gEngine, 0x10A8, 0x38, 0x0, 0x30, 0x2E0, 0x698));


	vars.LastItem = (Func<string>)(() => {
		// GWorld.GameInstance.PickedUpItems[].ArraySize
		var numberOfItems = new DeepPointer(gWorld, 0x1D8, 0x2C0 + 0x8).Deref<int>(game);
		var itemsPtr = new DeepPointer(gWorld, 0x1D8, 0x2C0).Deref<IntPtr>(game);

		return game.ReadString(game.ReadPointer(itemsPtr + (numberOfItems - 1) * 0x10), ReadStringType.UTF16, 100);
	});


	vars.completedSplits = new HashSet<string>();
}

update {
	vars.world.Update(game);
	vars.numberOfItems.Update(game);
	vars.debug.Update(game);
	vars.loading.Update(game);
	vars.spiderHasBeenEliminated.Update(game);
}

start {
	return vars.world.Current == "/Game/Development/Maps/Hunstman_Level" &&
	       vars.debug.Current == vars.debug.Old + 1;
}

onStart {
	vars.completedSplits.Clear();
}

split {
	// End of game: text "Spider has been Eliminated" appears on screen
	if (settings["End"] && vars.spiderHasBeenEliminated.Current > 0 && vars.spiderHasBeenEliminated.Old == 0) {
		return true;
	}
	// Items splits
	else if (vars.numberOfItems.Current > vars.numberOfItems.Old) {
		var item = vars.LastItem();
		return settings[item] && vars.completedSplits.Add(item);
	}
}

isLoading {
	return vars.loading.Current;
}

