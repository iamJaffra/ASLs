state("Gothic2") {
	long igt:           "ZSPEEDRUNTIMER.DLL", 0x19F70;
	int world:          "Gothic2.exe", 0x4C0664, 0xB8, 0x91C;
	byte inCutscene:    "Gothic2.exe", 0x4C38B8;
	float playerX:      "Gothic2.exe", 0x4C0894;
	float playerY:      "Gothic2.exe", 0x4C088C;
	int exp:            "Gothic2.exe", 0x4C0664, 0x3A0;
	int guild:          "Gothic2.exe", 0x4C0664, 0x21C;
	int firstNPC:       "Gothic2.exe", 0x5813DC, 0x8, 0x6280, 0x8;
	int playerAddr:     "Gothic2.exe", 0x4C0664;
	int inventoryOpen:  "Gothic2.exe", 0x57DCA8;
	int inDialogue:     "Gothic2.exe", 0x4C0664, 0x284;
	int inMenu:         "Gothic2.exe", 0x4C37E0;
}

startup {
	// Any%
	settings.Add("Any%", true, "Any%");
		settings.Add("Any%_EnterValley", true, "Enter valley of mines", "Any%");
			settings.Add("Any%_EnterValleyWithFieldraider", true, "... with fieldraider in inventory", "Any%_EnterValley");
		settings.Add("Any%_CollectTeleportToPass", true, "Collect teleport rune to pass", "Any%");
		settings.Add("Any%_CollectTeleportToCastle", true, "Collect teleport rune to castle", "Any%");
		settings.Add("Any%_TeleportToCastle", true, "Teleport to castle", "Any%");
		settings.Add("Any%_CollectFirerain", true, "Collect firerain", "Any%");
		settings.Add("Any%_OpenGate", true, "Open gate in castle", "Any%");
		settings.Add("Any%_RockDragon", true, "Kill Rock Dragon", "Any%");
		settings.Add("Any%_Chapter5", true, "Reach chapter 5", "Any%");
		settings.Add("Any%_CollectMap", true, "Collect sea map to Irdorath", "Any%");
		settings.Add("Any%_RecruitTorlof", true, "Torlof becomes your captain", "Any%");
		settings.Add("Any%_Irdorath", true, "Enter Irdorath", "Any%");
		settings.Add("Any%_UndeadDragon", true, "Kill Undead Dragon", "Any%");
		settings.Add("Any%_End", true, "Finish Game", "Any%");

	// Any% No Flying
	settings.Add("Any%NoFlying", false, "Any% No Flying");
		settings.Add("Any%NoFlying_EnterValley", true, "Enter the valley of mines", "Any%NoFlying");
		settings.Add("Any%NoFlying_CollectTeleportToPass", true, "Collect teleport rune to pass", "Any%NoFlying");
		settings.Add("Any%NoFlying_CollectTeleportToCastle", true, "Collect teleport rune to castle", "Any%NoFlying");
		settings.Add("Any%NoFlying_TeleportToCastle", true, "Teleport to castle", "Any%NoFlying");
		settings.Add("Any%NoFlying_OpenGate", true, "Open gate in castle", "Any%NoFlying");
		settings.Add("Any%NoFlying_RockDragon", false, "Kill Rock Dragon (easy route)", "Any%NoFlying");
		settings.Add("Any%NoFlying_SwampDragon", true, "Kill Swamp Dragon (fast route)", "Any%NoFlying");
		settings.Add("Any%NoFlying_FireDragon", false, "Kill Fire Dragon", "Any%NoFlying");
		settings.Add("Any%NoFlying_Chapter5", true, "Reach chapter 5", "Any%NoFlying");
		settings.Add("Any%NoFlying_CollectTeleportToTavern", true, "Buy teleport rune from Orlan", "Any%NoFlying");
		settings.Add("Any%NoFlying_CollectMap", true, "Collect sea map to Irdorath", "Any%NoFlying");
		settings.Add("Any%NoFlying_RecruitTorlof", true, "Torlof becomes your captain", "Any%NoFlying");
		settings.Add("Any%NoFlying_Irdorath", true, "Enter Irdorath", "Any%NoFlying");
		settings.Add("Any%NoFlying_UndeadDragon", true, "Kill Undead Dragon", "Any%NoFlying");
		settings.Add("Any%NoFlying_End", true, "Finish Game", "Any%NoFlying");

	// All Chapters
	settings.Add("AllChapters", false, "All Chapters");
		settings.Add("AllChapters_Chapter2", true, "Reach chapter 2", "AllChapters");
		settings.Add("AllChapters_EnterValley", true, "Enter the valley of mines", "AllChapters");
		settings.Add("AllChapters_OpenGate", true, "Open gate in castle", "AllChapters");
		settings.Add("AllChapters_Chapter3", true, "Reach chapter 3", "AllChapters");
		settings.Add("AllChapters_ZurisDead", true, "Kill Zuris", "AllChapters");
		settings.Add("AllChapters_Militia", true, "Join the militia", "AllChapters");
		settings.Add("AllChapters_Paladin", true, "Become paladin", "AllChapters");
		settings.Add("AllChapters_Vatras", true, "Talk to Vatras", "AllChapters");
		settings.Add("AllChapters_Pyrokar", true, "Talk to Pyrokar", "AllChapters");
		settings.Add("AllChapters_Xardas", true, "Talk to Xardas", "AllChapters");
		settings.Add("AllChapters_Lee", true, "Get teleport rune from Lee", "AllChapters");
		settings.Add("AllChapters_Chapter4", true, "Reach chapter 4", "AllChapters");
		settings.Add("AllChapters_Chapter5", true, "Reach chapter 5", "AllChapters");
		settings.Add("AllChapters_Irdorath", true, "Enter Irdorath", "AllChapters");
		settings.Add("AllChapters_UndeadDragon", true, "Kill Undead Dragon", "AllChapters");
		settings.Add("AllChapters_End", true, "Finish Game", "AllChapters");

	// Glitch-Restricted
	settings.Add("GlitchRestricted", false, "Glitch-Restricted");
		settings.Add("GlitchRestricted_Ignaz", true, "Talk to Ignaz", "GlitchRestricted");
		settings.Add("GlitchRestricted_Militia", true, "Join the militia", "GlitchRestricted");
		settings.Add("GlitchRestricted_Chapter2", true, "Reach chapter 2", "GlitchRestricted");
		settings.Add("GlitchRestricted_EnterValley", true, "Enter the valley of mines", "GlitchRestricted");
		settings.Add("GlitchRestricted_CollectTeleportToPass", true, "Collect teleport rune to pass", "GlitchRestricted");
		settings.Add("GlitchRestricted_CollectTeleportToCastle", true, "Collect teleport rune to castle", "GlitchRestricted");
		settings.Add("GlitchRestricted_TeleportToCastle", true, "Teleport to castle", "GlitchRestricted");
		settings.Add("GlitchRestricted_Chapter3", true, "Reach chapter 3", "GlitchRestricted");
		settings.Add("GlitchRestricted_Paladin", true, "Become paladin", "GlitchRestricted");
		settings.Add("GlitchRestricted_Vatras", true, "Talk to Vatras", "GlitchRestricted");
		settings.Add("GlitchRestricted_Xardas", true, "Talk to Xardas", "GlitchRestricted");
		settings.Add("GlitchRestricted_Lee", true, "Get teleport rune from Lee", "GlitchRestricted");
		settings.Add("GlitchRestricted_Chapter4", true, "Reach chapter 4", "GlitchRestricted");
		settings.Add("GlitchRestricted_FireDragon", true, "Kill Fire Dragon", "GlitchRestricted");
		settings.Add("GlitchRestricted_RockDragon", true, "Kill Rock Dragon", "GlitchRestricted");
		settings.Add("GlitchRestricted_SwampDragon", true, "Kill Swamp Dragon", "GlitchRestricted");
		settings.Add("GlitchRestricted_IceDragon", false, "Kill Ice Dragon", "GlitchRestricted");
		settings.Add("GlitchRestricted_Chapter5", true, "Reach chapter 5", "GlitchRestricted");
		settings.Add("GlitchRestricted_Irdorath", true, "Enter Irdorath", "GlitchRestricted");
		settings.Add("GlitchRestricted_UndeadDragon", true, "Kill Undead Dragon", "GlitchRestricted");
		settings.Add("GlitchRestricted_End", true, "Finish Game", "GlitchRestricted");

	// Undead Dragon Kill
	settings.Add("UndeadDragonKill", false, "Undead Dragon Kill");
		settings.Add("UndeadDragonKill_Irdorath", true, "Enter Irdorath", "UndeadDragonKill");
		settings.Add("UndeadDragonKill_UndeadDragon", true, "Kill Undead Dragon", "UndeadDragonKill");

	// General settings
	settings.Add("NewGame", true, "Reset+Start timer on New Game");

	// Flags
	vars.completedSplits = new HashSet<string>();

	// Variable to save IGT in case the game crashes
	vars.timeKeeper = new TimeSpan();
}

