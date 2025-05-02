state("Hypogea") {}

startup {
    settings.Add("Start", true, "Start timer after intro cutscene");
    settings.Add("Splits", true, "Splits");
        settings.Add("FinishTutorial", true, "Get out of tutorial area", "Splits");
        settings.Add("Crane", true, "Activate crane", "Splits");
        settings.Add("Elevator", true, "Take elevator", "Splits");
        settings.Add("End", true, "Pull final lever", "Splits");
    settings.Add("Reset", true, "Reset timer on main menu");
}

init {
	var PlayerControllerTrg = new SigScanTarget(11, "89 04 24 39 00 E8 ???????? B8 ???????? 89 38 8D 65 FC 8D 65 FC 5F C9 C3");
    var CameraControllerTrg = new SigScanTarget(11, "55 8B EC 57 83 EC 44 8B 7D 08 B8 ???????? 89 38 8B 47 18 89 04 24 39 00 8B C0");
    var SaveManagerTrg = new SigScanTarget(11, "55 8B EC 57 83 EC 24 8B 7D 08 B8 ???????? 89 38 89 3C 24 8D 6D 00 E8 ???????? 8B 47 0C 85 C0 74 0B 8B 47 0C 0F B6 40 18 85 C0 74 0E 8B 47 1C 89 04 24 39 00");
    
    vars.scan = new Func<SigScanTarget, Process, IntPtr>((target, g) => {
        IntPtr ptr = IntPtr.Zero;
        foreach (var page in g.MemoryPages()) {
            var scanner = new SignatureScanner(g, page.BaseAddress, (int)page.RegionSize);

            if (ptr == IntPtr.Zero) {
                ptr = scanner.Scan(target);
            }
            if (ptr != IntPtr.Zero) {
                return (IntPtr) BitConverter.ToInt32(game.ReadBytes(ptr, 4), 0);
            }
        }
        throw new InvalidOperationException("Couldn't find signature! Trying again.");
    });

    IntPtr PlayerControllerPtr = vars.scan(PlayerControllerTrg, game);
    IntPtr CameraControllerPtr = vars.scan(CameraControllerTrg, game);
    IntPtr SaveManagerPtr = vars.scan(SaveManagerTrg, game);

    vars.Watchers = new MemoryWatcherList {
		new MemoryWatcher<int>(new DeepPointer(PlayerControllerPtr, 0x240)) { Name = "BatteryCount" },
        new MemoryWatcher<int>(new DeepPointer(PlayerControllerPtr, 0x1E4)) { Name = "TraversalState" },

        new MemoryWatcher<int>(new DeepPointer(CameraControllerPtr, 0x20)) { Name = "SequencePlayer" },

        new MemoryWatcher<bool>(new DeepPointer(SaveManagerPtr, 0x20)) { Name = "IsMenuScene" },
	};

    vars.CheckForID = (Func<string, bool>)((id) => {
        // SaveManager.savedElementsIDs._size
        var _size = new DeepPointer(SaveManagerPtr, 0x14, 0xC).Deref<int>(game);

        for (int i = 0; i < _size; i++) {
            // SaveManager.savedElementsIDs._items[i].m_firstChar
            var item = new DeepPointer(SaveManagerPtr, 0x14, 0x8, 0x10 + i * 0x4, 0xC).DerefString(game, 100);

            if (item == id) {
                return true;
            }
        }
        return false;
    });
    
    vars.completedSplits = new HashSet<string>();
}

update {
    vars.Watchers.UpdateAll(game);
}

start {
    if (settings["Start"] && vars.Watchers["TraversalState"].Current == 13 && vars.Watchers["SequencePlayer"].Current == 0 && vars.Watchers["SequencePlayer"].Changed) {
        return true;
    }
}
onStart {
    vars.completedSplits.Clear();
}

split {
    // Get out of tutorial area
    if (settings["FinishTutorial"] && !vars.completedSplits.Contains("IntroEndDoorWaitTrigger|1") && vars.CheckForID("IntroEndDoorWaitTrigger|1")) {
        vars.completedSplits.Add("IntroEndDoorWaitTrigger|1");
        return true;
    }

    // Activate crane
    if (settings["Crane"] && !vars.completedSplits.Contains("cranePullLever|1") && vars.CheckForID("cranePullLever|1")) {
        vars.completedSplits.Add("cranePullLever|1");
        return true;
    }

    // Take elevator
    if (settings["Elevator"] && !vars.completedSplits.Contains("CraneMainHub|-1") && vars.CheckForID("CraneMainHub|-1")) {
        vars.completedSplits.Add("CraneMainHub|-1");
        return true;
    }

    // End split
    // Currently, this doesn't check whether the barred door has been unlocked first because I couldn't find a way to check for that
    if (settings["End"] && vars.Watchers["TraversalState"].Current == 11 && vars.Watchers["TraversalState"].Changed) {
        return true;
    }
}

reset {
    if (settings["Reset"] && vars.Watchers["IsMenuScene"].Current && vars.Watchers["IsMenuScene"].Changed) {
        return true;
    }
}