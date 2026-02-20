state("Cralon-Win64-Shipping") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.Uhara.EnableDebug();

	vars.TimerModel = new TimerModel { CurrentState = timer };

	settings.Add("Splits", true, "Splits");
		settings.Add("DemoEnd", true, "End Of Demo Screen", "Splits");
}

init {
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

	vars.Resolver.WatchString("Floor", vars.Utils.GEngine, 0x1248, 0x3A8, 0x0);
	vars.Resolver.Watch<double>("X", vars.Utils.GEngine, 0x1248, 0x790 + 0x0);
	vars.Resolver.Watch<double>("Y", vars.Utils.GEngine, 0x1248, 0x790 + 0x8);
	vars.Resolver.Watch<double>("Z", vars.Utils.GEngine, 0x1248, 0x790 + 0x10);
	
	IntPtr GameOver = vars.Events.InstancePtr("WG_GameOver_C", "");
	vars.Resolver.Watch<int>("EndOfDemoScreenVisibility", GameOver, 0x378, 0xDC);

	IntPtr GameController = vars.Events.InstancePtr("BP_GameController_C", "");
	vars.Resolver.Watch<bool>("IsEndOfDemo", GameController, 0x599);
	vars.Resolver.Watch<bool>("IsIntroPlaying", GameController, 0x7B9);
	
	vars.Events.FunctionFlag("InitLoadingScreen", "WG_Loading_C","WG_Loading_C","OnInitialized");
	vars.Events.FunctionFlag("ReceiveBeginPlay", "BP_Cralon_C", "BP_Cralon_C", "ReceiveBeginPlay");
	vars.Events.FunctionFlag("DestructLoadingScreen", "WG_Loading_C", "WG_Loading_C", "Destruct");
	vars.Events.FunctionFlag("NewGame", "UI_GameMenu_C", "UI_GameMenu_C", "BndEvt__UI_GameMenu_BT_NewGame_K2Node_ComponentBoundEvent_3_OnButtonPressedEvent__DelegateSignature");

	vars.BeginPlayFlag = false;
	vars.DestructFlag = false;
	vars.IsLoading = false;

	vars.CompletedSplits = new HashSet<string>();

	vars.DoubleEquals = (Func<double, double, bool>)((double1, double2) => {
		return Math.Abs(double1 - double2) < 0.00001;
	});

	vars.StartX = -1768.70838;
	vars.StartY =  1359.74558;
	vars.StartZ =  -106.80690;
}

update {
	vars.Uhara.Update();

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

	/*
	if (old.X != current.X || old.Y != current.Y || old.Z != current.Z) {
		print("pos -> " + current.X.ToString("0.00000") + " " + current.Y.ToString("0.00000") + " " + current.Z.ToString("0.00000"));
	}
	*/
}

isLoading {
	return vars.IsLoading;
}

reset {
	//return vars.Resolver.CheckFlag("NewGame");
	return false;
}

start {
	if (old.IsIntroPlaying && !current.IsIntroPlaying) {
		return true;
	}
	if (current.IsIntroPlaying) {
		if (vars.DoubleEquals(old.X, vars.StartX) && vars.DoubleEquals(old.Y, vars.StartY) && vars.DoubleEquals(old.Z, vars.StartZ)) {
			if (!vars.DoubleEquals(current.X, vars.StartX) || !vars.DoubleEquals(current.Y, vars.StartY) || !vars.DoubleEquals(current.Z, vars.StartZ)) {
				return true;
			}
		}
	}
}

onStart {
	vars.CompletedSplits.Clear();
}

split {
	if (settings["DemoEnd"] && current.IsEndOfDemo && old.EndOfDemoScreenVisibility == 2 && current.EndOfDemoScreenVisibility == 0) {
		return true;
	}
}

exit {
	var phase = timer.CurrentPhase;
	bool reset = settings.ResetEnabled;

	if (phase == TimerPhase.Running && reset) {
		vars.TimerModel.Reset();
	}
}