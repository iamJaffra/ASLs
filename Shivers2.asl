state("RSHIVERS") {
	ushort room:  0xB57D8,  0x34,  0x1C;
	int    score: 0xB57D8, 0x130, 0x204;
}

startup {
	settings.Add("Bahos", true, "Split any time you place a Bahos in the altar");
	settings.Add("End",   true, "Split on good ending");
}

start {
	return current.room == 1010 && old.room == 1000;
}

split {
	if (settings["End"] && current.room == 26901 && current.score == old.score + 2500) {
		return true;
	}
	else if (settings["Bahos"] && current.room == 26600 && current.score == old.score + 7000) {
		return true;
	}
}