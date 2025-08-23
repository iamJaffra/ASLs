state("GothicMod", "v1.30") {
	// TIMER
	long igt:           "ZSPEEDRUNTIMER.DLL", 0x1A048;
	byte manualReset:   "ZSPEEDRUNTIMER.DLL", 0x1A024;

	// POS VECTOR
	float x:       "GothicMod.exe", 0x0046A5FC;
	float y:       "GothicMod.exe", 0x0046A604;
	
	// WORLD
	// ogame.world.worldName
	string20 world:     "GothicMod.exe", 0x4DA6BC, 0x8, 0x625C, 0x0;
	// ogame.world.numVobsInWorld
	int vobs:           "GothicMod.exe", 0x4DA6BC, 0x8, 0xBC;

	// PLAYER
	int exp:            "GothicMod.exe", 0x4DBBB0, 0x31C;
	int guild:          "GothicMod.exe", 0x4DBBB0, 0x1E8;

	// MISC
	int camera:         "GothicMod.exe", 0x0046C800;
	int inDialogue:     "GothicMod.exe", 0x0046C648;
	int inMenu:         "GothicMod.exe", 0x46D3B0;
	int cutscene:       "binkw32.dll",   0x6522C;
}

startup {
	settings.Add("resetNewGame", true, "Reset and start timer on New Game");

	settings.Add("Any%", true, "Any% / No OoB");
		settings.Add("Any%_Chest", false, "Acquire orc dog spell from chest", "Any%");
		settings.Add("Any%_Temple", true, "Enter Sleeper temple", "Any%");
		settings.Add("Any%_Grate", false, "Pass under the grate", "Any%");
		settings.Add("Any%_Priest1", true, "Loot priest 1 (Varrag Hashor)", "Any%");
		settings.Add("Any%_Priest2", true, "Loot priest 2 (Varrag Kasorg)", "Any%");
		settings.Add("Any%_Priest3", true, "Loot priest 3 (Varrag Unhilqt)", "Any%");
		settings.Add("Any%_Priest4", true, "Loot priest 4 (Varrag Ruushk)", "Any%");
		settings.Add("Any%_Priest5", true, "Loot priest 5 (Vrash Harrag Arushnat)", "Any%");
		settings.Add("Any%_XardasTemple", false, "Reach Xardas in the Sleeper temple", "Any%");
		settings.Add("Any%_Descent", false, "Pass through the little door after the descent at the end", "Any%");
		settings.Add("Any%_End", true, "Beat the game", "Any%");

	settings.Add("NMG", false, "Additional splits for No Major Glitches");
		settings.Add("NMG_Bow", true, "Collect bow from Cavalorn's hut", "NMG");
		settings.Add("NMG_Riddle1", true, "Solve first 3-switch riddle near the entrance", "NMG");
		settings.Add("NMG_Riddle2", true, "Solve second 3-switch riddle", "NMG");
		settings.Add("NMG_Riddle3", true, "Activate switch in flooded room", "NMG");

	settings.Add("AllChapters", false, "All Chapters");
		settings.Add("AllChapters_Temple", true, "Enter Sleeper temple for the first time", "AllChapters");
		settings.Add("AllChapters_Priest2", true, "Loot priest 2 (Varrag Kasorg)", "AllChapters");
		settings.Add("AllChapters_Priest3", true, "Loot priest 3 (Varrag Unhilqt)", "AllChapters");
		settings.Add("AllChapters_Priest4", true, "Loot priest 4 (Varrag Ruushk)", "AllChapters");
		settings.Add("AllChapters_LeaveTemple", true, "Leave Sleeper temple", "AllChapters");
		settings.Add("AllChapters_EnterFreeMine", true, "Enter Free Mine (occurs twice)", "AllChapters");
		settings.Add("AllChapters_LeaveFreeMine", true, "Leave Free Mine (occurs twice)", "AllChapters");
		settings.Add("AllChapters_DeliveredWeed", true, "Talk to Baal Kagan after delivering weed", "AllChapters");
		settings.Add("AllChapters_Xardas", true, "Talk to Xardas for the first time", "AllChapters");
		settings.Add("AllChapters_TeleportToOldCamp", true, "Teleport to the Old Camp", "AllChapters");
		settings.Add("AllChapters_FocusRuinedMonastery", true, "Teleport to Old Camp after collecting Focus from the Ruined Monastery", "AllChapters");
		settings.Add("AllChapters_TrollTeeth", true, "Loot teeth from the troll", "AllChapters");
		settings.Add("AllChapters_Lares", true, "Become a rogue", "AllChapters");
		settings.Add("AllChapters_EnterOrcGraveyard", true, "Enter orc graveyard", "AllChapters");
		settings.Add("AllChapters_LeaveOrcGraveyard", true, "Leave orc graveyard", "AllChapters");
		settings.Add("AllChapters_Chapter3", true, "Reach chapter 3", "AllChapters");
		settings.Add("AllChapters_Chapter4", true, "Reach chapter 4", "AllChapters");
		settings.Add("AllChapters_Temple2", true, "Enter Sleeper temple for the second time", "AllChapters");
		settings.Add("AllChapters_Priest1", true, "Loot priest 1 (Varrag Hashor)", "AllChapters");
		settings.Add("AllChapters_Priest5", true, "Loot priest 5 (Vrash Harrag Arushnat)", "AllChapters");
		settings.Add("AllChapters_End", true, "Beat the game", "AllChapters");
	
	settings.Add("extraSettings", false, "Extra settings");
		settings.Add("manualReset", false, "Automatically turn on manual reset when you have 2 minecrawler eggs and turn it off when you have 3", "extraSettings");

	vars.completedSplits = new HashSet<string>();
	vars.timeKeeper = new TimeSpan();
}

