state("realMyst") {}

startup {
	// Settings


	// Debug
	vars.Info = (Action<string>)((msg) => {
		print("[realMyst Masterpiece ASL] " + msg);
	});   
}

init {
	vars.Scan = new Func<SigScanTarget, IntPtr>((target) => {
        IntPtr ptr = IntPtr.Zero;

        foreach (var page in game.MemoryPages()) {
            var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
			ptr = scanner.Scan(target);

            if (ptr != IntPtr.Zero) {
                return ptr;
            }
        }
		return IntPtr.Zero;
    });

#region Fade
	// 55 48 8B EC 56 41 56 41 57 48 83 EC 18 48 8B F1 48 8B 0C 25 ???????? 33 D2 48 83 EC 20 49 BB ???????? 00 00 00 00 41 FF D3 48 83 C4 20 85 C0
	var FadeTrg = new SigScanTarget(20, 
		"55"+ 
		"48 8B EC"+
		"56"+
		"41 56"+
		"41 57"+
		"48 83 EC 18"+
		"48 8B F1"+
		"48 8B 0C 25 ????????"+
		"33 D2"+
		"48 83 EC 20"+
		"49 BB ???????? 00 00 00 00"+
		"41 FF D3"+
		"48 83 C4 20"+
		"85 C0"
	);

	IntPtr Fade = vars.Scan(FadeTrg);
	if (Fade == IntPtr.Zero) {
		throw new InvalidOperationException("Fade not found.");
	}
	
	Fade = (IntPtr)BitConverter.ToInt32(game.ReadBytes(Fade, 4), 0);
	vars.Info("Found Fade at 0x" + Fade.ToString("X"));
#endregion

#region LoadingLevel
	// 55 48 8B EC 56 48 83 EC 08 48 8B F1 48 83 EC 20 49 BB ????????00000000 41 FF D3 48 83 C4 20 48 8B C8 48 83 EC 20 83 38 00  49 BB ????????00000000 41 FF D3 48 83 C4 20 48 83 EC 20 
	var LoadingLevelTrg = new SigScanTarget(0, 
		"55"+
		"48 8B EC"+
		"56"+
		"48 83 EC 08"+
		"48 8B F1"+
		"48 83 EC 20"+
		"49 BB ????????00000000"+
		"41 FF D3"+
		"48 83 C4 20"+
		"48 8B C8"+
		"48 83 EC 20"+
		"83 38 00"+
		"49 BB ????????00000000"+
		"41 FF D3"+
		"48 83 C4 20"+
		"48 83 EC 20"
	);

	IntPtr LoadingLevel = vars.Scan(LoadingLevelTrg);
	if (LoadingLevel == IntPtr.Zero) {
		throw new InvalidOperationException("LoadingLevel not found.");
	}
	vars.Info("Found LoadingLevel ctor at 0x" + LoadingLevel.ToString("X"));
#endregion

#region Patch
	const int HookSize = 16;
	long moduleBase = modules[0].BaseAddress.ToInt64();
	long trampoline = moduleBase + 0xE3AEE0;
	long thisPtrStorage = moduleBase + 0xD9D000; 
	long returnAddress = (long)LoadingLevel + HookSize;

	byte[] originalBytes = game.ReadBytes((IntPtr)LoadingLevel, HookSize);

	// Patch part 1
	byte[] hookPatch = new byte[16];

	hookPatch[0] = 0xFF;
	hookPatch[1] = 0x25;
	Array.Copy(BitConverter.GetBytes(trampoline), 0, hookPatch, 6, 8);
	hookPatch[14] = 0x90;
	hookPatch[15] = 0x90;

	// Patch part 2
	List<byte> trampolineBytes = new List<byte>();
	
	trampolineBytes.Add(0x50);
	trampolineBytes.AddRange(new byte[] { 0x48, 0xB8 });
	trampolineBytes.AddRange(BitConverter.GetBytes(thisPtrStorage));
	trampolineBytes.AddRange(new byte[] { 0x48, 0x89, 0x08 });
	trampolineBytes.Add(0x58);
	trampolineBytes.AddRange(originalBytes);
	trampolineBytes.AddRange(new byte[] { 0xFF, 0x25, 0x00, 0x00, 0x00, 0x00 });
	trampolineBytes.AddRange(BitConverter.GetBytes(returnAddress));

	// Apply patch
	game.WriteBytes((IntPtr)trampoline, trampolineBytes.ToArray());
	game.WriteBytes((IntPtr)LoadingLevel, hookPatch);
#endregion

	// WATCHERS
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		{ "loadingScreenEnabled", 
			new MemoryWatcher<byte>(new DeepPointer(
				(IntPtr)thisPtrStorage, 0x48, 0x18, 0x31
			)) 
		},
		{ "lastFade", 
			new MemoryWatcher<float>(new DeepPointer(
				Fade, 0x68
			))
		}
	};

	// FLAGS
	vars.completedSplits = new HashSet<string>();
	vars.isLoading = false;
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}
	
	if (vars.Watchers["lastFade"].Changed) {
		vars.Info("lastFade -> " + vars.Watchers["lastFade"].Current);
	}
	
	if (vars.Watchers["loadingScreenEnabled"].Changed) {
		vars.Info("loadingScreenEnabled -> " + vars.Watchers["loadingScreenEnabled"].Current.ToString("X"));
	}
	
	if (!vars.isLoading) {		
		if (vars.Watchers["loadingScreenEnabled"].Old != 1 && vars.Watchers["loadingScreenEnabled"].Current == 1) {
			vars.isLoading = true;
		}		
	}
	if (vars.isLoading) {
		if (vars.Watchers["lastFade"].Old == -1 && vars.Watchers["lastFade"].Current > 0.0f) {
			vars.isLoading = false;
		}
	}
}

isLoading {
	return vars.isLoading;
}