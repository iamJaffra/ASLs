state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("Scumm");
	//vars.ScummVM.LogChangedWatchers();
	vars.ScummVM.LogResolvedPaths();

	settings.Add("Splits", true, "Splits");
		//
		settings.Add("Beginning", true, "Beginning", "Splits");	
			settings.Add("Distaff", true, "Pick up the Distaff.", "Beginning");
			settings.Add("Sky", false, "Open the sky.", "Beginning");
			settings.Add("NightVision", false, "Learn Night Vision.", "Beginning");
			settings.Add("StrawToGold", false, "Learn Straw To Gold.", "Beginning");
		//
		settings.Add("Section F", true, "F", "Splits");	
			settings.Add("F", true, "Learn F.", "Section F");
		//
		settings.Add("Section G", true, "G", "Splits");	
			settings.Add("G", true, "Learn G.", "Section G");
			settings.Add("Invisibility", false, "Learn Invisibility.", "Section G");
			settings.Add("Terror", false, "Learn Terror.", "Section G");
			settings.Add("Healing", false, "Learn Healing.", "Section G");
		//
		settings.Add("Section A", true, "A", "Splits");	
			settings.Add("A", true, "Learn A.", "Section A");
			settings.Add("Cave", false, "Complete the dark cave.", "Section A");
		//
		settings.Add("Section B", true, "B", "Splits");	
			settings.Add("B", true, "Learn B.", "Section B");
			settings.Add("Blacksmiths", false, "Enter the Blacksmith's guild.", "Section B");
			settings.Add("Blade", false, "Twist the blade.", "Section B");
		//
		settings.Add("Section C", true, "C", "Splits");	
			settings.Add("C", true, "Learn C.", "Section C");
			settings.Add("End", true, "Finish the game.", "Section C");

	vars.Info = (Action<string>)((msg) => {
		print("[Loom ASL] " + msg);
	});
}

init {
	vars.ScummVM.Init();

	vars.ScummVM["room"] = vars.ScummVM.Watch<int>("_scummVars", 4 * 0x4);

	// DRAFTS
	vars.Drafts = new string[] {
	//	"Opening",
		"StrawToGold",
	//	"Dyeing",
		"NightVision",
	//	"Twisting",
	//	"Sleep",
	//	"Emptying",
		"Invisibility",
		"Terror",
	//	"Sharpening",
	//	"Reflection",
		"Healing",
	//	"Silence",
	//	"Shaping",
	//	"Unmaking"
	//	"Transcendence"
	};

	// THEADS
	vars.Threads = new Dictionary<string, int> {
		{ "F", 4 },
		{ "G", 5 },
		{ "A", 6 },
		{ "B", 7 },
		{ "C", 8 }
	};

	vars.ScummVM.OnEngineReady = (Func<bool>)(() => {
		int baseIndex;

		var gameName = vars.ScummVM.GameName;
		if (gameName == "loom-ega") {
			baseIndex = 50;
		} 
		else if (gameName == "loom-vga") {
			baseIndex = 100;
		}
		else {
			vars.Info("Invalid game name.");
			return false;
		}

		vars.Info("Game name = " + gameName);

		vars.ScummVM["distaff"] = vars.ScummVM.Watch<int>("_scummVars", (baseIndex + 50) * 0x4); // Set by Script 18
		vars.ScummVM["threads"] = vars.ScummVM.Watch<int>("_scummVars", (baseIndex + 72) * 0x4);

		// DRAFTS
		for (int i = 0; i < vars.Drafts.Length; i++) {
			vars.ScummVM[vars.Drafts[i]] = vars.ScummVM.Watch<int>("_scummVars", (baseIndex + 2 + i * 2) * 0x4);
			//vars.Info(vars.Drafts[i] + " is Var " + (baseIndex + 2+ i * 2).ToString());
		}

		return true;
	});


	// SCRIPT SLOTS
	vars.Slots = new Dictionary<int, MemoryWatcher>();

	// Create MemoryWatchers for script slots 1-n
	int numSlots = 20;
	for (int i = 1; i < numSlots + 1; i++) {
		vars.Slots[i] =	vars.ScummVM.Watch<ushort>("vm", "slot", i * 0x14 + 0x8);
	}

	/*
	struct ScriptSlot {
		uint32 offs;             // offset: 0x00
		int32 delay;             // offset: 0x04
		uint16 number;           // offset: 0x08
		uint16 delayFrameCount;  // offset: 0x0A
		bool freezeResistant;    // offset: 0x0C
		bool recursive           // offset: 0x0D
		bool didexec;            // offset: 0x0E
		byte status;             // offset: 0x0F
		byte where;              // offset: 0x10
		byte freezeCount;        // offset: 0x11
		byte cutsceneOverride;   // offset: 0x12
		byte cycle;              // offset: 0x13
	}; // size: 0x14
	*/

	// SCRIPT MONITORING
	vars.Script = (Func<object, bool>)(input => {
		int[] scripts;

		if (input is int) {
			scripts = new int[] { (int)input };
		} 
		else if (input is int[]) {
			scripts = (int[])input;
		} 
		else {
			return false;
		}

		foreach (int script in scripts) {
			foreach (var watcher in vars.Slots.Values) {
				if (watcher.Current == script) {
					return true;
				}
			}
		}

		return false;
	});


	// DRAFT FUNCTIONS
	vars.KnowsDraft = (Func<string, bool>)(draft => {
		return (vars.ScummVM[draft].Current & (1 << 13)) != 0;
	});

	vars.HasUsedDraft = (Func<string, bool>)(draft => {
		return (vars.ScummVM[draft].Current & (1 << 12)) != 0;
	});


	// FLAGS
	vars.completedSplits = new HashSet<string>();
}

