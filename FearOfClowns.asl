state("Fear of Clowns") { 
	string16 level: "EnhancementsFREE.dll", 0xCDD13;
	bool someByte: "DBProAnimationDebug.dll", 0x1C5CC;
}

startup {
	settings.Add("Level splits", true, "Individual level splits");
	vars.levels = new Dictionary<string,string> {
		{"level1.zip", "Level 1"},
		{"level2.zip", "Level 2"},
		{"level4.zip", "Level 3"},
		{"level6.zip", "Level 4"},
		{"level8.zip", "Level 5"},
		{"level10.zip", "Level 6"},
		{"level12.zip", "Level 7"},
		{"level14.zip", "Level 8"},
		{"level16.zip", "Level 9"},
		{"level18.zip", "Level 10"},
		{"end", "Level 11"},
	};
	foreach (var level in vars.levels) {
		settings.Add(level.Key, true, level.Value, "Level splits");
    	};
	vars.completedLevels = new HashSet<string>();
}

init {
	var loadSig = new SigScanTarget(1, "A1 ?? ?? ?? ?? 8B C8 A1 ?? ?? ?? ?? 8B 1D ?? ?? ?? ?? 8B 04 98 89 88 10 00 00 00 C7 05 ?? ?? ?? ?? 5E B1 00 00");
	
	vars.loadAddr = IntPtr.Zero;
	int scanAttempts = 10;

	foreach (var page in game.MemoryPages(true).Reverse()) {
		var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
		if ((vars.loadAddr = scanner.Scan(loadSig)) != IntPtr.Zero) {
			break;
		}
	}
	if (vars.loadAddr == IntPtr.Zero) {
		throw new InvalidOperationException("Failed to find signature! Trying again.");
	}

	vars.isLoading = new MemoryWatcher<bool>(new DeepPointer((IntPtr)vars.loadAddr, 0x0));
}

update {
	vars.isLoading.Update(game);
}

isLoading {
	return string.IsNullOrEmpty(current.level) 
		|| current.level == "level3.zip" 
		|| current.level == "level5.zip" 
		|| current.level == "level7.zip" 
		|| current.level == "level9.zip" 
		|| current.level == "level11.zip" 
		|| current.level == "level13.zip" 
		|| current.level == "level15.zip" 
		|| current.level == "level17.zip" 
		|| current.level == "level19.zip" 
		|| vars.isLoading.Current;
}

onReset {
	vars.completedLevels.Clear();
}

start {
	return current.level == "level1.zip" && vars.isLoading.Old && !vars.isLoading.Current;
}

split {
	if (settings["end"] && current.level == "level20.zip" && current.someByte) {
		vars.completedLevels.Add(current.level);
		return true;
	} 
	else if (!string.IsNullOrEmpty(old.level) && vars.levels.ContainsKey(old.level)) {
		int currentLevel = int.Parse(current.level.Replace("level", "").Replace(".zip", ""));
		int oldLevel = int.Parse(old.level.Replace("level", "").Replace(".zip", ""));

		if (settings[old.level] && currentLevel == oldLevel + 1 && !vars.completedLevels.Contains(old.level)) {
			vars.completedLevels.Add(old.level);
			return true;
		}
	}
}

exit {
	timer.IsGameTimePaused = true;
}