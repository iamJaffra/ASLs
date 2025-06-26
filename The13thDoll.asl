state("The13thDoll") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

	vars.Helper.LoadSceneManager = true;

	settings.Add("Richmond", false, "Richmond");
		settings.Add("Files",         true, "Files",                  "Richmond");
		settings.Add("Office",        true, "Nurse's Office",         "Richmond");
		settings.Add("Window",        true, "Window",                 "Richmond");
		settings.Add("Piano",         true, "Piano",                  "Richmond");
		settings.Add("Phone",         true, "Phone",                  "Richmond");
		settings.Add("Cake",          true, "Cake",                   "Richmond");
		settings.Add("Fireplace",     true, "Fireplace",              "Richmond");
		settings.Add("Scale",         true, "Scale",                  "Richmond");
		settings.Add("Clock",         true, "Clock",                  "Richmond");
		settings.Add("Typewriter",    true, "Typewriter",             "Richmond");
		settings.Add("Bathtub",       true, "Bathtub",                "Richmond");
		settings.Add("Picross",       true, "Picross",                "Richmond");
		settings.Add("MACHINEBUILT",  true, "Assembled Machine",      "Richmond");
		settings.Add("Door",          true, "Door in Dutton's Room",  "Richmond");

	settings.Add("Tad", false, "Tad");
		settings.Add("THREELETTERS",  true, "Three Letters",          "Tad");
		settings.Add("CEMETERY",      true, "Swords and Shields",     "Tad");
		settings.Add("KNIGHTSWITCH",  true, "Knight Switch",          "Tad");
		settings.Add("RAYOFLIGHT",    true, "Ray Of Light",           "Tad");
		settings.Add("SPIDER",        true, "Spider",                 "Tad");
		settings.Add("MAZE",          true, "Maze",                   "Tad");
		settings.Add("CRYPTTILT",     true, "Crypt Tilt",             "Tad");
		settings.Add("SUICIDEQUEENS", true, "Suicide Queens",         "Tad");
		settings.Add("KNOXPATHPUZ",   true, "Knox Path Puzzle",       "Tad");
		settings.Add("NUMBEREDROUTE", true, "Numbered Route (Cards)", "Tad");
		settings.Add("COINSTACKS",    true, "Coin Stacks",            "Tad");
		settings.Add("NUCLEUSDUTTON", true, "Nucleus (Dutton)",       "Tad");
		settings.Add("PIANOCHAPEL",   true, "Piano (Chapel)",         "Tad");
		settings.Add("HEX",           true, "Hex",                    "Tad");
		settings.Add("HANDSPUZZLE",   true, "Dollar",                 "Tad");

	settings.Add("End", true, "Beat the game");
}

init {
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>	{
		vars.Helper["controlWord"] = mono.MakeString("ControlWordScript", "ControlWord");
		
		return true;
	});

	vars.compareControlWords = (Action<string, string>)((oldStr, currentStr) => {
		for (int i = 0; i < Math.Min(oldStr.Length, currentStr.Length); i++) {
			if (oldStr[i] != currentStr[i])	{
				vars.Log("ControlWord[" + i + "]: " + oldStr[i] + " -> " + currentStr[i]);
			}
		}
	});

	vars.ChangedState = (Func<string, string, int, int, int, bool>)((oldStr, newStr, index, oldValue, currentValue) => {
		return oldStr[index] == oldValue.ToString()[0] && newStr[index] == currentValue.ToString()[0];
	});

	vars.isLoading = false;
}

update {
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

	if (old.activeScene != current.activeScene) {
		vars.Log("activeScene: " + old.activeScene + " -> " + current.activeScene);
		vars.isLoading = false;
	}

	if (old.loadingScene != current.loadingScene) {
		vars.Log("loadingScene: " + old.loadingScene + " -> " + current.loadingScene);
		vars.isLoading = true;
	}

	if (old.controlWord != current.controlWord) {
		vars.compareControlWords(old.controlWord, current.controlWord);
	}
}

reset {
	if (current.activeScene == "Menu" && old.activeScene != "Menu") {
		return true;
	}
}

start {
	if (current.activeScene == "IntroChoosePlayer" && old.controlWord != current.controlWord) {
		var o = old.controlWord;
		var c = current.controlWord;

		if (vars.ChangedState(o, c, 1, 0, 1)) {
			vars.Log("Started New Game with Richmond.");
			return true;
		}
		else if (vars.ChangedState(o, c, 2, 0, 1)) {
			vars.Log("Started New Game with Tad.");
			return true;
		}
	}
}

