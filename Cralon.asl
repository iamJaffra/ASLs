state("Cralon-Win64-Shipping") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");

	vars.TimerModel = new TimerModel { CurrentState = timer };

	settings.Add("Splits", true, "Splits");
		settings.Add("DemoEnd", true, "End Of Demo Screen", "Splits");
		settings.Add("End", true, "Trigger Ending Cutscene", "Splits");

	vars.SplittableDoors = new Dictionary<string, string> {
		{ "BP_DoorSlidingGate",  "Gate to Morass" },
		{ "BP_DoorSlidingGate5", "Gate to Fortress" },
	};

	settings.Add("DoorSplits", false, "Gates", "Splits");
	foreach (var door in vars.SplittableDoors) {
		var doorName = door.Key;
		var doorDescription = door.Value;
		settings.Add(doorName, true, doorDescription, "DoorSplits");
	}

	settings.Add("Tools", false, "Practice Tools");
		settings.Add("CheatMode", false, "Turn on Cheat Mode", "Tools");
		settings.Add("UnlockDoors", false, "Unlock locked doors by interacting with them", "Tools");
}

init {
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

	vars.Resolver.WatchString("Floor", vars.Utils.GEngine, 0x1248, 0x3A8, 0x0);  // FString CurrentFloor
	vars.Resolver.Watch<double>("X", vars.Utils.GEngine, 0x1248, 0x790 + 0x0);
	vars.Resolver.Watch<double>("Y", vars.Utils.GEngine, 0x1248, 0x790 + 0x8);
	vars.Resolver.Watch<double>("Z", vars.Utils.GEngine, 0x1248, 0x790 + 0x10);
	vars.Resolver.Watch<IntPtr>("CollectedQuestIDsArray", vars.Utils.GEngine, 0x1248, 0x210);
	vars.Resolver.Watch<int>("CollectedQuestIDsNum", vars.Utils.GEngine, 0x1248, 0x210 + 0x8);
	
	IntPtr GameOver = vars.Events.InstancePtr("WG_GameOver_C", "");
	vars.Resolver.Watch<int>("EndOfDemoScreenVisibility", GameOver, 0x378, 0xDC);
	vars.Resolver.Watch<int>("EndOfGameScreenVisibility", GameOver, 0x370, 0xDC);

	IntPtr GameController = vars.Events.InstancePtr("BP_GameController_C", "");
	vars.Resolver.Watch<bool>("IsEndOfDemo", GameController, 0x599);
	vars.Resolver.Watch<bool>("IsVideoPlaying", GameController, 0x7B9);
	vars.Resolver.Watch<bool>("IsDemo", GameController, 0x689);
	vars.Resolver.Watch<bool>("IsCheatMode", GameController, 0x690);
	vars.Resolver.Watch<IntPtr>("GameController", GameController);
	vars.Resolver.Watch<IntPtr>("Door", vars.Events.FunctionParentPtr("BP_Door*", "", ""));
	vars.Resolver.WatchString("DoorName", vars.Events.FunctionParentPtr("BP_Door*", "", ""), 0x2C0, 0x0);
	vars.Resolver.Watch<bool>("DoorOpen", vars.Events.FunctionParentPtr("BP_Door*", "", ""), 0x2F0);

	IntPtr VideoPlayer = vars.Events.InstancePtr("WG_VideoPlay_C", "WG_VideoPlay_C");
	vars.Resolver.WatchString("Video", VideoPlayer, 0x398, 0x98, 0x0);

	vars.Events.FunctionFlag("InitLoadingScreen", "WG_Loading_C", "WG_Loading_C", "OnInitialized");
	vars.Events.FunctionFlag("ReceiveBeginPlay", "BP_Cralon_C", "BP_Cralon_C", "ReceiveBeginPlay");
	vars.Events.FunctionFlag("DestructLoadingScreen", "WG_Loading_C", "WG_Loading_C", "Destruct");
	vars.Events.FunctionFlag("NewGame", "UI_GameMenu_C", "UI_GameMenu_C", "BndEvt__UI_GameMenu_BT_NewGame_K2Node_ComponentBoundEvent_3_OnButtonPressedEvent__DelegateSignature");
	vars.Events.FunctionFlag("DoorInteract", "BP_Door*", "", "");

	vars.BeginPlayFlag = false;
	vars.DestructFlag = false;
	vars.IsLoading = false;

	vars.DoubleEquals = (Func<double, double, bool>)((double1, double2) => {
		return Math.Abs(double1 - double2) < 0.00001;
	});

	vars.Info = (Action<string>)((msg) => {
		print("[Cralon ASL] " + msg);
	});

	vars.StartX = -1768.70838;
	vars.StartY =  1359.74558;
	vars.StartZ =  -106.80690;

	vars.CompletedSplits = new HashSet<string>();
	vars.RunningQuests = new HashSet<string>();
	vars.CompletedQuests = new HashSet<string>();
}

