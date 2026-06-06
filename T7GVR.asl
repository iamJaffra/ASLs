state("The7thGuestVR-Win64-Shipping") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");

	vars.TimerModel = new TimerModel { CurrentState = timer };

	vars.Rooms = new Dictionary<string, int> {
		{ "Outside" ,     18 }, 
		{ "Foyer",        1 }, 
		{ "DiningRoom",   3 }, 
		{ "Temple",       13 }, 
		{ "Heine",        10 }, 
		{ "Dutton",       9 }, 
		{ "Knox",         11 }, 
		{ "Library",      2 }, 
		{ "Kitchen",      6 }, 
		{ "Burden",       8 }, 
		{ "GameRoom",     14 }, 
		{ "Nursery",      12 }, 
		{ "MusicRoom",    4 }, 
		{ "Attic",        16 }, 
		{ "Workroom",     21 }, 
		{ "Bathroom",     7 }, 
		{ "Chapel",       19 }, 
		{ "StaufBedroom", 20 }, 
		{ "RitualRoom",   17 }, 
	};
	
	vars.Splits = new List<Tuple<string, string, int, string>> {
		//           name,                type,      room,                     className
		Tuple.Create("EnterMansion",      "mansion", -1,                       ""),
		Tuple.Create("CakeCover",         "puzzle",  vars.Rooms["DiningRoom"], "BP_DiningRoomCakeCover_C"),
		Tuple.Create("DisappearanceBox",  "puzzle",  vars.Rooms["Temple"],     "BP_TE_DisappearanceBox_C"),
		Tuple.Create("BrokenMirror",      "puzzle",  vars.Rooms["Heine"],      "BP_HE_Mirror_C"),
		Tuple.Create("SecretSafe",        "puzzle",  vars.Rooms["Dutton"],     "BP_MarbleSafe_C"),
		Tuple.Create("ToyBlocks",         "puzzle",  vars.Rooms["Knox"],       "BP_Knox_PuzzleBlock_C"),
		Tuple.Create("MovingBookcases",   "puzzle",  vars.Rooms["Library"],    "BP_LibraryManager_C"),
		Tuple.Create("StaufSoup",         "puzzle",  vars.Rooms["Kitchen"],    "BP_KI_Kettle_C"),
		Tuple.Create("MovingMannequins",  "puzzle",  vars.Rooms["Burden"],     "BP_BU_MannequinManager_C"),
		Tuple.Create("QueensOnBoard",     "puzzle",  vars.Rooms["GameRoom"],   "BP_GA_Chesstable_C"),
		Tuple.Create("TeaPartyOfDoom",    "puzzle",  vars.Rooms["Nursery"],    "BP_NU_Teaparty_C"),
		Tuple.Create("TheKnightsJourney", "puzzle",  vars.Rooms["MusicRoom"],  "BP_MR_MusicBox_C"),
		Tuple.Create("HexagramAltar",     "puzzle",  vars.Rooms["Workroom"],   "BP_WO_SealofSolomon_C"),
		Tuple.Create("RoachCabinet",      "puzzle",  vars.Rooms["Bathroom"],   "BP_BA_Cabinet_C"),
		Tuple.Create("CrimeScenes",       "puzzle",  vars.Rooms["Attic"],      "BP_AT_ModelHouse_C"),
		Tuple.Create("ShadowPlay",        "puzzle",  vars.Rooms["Chapel"],     "BP_CH_Altar_C"),
		Tuple.Create("TadsDoll",          "puzzle",  vars.Rooms["RitualRoom"], "BP_TadDollFace_C"),
	};

	settings.Add("Reset", true, "Reset");
		settings.Add("ResetMainMenu", true, "Reset on returning to the main menu", "Reset");
		settings.Add("ResetExit", true, "Reset on closing the game", "Reset");

	settings.Add("Splits", true, "Splits");
	foreach (var split in vars.Splits) {
		string splitName = split.Item1;

		string roomName = "";
		foreach (var room in vars.Rooms) {
			if (room.Value == split.Item3) {
				roomName = System.Text.RegularExpressions.Regex.Replace(room.Key, @"(?<!^)(?=[A-Z])", " ");
				break;
			}
		}
		string splitDesc = System.Text.RegularExpressions.Regex.Replace(splitName, @"(?<!^)(?=[A-Z])", " ")
			+ (roomName != "" ? " (" + roomName + ")" : "");

		settings.Add(splitName, true, splitDesc, "Splits");
	}
	settings.Add("End", true, "Fade out after final game", "Splits");
	
	vars.Info = (Action<string>)((msg) => {
		print("[T7G ASL] " + msg);
	});

	vars.CompletedSplits = new HashSet<string>();
}

