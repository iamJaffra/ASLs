state("RealMYST") {}

startup {
	// Settings
	vars.PageSplits = new Dictionary<string, Tuple<string, string>> {
		{ "Mechanical Blue",  Tuple.Create("ME_AC_HaveTheBluePage",   "ME_AC_BluePageIsAdded") },
		{ "Mechanical Red",   Tuple.Create("ME_SC_HaveTheRedPage",    "ME_SR_RedPageIsAdded") },
		{ "Stoneship Blue",   Tuple.Create("ST_SIRM_HaveTheRedPage",  "ST_SIRM_RedPageIsAdded") },
		{ "Stoneship Red",    Tuple.Create("ST_AKRM_HaveTheBluePage", "ST_AKRM_BluePageIsAdded") },
		{ "Channelwood Blue", Tuple.Create("CH_AC_HaveTheBluePage",   "CH_AC_BluePageIsAdded") },
		{ "Channelwood Red",  Tuple.Create("CH_SR_HaveTheRedPage",    "CH_SR_RedPageIsAdded") },
		{ "Selenitic Blue",   Tuple.Create("SL_OD_HaveTheBluePage",   "SL_OD_BluePageIsAdded") },
		{ "Selenitic Red",    Tuple.Create("SL_OD_HaveTheRedPage",    "SL_OD_RedPageIsAdded") } 
	};

	vars.GeneralSplits = new Dictionary<string, string> {
		{ "MT_FP_shat_is_close", "Shut the Fireplace." },
		{ "YouWon",              "Give Atrus the white page." }
	};

	settings.Add("Splits", true, "Splits");
		settings.Add("PagePickups", true, "Split on picking up pages:", "Splits");
		settings.Add("PageHandins", true, "Split on handing in pages:", "Splits");

	foreach (var split in vars.PageSplits) {
		var pickUp = split.Value.Item1;
		var handIn = split.Value.Item2;
		var splitDesc = split.Key;
		
		settings.Add(pickUp, false, splitDesc, "PagePickups");
		settings.Add(handIn, false, splitDesc, "PageHandins");
	}

	foreach (var split in vars.GeneralSplits) {
		var splitName = split.Key;
		var splitDesc = split.Value;

		bool defaultOn = false;
		if (splitName == "YouWon") {
			defaultOn = true;
		}
		settings.Add(splitName, defaultOn, splitDesc, "Splits");
	}

	// Timer
	vars.TimerModel = new TimerModel { CurrentState = timer };

	// Debug
	vars.Info = (Action<string>)((msg) => {
		print("[realMyst ASL] " + msg);
	});
}

