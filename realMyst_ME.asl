state("realMyst") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

	vars.TimerModel = new TimerModel { CurrentState = timer };

	// Settings
	settings.Add("Splits", true, "Splits");
		settings.Add("Linking", true, "Split on linking to ...", "Splits");
			settings.Add("Stoneship", false, "Stoneship", "Linking");
			settings.Add("Channelwood", false, "Channelwood", "Linking");
			settings.Add("Selenitic", false, "Selenitic", "Linking");
			settings.Add("Mechanical", false, "Mechanical", "Linking");
			settings.Add("Myst Island", false, "Myst", "Linking");
		settings.Add("Pages", true, "Split on handing in ...", "Splits");		
			settings.Add("StoneshipRed", true, "Stoneship Red", "Pages");
			settings.Add("StoneshipBlue", true, "Stoneship Blue", "Pages");
			settings.Add("ChannelwoodRed", true, "Channelwood Red", "Pages");
			settings.Add("ChannelwoodBlue", true, "Channelwood Blue", "Pages");
			settings.Add("SeleniticRed", true, "Selenitic Red", "Pages");
			settings.Add("SeleniticBlue", true, "Selenitic Blue", "Pages");
			settings.Add("MechanicalRed", true, "Mechanical Red", "Pages");
			settings.Add("MechanicalBlue", true, "Mechanical Blue", "Pages");
		settings.Add("End", true, "Trigger one of the endings.", "Splits");
	settings.Add("EnableMenuDuringAtrus", false, "Enable the menu during Atrus.");

	// Debug
	vars.Info = (Action<string>)((msg) => {
		print("[realMyst Masterpiece ASL] " + msg);
	});

	vars.firstLaunch = true;
}