init {
	vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
	vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

	const int PUZZLE_COMPLETED_OFFSET = 0x2A8;

	foreach (var split in vars.Splits) {
		string type        = split.Item2;
		string className   = split.Item4;
		string watcherName = "Solved" + split.Item1;

		if (type != "puzzle") continue;

		IntPtr puzzlePtr = vars.Events.InstancePtr(className, "");
		vars.Resolver.Watch<bool>(watcherName, puzzlePtr, PUZZLE_COMPLETED_OFFSET);
	}

	vars.Resolver.Watch<int>(
		"Room", 
		vars.Utils.GEngine, 
		0x1258,         // GameInstance
		0x108,          // GameInstanceSubsystems
		2 * 0x18 + 0x8, // [2].Value
		0xF0,           // T7GSaveGame
		0x120           // CurrentRoom
	);

	vars.Resolver.Watch<IntPtr>("GWorldPtr", vars.Utils.GWorld);
	vars.Resolver.Watch<ulong>("GWorldFName", vars.Utils.GWorld, 0x18);


	vars.Resolver.Watch<IntPtr>("Door", vars.Events.FunctionParentPtr("", "", "RoomDoorGRabbed"));
	vars.Resolver.Watch<bool>("IsRoomLoaded", vars.Events.FunctionParentPtr("", "", "RoomDoorGRabbed"), 0x530);

	// [BP_RitualRoomDoorRight_C] [BP_RitualRoomDoorRight_C] [RoomDoorGRabbed]
	// [BP_RitualRoomDoorRight_C] [BP_RitualRoomDoorRight_C] [RoomLOaded]
	vars.Events.FunctionFlag("RoomDoorGrabbed", "", "", "RoomDoorGRabbed");
	vars.Events.FunctionFlag("RoomLoaded", "", "", "RoomLOaded");


	//vars.Events.FunctionFlag("IsIntroStarted", "BP_FlatIntroManager_C", "", "ReceiveBeginPlay");
	vars.Events.FunctionFlag("IsIntroStarted", "BP_FlatIntroManager_C", "", "UpdateRatio__FinishedFunc");


	// [BP_T7GGameMode_C] [BP_T7GGameMode_C] [ChoosePlayerStart]
	// [WBP_FlatMainMenu_C] [WBP_FlatMainMenu] [WidgetAnimationEvt_FadeBeforePlay_K2Node_WidgetAnimationEvent
	// WBP_FlatMainMenu_C] [WBP_FlatMainMenu] [BndEvt__WBP_FlatMainMenu_WBP_FlatMainMenuButtons_K2Node_ComponentBoundEvent_4_OnStartNewGameClicked__DelegateSignature
	vars.Events.FunctionFlag("IsNewGameStarted", "WBP_FlatMainMenu_C", "", "BndEvt__WBP_FlatMainMenu_WBP_FlatMainMenuButtons_K2Node_ComponentBoundEvent_4_OnStartNewGameClicked__DelegateSignature");


	//[WBP_FlatInteractionWidget_C] [WBP_FlatInteractionWidget_C] [SetFade]
	vars.Events.FunctionFlag("SetFade", "WBP_FlatInteractionWidget_C", "", "SetFade");
	
	
	
	vars.RoomDoorGrabbed = false;
	vars.RoomLoaded = false;
	vars.IsLoading = false;

	vars.DoubleEquals = (Func<double, double, bool>)((double1, double2) => {
		return Math.Abs(double1 - double2) < 0.00001;
	});

	current.World = old.World = "";
}

update {
	vars.Uhara.Update();

	// DOOR LOAD REMOVAL
	
	var world = vars.Utils.FNameToString(current.GWorldFName);
	if (!string.IsNullOrEmpty(world) && world != "None") {
		current.World = world;
	}
	
	if (old.World != current.World) {
		vars.Info("World: " + old.World + " -> " + current.World);
	}


	if (current.Door != old.Door) {
		vars.Info("Door Instance: -> 0x" + current.Door.ToString("X"));
	}

	if (current.IsRoomLoaded != old.IsRoomLoaded) {
		vars.Info("IsRoomLoaded: ->" + current.IsRoomLoaded);
	}

	if (current.Room != old.Room) {
		vars.Info("Room: " + old.Room + " -> " + current.Room);
	}

	if (current.GWorldPtr != old.GWorldPtr) {
		vars.Info("GWorldPtr: -> 0x" + current.GWorldPtr.ToString("X"));
	}
	
	
}

reset {
	// Reset on returning to main menu
	if (current.World != old.World && current.World == "T7G_Title_Flat") {
		return settings["ResetMainMenu"];
	}
}

start {
	// [BP_FlatIntroManager_C] [BP_FlatIntroManager_C] [ReceiveBeginPlay]
	if (vars.Resolver.CheckFlag("IsNewGameStarted")) {
		return true;
	}

	// ende der Bootsfahrt:
	// [BP_Gondola_C] [BP_Gondola] [ExitBoat]
}

onStart {
	vars.CompletedSplits.Clear();
}

split {
	foreach (var split in vars.Splits) {
		string name        = split.Item1;
		string type        = split.Item2;
		int    room        = split.Item3;
		string watcherName = "Solved" + name;

		if (!settings[name] || vars.CompletedSplits.Contains(name)) continue;

		bool shouldSplit = false;
		if (type == "mansion") {
			shouldSplit = old.Room == vars.Rooms["Outside"] && current.Room == vars.Rooms["Foyer"];
		} 
		else if (type == "puzzle") {
			shouldSplit = current.Room == room
				&& !vars.Uhara[watcherName].Old
				&& vars.Uhara[watcherName].Current;
		}

		if (shouldSplit) {
			vars.Info("Split: " + name);
			vars.CompletedSplits.Add(name);
			return true;
		}
	}

	if (current.World == "T7G_Void" && vars.Resolver.CheckFlag("SetFade")) {
		return true;
	}
}

isLoading {
	return current.GWorldPtr == IntPtr.Zero;
}

exit {
	var phase = timer.CurrentPhase;
	bool reset = settings.ResetEnabled && settings["ResetExit"];

	if (phase == TimerPhase.Running && reset) {
		vars.TimerModel.Reset();
	}
}