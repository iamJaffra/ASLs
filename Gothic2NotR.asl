state("Gothic2") {
	long igt:           "ZSPEEDRUNTIMER.DLL", 0x19FE0;

	// POS VECTOR
	float x:            "Gothic2.exe", 0x004CEF4C;
	float y:            "Gothic2.exe", 0x004CEF44;

	// WORLD
	int world:          "Gothic2.exe", 0x004CECC0, 0x920;
	string10 worldname: "Gothic2.exe", 0x006B0884, 0x8, 0x6274, 0x0;

	// PLAYER
	int guild:          "Gothic2.exe", 0x006B2684, 0x230;
	int exp:            "Gothic2.exe", 0x006B2684, 0x42C;
	int inDialogue:     "Gothic2.exe", 0x006B2684, 0x298;
	// player.visual.activeAniList.protoAni.aniName
	string20 ani:       "Gothic2.exe", 0x006B2684, 0xC8, 0x50, 0x0, 0x2C, 0x0;
	// player.timedOverlays[0].mdsOverlayName
	string20 overlay:   "Gothic2.exe", 0x006B2684, 0x564, 0x0, 0x8, 0x0;
	
	// MISC
	int inCutscene:     "Gothic2.exe", 0x004D1F18;
	int inventoryOpen:  "Gothic2.exe", 0x005A43F0;
}

startup {
	settings.Add("Any%", false, "Any%");
		settings.Add("Any%_Zuris", true, "Talk to Zuris", "Any%");
		settings.Add("Any%_Ignaz", false, "Talk to Ignaz", "Any%");
		settings.Add("Any%_EnterValley", true, "Enter valley", "Any%");
		settings.Add("Any%_FireDragon", true, "Kill Fire Dragon", "Any%");
		settings.Add("Any%_RockDragon", true, "Kill Rock Dragon", "Any%");
		settings.Add("Any%_SwampDragon", true, "Kill Swamp Dragon", "Any%");
		settings.Add("Any%_IceDragon", false, "Kill Ice Dragon (Any% No Flying)", "Any%");
		settings.Add("Any%_Chapter5", true, "Reach Chapter 5", "Any%");
		settings.Add("Any%_Map", true, "Collect sea map to Irdorath", "Any%");
		settings.Add("Any%_LighthouseBed", false, "Go to bed in Jack's Lighthouse", "Any%");
		settings.Add("Any%_Irdorath", true, "Reach Irdorath", "Any%");
		settings.Add("Any%_UndeadDragon", true, "Kill Undead Dragon", "Any%");
		settings.Add("Any%_End", true, "Finish game", "Any%");

	settings.Add("AllChapters", false, "All Chapters");
		settings.Add("AllChapters_SnapperWeed", false, "Eat snapper weed", "AllChapters");
		settings.Add("AllChapters_Ore", false, "Collect black ore", "AllChapters");
		settings.Add("AllChapters_Zuris", true, "Talk to Zuris", "AllChapters");
		settings.Add("AllChapters_Chapter2", true, "Reach chapter 2", "AllChapters");
		settings.Add("AllChapters_EnterValley", true, "Enter valley of mines", "AllChapters");
		settings.Add("AllChapters_CastleRune", true, "Collect teleport rune to castle", "AllChapters");
		settings.Add("AllChapters_FireDragon", true, "Kill Fire Dragon", "AllChapters");
		settings.Add("AllChapters_RockDragon", true, "Kill Rock Dragon", "AllChapters");
		settings.Add("AllChapters_Chapter3", true, "Reach chapter 3", "AllChapters");
		settings.Add("AllChapters_EnterJharkendar", true, "Enter Jharkendar", "AllChapters");
		settings.Add("AllChapters_Raven", true, "Kill Raven", "AllChapters");
		settings.Add("AllChapters_LeaveJharkendar", false, "Leave Jharkendar", "AllChapters");
		settings.Add("AllChapters_JoinMilitia", true, "Join militia", "AllChapters");
		settings.Add("AllChapters_Eye", true, "Collect broken Eye of Innos", "AllChapters");
		settings.Add("AllChapters_OnarRune", true, "Get teleport rune from Lee", "AllChapters");
		settings.Add("AllChapters_Chapter4", true, "Reach chapter 4", "AllChapters");
		settings.Add("AllChapters_SwampDragon", true, "Kill Swamp Dragon", "AllChapters");
		settings.Add("AllChapters_Chapter5", true, "Reach chapter 5", "AllChapters");
		settings.Add("AllChapters_Irdorath", true, "Enter Irdorath", "AllChapters");
		settings.Add("AllChapters_UndeadDragon", true, "Kill Undead Dragon", "AllChapters");
		settings.Add("AllChapters_End", true, "Finish game", "AllChapters");

	settings.Add("NewGame", true, "Reset+Start timer on New Game");

	// Flags
	vars.completedSplits = new HashSet<string>();

	// Variable to save IGT in case the game crashes
	vars.timeKeeper = new TimeSpan();

	vars.Sw = new Stopwatch();
}

