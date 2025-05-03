state("Hypogea") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");

	settings.Add("Start", true, "Start timer after intro cutscene");
	settings.Add("Splits", true, "Splits");
		settings.Add("FinishTutorial", true, "Get out of tutorial area", "Splits");
		settings.Add("Crane", true, "Activate crane", "Splits");
		settings.Add("Elevator", true, "Take elevator", "Splits");
		settings.Add("End", true, "Pull final lever", "Splits");
	settings.Add("Reset", true, "Reset timer on main menu");
}

init {
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
		vars.Helper["traversalState"] = mono.Make<int>("PlayerController", "pc", "currState");
		vars.Helper["batteryCount"] = mono.Make<int>("PlayerController", "pc", "batteryCount");
		vars.Helper["sequencePlayer"] = mono.Make<int>("CameraController", "cc", "currentSequence");
		vars.Helper["isMenuScene"] = mono.Make<bool>("SaveManager", "sm", "isMenuScene");
		vars.Helper["savedElementsIDs"] = mono.Make<IntPtr>("SaveManager", "sm", "savedElementsIDs");
		
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
}

update {
	// SaveManager.savedElementsIDs._size
	current.numberOfEvents = game.ReadValue<int>((IntPtr)current.savedElementsIDs + 0xC);
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
	}
	// End split
	// Currently, this doesn't check whether the barred door has been unlocked first because I couldn't find a way to check for that
	if (settings["End"] && current.traversalState == 11 && old.traversalState != 11) {
		return true;
	}
}

reset {
	if (settings["Reset"] && current.isMenuScene && !old.isMenuScene) {
		return true;
	}
}
