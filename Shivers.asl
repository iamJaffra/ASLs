state("scummvm") {
	// Main variables
	int Room: 0x017AE444, 0xA4, 0x20, 0x8, 0x4;
	ushort CapturedIxupi: 0x17AE444, 0x100, 0x88, 0x1A2;

	// Life Essence
	byte Life: 0x17AE444, 0x100, 0x88, 0x1B6;

	// Skull Dials
	byte SkullDialNest: 0x17AE444, 0x100, 0x88, 0x522;
	byte SkullDialMaze: 0x17AE444, 0x100, 0x88, 0x526;
	byte SkullDialWerewolf: 0x17AE444, 0x100, 0x88, 0x52A;
	byte SkullDialChina: 0x17AE444, 0x100, 0x88, 0x52E;
	byte SkullDialEgypt: 0x17AE444, 0x100, 0x88, 0x532;
	byte SkullDialLyre: 0x17AE444, 0x100, 0x88, 0x536;

	// Puzzle States
	// Atlantis Globe (5), Organ (6), Theater Curtain (2), Marble Pinball (4)
	byte PuzzleGroupA: 0x17AE444, 0x100, 0x88, 0x346;
	// Gears (7), Stonehenge (6)
	byte PuzzleGroupB: 0x17AE444, 0x100, 0x88, 0x347;
	// Maze Door (0), Theater Door (3), Geoffrey Door (1), Horse Puzzle (5), Red Door (7)
	byte PuzzleGroupC: 0x17AE444, 0x100, 0x88, 0x34A;
	// Columns of Ra (6), Burial Door (5), Shaman (1), Lyre (0)
	byte PuzzleGroupD: 0x17AE444, 0x100, 0x88, 0x34B;
	// Library Statue (7)
	byte PuzzleGroupE: 0x17AE444, 0x100, 0x88, 0x34E;
	// Alchemy (5)
	byte PuzzleGroupF: 0x17AE444, 0x100, 0x88, 0x352;
	// Skull Dial Door (1), Beth's Body Page (7), Guillotine (6)
	byte PuzzleGroupG: 0x17AE444, 0x100, 0x88, 0x356;
	// Workshop Drawers (7), UFO (3), Jukebox (5), Mastermind (6)
	byte PuzzleGroupH: 0x17AE444, 0x100, 0x88, 0x357;
	// Clock Chains (5), Anansi (7)
	byte PuzzleGroupI: 0x17AE444, 0x100, 0x88, 0x35A;
	// Chinese Solitaire (4), Gallows (6)
	byte PuzzleGroupJ: 0x17AE444, 0x100, 0x88, 0x35B;
}