init {
	// Find global variables
	vars.globals = new Dictionary<string, MemoryWatcher>();

	var globalsDict = new Dictionary<string, string> {
		{ "KAPITEL",         "chapter"     },
		{ "RCKDRAGNISDEAD",  "rockDragon"  },
		{ "FREDRAGNISDEAD",  "fireDragon"  },
		{ "SWAPDRAGNISDEAD", "swampDragon" },
		{ "ICDRAGNISDEAD",   "iceDragon"   } 
	};

	int symtab = new DeepPointer("Gothic2.exe", 0x6B6428, 0x8).Deref<int>(game);
	int size = new DeepPointer("Gothic2.exe", 0x6B6428, 0x8 + 0x4).Deref<int>(game);
	
	for (int i = 0; i < size; i++) {
		var symbol = new DeepPointer((IntPtr)symtab + i * 0x4).Deref<int>(game); 
		string name = new DeepPointer((IntPtr)symbol + 0x8, 0x0).DerefString(game, 100); 
		int address = symbol + 0x18;

		foreach (var global in globalsDict) {
			if (name == global.Key) {
				print(name + " = table[" + i + "] at 0x" + address.ToString("X"));

				vars.globals[global.Value] = new MemoryWatcher<int>(new DeepPointer((IntPtr)address));
			}
		} 
	}

	foreach (var global in globalsDict) {
		if (!vars.globals.ContainsKey(global.Value)) {
			throw new InvalidOperationException("Not all globals found. Trying again.");
		}
	}

	// Starting coordinates
	vars.startX = -15710.02637; 
	vars.startY =  29912.93750;

	// NPC IDs
	vars.ZURIS = 409;
	vars.IGNAZ = 498;
	vars.RAVEN = 1090;
	vars.UNDEAD_DRAGON = 12377;

	// Functions

	vars.IsDead = (Func<int, bool>)((npcID) => {
		// ogame.world.voblist_npc.data
		IntPtr npc = (IntPtr) new DeepPointer("Gothic2.exe", 0x6B0884, 0x8, 0x6284, 0x8).Deref<int>(game);

		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var id = game.ReadValue<int>(npcData + 0x120);
			var hp = game.ReadValue<int>(npcData + 0x1B8);
			
			if (id == npcID && hp == 0) {
				return true;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}

		return false;
	});
	
	vars.IsInDialogue = (Func<int, bool>)((npcID) => {
		// ogame.world.voblist_npc.data
		IntPtr npc = (IntPtr) new DeepPointer("Gothic2.exe", 0x6B0884, 0x8, 0x6284, 0x8).Deref<int>(game);

		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var id = game.ReadValue<int>(npcData + 0x120);
			var inDialogue = game.ReadValue<int>(npcData + 0x298);

			if (id == npcID && inDialogue == 1) {
				return true;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}

		return false;
	});

	vars.PlayerHasItem = (Func<string, bool>)(TargetItemName => {
		// player.inventory2.contents
		IntPtr item = (IntPtr) new DeepPointer("Gothic2.exe", 0x006B2684, 0x66C, 0x8).Deref<int>(game);
		
		while (item != IntPtr.Zero) {
			var itemData = game.ReadPointer(item + 0x4);
	
			string itemName = game.ReadString(game.ReadPointer(itemData + 0x18), 20);
			
			if (itemName == TargetItemName) {
				return true;
			}
	
			item = game.ReadPointer(item + 0x8);
		}
		return false;
	});

	vars.snapperWeed = 0;
	vars.canReset = true;

	vars.globalsFound = false;
}

