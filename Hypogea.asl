state("Hypogea") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;
	vars.Helper.AlertLoadless();

	settings.Add("Start", true, "Start timer after intro cutscene");

	settings.Add("Splits", true, "Splits");
		settings.Add("Levels", true, "Split on every level change.", "Splits");
		settings.Add("End", true, "Split on losing control to the ending cutscene.", "Splits");

	settings.Add("Events", true, "Event-based Sub Splits");
		settings.Add("Chapter1", true, "Chapter 1", "Events");
			settings.Add("FinishTutorial", false, "Get out of the Tutorial Area", "Chapter1");
			settings.Add("Crane", false, "Activate the Crane", "Chapter1");
		settings.Add("Chapter6", true, "Chapter 6", "Events");
			settings.Add("Gauntlet1", false, "Finish Section 1 of the Gauntlet", "Chapter6");
			settings.Add("Gauntlet2", false, "Finish Section 2 of the Gauntlet", "Chapter6");

	settings.Add("Reset", true, "Reset timer on main menu");

	vars.Info = (Action<string>)((msg) => {
		print("[Hypogea ASL] " + msg);
	});
}

init {
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
		vars.Helper["traversalState"] = mono.Make<int>("PlayerController", "pc", "currState");
		vars.Helper["batteryCount"] = mono.Make<int>("PlayerController", "pc", "batteryCount");
		vars.Helper["sequencePlayer"] = mono.Make<int>("CameraController", "cc", "currentSequence");
		vars.Helper["sequenceDuration"] = mono.Make<float>("CameraController", "cc", "currentSequence", "sequenceDuration");
		vars.Helper["isMenuScene"] = mono.Make<bool>("SaveManager", "sm", "isMenuScene");
		vars.Helper["savedElementsIDs"] = mono.Make<IntPtr>("SaveManager", "sm", "savedElementsIDs");
		vars.Helper["canControl"] = mono.Make<bool>("CameraController", "cc", "canControl");
		vars.Helper["isLoading"] = mono.Make<float>("SceneLoadManager", "slm", "loadingBar", "m_FillAmount");
		return true;
	});

	vars.CheckForID = (Func<string, bool>)((id) => {
		// SaveManager.savedElementsIDs._size
		var _size = new DeepPointer(current.savedElementsIDs + 0xC).Deref<int>(game);

		for (int i = 0; i < _size; i++) {
			// SaveManager.savedElementsIDs._items[i].m_firstChar
			var item = new DeepPointer(current.savedElementsIDs + 0x8, 0x10 + i * 0x4, 0xC).DerefString(game, 100);

			if (item == id) {
				return true;
			}
		}
		return false;
	});
	
	vars.Equals = (Func<float, float, bool>)((f1, f2) => {
		return (Math.Abs(f1 - f2) < 0.001f);
	});

	vars.completedSplits = new HashSet<string>();
	vars.isLoading = false;
}

update {
	
	// SaveManager.savedElementsIDs._size
	current.numberOfEvents = game.ReadValue<int>((IntPtr)current.savedElementsIDs + 0xC);
	
	/*
	// DEBUG PRINTS FOR FINDING EVENT IDS
	if (current.numberOfEvents != old.numberOfEvents) {
		// SaveManager.savedElementsIDs._size
		var _size = new DeepPointer(current.savedElementsIDs + 0xC).Deref<int>(game);

		for (int i = 0; i < _size; i++) {
			// SaveManager.savedElementsIDs._items[i].m_firstChar
			var item = new DeepPointer(current.savedElementsIDs + 0x8, 0x10 + i * 0x4, 0xC).DerefString(game, 100);

			vars.Info(item);
		}
	}
	*/

	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? current.loadingScene;

	if (old.activeScene != current.activeScene) {
		vars.Info("activeScene: " + old.activeScene + " -> " + current.activeScene);
		vars.isLoading = false;
	}
	if (old.loadingScene != current.loadingScene) {
		vars.Info("loadingScene: " + old.loadingScene + " -> " + current.loadingScene);
		vars.isLoading = true;
	}

	
	if (old.sequenceDuration != current.sequenceDuration) {
		vars.Log("sequenceDuration: " + old.sequenceDuration + " -> " + current.sequenceDuration);
		//vars.Log("currentSequence = " + current.sequencePlayer.ToString("X"));

	}
	/*
	if (old.traversalState != current.traversalState) {
		vars.Log("traversalState: " + old.traversalState + " -> " + current.traversalState);
		//vars.Log("currentSequence = " + current.sequencePlayer.ToString("X"));

	}
	
	if (old.canControl != current.canControl) {
		vars.Log("canControl: " + old.canControl + " -> " + current.canControl);
	}
	*/
}

reset {
	if (settings["Reset"] && current.isMenuScene && !old.isMenuScene) {
		return true;
	}
}

start {
	if (settings["Start"] && current.traversalState == 13 && current.sequencePlayer == 0 && old.sequencePlayer != 0) {
		return true;
	}
}

onStart {
	vars.completedSplits.Clear();
}

split {
	// Event-based splits
	// Only check when a new event has occured
	
	if (current.numberOfEvents != old.numberOfEvents) {
		// Get out of tutorial area
		if (settings["FinishTutorial"] && !vars.completedSplits.Contains("FinishTutorial") && current.activeScene == "Tutorial" && vars.CheckForID("IntroEndDoorWaitTrigger|1")) {
			vars.completedSplits.Add("FinishTutorial");
			vars.Info("Split: FinishTutorial.");
			return true;
		}
		// Activate crane
		if (settings["Crane"] && !vars.completedSplits.Contains("Crane") && current.activeScene == "Tutorial"  && vars.CheckForID("cranePullLever|1")) {
			vars.completedSplits.Add("Crane");
			vars.Info("Split: Crane.");
			return true;
		}

		// L1PistonmanagerTrigger|1
		// tankBotSetup|1
	}

	// Chapter 6
	if (settings["Gauntlet1"] && !vars.completedSplits.Contains("Gauntlet1") && current.activeScene == "EndGauntlet" && vars.Equals(current.sequenceDuration, 7.0f)) {
		vars.completedSplits.Add("Gauntlet1");
		vars.Info("Split: Gauntlet1.");
		return true;
	}
	if (settings["Gauntlet2"] && !vars.completedSplits.Contains("Gauntlet2") && current.activeScene == "EndGauntlet" && vars.Equals(current.sequenceDuration, 6.216f)) {
		vars.completedSplits.Add("Gauntlet2");
		vars.Info("Split: Gauntlet2.");
		return true;
	}

	if (settings["Levels"] && current.loadingScene != old.loadingScene && current.loadingScene != "MainMenu" && old.loadingScene != "MainMenu") {
		vars.Info("Split on level change.");
		return true;
	}
	
	// Ending cutscene // 130.316
	if (settings["End"] && current.activeScene == "EndLevel" && !current.canControl && 
		current.sequenceDuration > 120.0f && !vars.completedSplits.Contains("End")) {
		vars.Info("Split on ending sequence.");
		vars.completedSplits.Add("End");
		return true;
	}
	
}

isLoading {
	//return vars.isLoading;
	return current.isLoading != 1.0f;
}