state("Gothic2") {
	long igt:           "ZSPEEDRUNTIMER.DLL", 0x19FE0;
	int fireDragon:     "Gothic2.exe", 0x006B40D8, 0x9128, 0xE64;
	int rockDragon:     "Gothic2.exe", 0x006B40D8, 0x9128, 0xEA0;
	int swampDragon:    "Gothic2.exe", 0x006B40D8, 0x9128, 0xEDC;
	int iceDragon:      "Gothic2.exe", 0x006B40D8, 0x9128, 0xE28;
	int world:          "Gothic2.exe", 0x004CECC0, 0x920;
	int chapter:        "Gothic2.exe", 0x006B40D8, 0x330C, 0xA68;
	int firstNPC:       "Gothic2.exe", 0x006B0884, 0x8, 0x6284, 0x8;
	int firstItem:      "Gothic2.exe", 0x006B629C, 0x1C, 0x66C, 0x8;
	int inCutscene:     "Gothic2.exe", 0x004D1F18;
	float playerX:      "Gothic2.exe", 0x004CEF4C;
	float playerY:      "Gothic2.exe", 0x004CEF44;
	int guild:          "Gothic2.exe", 0x006B629C, 0x1C, 0x230;
	string10 worldname: "Gothic2.exe", 0x006B0884, 0x8, 0x6274, 0x0;
	int inDialogue:     "Gothic2.exe", 0x006B629C, 0x1C, 0x298;
	int inventoryOpen:  "Gothic2.exe", 0x005A43F0;
	int load:           "Gothic2.exe", 0x005A3434;
}