start {
	if (settings["NewGame"]) {
		if (current.igt < 500000
				&& Math.Abs(current.x - vars.startX) < 0.0001
				&& Math.Abs(current.y - vars.startY) < 0.0001) {

			vars.canReset = false;
			return true;
		}
	}
}

onStart {
	vars.completedSplits.Clear();
	vars.snapperWeed = 0;
	vars.timeKeeper = TimeSpan.FromMilliseconds(0);
}

reset {
	if (settings["NewGame"]) {
		if (current.igt < 500000 && vars.canReset
				&& Math.Abs(current.x - vars.startX) < 0.0001
				&& Math.Abs(current.y - vars.startY) < 0.0001) {

			return true;
		}
	}
}

update {
	foreach (var watcher in vars.globals.Values) {
		watcher.Update(game);
	}

	if (!vars.canReset && current.igt > 500000) {
		vars.canReset = true;
	}
}

split {
	// ANY%

	if (settings["Any%_Zuris"] && !vars.completedSplits.Contains("Zuris") && current.world == 1 &&  vars.IsInDialogue(vars.ZURIS)) {
		print("Split: Zuris");
		return vars.completedSplits.Add("Zuris");
	}
	else if (settings["Any%_Ignaz"] && !vars.completedSplits.Contains("Ignaz") && current.world == 1 && current.inDialogue == 1 && vars.IsInDialogue(vars.IGNAZ)) {
		print("Split: Ignaz");
		return vars.completedSplits.Add("Ignaz");
	}
	else if (settings["Any%_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
		print("Split: EnterValley");
		return vars.completedSplits.Add("EnterValley");
	}
	else if (settings["Any%_FireDragon"] && !vars.completedSplits.Contains("FireDragon") && vars.globals["fireDragon"].Current == 1) {
		print("Split: FireDragon");
		return vars.completedSplits.Add("FireDragon");
	}
	else if (settings["Any%_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && vars.globals["rockDragon"].Current == 1) {
		print("Split: RockDragon");
		return vars.completedSplits.Add("RockDragon");
	}
	else if (settings["Any%_SwampDragon"] && !vars.completedSplits.Contains("SwampDragon") && vars.globals["swampDragon"].Current == 1) {
		print("Split: SwampDragon");
		return vars.completedSplits.Add("SwampDragon");
	}
	else if (settings["Any%_IceDragon"] && !vars.completedSplits.Contains("IceDragon") && vars.globals["iceDragon"].Current == 1) {
		print("Split: IceDragon");
		return vars.completedSplits.Add("IceDragon");
	}
	else if (settings["Any%_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && vars.globals["chapter"].Current == 5) {
		print("Split: Chapter5");
		return vars.completedSplits.Add("Chapter5");
	}
	else if (settings["Any%_Map"] && !vars.completedSplits.Contains("Map") && current.world == 1 && vars.PlayerHasItem("ITWR_SEAMAP_IRDORATH")) {
		print("Split: Map");
		return vars.completedSplits.Add("Map");
	}
	else if (settings["Any%_LighthouseBed"] && !vars.completedSplits.Contains("LighthouseBed") && current.ani == "T_BEDHIGH_BACK_S0_2_" && vars.globals["chapter"].Current == 5) {
		print("Split: LighthouseBed");
		return vars.completedSplits.Add("LighthouseBed");
	}
	else if (settings["Any%_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
		print("Split: Irdorath");
		return vars.completedSplits.Add("Irdorath");
	}
	else if (settings["Any%_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && current.exp > old.exp && vars.IsDead(vars.UNDEAD_DRAGON)) {
		print("Split: UndeadDragon");
		return vars.completedSplits.Add("UndeadDragon");
	}
	else if (settings["Any%_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
		print("Split: End");
		return vars.completedSplits.Add("End");
	}

	// ALL CHAPTERS

	if (settings["AllChapters_SnapperWeed"] && !vars.completedSplits.Contains("SnapperWeed") && current.overlay == "HUMANS_SPRINT.MDS") {
		return vars.completedSplits.Add("SnapperWeed");
	}
	else if (settings["AllChapters_Ore"] && !vars.completedSplits.Contains("Ore") && current.world == 1 && vars.PlayerHasItem("ITMI_ZEITSPALT_ADDON")) {
		return vars.completedSplits.Add("Ore");
	}
	else if (settings["AllChapters_Zuris"] && !vars.completedSplits.Contains("Zuris") && current.world == 1 && current.inDialogue == 1 && vars.IsInDialogue(vars.ZURIS)) {
		return vars.completedSplits.Add("Zuris");
	}
	else if (settings["AllChapters_Chapter2"] && !vars.completedSplits.Contains("Chapter2") && vars.globals["chapter"].Current == 2) {
		return vars.completedSplits.Add("Chapter2");
	}
	else if (settings["AllChapters_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
		return vars.completedSplits.Add("EnterValley");
	}
	else if (settings["AllChapters_CastleRune"] && !vars.completedSplits.Contains("CastleRune") && current.world == 2 && vars.PlayerHasItem("ITRU_TELEPORTOC")) {
		return vars.completedSplits.Add("CastleRune");
	}
	else if (settings["AllChapters_FireDragon"] && !vars.completedSplits.Contains("FireDragon") && vars.globals["fireDragon"].Current == 1) {
		return vars.completedSplits.Add("FireDragon");
	}
	else if (settings["AllChapters_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && vars.globals["rockDragon"].Current == 1) {
		return vars.completedSplits.Add("RockDragon");
	}
	else if (settings["AllChapters_Chapter3"] && !vars.completedSplits.Contains("Chapter3") && vars.globals["chapter"].Current == 3) {
		return vars.completedSplits.Add("Chapter3");
	}
	else if (settings["AllChapters_EnterJharkendar"] && !vars.completedSplits.Contains("EnterJharkendar") && current.worldname == "ADDONWORLD") {
		return vars.completedSplits.Add("EnterJharkendar");
	}
	else if (settings["AllChapters_Raven"] && !vars.completedSplits.Contains("Raven") && current.worldname == "ADDONWORLD" && current.exp > old.exp && vars.IsDead(vars.RAVEN)) {
		return vars.completedSplits.Add("Raven");
	}
	else if (settings["AllChapters_LeaveJharkendar"] && !vars.completedSplits.Contains("LeaveJharkendar") && old.worldname == "ADDONWORLD" && current.worldname == "NEWWORLD") {
		return vars.completedSplits.Add("LeaveJharkendar");
	}
	else if (settings["AllChapters_JoinMilitia"] && !vars.completedSplits.Contains("JoinMilitia") && current.guild == 2) {
		return vars.completedSplits.Add("JoinMilitia");
	}
	else if (settings["AllChapters_Eye"] && !vars.completedSplits.Contains("Eye") && current.world == 1 && vars.PlayerHasItem("ITMI_INNOSEYE_BROKEN")) {
		return vars.completedSplits.Add("Eye");
	}
	else if (settings["AllChapters_OnarRune"] && !vars.completedSplits.Contains("OnarRune") && current.world == 1 && vars.PlayerHasItem("ITRU_TELEPORTFARM")) {
		return vars.completedSplits.Add("OnarRune");
	}
	else if (settings["AllChapters_Chapter4"] && !vars.completedSplits.Contains("Chapter4") && vars.globals["chapter"].Current == 4) {
		return vars.completedSplits.Add("Chapter4");
	}
	else if (settings["AllChapters_SwampDragon"] && !vars.completedSplits.Contains("SwampDragon") && vars.globals["swampDragon"].Current == 1) {
		return vars.completedSplits.Add("SwampDragon");
	}
	else if (settings["AllChapters_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && vars.globals["chapter"].Current == 5) {
		return vars.completedSplits.Add("Chapter5");
	}
	else if (settings["AllChapters_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
		return vars.completedSplits.Add("Irdorath");
	}
	else if (settings["AllChapters_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && vars.IsDead(vars.UNDEAD_DRAGON)) {
		return vars.completedSplits.Add("UndeadDragon");
	}
	else if (settings["AllChapters_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
		return vars.completedSplits.Add("End");
	}
}

isLoading {
	return true;
}

gameTime {
	return (vars.timeKeeper + TimeSpan.FromMilliseconds(current.igt / 1000));
}

exit {
	vars.timeKeeper = timer.CurrentTime.GameTime;
}