init {
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);
	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => (IntPtr)BitConverter.ToInt32(p.ReadBytes(addr, 4), 0);

	// Event logger vars
	vars.idxPtr = modules[0].BaseAddress + 0x1B5000;
	vars.bufferPtr = modules[0].BaseAddress + 0x1B5004;
	vars.trampolinePtr = modules[0].BaseAddress + 0x180100;
	vars.last = -1;

	byte[] jmp = new byte[] {
		0xE9, 0xE8, 0x33, 0x06, 0x00         // jmp RealMYST.exe+180100
	};

	var trampoline = new byte[] {
		0x51,                                // push ecx
		0x52,                                // push edx
		0x56,                                // push esi
		0x57,                                // push edi
		0x8B, 0x0D, 0x00, 0x50, 0x5B, 0x00,  // mov ecx,[RealMYST.exe+1B5000]
		0x6B, 0xC9, 0x40,                    // imul ecx,ecx,40
		0x8D, 0xB9, 0x04, 0x50, 0x5B, 0x00,  // lea edi,[ecx+RealMYST.exe+1B5004]
		0xBA, 0x3F, 0x00, 0x00, 0x00,        // mov edx,0000003F
		0xAC,                                // lodsb 
		0xAA,                                // stosb 
		0x84, 0xC0,                          // test al,al
		0x74, 0x03,                          // je RealMYST.exe+180121
		0x4A,                                // dec edx
		0x75, 0xF7,                          // jne RealMYST.exe+180118
		0xC6, 0x07, 0x00,                    // mov byte ptr [edi],00
		0x8B, 0x0D, 0x00, 0x50, 0x5B, 0x00,  // mov ecx,[RealMYST.exe+1B5000]
		0x41,                                // inc ecx
		0x83, 0xF9, 0x32,                    // cmp ecx,32
		0x7C, 0x02,                          // jl RealMYST.exe+180132
		0x31, 0xC9,                          // xor ecx,ecx
		0x89, 0x0D, 0x00, 0x50, 0x5B, 0x00,  // mov [RealMYST.exe+1B5000],ecx
		0x5F,                                // pop edi
		0x5E,                                // pop esi
		0x5A,                                // pop edx
		0x59,                                // pop ecx
		0x85, 0xF6,                          // test esi,esi
		0x57,                                // push edi
		0x8B, 0xF9,                          // mov edi,ecx
		0xE9, 0xD2, 0xCB, 0xF9, 0xFF         // jmp RealMYST.exe+11CD18
	};

	byte[] bytes = game.ReadBytes((IntPtr)vars.trampolinePtr, trampoline.Length);

	if (bytes.SequenceEqual(trampoline)) {
		vars.Info("Patch was already applied. Moving on...");
	}
	else {
		vars.Info("Preparing patch...");

		var eventRegistererTrg = new SigScanTarget(35, 
			"64 A1 00000000"+
			"6A FF"+
			"68 ????????"+
			"50"+
			"64 89 25 00000000"+
			"81 EC 10010000"+
			"56"+
			"8B B4 24 24010000"+
			"85 F6"+
			"57"+
			"8B F9"+
			"8B C6"+
			"75 05"+
			"B8 ????????"
		);

		var eventRegisterer = scanner.Scan(eventRegistererTrg);
		if (eventRegisterer == IntPtr.Zero) {
			throw new InvalidOperationException("Couldn't find event register function.");
		}
		vars.Info("Found event register function. Hooking at address 0x" + eventRegisterer.ToString("X") + "...");

		game.WriteBytes((IntPtr)vars.trampolinePtr, trampoline);
		game.WriteBytes(eventRegisterer, jmp);

		vars.Info("  => Applied patch.");
	}

	/*
	var loaderTrg = new SigScanTarget(2, "8B 0D ???????? 74 1B 8B 11 FF 52 2C 8B 0D ???????? 8B 41 0C F6 C4 10") { OnFound = onFound };
	var loader = scanner.Scan(loaderTrg);

	if (loader == IntPtr.Zero) {
		throw new InvalidOperationException("Couldn't find Save/Load object.");
	}
	vars.Info("Found Save/Load object at 0x" + loader.ToString("X"));
	*/

	/*
	trg = new SigScanTarget(13, "50 8B CE FF 92 64 01 00 00 8B 08 89 0D ???????? 8B 50 04 89 15 ???????? 8B 40 08") { OnFound = onFound };
	var posVector = scanner.Scan(trg);

	if (posVector == IntPtr.Zero) {
		throw new InvalidOperationException("Couldn't find posVector.");
	}
	vars.Info("Found posVector at 0x" + posVector.ToString("X"));
	*/

	// Watchers
	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		{ "saveload", new MemoryWatcher<int>(new DeepPointer("RealMYST.exe", 0x1AAA8C, 0x140)) }, 
	};

	vars.SplitEvents = new HashSet<string>();

	foreach (var page in vars.PageSplits.Values) {
		vars.SplitEvents.Add(page.Item1);
		vars.SplitEvents.Add(page.Item2);
	}
	foreach (var generalEvent in vars.GeneralSplits.Keys) {
		vars.SplitEvents.Add(generalEvent);
	}

	// Flags
	vars.newGame = false;
	vars.completedSplits = new HashSet<string>();
}
	
update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	var idx = game.ReadValue<int>((IntPtr)vars.idxPtr);

	if (idx != vars.last) {
		var cur = vars.last;

		while (cur != idx) {
			cur = (cur + 1) % 0x32;

			var slot = (cur != 0) ? (cur - 1) : 0x31;

			IntPtr addr = (IntPtr)vars.bufferPtr + slot * 64;
			var eventName = game.ReadString(addr, 64);

			vars.Info("(" + slot.ToString("X2") + ") " + eventName);

			//
			var phase = timer.CurrentPhase;

			// Timer not running?
			if (phase == TimerPhase.NotRunning && settings.StartEnabled && vars.newGame) {
				if (eventName == "GL_PlayerMoving") {
					vars.TimerModel.Start();
					vars.newGame = false;
					vars.completedSplits.Clear();
				}
			}

			// Timer running?
			if (phase == TimerPhase.Running) {
				// Split
				if (vars.SplitEvents.Contains(eventName) && settings[eventName] && vars.completedSplits.Add(eventName)) {
					vars.TimerModel.Split();
				}

				// Reset
				if (eventName.StartsWith("OP_")) {
					vars.TimerModel.Reset();
				}
			}
			
			// New game flag
			if (eventName == "MystFirstTime") {
				vars.newGame = true;
			}
		}

		vars.last = idx;
	}
}

start {	return false; }
reset { return false; }
split { return false; }

isLoading {
	var status = vars.Watchers["saveload"].Current;
	return status == 1 || // Loading screen after linking
	       status == 2 || // Saving
	       status == 4;   // Loading a save
}   