split {
	var o = old.controlWord;
	var c = current.controlWord;

	// Final Split
	if ((old.activeScene == "EndingChooseKillTadOrStauf" || old.activeScene == "EndingChooseWindowOrWIW") && current.activeScene == "Loading") {
		return true;
	}

#region Richmond Splits
	// Files
	else if (settings["Files"] && vars.ChangedState(o, c, 4, 1, 9)) {
		return true;
	} 
	// Nurse's Office
	else if (settings["Office"] && vars.ChangedState(o, c, 5, 1, 9)) {
		return true;
	} 
	// Window
	else if (settings["Window"] && vars.ChangedState(o, c, 6, 1, 9)) {
		return true;
	} 
	// Piano
	else if (settings["Piano"] && vars.ChangedState(o, c, 7, 1, 9)) {
		return true;
	} 
	// Phone
	else if (settings["Phone"] && vars.ChangedState(o, c, 8, 1, 9)) {
		return true;
	}
	// Cake
	else if (settings["Cake"] && vars.ChangedState(o, c, 9, 1, 9)) {
		return true;
	}
	// Fireplace
	else if (settings["Fireplace"] && vars.ChangedState(o, c, 10, 1, 9)) {
		return true;
	}
	// Scale
	else if (settings["Scale"] && vars.ChangedState(o, c, 11, 1, 9)) {
		return true;
	}
	// Clock
	else if (settings["Clock"] && vars.ChangedState(o, c, 12, 1, 9)) {
		return true;
	}
	// Typewriter
	else if (settings["Typewriter"] && vars.ChangedState(o, c, 13, 1, 9)) {
		return true;
	}
	// Bathtub
	else if (settings["Bathtub"] && vars.ChangedState(o, c, 14, 1, 9)) {
		return true;
	}
	// Picross
	else if (settings["Picross"] && vars.ChangedState(o, c, 15, 1, 9)) {
		return true;
	}
	// Assembled Machine
	else if (settings["MACHINEBUILT"] && vars.ChangedState(o, c, 76, 0, 1)) {
		return true;
	}
	// Door (TRIPLETSDUTTON)
	else if (settings["Door"] && vars.ChangedState(o, c, 16, 1, 9)) {
		return true;
	}
#endregion

#region Tad Splits
	// THREELETTERS
	else if (settings["THREELETTERS"] && vars.ChangedState(o, c, 17, 1, 9)) {
		return true;
	}
	// CEMETERY (Swords and Shields)
	else if (settings["CEMETERY"] && vars.ChangedState(o, c, 18, 1, 9)) {
		return true;
	}
	// KNIGHTSWITCH
	else if (settings["KNIGHTSWITCH"] && vars.ChangedState(o, c, 19, 1, 9)) {
		return true;
	}
	// RAYOFLIGHT
	else if (settings["RAYOFLIGHT"] && vars.ChangedState(o, c, 20, 1, 9)) {
		return true;
	}
	// SPIDER
	else if (settings["SPIDER"] && vars.ChangedState(o, c, 21, 1, 9)) {
		return true;
	}
	// MAZE
	else if (settings["MAZE"] && vars.ChangedState(o, c, 42, 1, 9)) {
		return true;
	}
	// CRYPTTILT
	else if (settings["CRYPTTILT"] && vars.ChangedState(o, c, 22, 1, 9)) {
		return true;
	}
	// SUICIDEQUEENS
	else if (settings["SUICIDEQUEENS"] && vars.ChangedState(o, c, 23, 1, 9)) {
		return true;
	}
	// KNOXPATHPUZ
	else if (settings["KNOXPATHPUZ"] && vars.ChangedState(o, c, 24, 1, 9)) {
		return true;
	}
	// NUMBEREDROUTE
	else if (settings["NUMBEREDROUTE"] && vars.ChangedState(o, c, 25, 1, 9)) {
		return true;
	}
	// COINSTACKS
	else if (settings["COINSTACKS"] && vars.ChangedState(o, c, 26, 1, 9)) {
		return true;
	}
	// NUCLEUSDUTTON
	else if (settings["NUCLEUSDUTTON"] && vars.ChangedState(o, c, 27, 1, 9)) {
		return true;
	}
	// PIANOCHAPEL
	else if (settings["PIANOCHAPEL"] && vars.ChangedState(o, c, 28, 1, 9)) {
		return true;
	}
	// HEX
	else if (settings["HEX"] && vars.ChangedState(o, c, 29, 1, 9)) {
		return true;
	}
	// HANDSPUZZLE
	else if (settings["HANDSPUZZLE"] && vars.ChangedState(o, c, 30, 1, 9)) {
		return true;
	}
#endregion
}

isLoading {
	return vars.isLoading;
}