init {
	if (vars.firstLaunch) {
		int delay = 3000;
		vars.Info("Reattaching in " + delay + "ms...");
		Thread.Sleep(delay);
		vars.firstLaunch = false;

		var allComponents = timer.Layout.Components;
		if (timer.Run.AutoSplitter != null && timer.Run.AutoSplitter.Component != null) {
			allComponents = allComponents.Append(timer.Run.AutoSplitter.Component);
		}
		foreach (var component in allComponents) {
			var type = component.GetType();
			if (type.Name == "ASLComponent") {
				var script = type.GetProperty("Script").GetValue(component);
				script.GetType().GetField(
					"_game",
					BindingFlags.NonPublic | BindingFlags.Instance
				).SetValue(script, null);
			}
		}
		return;
	}
	
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
		vars.Helper["initialProgress"] = mono.Make<float>("LoadLevelManager", "_InitialProgress");
		vars.Helper["lastFade"] = mono.Make<float>("Fade", "_Instance", "_StartTime");
		vars.Helper["states"] = mono.Make<IntPtr>("PersistentData", "_Instance", "_States");
		vars.Helper["xSpeed"] = mono.Make<float>("GameLogic", "_Instance", "_MystController", "_MovementSpeed", "x");
		vars.Helper["zSpeed"] = mono.Make<float>("GameLogic", "_Instance", "_MystController", "_MovementSpeed", "z");
		vars.Helper["newGame"] = mono.Make<bool>("GameLogic", "_StartNewGame");
		vars.Helper["engagedPuzzle"] = game.Is64Bit()
			? mono.Make<long>("GameLogic", "_Instance", "_EngagedPuzzle")
			: mono.Make<int>("GameLogic", "_Instance", "_EngagedPuzzle");
		vars.Helper["linkTarget"] = mono.MakeString("LoadingLevel", "_LoadLevel");

		return true;
	});

	vars.StateIDs = new Dictionary<string, int> {
		{ "kGlobalClassicMode",             19 },
		{ "kGlobalCurrentNodeName",         20 },
		{ "kMystRedBookPages",            1031 },
		{ "kMystBlueBookPages",           1032 },
		{ "kMystWhitePagePickedUp",       1042 },
		{ "kSeleniticRedPagePickedUp",    2006 },
		{ "kSeleniticBluePagePickedUp",   2007 },
		{ "kChannelwoodRedPagePickedUp",  3001 },
		{ "kChannelwoodBluePagePickedUp", 3002 },
		{ "kMechanicalRedPagePickedUp",   4001 },
		{ "kMechanicalBluePagePickedUp",  4002 },
		{ "kStoneshipRedPagePickedUp",    5002 },
		{ "kStoneshipBluePagePickedUp",   5003 },
	};

	vars.FindStateSlot = (Func<int, int>)(stateId => {
		IntPtr dictPtr = vars.Helper["states"].Current;

		bool is64Bit = game.Is64Bit();

		var tablePtr = game.ReadPointer(dictPtr + (is64Bit ? 0x10 : 0x08));
		var linkSlotsPtr = game.ReadPointer(dictPtr + (is64Bit ? 0x18 : 0x0C));
		var keySlotsPtr = game.ReadPointer(dictPtr + (is64Bit ? 0x20 : 0x10));

		int tableLength = game.ReadValue<int>(tablePtr + (is64Bit ? 0x18 : 0x0C));

		int hash = stateId & 0x7FFFFFFF;
		int bucket = hash % tableLength;

		int bucketVal = game.ReadValue<int>(tablePtr + (is64Bit ? 0x20 : 0x10) + bucket * 4);
		int slot = bucketVal - 1;

		while (slot >= 0) {
			IntPtr linkEntryAddr = linkSlotsPtr + (is64Bit ? 0x20 : 0x10) + slot * 8;
			int entryHashCode = game.ReadValue<int>(linkEntryAddr);
			int entryNext = game.ReadValue<int>(linkEntryAddr + 4);
			int entryKey = game.ReadValue<int>(keySlotsPtr + (is64Bit ? 0x20 : 0x10) + slot * 4);

			if ((entryHashCode & 0x7FFFFFFF) == hash && entryKey == stateId)
				return slot;

			slot = entryNext;
		}

		return -1;
	});

	vars.GetState = (Func<string, int>)(name => {
		int stateId = vars.StateIDs[name];
		bool is64Bit = game.Is64Bit();

		int slot = vars.FindStateSlot(stateId);
		if (slot < 0) return -1;

		IntPtr dictPtr = vars.Helper["states"].Current;
		var valueSlotsPtr = game.ReadPointer(dictPtr + (is64Bit ? 0x28 : 0x14));
		IntPtr valueObjPtr = game.ReadPointer(
			valueSlotsPtr 
			+ (is64Bit ? 0x20 : 0x10) 
			+ slot * (is64Bit ? 8 : 4)
		);

		if (valueObjPtr == IntPtr.Zero) return -1;

		return game.ReadValue<int>(valueObjPtr + (is64Bit ? 0x10 : 0x8));
	});

	vars.GetStringState = (Func<string, string>)(name => {
		int stateId = vars.StateIDs[name];
		bool is64Bit = game.Is64Bit();
	
		int slot = vars.FindStateSlot(stateId);
		if (slot < 0) return "None";
	
		IntPtr dictPtr = vars.Helper["states"].Current;
		IntPtr valueSlotsPtr = game.ReadPointer(dictPtr + (is64Bit ? 0x28 : 0x14));
		IntPtr valueObjPtr = game.ReadPointer(
			valueSlotsPtr
			+ (is64Bit ? 0x20 : 0x10)
			+ slot * (is64Bit ? 8 : 4)
		);

		if (valueObjPtr == IntPtr.Zero) return "None";

		IntPtr stringObjPtr = game.ReadPointer(valueObjPtr + (is64Bit ? 0x10 : 0x8));
		if (stringObjPtr == IntPtr.Zero) return "None";

		return game.ReadString(stringObjPtr + (is64Bit ? 0x14 : 0xC), 64);
	});

	vars.FloatEquals = (Func<float, float, bool>)((float1, float2) => {
		return Math.Abs(float1 - float2) < 0.00001;
	});

	// FLAGS
	vars.isLoading = false;
	vars.newGame = false;
	vars.linkingToAge = "";
	current.puzzle = "";
	vars.completedSplits = new HashSet<string>();
}