init {
	// Find global variables
	vars.globals = new Dictionary<string, MemoryWatcher>();

	var globalsDict = new Dictionary<string, string> {
		{ "KAPITEL",       "chapter"              },
		{ "ENTEREDTEMPLE", "enteredSleeperTemple" },
	};

	// cur_table.table
	int symtab = new DeepPointer("GothicMod.exe", 0x4DE174, 0x8).Deref<int>(game);
	int size = new DeepPointer("GothicMod.exe", 0x4DE174, 0x8 + 0x4).Deref<int>(game);
	
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

	// Important Coordinates
	vars.startX = 5547.608887; 
	vars.startY = 36488.625;

	// Grate
	vars.g1X = 2858.224854;
	vars.g1Y = -1903.604614;
	vars.g2X = 2663.101807;
	vars.g2Y = -1470.245605;

	// 
	vars.d1X = 19640.20508;
	vars.d1Y = 36921.04688;
	vars.d2X = 20025.33398;
	vars.d2Y = 36941.64062;

	//  
	vars.s1X = 14235.77246;
	vars.s1Y = 40537.76953;
	vars.s2X = 13863.95215;
	vars.s2Y = 40548.70703;	

	// Functions

	vars.PlayerHasMiscItem = (Func<string, bool>)(TargetItemName => {
		// player.inventory2.inventory[8].next
		IntPtr item = (IntPtr) new DeepPointer("GothicMod.exe", 0x4DBBB0, 0x550 + 0xA0 + 8 * 0xC + 0x8).Deref<int>(game);
		
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

	vars.PlayerHasMagicItem = (Func<string, bool>)(TargetItemName => {
		// player.inventory2.inventory[3].next
		IntPtr item = (IntPtr) new DeepPointer("GothicMod.exe", 0x4DBBB0, 0x550 + 0xA0 + 3 * 0xC + 0x8).Deref<int>(game);
		
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

	vars.PlayerHasWeapon = (Func<string, bool>)(TargetItemName => {
		// player.inventory2.inventory[1].next
		IntPtr item = (IntPtr) new DeepPointer("GothicMod.exe", 0x4DBBB0, 0x550 + 0xA0 + 1 * 0xC + 0x8).Deref<int>(game);
		
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

	vars.eggsDuped = false;
	vars.canReset = true;
}

update {
	if (!string.IsNullOrEmpty(current.world)) {
		vars.currentWorld = current.world;
	}
	if (!string.IsNullOrEmpty(old.world)) {
		vars.oldWorld = old.world;
	}

	foreach (var watcher in vars.globals.Values) {
		watcher.Update(game);
	}

	if (settings["manualReset"] && current.world == "ORCTEMPEL" && !vars.eggsDuped) {
		IntPtr misc = (IntPtr)current.FirstMisc;
		while (misc != IntPtr.Zero) {	
			var miscData = game.ReadPointer(misc + 0x4);
			string miscName = game.ReadString(game.ReadPointer(miscData + 0x18), 20);
			var miscAmount = game.ReadValue<int>(miscData + 0x2E4);
			
			if (miscName == "ITAT_CRAWLERQUEEN") {
				if (miscAmount == 2 && current.manualReset == 0) {
					game.WriteBytes(modules.Where(m => m.ModuleName == "ZSPEEDRUNTIMER.DLL").First().BaseAddress + 0x1A024, new byte[] {1});
				}
				if (miscAmount == 3) {
					game.WriteBytes(modules.Where(m => m.ModuleName == "ZSPEEDRUNTIMER.DLL").First().BaseAddress + 0x1A024, new byte[] {0});
					vars.eggsDuped = true;
				}
			}
	
			misc = game.ReadPointer(misc + 0x8);
		}	
	}

	if (!vars.canReset && current.igt > 500000) {
		vars.canReset = true;
	}
}

isLoading {
	return true;
}

gameTime {
	return (vars.timeKeeper + TimeSpan.FromMilliseconds(current.igt / 1000));
}

start {
	if (settings["resetNewGame"]) {
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
	vars.timeKeeper = TimeSpan.FromMilliseconds(0);
	vars.eggsDuped = false;
}

reset {
	if (settings["resetNewGame"]) {
		if (current.igt < 500000 && vars.canReset
				&& Math.Abs(current.x - vars.startX) < 0.0001
				&& Math.Abs(current.y - vars.startY) < 0.0001) {

			return true;
		}
	}
}

split {
	// Any%

	if (settings["Any%"]) {
		if (settings["Any%_Chest"] && !vars.completedSplits.Contains("Chest") && current.world == "WORLD" && vars.PlayerHasMagicItem("ITARSCROLLTRFORCDOG")) {
			return vars.completedSplits.Add("Chest");
		}
		if (settings["Any%_Temple"] && !vars.completedSplits.Contains("Temple") && current.world == "ORCTEMPEL" && vars.oldWorld == "WORLD") {
			return vars.completedSplits.Add("Temple");
		}
		if (settings["Any%_Grate"] && !vars.completedSplits.Contains("Grate") && current.world == "ORCTEMPEL") {
			if (((vars.g2X - vars.g1X) * (current.y - vars.g1Y) - (vars.g2Y - vars.g1Y) * (current.x - vars.g1X)) < 0) {
				return vars.completedSplits.Add("Grate");
			}
		}
		if (settings["Any%_Priest1"] && !vars.completedSplits.Contains("Priest1") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("ZEITENKLINGE") ) {
			return vars.completedSplits.Add("Priest1");
		}
		if (settings["Any%_Priest2"] && !vars.completedSplits.Contains("Priest2") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("LICHTBRINGER") ) {
			return vars.completedSplits.Add("Priest2");
		}
		if (settings["Any%_Priest3"] && !vars.completedSplits.Contains("Priest3") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("WELTENSPALTER") ) {
			return vars.completedSplits.Add("Priest3");
		}
		if (settings["Any%_Priest4"] && !vars.completedSplits.Contains("Priest4") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("DAEMONENSTREICH") ) {
			return vars.completedSplits.Add("Priest4");
		}
		if (settings["Any%_Priest5"] && !vars.completedSplits.Contains("Priest5") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("BANNKLINGE") ) {
			return vars.completedSplits.Add("Priest5");
		}
		if (settings["Any%_XardasTemple"] && !vars.completedSplits.Contains("XardasTemple") && current.world == "ORCTEMPEL" && current.camera == 1 
				&& Math.Sqrt(Math.Pow(12130 - current.x, 2) + Math.Pow(32027 - current.y, 2)) < 500) {
			return vars.completedSplits.Add("XardasTemple");
		}
		if (settings["Any%_Descent"] && !vars.completedSplits.Contains("Descent") && current.world == "ORCTEMPEL") {
			if (((vars.d2X - vars.d1X) * (current.y - vars.d1Y) - (vars.d2Y - vars.d1Y) * (current.x - vars.d1X)) > 0) {
				return vars.completedSplits.Add("Descent");
			}
		}
		if (settings["Any%_End"] && !vars.completedSplits.Contains("End") && current.cutscene > 0 && current.inMenu == 0 && current.world == "ORCTEMPEL" && current.vobs < 4000) {
			return vars.completedSplits.Add("End");
		}
	}

	// No Major Glitches
	
	if (settings["NMG"]) {
		if (settings["NMG_Bow"] && !vars.completedSplits.Contains("Bow") && current.world == "WORLD" && vars.PlayerHasWeapon("ITRW_BOW_SMALL_01")) {
			return vars.completedSplits.Add("Bow");
		}
		if (settings["NMG_Riddle1"] && !vars.completedSplits.Contains("Riddle1") && current.world == "ORCTEMPEL" 
				&& current.camera == 1 && Math.Sqrt(Math.Pow(1871 - current.x, 2) + Math.Pow(2498 - current.y, 2)) < 200) {
			return vars.completedSplits.Add("Riddle1");
		}
		if (settings["NMG_Riddle2"] && !vars.completedSplits.Contains("Riddle2") && current.world == "ORCTEMPEL" 
				&& current.camera == 1 && Math.Sqrt(Math.Pow(14805 - current.x, 2) + Math.Pow(-1733 - current.y, 2)) < 1500) {
			return vars.completedSplits.Add("Riddle2");
		}
		if (settings["NMG_Riddle3"] && !vars.completedSplits.Contains("Riddle3") && current.world == "ORCTEMPEL" && 
				current.camera == 1 && Math.Sqrt(Math.Pow(4880 - current.x, 2) + Math.Pow(9179 - current.y, 2)) < 500) {
			return vars.completedSplits.Add("Riddle3");
		}
	}

	// All Chapters
	
	if (settings["AllChapters"]) {
		if (settings["AllChapters_Temple"] && !vars.completedSplits.Contains("Temple") && current.world == "ORCTEMPEL") {
			return vars.completedSplits.Add("Temple");
		}
		if (settings["AllChapters_LeaveTemple"] && !vars.completedSplits.Contains("LeaveTemple") && current.world == "WORLD" && vars.globals["enteredSleeperTemple"].Current == 1 
				&& Math.Sqrt(Math.Pow(-37301 - current.x, 2) + Math.Pow(-28734 - current.y, 2)) < 200) {
			return vars.completedSplits.Add("LeaveTemple");
		}
		if (settings["AllChapters_EnterFreeMine"] && current.world == "FREEMINE" && vars.oldWorld == "WORLD") {
			return true;
		}
		if (settings["AllChapters_LeaveFreeMine"] && current.world == "WORLD" && vars.oldWorld == "FREEMINE") {
			return true;
		}
		if (settings["AllChapters_DeliveredWeed"] && !vars.completedSplits.Contains("DeliveredWeed") && current.inDialogue == 1 && current.exp == old.exp + 200) {
			return vars.completedSplits.Add("DeliveredWeed");
		}
		if (settings["AllChapters_Xardas"] && !vars.completedSplits.Contains("Xardas") && current.world == "WORLD" && current.inDialogue == 1
				&& Math.Sqrt(Math.Pow(-12000 - current.x, 2) + Math.Pow(-34300 - current.y, 2)) < 1000) {
			return vars.completedSplits.Add("Xardas");
		}
		if (settings["AllChapters_TeleportToOldCamp"] && !vars.completedSplits.Contains("TeleportToOldCamp")
				&& Math.Sqrt(Math.Pow(998 - current.x, 2) + Math.Pow(-3146 - current.y, 2)) < 200) {
			return vars.completedSplits.Add("TeleportToOldCamp");
		}
		if (settings["AllChapters_FocusRuinedMonastery"] && !vars.completedSplits.Contains("FocusRuinedMonastery") && current.world == "WORLD" && vars.PlayerHasMiscItem("FOCUS_4")
				&& Math.Sqrt(Math.Pow(998 - current.x, 2) + Math.Pow(-3146 - current.y, 2)) < 200) {
			return vars.completedSplits.Add("FocusRuinedMonastery");
		}
		if (settings["AllChapters_TrollTeeth"] && !vars.completedSplits.Contains("TrollTeeth") && current.world == "WORLD" && vars.PlayerHasMiscItem("ITAT_TROLL_02")) {
			return vars.completedSplits.Add("TrollTeeth");
		}
		if (settings["AllChapters_Lares"] && !vars.completedSplits.Contains("Lares") && current.guild == 8) {
			return vars.completedSplits.Add("Lares");
		}
		if (settings["AllChapters_EnterOrcGraveyard"] && current.world == "ORCGRAVEYARD" && vars.oldWorld == "WORLD") {
			return true;
		}
		if (settings["AllChapters_LeaveOrcGraveyard"] && current.world == "WORLD" && vars.oldWorld == "ORCGRAVEYARD") {
			return true;
		}
		if (settings["AllChapters_Chapter3"] && !vars.completedSplits.Contains("Chapter3") && vars.globals["chapter"].Current == 3) {
			return vars.completedSplits.Add("Chapter3");
		}
		if (settings["AllChapters_Chapter4"] && !vars.completedSplits.Contains("Chapter4") && vars.globals["chapter"].Current == 4) {
			return vars.completedSplits.Add("Chapter4");
		}
		if (settings["AllChapters_Temple2"] && !vars.completedSplits.Contains("Temple2") && current.world == "ORCTEMPEL" && vars.PlayerHasWeapon("MYTHRILKLINGE02")) {
			return vars.completedSplits.Add("Temple2");
		}
		if (settings["AllChapters_Priest1"] && !vars.completedSplits.Contains("Priest1") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("ZEITENKLINGE") ) {
			return vars.completedSplits.Add("Priest1");
		}
		if (settings["AllChapters_Priest2"] && !vars.completedSplits.Contains("Priest2") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("LICHTBRINGER") ) {
			return vars.completedSplits.Add("Priest2");
		}
		if (settings["AllChapters_Priest3"] && !vars.completedSplits.Contains("Priest3") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("WELTENSPALTER") ) {
			return vars.completedSplits.Add("Priest3");
		}
		if (settings["AllChapters_Priest4"] && !vars.completedSplits.Contains("Priest4") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("DAEMONENSTREICH") ) {
			return vars.completedSplits.Add("Priest4");
		}
		if (settings["AllChapters_Priest5"] && !vars.completedSplits.Contains("Priest5") && current.world == "ORCTEMPEL" && vars.PlayerHasMiscItem("BANNKLINGE") ) {
			return vars.completedSplits.Add("Priest5");
		}
		if (settings["AllChapters_End"] && !vars.completedSplits.Contains("End") && current.cutscene > 0 && current.inMenu == 0 && current.world == "ORCTEMPEL" && current.vobs < 4000) {
			return vars.completedSplits.Add("End");
		}
	}
}

exit {
	vars.timeKeeper = timer.CurrentTime.GameTime;
}