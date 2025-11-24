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
		//"Opening",
		"StrawToGold",
		//"Dyeing",
		"NightVision",
		//"Twisting",
		//"Sleep",
		//"Emptying",
		"Invisibility",
		"Terror",
		//"Sharpening",
		//"Reflection",
		"Healing",
		//"Silence",
		//"Shaping",
		//"Unmaking"
		//"Transcendence"
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

/*
===== script-49.dmp ===== 
[0000] (1A) Var[214 Bit 7] = 1;
[0005] (A8) if (Var[218 Bit 4]) {
[000A] (14)   print(1,[Center(),Text("Once was plenty for me.")]);
[0026] (80)   breakHere();
[0027] (62)   stopScript(0);
[0029] (**) }
[0029] (40) cutscene([1]);
[002E] (80) breakHere();
[002F] (1A) Var[218 Bit 4] = 1;
[0034] (5D) setClass(154,[152]);
[003B] (62) stopScript(45);
[003D] (80) breakHere();
[003E] (28) unless (!Var[214 Bit 6]) goto 003D;
[0043] (1A) Var[214 Bit 4] = 0;
[0048] (80) breakHere();
[0049] (28) unless (!Var[214 Bit 5]) goto 0048;
[004E] (80) breakHere();
[004F] (28) unless (!Var[215 Bit 9]) goto 004E;
[0054] (62) stopScript(42);
[0056] (0C) Resource.clearHeap();
[0058] (58) beginOverride();
[005A] (18) goto 022E;
[005D] (0C) Resource.loadCostume(150);
[0060] (0C) Resource.loadCostume(4);
[0063] (0C) Resource.loadCostume(5);
[0066] (0C) Resource.loadScript(40);
[0069] (0C) Resource.loadRoom(11);
[006C] (0C) Resource.loadCostume(22);
[006F] (0C) Resource.loadScript(50);
[0072] (0C) Resource.loadRoom(3);
[0075] (0C) Resource.loadCostume(10);
[0078] (0C) Resource.loadCostume(9);
[007B] (0C) Resource.loadCostume(82);
[007E] (0C) Resource.loadRoom(10);
[0081] (0C) Resource.loadCostume(19);
[0084] (5D) setClass(2,[0,150,149]);
[0091] (13) ActorOps(2,[Costume(4),Elevation(0)]);
[0099] (11) animateCostume(2,250);
[009C] (2D) putActorInRoom(2,2);
[009F] (01) putActor(2,687,37);
[00A5] (2A) startScript(40,[19],F);
[00AB] (11) animateCostume(2,6);
[00AE] (1A) Local[0] = 1;
[00B3] (80) breakHere();
[00B4] (46) Local[0]++;
[00B7] (44) unless (Local[0] > 6) goto 00B3;
[00BE] (11) animateCostume(2,7);
[00C1] (1A) Local[0] = 1;
[00C6] (80) breakHere();
[00C7] (46) Local[0]++;
[00CA] (44) unless (Local[0] > 6) goto 00C6;
[00D1] (33) ShakeOn();
[00D7] (11) animateCostume(2,8);
[00DA] (1A) Local[0] = 1;
[00DF] (80) breakHere();
[00E0] (46) Local[0]++;
[00E3] (44) unless (Local[0] > 6) goto 00DF;
[00EA] (13) ActorOps(2,[Costume(150)]);
[00EF] (11) animateCostume(2,6);
[00F2] (1A) Local[0] = 1;
[00F7] (80) breakHere();
[00F8] (46) Local[0]++;
[00FB] (44) unless (Local[0] > 16) goto 00F7;
[0102] (33) ShakeOff();
[0108] (5C) oldRoomEffect-set(128);
[010C] (72) loadRoom(11);
[010E] (32) setCameraAt(288);
[0111] (5D) setClass(3,[0,150,148]);
[011E] (13) ActorOps(3,[Costume(22),Elevation(0),WalkSpeed(1,1),InitAnimNr(3),WalkAnimNr(2),StandAnimNr(3)]);
[012F] (11) animateCostume(3,250);
[0132] (2D) putActorInRoom(3,11);
[0135] (01) putActor(3,412,117);
[013B] (11) animateCostume(3,3);
[013E] (2D) putActorInRoom(2,11);
[0141] (01) putActor(2,364,8);
[0147] (11) animateCostume(2,7);
[014A] (1A) Local[0] = 1;
[014F] (80) breakHere();
[0150] (46) Local[0]++;
[0153] (44) unless (Local[0] > 9) goto 014F;
[015A] (11) animateCostume(3,8);
[015D] (80) breakHere();
[015E] (80) breakHere();
[015F] (05) drawObject(311,255,255);
[0166] (11) animateCostume(3,6);
[0169] (1A) Local[0] = 1;
[016E] (80) breakHere();
[016F] (46) Local[0]++;
[0172] (44) unless (Local[0] > 26) goto 016E;
[0179] (2D) putActorInRoom(2,0);
[017C] (11) animateCostume(3,7);
[017F] (1A) Local[0] = 1;
[0184] (80) breakHere();
[0185] (46) Local[0]++;
[0188] (44) unless (Local[0] > 22) goto 0184;
[018F] (1E) walkActorTo(3,350,117);
[0195] (AE) WaitForActor(3);
[0198] (0A) startScript(50,[]);
[019B] (80) breakHere();
[019C] (68) VAR_RESULT = isScriptRunning(50);
[01A0] (28) unless (!VAR_RESULT) goto 019B;
[01A5] (1A) Var[124] = 0;
[01AA] (72) loadRoom(2);
[01AC] (32) setCameraAt(800);
[01AF] (5D) setClass(1,[0,150,149,146]);
[01BF] (11) animateCostume(1,250);
[01C2] (2D) putActorInRoom(1,2);
[01C5] (01) putActor(1,817,100);
[01CB] (2E) delay(60);
[01CF] (1E) walkActorTo(1,817,83);
[01D5] (AE) WaitForActor(1);
[01D8] (2E) delay(60);
[01DC] (14) print(1,[Center(),Pos(160,152),Text("Is it over now?")]);
[01F5] (AE) WaitForMessage();
[01F7] (2E) delay(60);
[01FB] (1E) walkActorTo(1,817,52);
[0201] (AE) WaitForActor(1);
[0204] (5D) setClass(1,[0,150,148]);
[0211] (01) putActor(1,817,52);
[0217] (1E) walkActorTo(1,817,60);
[021D] (AE) WaitForActor(1);
[0220] (5D) setClass(1,[0]);
[0227] (01) putActor(1,817,60);
[022D] (80) breakHere();
[022E] (5C) oldRoomEffect-set(-32512);
[0232] (A8) if (VAR_OVERRIDE) {
[0237] (33)   ShakeOff();
[023D] (62)   stopScript(50);
[023F] (11)   animateCostume(1,255);
[0242] (11)   animateCostume(3,255);
[0245] (11)   animateCostume(2,255);
[0248] (2D)   putActorInRoom(3,0);
[024B] (2D)   putActorInRoom(2,0);
[024E] (1A)   Var[220 Bit 9] = 1;
[0253] (08)   if (VAR_ROOM != 2) {
[025A] (1A)     Var[124] = 0;
[025F] (72)     loadRoom(2);
[0261] (32)     setCameraAt(752);
[0264] (18)   } else {
[0267] (07)     setState(155,1);
[026B] (**)   }
[026B] (5D)   setClass(1,[0]);
[0272] (11)   animateCostume(1,250);
[0275] (2D)   putActorInRoom(1,2);
[0278] (01)   putActor(1,817,60);
[027E] (11)   animateCostume(5,255);
[0281] (2D)   putActorInRoom(5,0);
[0284] (BC)   stopSound(Var[164]);
[0287] (1A)   Var[164] = 0;
[028C] (**) }
[028C] (80) breakHere();
[028D] (0C) Resource.clearHeap();
[028F] (14) print(1,[Center(),Pos(160,Var[166]),Text()]);
[0299] (80) breakHere();
[029A] (C0) endCutscene();
[029B] (0A) startScript(23,[0]);
[02A1] (28) if (!Var[214 Bit 10]) {
[02A6] (0A)   startScript(34,[0]);
[02AC] (0A)   startScript(23,[2]);
[02B2] (A8)   if (Var[214 Bit 10]) {
[02B7] (0A)     startScript(23,[1]);
[02BD] (A8)     if (Var[214 Bit 10]) {
[02C2] (28)       if (!Var[214 Bit 14]) {
[02C7] (0A)         startScript(29,[4,12]);
[02D0] (**)       }
[02D0] (**)     }
[02D0] (**)   }
[02D0] (**) }
[02D0] (42) chainScript(45,[]);
[02D3] (A0) stopObjectCode();
END
*/