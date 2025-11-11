state("Hypogea") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;

	settings.Add("Start", true, "Start timer after intro cutscene");
	settings.Add("Splits", true, "Splits");
		//settings.Add("FinishTutorial", true, "Get out of tutorial area", "Splits");
		//settings.Add("Crane", true, "Activate crane", "Splits");
		//settings.Add("Elevator", true, "Take elevator", "Splits");
		//settings.Add("End", true, "Pull final lever", "Splits");
		settings.Add("Levels", true, "Split on every level change.", "Splits");
		settings.Add("End", true, "Split on losing control to the ending cutscene.", "Splits");
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
		vars.Helper["isMenuScene"] = mono.Make<bool>("SaveManager", "sm", "isMenuScene");
		vars.Helper["savedElementsIDs"] = mono.Make<IntPtr>("SaveManager", "sm", "savedElementsIDs");

		vars.Helper["canControl"] = mono.Make<bool>("CameraController", "cc", "canControl");
		
		//vars.Helper["isLoading"] = mono.Make<float>("SceneLoadManager", "slm", "target");
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
		vars.Log("activeScene: " + old.activeScene + " -> " + current.activeScene);
		vars.isLoading = false;
	}
	if (old.loadingScene != current.loadingScene) {
		vars.Log("loadingScene: " + old.loadingScene + " -> " + current.loadingScene);
		vars.isLoading = true;
	}

	/*
	if (old.traversalState != current.traversalState) {
		vars.Log("traversalState: " + old.traversalState + " -> " + current.traversalState);
		vars.Log("currentSequence = " + current.sequencePlayer.ToString("X"));

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
	/*
	if (current.numberOfEvents != old.numberOfEvents) {
		// Get out of tutorial area
		if (settings["FinishTutorial"] && !vars.completedSplits.Contains("FinishTutorial") && vars.CheckForID("IntroEndDoorWaitTrigger|1")) {
			vars.completedSplits.Add("FinishTutorial");
			return true;
		}
		// Activate crane
		if (settings["Crane"] && !vars.completedSplits.Contains("Crane") && vars.CheckForID("cranePullLever|1")) {
			vars.completedSplits.Add("Crane");
			return true;
		}
		// Take elevator
		if (settings["Elevator"] && !vars.completedSplits.Contains("Elevator") && vars.CheckForID("CraneMainHub|-1")) {
			vars.completedSplits.Add("Elevator");
			return true;
		}

		// Take elevator
		if (settings["HubCranePoint"] && !vars.completedSplits.Contains("HubCranePoint") && vars.CheckForID("HubCranePointInside|1")) {
			vars.completedSplits.Add("HubCranePoint");
			return true;
		}

		// L1PistonmanagerTrigger|1
		// tankBotSetup|1
	}
	*/

	if (settings["Levels"] && current.loadingScene != old.loadingScene && current.loadingScene != "MainMenu" && old.loadingScene != "MainMenu") {
		vars.Info("Split on level change.");
		return true;
	}
	
	// End split
	// Split on losing control of the camera
	if (settings["End"] && current.activeScene == "EndLevel" && current.traversalState == 18 && 
		old.canControl && !current.canControl && !vars.completedSplits.Contains("End")) {
		vars.completedSplits.Add("End");
		return true;
	}
}

isLoading {
	//return vars.isLoading;
	return current.isLoading != 1.0f;
}