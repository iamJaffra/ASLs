state("Gothic-Win64-Shipping") {}

startup {

}

init {
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);
	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
	
	var gNamesTrg = new SigScanTarget(7, "8B D9 74 ?? 48 8D 15 ???????? EB") { OnFound = onFound };
	var gEngineTrg = new SigScanTarget(3, "48 8B 0D ???????? 48 8B BC 24 ???????? 48 8B 9C 24") { OnFound = onFound };

	var gNames = scanner.Scan(gNamesTrg);
	var gEngine = scanner.Scan(gEngineTrg);
	
	if (gNames == IntPtr.Zero || gEngine == IntPtr.Zero) {
		throw new InvalidOperationException("Not all signatures resolved. Trying again.");
	}

	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		{ "LoadScreenFlags",
			new MemoryWatcher<byte>(new DeepPointer(
				gEngine, 
				0x10A8,  // GameInstance
				0x108,   // ~GameInstanceSubsystems~
				0x20,    // [2].Value (SaveGameSubsystem)
				0x2F8,   // LoadScreen
				0xD9     // ~bitfield flags~
			)) 
		},
	};
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}
}

isLoading {
	return (vars.Watchers["LoadScreenFlags"].Current & (1 << 5)) != 0;
}