init {
	// Find global variables
	vars.globals = new Dictionary<string, MemoryWatcher>();

	var globalsDict = new Dictionary<string, string> {
		{ "KAPITEL",         "chapter"     }
	};

	int symtab = new DeepPointer("Gothic2.exe", 0x585F70, 0x8).Deref<int>(game);
	int size = new DeepPointer("Gothic2.exe", 0x585F70, 0x8 + 0x4).Deref<int>(game);
	
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
	vars.XARDAS = 100;
	vars.ZURIS = 409;
	vars.VATRAS = 439;
	vars.IGNAZ = 498;
	vars.PYROKAR = 500;
	vars.TORLOF = 801;
	vars.ROCK_DRAGON = 9148;
	vars.SWAMP_DRAGON = 9151;
	vars.FIRE_DRAGON = 9141;
	vars.ICE_DRAGON = 9145;
	vars.UNDEAD_DRAGON = 9154;

	// Functions

	vars.IsDead = (Func<int, bool>)((npcID) => {
		// ogame.world.voblist_npc.data
		IntPtr npc = (IntPtr) new DeepPointer("Gothic2.exe", 0x5813DC, 0x8, 0x6280, 0x8).Deref<int>(game);

		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var id = game.ReadValue<int>(npcData + 0x120);
			var hp = game.ReadValue<int>(npcData + 0x1A4);
			
			if (id == npcID && hp == 0) {
				return true;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}

		return false;
	});
	
	vars.IsInDialogue = (Func<int, bool>)((npcID) => {
		// ogame.world.voblist_npc.data
		IntPtr npc = (IntPtr) new DeepPointer("Gothic2.exe", 0x5813DC, 0x8, 0x6280, 0x8).Deref<int>(game);

		while (npc != IntPtr.Zero) {
			var npcData = game.ReadPointer(npc + 0x4);
			var id = game.ReadValue<int>(npcData + 0x120);
			var inDialogue = game.ReadValue<int>(npcData + 0x284);

			if (id == npcID && inDialogue == 1) {
				return true;
			}
	
			npc = game.ReadPointer(npc + 0x8);
		}

		return false;
	});

	vars.PlayerHasItem = (Func<string, bool>)(TargetItemName => {
		// player.inventory2.contents
		IntPtr item = (IntPtr) new DeepPointer("Gothic2.exe", 0x5831DC, 0x5E0, 0x8).Deref<int>(game);    

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

	vars.canReset = true;
}

update {
	if (!vars.canReset && current.igt > 500000) {
		vars.canReset = true;
	}

	foreach (var watcher in vars.globals.Values) {
		watcher.Update(game);
	}
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

split {	
	// Any%

	if (settings["Any%"]) {
		if (settings["Any%_EnterValleyWithFieldraider"] && !vars.completedSplits.Contains("CollectedFieldraider") && vars.PlayerHasItem("ITSC_TRFGIANTBUG")) {
			vars.completedSplits.Add("CollectedFieldraider");
		}
		if (settings["Any%_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
			if ((settings["Any%_EnterValleyWithFieldraider"] && vars.completedSplits.Contains("CollectedFieldraider")) || !settings["Any%_EnterValleyWithFieldraider"]) {
				print("Split: EnterValley");
				return vars.completedSplits.Add("EnterValley");
			}
		}
		if (settings["Any%_CollectTeleportToPass"] && !vars.completedSplits.Contains("CollectTeleportToPass") && current.world == 2 && vars.PlayerHasItem("ITRU_TELEPORTPASSOW")
				&& Math.Sqrt(Math.Pow(27444.02148 - current.playerX, 2) + Math.Pow(-333.9581604 - current.playerY, 2)) < 1000) {
			print("Split: CollectTeleportToPass");
			return vars.completedSplits.Add("CollectTeleportToPass");
		}
		if (settings["Any%_CollectTeleportToCastle"] && !vars.completedSplits.Contains("CollectTeleportToCastle") && current.world == 2 && vars.PlayerHasItem("ITRU_TELEPORTOC")
				&& Math.Sqrt(Math.Pow(-3099.234131 - current.playerX, 2) + Math.Pow(1561.480957 - current.playerY, 2)) < 1000) {
			print("Split: CollectTeleportToCastle");
			return vars.completedSplits.Add("CollectTeleportToCastle");
		}
		if (settings["Any%_CollectFirerain"] && !vars.completedSplits.Contains("CollectFirerain") && current.world == 2 && vars.PlayerHasItem("ITSC_FIRERAIN")
				&& Math.Sqrt(Math.Pow(-13257.24512 - current.playerX, 2) + Math.Pow(-3468.070312 - current.playerY, 2)) < 1000) {
			print("Split: CollectFirerain");
			return vars.completedSplits.Add("CollectFirerain");
		}
		if (settings["Any%_TeleportToCastle"] && !vars.completedSplits.Contains("TeleportToCastle") && current.world == 2
				&& Math.Sqrt(Math.Pow(-3140 - current.playerX, 2) + Math.Pow(1012 - current.playerY, 2)) < 200 
				&& Math.Sqrt(Math.Pow(-3140 - old.playerX, 2) + Math.Pow(1012 - old.playerY, 2)) > 1000) {
			print("Split: TeleportToCastle");
			return vars.completedSplits.Add("TeleportToCastle");
		}
		if (settings["Any%_OpenGate"] && !vars.completedSplits.Contains("OpenGate") && current.inCutscene != 0 && current.world == 2
				&& Math.Sqrt(Math.Pow(1962 - current.playerX, 2) + Math.Pow(-2644 - current.playerY, 2)) < 200) {
			print("Split: OpenGate");
			return vars.completedSplits.Add("OpenGate");
		}
		if (settings["Any%_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.ROCK_DRAGON)) {
			print("Split: RockDragon");
			return vars.completedSplits.Add("RockDragon");
		}
		if (settings["Any%_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && vars.globals["chapter"].Current == 5) {
			print("Split: Chapter5");
			return vars.completedSplits.Add("Chapter5");
		}
		if (settings["Any%_CollectMap"] && !vars.completedSplits.Contains("CollectMap") && current.world == 1 && vars.PlayerHasItem("ITWR_SEAMAP_IRDORATH")
				&& Math.Sqrt(Math.Pow(19408.43555 - current.playerX, 2) + Math.Pow(51082.89062 - current.playerY, 2)) < 1000) {
			print("Split: CollectMap");
			return vars.completedSplits.Add("CollectMap");
		}
		if (settings["Any%_RecruitTorlof"] && !vars.completedSplits.Contains("RecruitTorlof") && current.world == 1 
				&& vars.IsInDialogue(801) && current.exp == old.exp + 2000) {
			print("Split: RecruitTorlof");
			return vars.completedSplits.Add("RecruitTorlof");
		}
		if (settings["Any%_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			print("Split: Irdorath");
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["Any%_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && current.exp > old.exp && vars.IsDead(vars.UNDEAD_DRAGON)) {
			print("Split: UndeadDragon");
			return vars.completedSplits.Add("UndeadDragon");
		}
		if (settings["Any%_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
			print("Split: End");
			return vars.completedSplits.Add("End");
		}
	}
	
	// Any% No Flying

	if (settings["Any%NoFlying"]) {
		if (settings["Any%NoFlying_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
			return vars.completedSplits.Add("EnterValley");
		}
		if (settings["Any%NoFlying_CollectTeleportToPass"] && !vars.completedSplits.Contains("CollectTeleportToPass") && vars.PlayerHasItem("ITRU_TELEPORTPASSOW")) {
			return vars.completedSplits.Add("CollectTeleportToPass");
		}
		if (settings["Any%NoFlying_CollectTeleportToCastle"] && !vars.completedSplits.Contains("CollectTeleportToCastle") && vars.PlayerHasItem("ITRU_TELEPORTOC")) {
			return vars.completedSplits.Add("CollectTeleportToCastle");
		}
		if (settings["Any%NoFlying_TeleportToCastle"] && !vars.completedSplits.Contains("TeleportToCastle") && current.world == 2
				&& Math.Sqrt(Math.Pow(-3140 - current.playerX, 2) + Math.Pow(1012 - current.playerY, 2)) < 200 
				&& Math.Sqrt(Math.Pow(-3140 - old.playerX, 2) + Math.Pow(1012 - old.playerY, 2)) > 1000) {
			return vars.completedSplits.Add("TeleportToCastle");
		}
		if (settings["Any%NoFlying_OpenGate"] && !vars.completedSplits.Contains("OpenGate") && current.inCutscene != 0 && current.world == 2
				&& Math.Sqrt(Math.Pow(1962 - current.playerX, 2) + Math.Pow(-2644 - current.playerY, 2)) < 200) {
			return vars.completedSplits.Add("OpenGate");
		}
		if (settings["Any%NoFlying_SwampDragon"] && !vars.completedSplits.Contains("SwampDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.SWAMP_DRAGON)) {
			return vars.completedSplits.Add("SwampDragon");
		}
		if (settings["Any%NoFlying_FireDragon"] && !vars.completedSplits.Contains("FireDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.SWAMP_DRAGON)) {
			return vars.completedSplits.Add("FireDragon");
		}
		if (settings["Any%NoFlying_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.ROCK_DRAGON)) {
			return vars.completedSplits.Add("RockDragon");
		}
		if (settings["Any%NoFlying_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && vars.globals["chapter"].Current == 5) {
			return vars.completedSplits.Add("Chapter5");
		}
		if (settings["Any%NoFlying_CollectTeleportToTavern"] && !vars.completedSplits.Contains("CollectTeleportToTavern") && vars.PlayerHasItem("ITRU_TELEPORTTAVERNE")) {
			return vars.completedSplits.Add("CollectTeleportToTavern");
		}
		if (settings["Any%NoFlying_CollectMap"] && !vars.completedSplits.Contains("CollectMap") && vars.PlayerHasItem("ITWR_SEAMAP_IRDORATH")) {
			return vars.completedSplits.Add("CollectMap");
		}
		if (settings["Any%NoFlying_RecruitTorlof"] && !vars.completedSplits.Contains("RecruitTorlof") && current.world == 1 
				&& vars.IsInDialogue(801) && current.exp == old.exp + 2000) {
			return vars.completedSplits.Add("RecruitTorlof");
		}
		if (settings["Any%NoFlying_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["Any%NoFlying_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && current.exp > old.exp && vars.IsDead(vars.UNDEAD_DRAGON)) {
			return vars.completedSplits.Add("UndeadDragon");
		}
		if (settings["Any%NoFlying_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
			return vars.completedSplits.Add("End");
		}
	}
	
	// All Chapters
	
	if (settings["AllChapters"]) {
		if (settings["AllChapters_Chapter2"] && !vars.completedSplits.Contains("Chapter2") && vars.globals["chapter"].Current == 2) {
			print("Split chapter 2");
			return vars.completedSplits.Add("Chapter2");
		}
		if (settings["AllChapters_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
			print("Split enter valley");
			return vars.completedSplits.Add("EnterValley");
		}
		if (settings["AllChapters_OpenGate"] && !vars.completedSplits.Contains("OpenGate") && current.inCutscene != 0 && current.world == 2
				&& Math.Sqrt(Math.Pow(1962 - current.playerX, 2) + Math.Pow(-2644 - current.playerY, 2)) < 200) {
			print("Split open gate");
			return vars.completedSplits.Add("OpenGate");
		}
		if (settings["AllChapters_Chapter3"] && !vars.completedSplits.Contains("Chapter3") && vars.globals["chapter"].Current == 3) {
			print("Split chapter 3");
			return vars.completedSplits.Add("Chapter3");
		}
		if (settings["AllChapters_ZurisDead"] && !vars.completedSplits.Contains("ZurisDead") && current.world == 1 && current.exp > old.exp && vars.IsDead(vars.ZURIS)) {
			print("Split zuris dead");
			return vars.completedSplits.Add("ZurisDead");
		}
		if (settings["AllChapters_Militia"] && !vars.completedSplits.Contains("Militia") && current.guild == 2) {
			print("Split militia");
			return vars.completedSplits.Add("Militia");
		}
		if (settings["AllChapters_Paladin"] && !vars.completedSplits.Contains("Paladin") && current.guild == 1) {
			print("Split paladin");
			return vars.completedSplits.Add("Paladin");
		}
		if (settings["AllChapters_Vatras"] && !vars.completedSplits.Contains("Vatras") && current.world == 1 && vars.globals["chapter"].Current == 3 && current.inDialogue == 1 && vars.IsInDialogue(vars.VATRAS)) {
			print("Split vatras");
			return vars.completedSplits.Add("Vatras");
		}
		if (settings["AllChapters_Pyrokar"] && !vars.completedSplits.Contains("Pyrokar") && current.world == 1 && vars.globals["chapter"].Current == 3 && current.inDialogue == 1 && vars.IsInDialogue(vars.PYROKAR)) {
			print("Split pyrokar");
			return vars.completedSplits.Add("Pyrokar");
		}
		if (settings["AllChapters_Xardas"] && !vars.completedSplits.Contains("Xardas") && current.world == 1 && vars.globals["chapter"].Current == 3 && current.inDialogue == 1 && vars.IsInDialogue(vars.XARDAS)) {
			print("Split xardas");
			return vars.completedSplits.Add("Xardas");
		}
		if (settings["AllChapters_Lee"] && !vars.completedSplits.Contains("Lee") && vars.PlayerHasItem("ITRU_TELEPORTFARM")) {
			print("Split lee");
			return vars.completedSplits.Add("Lee");
		}
		if (settings["AllChapters_Chapter4"] && !vars.completedSplits.Contains("Chapter4") && vars.globals["chapter"].Current == 4) {
			print("Split chapter 4");
			return vars.completedSplits.Add("Chapter4");
		}
		if (settings["AllChapters_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && vars.globals["chapter"].Current == 5) {
			print("Split chapter 5");
			return vars.completedSplits.Add("Chapter5");
		}
		if (settings["AllChapters_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["AllChapters_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && current.exp > old.exp && vars.IsDead(vars.UNDEAD_DRAGON)) {
			return vars.completedSplits.Add("UndeadDragon");
		}
		if (settings["AllChapters_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
			return vars.completedSplits.Add("End");
		}
	}
	
	// Glitch-Restricted

	if (settings["GlitchRestricted"]) {
		if (settings["GlitchRestricted_Ignaz"] && !vars.completedSplits.Contains("Ignaz") && current.world == 1 && current.inDialogue == 1 && vars.IsInDialogue(vars.IGNAZ)) {
			return vars.completedSplits.Add("Ignaz");
		}
		if (settings["GlitchRestricted_Militia"] && !vars.completedSplits.Contains("Militia") && current.guild == 2) {
			return vars.completedSplits.Add("Militia");
		}
		if (settings["GlitchRestricted_Chapter2"] && !vars.completedSplits.Contains("Chapter2") && vars.globals["chapter"].Current == 2) {
			return vars.completedSplits.Add("Chapter2");
		}
		if (settings["GlitchRestricted_EnterValley"] && !vars.completedSplits.Contains("EnterValley") && current.world == 2) {
			return vars.completedSplits.Add("EnterValley");
		}
		if (settings["GlitchRestricted_CollectTeleportToPass"] && !vars.completedSplits.Contains("CollectTeleportToPass") && vars.PlayerHasItem("ITRU_TELEPORTPASSOW")) {
			return vars.completedSplits.Add("CollectTeleportToPass");
		}
		if (settings["GlitchRestricted_CollectTeleportToCastle"] && !vars.completedSplits.Contains("CollectTeleportToCastle") && vars.PlayerHasItem("ITRU_TELEPORTOC")) {
			return vars.completedSplits.Add("CollectTeleportToCastle");
		}
		if (settings["GlitchRestricted_TeleportToCastle"] && !vars.completedSplits.Contains("TeleportToCastle") && current.world == 2
				&& Math.Sqrt(Math.Pow(-3140 - current.playerX, 2) + Math.Pow(1012 - current.playerY, 2)) < 200 
				&& Math.Sqrt(Math.Pow(-3140 - old.playerX, 2) + Math.Pow(1012 - old.playerY, 2)) > 1000) {
			return vars.completedSplits.Add("TeleportToCastle");
		}
		if (settings["GlitchRestricted_Chapter3"] && !vars.completedSplits.Contains("Chapter3") && vars.globals["chapter"].Current == 3) {
			return vars.completedSplits.Add("Chapter3");
		}		
		if (settings["GlitchRestricted_Paladin"] && !vars.completedSplits.Contains("Paladin") && current.guild == 1) {
			return vars.completedSplits.Add("Paladin");
		}
		if (settings["GlitchRestricted_Vatras"] && !vars.completedSplits.Contains("Vatras") && current.world == 1 && vars.globals["chapter"].Current == 3 && current.inDialogue == 1 && vars.IsInDialogue(vars.VATRAS)) {
			return vars.completedSplits.Add("Vatras");
		}
		if (settings["GlitchRestricted_Xardas"] && !vars.completedSplits.Contains("Xardas") && current.world == 1 && vars.globals["chapter"].Current == 3 && current.inDialogue == 1 && vars.IsInDialogue(vars.XARDAS)) {
			return vars.completedSplits.Add("Xardas");
		}
		if (settings["GlitchRestricted_Lee"] && !vars.completedSplits.Contains("Lee") && vars.PlayerHasItem("ITRU_TELEPORTFARM")) {
			return vars.completedSplits.Add("Lee");
		}
		if (settings["GlitchRestricted_Chapter4"] && !vars.completedSplits.Contains("Chapter4") && vars.globals["chapter"].Current == 4) {
			return vars.completedSplits.Add("Chapter4");
		}
		if (settings["GlitchRestricted_FireDragon"] && !vars.completedSplits.Contains("FireDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.FIRE_DRAGON)) {
			return vars.completedSplits.Add("FireDragon");
		}
		if (settings["GlitchRestricted_RockDragon"] && !vars.completedSplits.Contains("RockDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.ROCK_DRAGON)) {
			return vars.completedSplits.Add("RockDragon");
		}
		if (settings["GlitchRestricted_SwampDragon"] && !vars.completedSplits.Contains("SwampDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.SWAMP_DRAGON)) {
			return vars.completedSplits.Add("SwampDragon");
		}
		if (settings["GlitchRestricted_IceDragon"] && !vars.completedSplits.Contains("IceDragon") && current.world == 2 && current.exp > old.exp && vars.IsDead(vars.ICE_DRAGON)) {
			return vars.completedSplits.Add("IceDragon");
		}
		if (settings["GlitchRestricted_Chapter5"] && !vars.completedSplits.Contains("Chapter5") && vars.globals["chapter"].Current == 5) {
			return vars.completedSplits.Add("Chapter5");
		}
		if (settings["GlitchRestricted_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["GlitchRestricted_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && current.exp > old.exp && vars.IsDead(vars.UNDEAD_DRAGON)) {
			return vars.completedSplits.Add("UndeadDragon");
		}
		if (settings["GlitchRestricted_End"] && !vars.completedSplits.Contains("End") && current.world == 3 && current.inDialogue == 1 && current.inCutscene == 1) {
			return vars.completedSplits.Add("End");
		}
	}

	// Undead Dragon Kill
	if (settings["UndeadDragonKill"]) {
		if (settings["UndeadDragonKill_Irdorath"] && !vars.completedSplits.Contains("Irdorath") && current.world == 3) {
			return vars.completedSplits.Add("Irdorath");
		}
		if (settings["UndeadDragonKill_UndeadDragon"] && !vars.completedSplits.Contains("UndeadDragon") && current.world == 3 && current.exp > old.exp && vars.IsDead(vars.UNDEAD_DRAGON)) {
			return vars.completedSplits.Add("UndeadDragon");
		}
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