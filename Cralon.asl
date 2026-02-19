state("Cralon-Win64-Shipping") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
	vars.Uhara.EnableDebug();
}

init {
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

	vars.Resolver.WatchString("Floor", vars.Utils.GEngine, 0x1248, 0x3A8, 0x0);

	IntPtr GameOver = vars.Events.InstancePtr("WG_GameOver_C", "");
	vars.Resolver.Watch<int>("EndOfDemoScreenVisibility", GameOver, 0x378, 0xDC);

	IntPtr GameController = vars.Events.InstancePtr("BP_GameController_C", "");
	vars.Resolver.Watch<bool>("IsIntroPlaying", GameController, 0x7B9);

	vars.Events.FunctionFlag("InitLoadingScreen", "WG_Loading_C","WG_Loading_C","OnInitialized");
	vars.Events.FunctionFlag("ReceiveBeginPlay", "BP_Cralon_C", "BP_Cralon_C", "ReceiveBeginPlay");
	vars.Events.FunctionFlag("DestructLoadingScreen", "WG_Loading_C", "WG_Loading_C", "Destruct");
	vars.Events.FunctionFlag("NewGame", "UI_GameMenu_C", "UI_GameMenu_C", "BndEvt__UI_GameMenu_BT_NewGame_K2Node_ComponentBoundEvent_3_OnButtonPressedEvent__DelegateSignature");

	vars.BeginPlayFlag = false;
	vars.DestructFlag = false;
	vars.IsLoading = false;

	vars.CompletedSplits = new HashSet<string>();
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

}

isLoading {
	return vars.IsLoading;
}

reset {
	return vars.Resolver.CheckFlag("NewGame");
}

start {
	return old.IsIntroPlaying && !current.IsIntroPlaying;
}

onStart {
	vars.CompletedSplits.Clear();
}

split {
	if (old.EndOfDemoScreenVisibility == 2 && current.EndOfDemoScreenVisibility == 0) {
		return true;
	}
}