update {	
	vars.ScummVM.Update();

	foreach (var watcher in vars.Slots.Values) {
		watcher.Update(game);
	}
}

reset {
	return (vars.ScummVM["g_engine"].Changed && vars.ScummVM["g_engine"].Current == 0) ||
	       (old.room != 69 && current.room == 69);
}

start {
	if (vars.ScummVM["room"].Current == 69) {
		if (vars.Script(new int[]{808, 809, 810, 877, 878, 879})) {
			// Button scripts:
			// VGA: 808, 809, 810
			// EGA: 877, 878, 879
		
			vars.Info("Started timer on selecting difficulty.");
			return true;
		}
	}
}

onStart {
	vars.hasSelectedDifficulty = false;
	vars.completedSplits.Clear();
}

split {
	// END
	if (current.room == 66 && vars.Script(106) && settings["End"] && !vars.completedSplits.Contains("End")) {
		vars.completedSplits.Add("End");
		vars.Info("SPLIT: Triggered the ending.");
		return true;
	}

	// DISTAFF
	// Gets set to 2 by Script 18
	if (current.room == 9 && old.distaff == 0 && current.distaff == 2 && settings["Distaff"] && !vars.completedSplits.Contains("Distaff")) {
		vars.completedSplits.Add("Distaff");
		vars.Info("SPLIT: Picked up Distaff.");
		return true;
	}

	// THREADS
	if (old.threads != current.threads) {
		foreach (var thread in vars.Threads) {
			var name = thread.Key;
			var number = thread.Value;
			
			if (current.threads == number && settings[name] && !vars.completedSplits.Contains(name)) {
				vars.completedSplits.Add(name);
				vars.Info("SPLIT: Learned " + name);
				return true;
			}
		}
	}

	// DRAFTS
	for (int i = 0; i < vars.Drafts.Length; i++) {
		var draft = vars.Drafts[i];

		if (settings[draft] && !vars.completedSplits.Contains(draft)) {
			if (vars.KnowsDraft(draft)) {
				vars.completedSplits.Add(draft);
				vars.Info("SPLIT: Learned " + draft);
				return true;
			}
		}
	}

	// OPENING THE SKY
	// 4th bit set by Script 49
	// current.room == 2 && (current.sky & (1 << 4)) != 0 && settings["Sky"]
	if (current.room == 2 && vars.Script(49) && settings["Sky"] && !vars.completedSplits.Contains("Sky")) {
		vars.completedSplits.Add("Sky");
		vars.Info("SPLIT: Opening the sky.");
		return true;
	}

	// COMPLETE THE DARK CAVE
	if (old.room == 30 && current.room == 33 && settings["Cave"] && !vars.completedSplits.Contains("Cave")) {
		vars.completedSplits.Add("Cave");
		vars.Info("SPLIT: Complete the cave.");
		return true;
	}

	// ENTER THE BLACKSMITH'S GUILD
	if (old.room == 35 && current.room == 36 && settings["Blacksmiths"] && !vars.completedSplits.Contains("Blacksmiths")) {
		vars.completedSplits.Add("Blacksmiths");
		vars.Info("SPLIT: Enter the Blacksmith's guilde.");
		return true;
	}

	// TWIST THE BLADAE
	if (current.room == 41 && vars.Script(204) && settings["Blade"] && !vars.completedSplits.Contains("Blade")) {
		vars.completedSplits.Add("Blade");
		vars.Info("SPLIT: Twist the blade.");
		return true;
	}
}