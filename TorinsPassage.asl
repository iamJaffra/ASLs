state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("SCI");

	settings.Add("splits", false, "Split on ...");
		settings.Add("chapterSplits", true, "Chapter transitions", "splits");
		settings.Add("end",           true, "Finishing the game",  "splits");
}

init {
	vars.ScummVM.Init();

	vars.ScummVM.TryLoad = (Func<dynamic, bool>)(svm => {
		svm["room"] = svm.Watch<ushort>("_gamestate", "variables", 0x0, 11 * 0x4 + 0x2);
		svm["score"] = svm.Watch<ushort>("_gamestate", "variables", 0x0, 15 * 0x4 + 0x2);
		svm["chapter"] = svm.Watch<ushort>("_gamestate", "variables", 0x0, 202 * 0x4 + 0x2);
		
		return true;
	});
}

update {
	vars.ScummVM.Update();
}

start {
	// Start on selecting chapter 1 (The Lands Above) from the main menu
	return current.chapter == 1 && old.chapter == 0;
}

reset {
	// Reset on main menu
	return current.room == 61100 && old.room != 61100;
}

split {
	// Use magic book on Pecand
	if (settings["end"] && current.room == 51400 && current.score == old.score + 18) {
		return true;
	}
	// Chapter splits
	else if (settings["chapterSplits"] && current.chapter == old.chapter + 1) {
		return true;
	}
}