startup {
	// Settings
	settings.Add("Misc", false, "Miscellaneous checkpoints");
		settings.Add("Light", false, "Turn on light in Green Tunnel", "Misc");
		settings.Add("FirstBlood", false, "First Blood", "Misc");
		settings.Add("Office", false, "Reach Office", "Misc");
		settings.Add("Beth", false, "Beth's Body Page", "Misc");
		settings.Add("Guillotine", false, "Guillotine", "Misc");
	settings.Add("Ixupi", true, "Split when capturing Ixupi");
		settings.Add("Sand", true, "Sand", "Ixupi");
		settings.Add("Crystal", true, "Ash", "Ixupi");
		settings.Add("Metal", true, "Metal", "Ixupi");
		settings.Add("Tar", true, "Tar", "Ixupi");
		settings.Add("Wood", true, "Wood", "Ixupi");
		settings.Add("Lightning", true, "Lightning", "Ixupi");
		settings.Add("Ash", true, "Ash", "Ixupi");
		settings.Add("Water", true, "Water", "Ixupi");
		settings.Add("Cloth", true, "Cloth", "Ixupi");
		settings.Add("Wax", true, "Wax", "Ixupi");
	settings.Add("SkullDials", false, "Split when solving Skull Dials");
		settings.Add("SkullDialNest", false, "Nest", "SkullDials");
		settings.Add("SkullDialMaze", false, "Maze", "SkullDials");
		settings.Add("SkullDialWerewolf", false, "Werewolf", "SkullDials");
		settings.Add("SkullDialChina", false, "China", "SkullDials");
		settings.Add("SkullDialEgypt", false, "Egypt", "SkullDials");
		settings.Add("SkullDialLyre", false, "Lyre", "SkullDials");
	settings.Add("Puzzles", false, "Puzzles");
		settings.Add("AtlantisGlobe", false, "Solve Atlantis Globe", "Puzzles");
		settings.Add("Organ", false, "Solve Organ", "Puzzles");
		settings.Add("TheaterCurtain", false, "Solve Theater Curtain", "Puzzles");
		settings.Add("MarblePinball", false, "Solve Marble Pinball", "Puzzles");
		settings.Add("Gears", false, "Solve Gears", "Puzzles");
		settings.Add("Stonehenge", false, "Solve Stonehenge", "Puzzles");
		settings.Add("MazeDoor", false, "Solve Maze Door", "Puzzles");
		settings.Add("TheaterDoor", false, "Solve Theater Door", "Puzzles");
		settings.Add("GeoffreyDoor", false, "Solve Geoffrey Door", "Puzzles");
		settings.Add("HorsePuzzle", false, "Solve Horse Puzzle", "Puzzles");
		settings.Add("RedDoor", false, "Solve Red Door", "Puzzles");
		settings.Add("ColumnsOfRa", false, "Solve Columns of Ra", "Puzzles");
		settings.Add("BurialDoor", false, "Solve Burial Door", "Puzzles");
		settings.Add("Shaman", false, "Solve Shaman", "Puzzles");
		settings.Add("Lyre", false, "Solve Lyre", "Puzzles");
		settings.Add("LibraryStatue", false, "Solve Library Statue", "Puzzles");
		settings.Add("Alchemy", false, "Solve Alchemy", "Puzzles");
		settings.Add("SkullDialDoor", false, "Solve Skull Dial Door", "Puzzles");
		settings.Add("WorkshopDrawers", false, "Solve Workshop Drawers", "Puzzles");
		settings.Add("UFO", false, "Solve UFO", "Puzzles");
		settings.Add("Jukebox", false, "Solve Jukebox", "Puzzles");
		settings.Add("Mastermind", false, "Solve Mastermind", "Puzzles");
		settings.Add("ClockChains", false, "Solve Clock Chains", "Puzzles");
		settings.Add("Anansi", false, "Solve Anansi", "Puzzles");
		settings.Add("Solitaire", false, "Solve Solitaire", "Puzzles");
		settings.Add("Gallows", false, "Solve Gallows", "Puzzles");

	// Flags
	vars.completedSplits = new HashSet<string>();
}

start {
	return (old.Room == 1012 && (current.Room == 1000 || current.Room == 1010));
}

reset {
	// TODO
}

onStart {
	vars.completedSplits.Clear();
}