startup {
	settings.Add("Any%", false, "Any%");
		settings.Add("Any%_Zuris", true, "Talk to Zuris", "Any%");
		settings.Add("Any%_EnterValley", true, "Enter valley", "Any%");
		settings.Add("Any%_FireDragon", true, "Kill Fire Dragon", "Any%");
		settings.Add("Any%_RockDragon", true, "Kill Rock Dragon", "Any%");
		settings.Add("Any%_SwampDragon", true, "Kill Swamp Dragon", "Any%");
		settings.Add("Any%_IceDragon", false, "Kill Ice Dragon (Any% No Flying)", "Any%");
		settings.Add("Any%_Chapter5", true, "Reach Chapter 5", "Any%");
		settings.Add("Any%_Map", true, "Collect sea map to Irdorath", "Any%");
		settings.Add("Any%_Irdorath", true, "Reach Irdorath", "Any%");
		settings.Add("Any%_UndeadDragon", true, "Kill Undead Dragon", "Any%");
		settings.Add("Any%_End", true, "Finish game", "Any%");

	settings.Add("AllChapters", false, "All Chapters");
		settings.Add("AllChapters_SnapperWeed", false, "Eat (or drop...) snapper weed", "AllChapters");
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
	// Starting coordinates
	vars.startX = -15710.02637; 
	vars.startY =  29912.93750;

	// NPC IDs	
	vars.importantNPCs = new HashSet<int> {
		409,  // Zuris
		1090, // Raven
		12377 // Undead Dragon
	};

	// Functions

	vars.NPCAddrMap = new Dictionary<int, IntPtr>();

	vars.CreateNPCAddrMap = (Action)(() => {
		print("Rebuilding NPC Map");
		vars.NPCAddrMap.Clear();

		IntPtr npc = (IntPtr)current.firstNPC;
		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var npcId = game.ReadValue<int>(npcData + 0x120);
			
			if (vars.importantNPCs.Contains(npcId)) {
				vars.NPCAddrMap[npcId] = npcData;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}
	});

	vars.IsDead = (Func<int, bool>)((npcID) => {
		IntPtr npcPtr;
		if (!vars.NPCAddrMap.TryGetValue(npcID, out npcPtr)) {
			print("IsDead() - TryGetValue failed");
			vars.CreateNPCAddrMap();
			return false;
		}

		if (npcPtr == IntPtr.Zero) {
			print("IsDead() - Ptr is Zero");
			vars.CreateNPCAddrMap();
			return false;
		}

		// Double check that the address is still valid
		var id = game.ReadValue<int>(npcPtr + 0x120);

		if (id == npcID) {
			var hp = game.ReadValue<int>(npcPtr + 0x1B8);
			
			return hp == 0;
		}
		else {
			print("IsDead() - id does not match");
			vars.CreateNPCAddrMap();
			return false;
		}
	});
	
	vars.IsInDialogue = (Func<int, bool>)((npcID) => {
		IntPtr npcPtr;
		if (!vars.NPCAddrMap.TryGetValue(npcID, out npcPtr)) {
			print("IsInDialogue() - TryGetValue failed");
			vars.CreateNPCAddrMap();
			return false;
		}

		if (npcPtr == IntPtr.Zero) {
			print("IsInDialogue() - Ptr is Zero");
			vars.CreateNPCAddrMap();
			return false;
		}

		// Double check that the address is still valid
		var id = game.ReadValue<int>(npcPtr + 0x120);

		if (id == npcID) {
			var inDialogue = game.ReadValue<int>(npcPtr + 0x298);
			
			return inDialogue == 1;
		}
		else {
			vars.CreateNPCAddrMap();
			print("IsInDialogue() - id does not match");
			return false;
		}
	});

	vars.PlayerHasItem = (Func<string, bool>)(TargetItemName => {
		IntPtr item = (IntPtr)current.firstItem;
		
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

	vars.lastTime = 0;
}

start {
	if (settings["NewGame"]) {
		if (current.igt < 500000
				&& Math.Abs(current.playerX - vars.startX) < 0.0001
				&& Math.Abs(current.playerY - vars.startY) < 0.0001) {

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
				&& Math.Abs(current.playerX - vars.startX) < 0.0001
				&& Math.Abs(current.playerY - vars.startY) < 0.0001) {

			return true;
		}
	}
}

update {
	if (settings["AllChapters_SnapperWeed"] && (vars.snapperWeed == 0 || vars.snapperWeed == 1)) {
		IntPtr item = (IntPtr)current.firstItem;

		var snapperWeedFound = false;

		while (item != IntPtr.Zero) {
			var itemData = game.ReadPointer(item + 0x4);
	
			string itemName = game.ReadString(game.ReadPointer(itemData + 0x18), 20);
			
			if (itemName == "ITPL_SPEED_HERB_01") {
				snapperWeedFound = true;
				vars.snapperWeed = 1;
			}
	
			item = game.ReadPointer(item + 0x8);
		}
		if (current.inventoryOpen == 1 && !snapperWeedFound && vars.snapperWeed == 1) {
			vars.snapperWeed = 2;
		}
	}

	if (!vars.canReset && current.igt > 500000) {
		vars.canReset = true;
	}

	if ((old.load == 1 && current.load == 0) || current.igt > vars.lastTime + 2000000) {
		vars.CreateNPCAddrMap();
		vars.lastTime = current.igt;
		print("lastTime == " + vars.lastTime);
	}
}

split {
	if ((settings["AllChapters_SnapperWeed"] && vars.snapperWeed == 3 && vars.Sw.ElapsedMilliseconds >= 5000) || !settings["AllChapters_SnapperWeed"]) {

		// ANY%

		if (settings["Any%_Zuris"] && !vars.completedSplits.Contains("Zuris") && current.world == 1 && vars.IsInDialogue(409)) {
			return vars.completedSplits.Add("Zuris");
		}
		if (settings["Any%_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
			return vars.completedSplits.Add("EnterValley");
		}
		if (settings["Any%_FireDragon"] && !vars.completedSplits.Contains("FireDragon") && current.fireDragon == 1) {
			return vars.completedSplits.Add("FireDragon");
		}
		if (settings["Any%_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && current.rockDragon == 1) {
			return vars.completedSplits.Add("RockDragon");
		}
		if (settings["Any%_SwampDragon"] && !vars.completedSplits.Contains("SwampDragon") && current.swampDragon == 1) {
			return vars.completedSplits.Add("SwampDragon");
		}
		if (settings["Any%_IceDragon"] && !vars.completedSplits.Contains("IceDragon") && current.iceDragon == 1) {
			return vars.completedSplits.Add("IceDragon");
		}
		if (settings["Any%_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && current.chapter == 5) {
			return vars.completedSplits.Add("Chapter5");
		}
		if (settings["Any%_Map"] && !vars.completedSplits.Contains("Map") && current.world == 1 && vars.PlayerHasItem("ITWR_SEAMAP_IRDORATH")) {
			return vars.completedSplits.Add("Map");
		}
		if (settings["Any%_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["Any%_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && vars.IsDead(12377)) {
			return vars.completedSplits.Add("UndeadDragon");
		}
		if (settings["Any%_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
			return vars.completedSplits.Add("End");
		}

		// ALL CHAPTERS

		if (settings["AllChapters_Ore"] && !vars.completedSplits.Contains("Ore") && current.world == 1 && vars.PlayerHasItem("ITMI_ZEITSPALT_ADDON")) {
			return vars.completedSplits.Add("Ore");
		}
		if (settings["AllChapters_Zuris"] && !vars.completedSplits.Contains("Zuris") && current.world == 1 && vars.IsInDialogue(409)) {
			return vars.completedSplits.Add("Zuris");
		}
		if (settings["AllChapters_Chapter2"] && !vars.completedSplits.Contains("Chapter2") && current.chapter == 2) {
			return vars.completedSplits.Add("Chapter2");
		}
		if (settings["AllChapters_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
			return vars.completedSplits.Add("EnterValley");
		}
		if (settings["AllChapters_CastleRune"] && !vars.completedSplits.Contains("CastleRune") && current.world == 2 && vars.PlayerHasItem("ITRU_TELEPORTOC")) {
			return vars.completedSplits.Add("CastleRune");
		}
		if (settings["AllChapters_FireDragon"] && !vars.completedSplits.Contains("FireDragon") && current.fireDragon == 1) {
			return vars.completedSplits.Add("FireDragon");
		}
		if (settings["AllChapters_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && current.rockDragon == 1) {
			return vars.completedSplits.Add("RockDragon");
		}
		if (settings["AllChapters_Chapter3"] && !vars.completedSplits.Contains("Chapter3") && current.chapter == 3) {
			return vars.completedSplits.Add("Chapter3");
		}
		if (settings["AllChapters_EnterJharkendar"] && !vars.completedSplits.Contains("EnterJharkendar") && current.worldname == "ADDONWORLD") {
			return vars.completedSplits.Add("EnterJharkendar");
		}
		if (settings["AllChapters_Raven"] && !vars.completedSplits.Contains("Raven") && current.worldname == "ADDONWORLD" && vars.IsDead(1090)) {
			return vars.completedSplits.Add("Raven");
		}
		if (settings["AllChapters_LeaveJharkendar"] && !vars.completedSplits.Contains("LeaveJharkendar") && old.worldname == "ADDONWORLD" && current.worldname == "NEWWORLD") {
			return vars.completedSplits.Add("LeaveJharkendar");
		}
		if (settings["AllChapters_JoinMilitia"] && !vars.completedSplits.Contains("JoinMilitia") && current.guild == 2) {
			return vars.completedSplits.Add("JoinMilitia");
		}
		if (settings["AllChapters_Eye"] && !vars.completedSplits.Contains("Eye") && current.world == 1 && vars.PlayerHasItem("ITMI_INNOSEYE_BROKEN")) {
			return vars.completedSplits.Add("Eye");
		}
		if (settings["AllChapters_OnarRune"] && !vars.completedSplits.Contains("OnarRune") && current.world == 1 && vars.PlayerHasItem("ITRU_TELEPORTFARM")) {
			return vars.completedSplits.Add("OnarRune");
		}
		if (settings["AllChapters_Chapter4"] && !vars.completedSplits.Contains("Chapter4") && current.chapter == 4) {
			return vars.completedSplits.Add("Chapter4");
		}
		if (settings["AllChapters_SwampDragon"] && !vars.completedSplits.Contains("SwampDragon") && current.swampDragon == 1) {
			return vars.completedSplits.Add("SwampDragon");
		}
		if (settings["AllChapters_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && current.chapter == 5) {
			return vars.completedSplits.Add("Chapter5");
		}
		if (settings["AllChapters_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["AllChapters_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && vars.IsDead(12377)) {
			return vars.completedSplits.Add("UndeadDragon");
		}
		if (settings["AllChapters_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
			return vars.completedSplits.Add("End");
		}
	}
	if (vars.snapperWeed == 2) {
		vars.snapperWeed = 3;
		vars.Sw.Start();
		return true;
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