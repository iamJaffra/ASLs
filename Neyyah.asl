// ASL by Jaffra

state("Neyyah") {}

startup {
	vars.splits = new List<string[]> {	
		// Split name, origin, destination, description
		new string[] { "Felitsu Island", 
		               "OlujayJalood Station 14a",
		               "Felitsu Island Gufunkye Arrival Area 1a",
		               "Reach Felitsu Island"},
	};

	settings.Add("Splits", true, "Splits");

	foreach (var s in vars.splits) {
		var splitName   = s[0];
		var description = s[3];

		settings.Add(splitName, true, description, "Splits");
	}
}

init {
	var scanner = new SignatureScanner(game, modules[0].BaseAddress, modules[0].ModuleMemorySize);
	SigScanTarget.OnFoundCallback onFound = (p, _, addr) => addr + 0x4 + p.ReadValue<int>(addr);
	
	var trg = new SigScanTarget(8, "BA 01000000 48 8B 0D ???????? E8 ???????? 80 3D ???????? 00") { OnFound = onFound };
	var ptr = scanner.Scan(trg);
	
	if (ptr == IntPtr.Zero) {
		throw new InvalidOperationException("Failed to find signature. Trying again.");
	}
	
	// print("ptr = " + ptr.ToString("X"));

	vars.Watchers = new Dictionary<string, MemoryWatcher> {
		// TGameControl -> TSceneControl -> TVisionaireObject (presumably the Scene object) -> Name
		{ "card", new StringWatcher(new DeepPointer(ptr, 0x290, 0x18, 0x38, 0x0), 128) },
	};

	vars.completedSplits = new HashSet<string>();
}

update {
	foreach (var watcher in vars.Watchers.Values) {
		watcher.Update(game);
	}

	if (vars.Watchers["card"].Changed) {
		// Putting quotation marks around the name to catch the rampant trailing spaces
		print("Current card = '" + vars.Watchers["card"].Current + "'");
	}

	current.card = vars.Watchers["card"].Current;
}

start {
	return current.card == "player enter olujay " && old.card == "choose your journey mode";
}

onStart {
	vars.completedSplits.Clear();
}

reset {
	return current.card == "START MENU" && old.card != "START MENU";
}

split {
	foreach (var s in vars.splits) {
		var splitName   = s[0];
		var origin      = s[1];
		var destination = s[2];

		if (settings[splitName] &&
		    old.card == origin && current.card == destination &&
		    vars.completedSplits.Add(splitName)) {
			return true;
		}
	}
}