split {
	// Misc. Checkpoints
	if (settings["Light"] && !vars.completedSplits.Contains("Light") && current.Room == 2340) {
		return vars.completedSplits.Add("Light");
	}
	if (settings["FirstBlood"] && !vars.completedSplits.Contains("FirstBlood") && current.Life == old.Life - 10) {
		return vars.completedSplits.Add("FirstBlood");
	}
	if (settings["Office"] && !vars.completedSplits.Contains("Office") && current.Room == 5050) {
		return vars.completedSplits.Add("Office");
	}

	// Ixupi
	if (settings["Sand"] && !vars.completedSplits.Contains("Sand") && ((current.CapturedIxupi & (1 << 0)) != 0)) {
		return vars.completedSplits.Add("Sand");
	}
	if (settings["Crystal"] && !vars.completedSplits.Contains("Crystal") && ((current.CapturedIxupi & (1 << 1)) != 0)) {
		return vars.completedSplits.Add("Crystal");
	}
	if (settings["Metal"] && !vars.completedSplits.Contains("Metal") && ((current.CapturedIxupi & (1 << 2)) != 0)) {
		return vars.completedSplits.Add("Metal");
	}
	if (settings["Tar"] && !vars.completedSplits.Contains("Tar") && ((current.CapturedIxupi & (1 << 3)) != 0)) {
		return vars.completedSplits.Add("Tar");
	}
	if (settings["Wood"] && !vars.completedSplits.Contains("Wood") && ((current.CapturedIxupi & (1 << 4)) != 0)) {
		return vars.completedSplits.Add("Wood");
	}
	if (settings["Lightning"] && !vars.completedSplits.Contains("Lightning") && ((current.CapturedIxupi & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("Lightning");
	}
	if (settings["Ash"] && !vars.completedSplits.Contains("Ash") && ((current.CapturedIxupi & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("Ash");
	}
	if (settings["Water"] && !vars.completedSplits.Contains("Water") && ((current.CapturedIxupi & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("Water");
	}
	if (settings["Cloth"] && !vars.completedSplits.Contains("Cloth") && ((current.CapturedIxupi & (1 << 8)) != 0)) {
		return vars.completedSplits.Add("Cloth");
	}
	if (settings["Wax"] && !vars.completedSplits.Contains("Wax") && ((current.CapturedIxupi & (1 << 9)) != 0)) {
		return vars.completedSplits.Add("Wax");
	}

	// Skull Dials
	if (settings["SkullDialNest"] && !vars.completedSplits.Contains("SkullDialNest") && current.SkullDialNest == 0) {
		return vars.completedSplits.Add("SkullDialNest");
	}
	if (settings["SkullDialMaze"] && !vars.completedSplits.Contains("SkullDialMaze") && current.SkullDialMaze == 2) {
		return vars.completedSplits.Add("SkullDialMaze");
	}
	if (settings["SkullDialWerewolf"] && !vars.completedSplits.Contains("SkullDialWerewolf") && current.SkullDialWerewolf == 3) {
		return vars.completedSplits.Add("SkullDialWerewolf");
	}
	if (settings["SkullDialChina"] && !vars.completedSplits.Contains("SkullDialChina") && current.SkullDialChina == 0) {
		return vars.completedSplits.Add("SkullDialChina");
	}
	if (settings["SkullDialEgypt"] && !vars.completedSplits.Contains("SkullDialEgypt") && current.SkullDialEgypt == 1) {
		return vars.completedSplits.Add("SkullDialEgypt");
	}
	if (settings["SkullDialLyre"] && !vars.completedSplits.Contains("SkullDialLyre") && current.SkullDialLyre == 3) {
		return vars.completedSplits.Add("SkullDialLyre");
	}

	// Puzzles
	// PuzzleGroupA: Atlantis Globe (5), Organ (6), Theater Curtain (2), Marble Pinball (4)
	if (settings["AtlantisGlobe"] && !vars.completedSplits.Contains("AtlantisGlobe") && ((current.PuzzleGroupA & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("AtlantisGlobe");
	}
	if (settings["Organ"] && !vars.completedSplits.Contains("Organ") && ((current.PuzzleGroupA & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("Organ");
	}
	if (settings["TheaterCurtain"] && !vars.completedSplits.Contains("TheaterCurtain") && ((current.PuzzleGroupA & (1 << 2)) != 0)) {
		return vars.completedSplits.Add("TheaterCurtain");
	}
	if (settings["MarblePinball"] && !vars.completedSplits.Contains("MarblePinball") && ((current.PuzzleGroupA & (1 << 4)) != 0)) {
		return vars.completedSplits.Add("MarblePinball");
	}
	// PuzzleGroupB: Gears (7), Stonehenge (6)
	if (settings["Gears"] && !vars.completedSplits.Contains("Gears") && ((current.PuzzleGroupB & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("Gears");
	}
	if (settings["Stonehenge"] && !vars.completedSplits.Contains("Stonehenge") && ((current.PuzzleGroupB & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("Stonehenge");
	}
	// PuzzleGroupC: Maze Door (0), Theater Door (3), Geoffrey Door (1), Horse Puzzle (5), Red Door (7)
	if (settings["MazeDoor"] && !vars.completedSplits.Contains("MazeDoor") && ((current.PuzzleGroupC & (1 << 0)) != 0)) {
		return vars.completedSplits.Add("MazeDoor");
	}
	if (settings["TheaterDoor"] && !vars.completedSplits.Contains("TheaterDoor") && ((current.PuzzleGroupC & (1 << 3)) != 0)) {
		return vars.completedSplits.Add("TheaterDoor");
	}
	if (settings["GeoffreyDoor"] && !vars.completedSplits.Contains("GeoffreyDoor") && ((current.PuzzleGroupC & (1 << 1)) != 0)) {
		return vars.completedSplits.Add("GeoffreyDoor");
	}
	if (settings["HorsePuzzle"] && !vars.completedSplits.Contains("HorsePuzzle") && ((current.PuzzleGroupC & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("HorsePuzzle");
	}
	if (settings["RedDoor"] && !vars.completedSplits.Contains("RedDoor") && ((current.PuzzleGroupC & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("RedDoor");
	}
	// PuzzleGroupD: Columns of Ra (6), Burial Door (5), Shaman (1), Lyre (0)
	if (settings["ColumnsOfRa"] && !vars.completedSplits.Contains("ColumnsOfRa") && ((current.PuzzleGroupD & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("ColumnsOfRa");
	}
	if (settings["BurialDoor"] && !vars.completedSplits.Contains("BurialDoor") && ((current.PuzzleGroupD & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("BurialDoor");
	}
	if (settings["Shaman"] && !vars.completedSplits.Contains("Shaman") && ((current.PuzzleGroupD & (1 << 1)) != 0)) {
		return vars.completedSplits.Add("Shaman");
	}
	if (settings["Lyre"] && !vars.completedSplits.Contains("Lyre") && ((current.PuzzleGroupD & (1 << 0)) != 0)) {
		return vars.completedSplits.Add("Lyre");
	}
	// PuzzleGroupE: Library Statue (7)
	if (settings["LibraryStatue"] && !vars.completedSplits.Contains("LibraryStatue") && ((current.PuzzleGroupE & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("LibraryStatue");
	}
	// PuzzleGroupF: Alchemy (5)
	if (settings["Alchemy"] && !vars.completedSplits.Contains("Alchemy") && ((current.PuzzleGroupF & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("Alchemy");
	}
	// PuzzleGroupG: Skull Dial Door (1), Beth's Body Page (7), Guillotine (6)
	if (settings["SkullDialDoor"] && !vars.completedSplits.Contains("SkullDialDoor") && ((current.PuzzleGroupG & (1 << 1)) != 0)) {
		return vars.completedSplits.Add("SkullDialDoor");
	}
	if (settings["Beth"] && !vars.completedSplits.Contains("Beth") && ((current.PuzzleGroupG & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("Beth");
	}
	if (settings["Guillotine"] && !vars.completedSplits.Contains("Guillotine") && ((current.PuzzleGroupG & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("Guillotine");
	}
	// PuzzleGroupH: Workshop Drawers (7), UFO (3), Jukebox (5), Mastermind (6)
	if (settings["WorkshopDrawers"] && !vars.completedSplits.Contains("WorkshopDrawers") && ((current.PuzzleGroupH & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("WorkshopDrawers");
	}
	if (settings["UFO"] && !vars.completedSplits.Contains("UFO") && ((current.PuzzleGroupH & (1 << 3)) != 0)) {
		return vars.completedSplits.Add("UFO");
	}
	if (settings["Jukebox"] && !vars.completedSplits.Contains("Jukebox") && ((current.PuzzleGroupH & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("Jukebox");
	}
	if (settings["Mastermind"] && !vars.completedSplits.Contains("Mastermind") && ((current.PuzzleGroupH & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("Mastermind");
	}
	// PuzzleGroupI: Clock Chains (5), Anansi (7)
	if (settings["ClockChains"] && !vars.completedSplits.Contains("ClockChains") && ((current.PuzzleGroupI & (1 << 5)) != 0)) {
		return vars.completedSplits.Add("ClockChains");
	}
	if (settings["Anansi"] && !vars.completedSplits.Contains("Anansi") && ((current.PuzzleGroupI & (1 << 7)) != 0)) {
		return vars.completedSplits.Add("Anansi");
	}
	// PuzzleGroupJ: Chinese Solitaire (4), Gallows (6)
	if (settings["Solitaire"] && !vars.completedSplits.Contains("Solitaire") && ((current.PuzzleGroupJ & (1 << 4)) != 0)) {
		return vars.completedSplits.Add("Solitaire");
	}
	if (settings["Gallows"] && !vars.completedSplits.Contains("Gallows") && ((current.PuzzleGroupJ & (1 << 6)) != 0)) {
		return vars.completedSplits.Add("Gallows");
	}
}
