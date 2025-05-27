state("RSHIVERS") {
	ushort room:  0xB57D8,  0x34,  0x1C;
	int    score: 0xB57D8, 0x130, 0x204;
}

start {
	return current.room == 1010 && old.room == 1000;
}

split {
	// End
	if (current.room == 26901 && current.score == old.score + 2500) {
		return true;
	}
	// Placing bahos in kiva
	else if (current.room == 26600 && current.score == old.score + 7000) {
		return true;
	}
}