update {
	vars.Uhara.Update();

	// LOAD REMOVAL
	{
		if (!vars.IsLoading) {
			if (vars.Resolver.CheckFlag("InitLoadingScreen")) {
				vars.IsLoading = true;
			}
		}

		if (vars.IsLoading) {
			if (!vars.BeginPlayFlag && vars.Resolver.CheckFlag("ReceiveBeginPlay")) {
				vars.BeginPlayFlag = true;
			}
			if (vars.BeginPlayFlag && !vars.DestructFlag && vars.Resolver.CheckFlag("DestructLoadingScreen")) {
				vars.DestructFlag = true;
			}
			if (vars.BeginPlayFlag && vars.DestructFlag) {
				vars.IsLoading = false;
				vars.BeginPlayFlag = false;
				vars.DestructFlag = false;
			}
		}
	}

	// POS VECTOR
	/*
	if (old.X != current.X || old.Y != current.Y || old.Z != current.Z) {
		vars.Info("Pos -> " + current.X.ToString("0.00000") + " " + current.Y.ToString("0.00000") + " " + current.Z.ToString("0.00000"));
	}
	*/
	
	if (old.IsEndOfDemo != current.IsEndOfDemo) {
		vars.Info("IsEndOfDemo -> " + current.IsEndOfDemo);
	}

	if (old.Floor != current.Floor) {
		vars.Info("Floor -> " + current.Floor);
	}

	if (old.DoorName != current.DoorName) {
		vars.Info("DoorName -> " + current.DoorName);
	}	

	if (old.Video != current.Video) {
		vars.Info("Video -> " + current.Video);
	}


	if (current.IsVideoPlaying) {
		return;
	}

	// QUEST TRACKING
	{
		var questCount = current.CollectedQuestIDsNum;

		for (int i = 0; i < questCount; i++) {
			string quest = new DeepPointer((IntPtr)current.CollectedQuestIDsArray + i * 0x28, 0x0).DerefString(game, 100);
			string status = new DeepPointer((IntPtr)current.CollectedQuestIDsArray + i * 0x28 + 0x10, 0x0).DerefString(game, 100);

			if (status == "Running" && !vars.RunningQuests.Contains(quest)) {
				vars.RunningQuests.Add(quest);
				vars.Info("Started quest: " + quest);
			}

			if (status == "Success" && !vars.CompletedQuests.Contains(quest)) {
				vars.RunningQuests.Remove(quest);
				vars.CompletedQuests.Add(quest);
				vars.Info("Completed quest: " + quest);
			}
		}
	}

	// ENABLING CHEAT MODE
	if (settings["CheatMode"] && current.GameController != IntPtr.Zero) {
		if (!current.IsCheatMode) {
			game.WriteBytes((IntPtr)current.GameController + 0x690, new byte[] { 1 });
			vars.Info("Activated Cheat Mode!");
		}
		/*
		if (current.IsDemo) {
			game.WriteBytes((IntPtr)current.GameController + 0x689, new byte[] { 0 });
			vars.Info("Set IsDemo? To False.");
		}
		*/
	}

	// UNLOCK DOORS
	if (settings["UnlockDoors"] && vars.Resolver.CheckFlag("DoorInteract")) {
		if (new DeepPointer((IntPtr)current.Door + 0x329).Deref<bool>(game)) {
			game.WriteBytes((IntPtr)current.Door + 0x329, new byte[] { 0 });
			vars.Info("Unlocked door!");
		}
	}
}

isLoading {
	return vars.IsLoading;
}

reset {
	//return vars.Resolver.CheckFlag("NewGame");
	return false;
}

start {
	if (current.IsDemo) {
		if (old.IsVideoPlaying && !current.IsVideoPlaying) {
			return true;
		}
		if (current.IsVideoPlaying) {
			if (vars.DoubleEquals(old.X, vars.StartX) && vars.DoubleEquals(old.Y, vars.StartY) && vars.DoubleEquals(old.Z, vars.StartZ)) {
				if (!vars.DoubleEquals(current.X, vars.StartX) || !vars.DoubleEquals(current.Y, vars.StartY) || !vars.DoubleEquals(current.Z, vars.StartZ)) {
					return true;
				}
			}
		}	
	}
	else {
		return vars.Resolver.CheckFlag("NewGame");
	}
}

onStart {
	vars.CompletedSplits.Clear();
	vars.RunningQuests.Clear();
	vars.CompletedQuests.Clear();
}

split {
	if (settings["DemoEnd"] && current.IsEndOfDemo && old.EndOfDemoScreenVisibility == 2 && current.EndOfDemoScreenVisibility == 0) {
		return true;
	}

	if (vars.Resolver.CheckFlag("DoorInteract")) {
		if (!old.DoorOpen && current.DoorOpen) {
			string name = current.DoorName;
			if (vars.SplittableDoors.ContainsKey(name) && settings[name] && !vars.CompletedSplits.Contains(name)) {
				vars.CompletedSplits.Add(name);
				vars.Info("Split: Opened door '" + name + "'");
				return true;
			}
		}
	}

	if (settings["End"] && current.IsVideoPlaying && !vars.CompletedSplits.Contains("End")) {
		if (current.Video == "Movies/V_Outro_Bad.bk2" || current.Video == "Movies/V_Outro_Good.bk2") {
			vars.CompletedSplits.Add("End");
			vars.Info("Split: Triggered Ending");
			return true;
		}
	}
}

exit {
	var phase = timer.CurrentPhase;
	bool reset = settings.ResetEnabled;

	if (phase == TimerPhase.Running && reset) {
		vars.TimerModel.Reset();
	}
}