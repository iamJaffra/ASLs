state("eoa") {
	string8 age:		"eoa.exe", 0x006DB610, 0xFC;
	byte menu:			"eoa.exe", 0x006DEB00, 0x8, 0x40, 0x14, 0x38;
	byte tabletWithNPC:	"eoa.exe", 0x006F0BB4, 0x8, 0x14, 0x38, 0x8, 0x84, 0x1C, 0x6C, 0x8, 0x4, 0x20;
}

startup {
	settings.Add("startTimer", true, "Start the timer when you click OK");
	settings.Add("splitAgeChange", true, "Split any time you link from one age to another");
		settings.Add("Exception", true, "... except when linking from the Keep back to Kveer", "splitAgeChange");
	settings.Add("splitWings", true, "Split when the Bahro's wings fully cover the screen (Good Ending)");
	settings.Add("resetInMainMenu", true, "Reset the timer when you go to the main menu");
}

init {
	vars.runOver = 0;
	
	vars.wingsTimer = new Stopwatch();
	vars.wingsDelay = TimeSpan.FromSeconds(1.250);
}

reset {
	if (settings["resetInMainMenu"] && current.age == "StartUp") {
		return true;
	}
}

start {
	if (settings["startTimer"] && current.age == "Kveer" && current.menu == 0 && old.menu == 1) {
		return true;
	}	
}

onStart {
	vars.runOver = 0;
}

update {
	if (current.tabletWithNPC == 3 && old.tabletWithNPC == 0) {
		vars.runOver = 1;
		vars.wingsTimer.Restart();
	}

	if (vars.wingsTimer.Elapsed >= vars.wingsDelay) {
		vars.wingsTimer.Stop();
	}
}

split {
	if (settings["splitWings"] && !vars.wingsTimer.IsRunning && vars.runOver == 1) {
		vars.runOver = 2;
		return true;
	}
	
	string[] ages = {"Kveer", "Descent", "Direbo", "Tahgira", "Todelmer", "Siralehn", "Laki", "Myst"};

	if (settings["splitAgeChange"] && current.age != old.age && Array.Exists(ages, age => age == current.age)) 	
	{
		if (settings["Exception"] && current.age == "Kveer") {
			return false;
		} 
		return true;
	}
}