update {
	if (!vars.isLoading) {		
		if (current.initialProgress != old.initialProgress && current.initialProgress != 0) {
			vars.isLoading = true;
		}		
	}
	if (vars.isLoading) {
		if (old.lastFade == -1 && current.lastFade > 0) {
			vars.isLoading = false;
	
			if (vars.linkingToAge != "" && settings[vars.linkingToAge]) {
				vars.Info("Split on arriving in age: " + vars.linkingToAge);
				vars.linkingToAge = "";
				vars.TimerModel.Split();
			}
		}
	}

	if (old.newGame && !current.newGame) {
		vars.newGame = true;
	}	

	current.redPages = vars.GetState("kMystRedBookPages");
	current.bluePages = vars.GetState("kMystBlueBookPages");
	current.seleniticRedPage = vars.GetState("kSeleniticRedPagePickedUp");
	current.seleniticBluePage = vars.GetState("kSeleniticBluePagePickedUp");
	current.channelwoodRedPage = vars.GetState("kChannelwoodRedPagePickedUp");
	current.channelwoodBluePage = vars.GetState("kChannelwoodBluePagePickedUp");
	current.mechanicalRedPage = vars.GetState("kMechanicalRedPagePickedUp");
	current.mechanicalBluePage = vars.GetState("kMechanicalBluePagePickedUp");
	current.stoneshipRedPage = vars.GetState("kStoneshipRedPagePickedUp");
	current.stoneshipBluePage = vars.GetState("kStoneshipBluePagePickedUp");
	current.whitePage = vars.GetState("kMystWhitePagePickedUp");

	if (String.IsNullOrEmpty(old.linkTarget) && !String.IsNullOrEmpty(current.linkTarget)) {
		vars.Info("Linking to: " + current.linkTarget);
		vars.linkingToAge = current.linkTarget;
	}

	if (old.engagedPuzzle == 0 && current.engagedPuzzle != 0) {
		var name = game.Is64Bit()
			? new DeepPointer((IntPtr)current.engagedPuzzle + 0x18, 0x68, 0x8, 0x48, 0x0).DerefString(game, 128)
			: new DeepPointer((IntPtr)current.engagedPuzzle + 0xC, 0x40, 0x4, 0x30, 0x0).DerefString(game, 128);
		vars.Info("Engaged with puzzle: " + name);
		current.puzzle = name;
	}
	if (old.engagedPuzzle != 0 && current.engagedPuzzle == 0) {
		current.puzzle = "";
	}

	if (settings["EnableMenuDuringAtrus"] && old.puzzle == "" && current.puzzle == "Atrus") {
		game.WriteBytes((IntPtr)current.engagedPuzzle + (game.Is64Bit() ? 0x4B : 0x2B), new byte[] { 0x01 });
		vars.Info("Enabled menu!");
	}
}

isLoading {
	return vars.isLoading;
}

reset {
	return !old.newGame && current.newGame;
}

start {
	current.node = vars.GetStringState("kGlobalCurrentNodeName");
	current.classicMode = vars.GetState("kGlobalClassicMode");

	if (vars.newGame) {
		// Free roam
		if (current.node == "Dock1-E") {
			if (vars.FloatEquals(old.xSpeed, 0.0f) && vars.FloatEquals(old.zSpeed, 0.0f)) {
				if (!vars.FloatEquals(current.xSpeed, 0.0f) || !vars.FloatEquals(current.zSpeed, 0.0f)) {
					return true;
				}
			}			
		}
		// Classic mode
		if (current.classicMode == 1 && old.node == "Dock1-E" && old.node != current.node && current.node.Contains("Dock")) {
			return true;
		}
	}
}

onStart {
	vars.newGame = false;
	vars.completedSplits.Clear();
}

split {
	// ENDINGS
	if (settings["End"]) {
		// Good Ending
		if (old.whitePage == 1 && current.whitePage == 2) {
			return true;
		}
	
		// Bad Ending
		if (old.engagedPuzzle == 0 && current.engagedPuzzle != 0) {
			if (current.puzzle == "Atrus" && current.whitePage == 0) {
				return true;
			}	
		}
		
		// Free Brother
		if (old.redPages == 5 && current.redPages == 6) {
			return true;
		}
		if (old.bluePages == 5 && current.bluePages == 6) {
			return true;
		}
	}
	
	// PAGES
	if (settings["SeleniticRed"] && old.seleniticRedPage == 1 && current.seleniticRedPage == 2 && vars.completedSplits.Add("SeleniticRed")) {
		return true;
	}
	if (settings["SeleniticBlue"] && old.seleniticBluePage == 1 && current.seleniticBluePage == 2 && vars.completedSplits.Add("SeleniticBlue")) {
		return true;
	}
	if (settings["ChannelwoodRed"] && old.channelwoodRedPage == 1 && current.channelwoodRedPage == 2 && vars.completedSplits.Add("ChannelwoodRed")) {
		return true;
	}
	if (settings["ChannelwoodBlue"] && old.channelwoodBluePage == 1 && current.channelwoodBluePage == 2 && vars.completedSplits.Add("ChannelwoodBlue")) {
		return true;
	}
	if (settings["MechanicalRed"] && old.mechanicalRedPage == 1 && current.mechanicalRedPage == 2 && vars.completedSplits.Add("MechanicalRed")) {
		return true;
	}
	if (settings["MechanicalBlue"] && old.mechanicalBluePage == 1 && current.mechanicalBluePage == 2 && vars.completedSplits.Add("MechanicalBlue")) {
		return true;
	}
	if (settings["StoneshipRed"] && old.stoneshipRedPage == 1 && current.stoneshipRedPage == 2 && vars.completedSplits.Add("StoneshipRed")) {
		return true;
	}
	if (settings["StoneshipBlue"] && old.stoneshipBluePage == 1 && current.stoneshipBluePage == 2 && vars.completedSplits.Add("StoneshipBlue")) {
		return true;
	}	
}

exit {
	vars.firstLaunch = true;
}