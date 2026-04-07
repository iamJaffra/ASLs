state("Funi_Raccoon_Game") {}

startup {
	vars.TimerModel = new TimerModel { CurrentState = timer };

	vars.Levels = new Dictionary<int, string> {
		//{0, "DEFAULT"},
		//{1, "NON_EXIST"},

		{7, "The Dumpster"}, // The GDScript calls it "MAIN_MENU", but it's The Dumpster
		{2, "Norwich"},
		{5, "Chicken Farm"},
		{27, "Smog Room"},
		{26, "Fields"},
		{10, "Beenie HQ"}, // GDScript name: "EVIL_FACTORY"
		{29, "Beenie Factory"},
		{30, "The Process"},
		{25, "Goo Office"},
		{8, "Blimbo City"},
		{21, "BLMB Reactor Core"},
		{60, "Canyon"},
		{59, "Gully"},
		{69, "Chamber"}, // GDScript name: "ORB_ENDING"
		{71, "Beenie Branch"},
		{73, "Outside Hypercube Datacenter"},  
		{70, "HYPERCENTER"},
		{75, "Hypercube Tree"},
		//{3, "GYM_INSIDE"},
		//{4, "SECRET_UNDERGROUND"},
		//{6, "CLEANERS"},
		//{9, "FISH_INSIDES"},
		//{11, "MUSEUM"},
		//{12, "TRAIN_STATION"},
		//{13, "DREAM_LIKE"},
		//{14, "OFFICE_START"},
		//{15, "WATER_ZONE"},
		//{16, "CLIFF"},
		//{17, "MONITOR_ROOM"},
		//{18, "WAITING_ROOM"},
		//{19, "CRICKET_PITCH"},
		//{20, "JAPAN_STREET"},
		{22, "Blimbo Village"},
		//{23, "PARKING_LOT"},
		//{24, "TRASCO_ENTRANCE"},
		//{28, "DRIVING_BEGIN"},
		//{31, "BEENIE_JESUS"},
		//{32, "KIT_TEST"},
		//{33, "INSIDE_THE_MACHINE"},
		//{34, "HAPPY_FACTORY"},
		//{35, "PATRICKS_SECRET_PLACE"},
		//{36, "BEENIE_CHAMBER"},
		//{37, "INSIDE_TRAIN"},
		//{38, "FUNKYHEART"},
		//{39, "CENTRAL_STATION"},
		//{40, "HAT_STORE"},
		//{41, "INSIDE_TRAIN_WATERZONE"},
		//{42, "HOWTH"},
		//{43, "TEN_THOUSAND_RACCOONS"},
		//{44, "FRIDGE_WORLD"},
		//{45, "GARDEN_TABLE"},
		//{46, "TYRE_SHOP"},
		//{47, "CAVE"},
		//{48, "INSIDE_TRAIN_TRASCO"},
		//{49, "BLIMBO_FOREST"},
		//{50, "PUB"},
		//{51, "BEENIE_CHURCH"},
		//{52, "DESERT"},
		//{53, "PETROL_STATION"},
		//{54, "BEES"},
		//{55, "WASPS"},
		//{56, "NORWICH_RUINS"},
		//{57, "SALMON_OF_KNOWLEDGE"},
		//{58, "DESERT_CONNECTION"},
		//{61, "DRY_ZONE"},
		//{62, "DESERT_BEES"},
		//{63, "PHARMACY"},
		//{64, "PLIMBOS_MIND"},
		//{65, "BEHRMAN_RACETRACK"},
		//{66, "ENDING_ALL_ITEMS"},
		//{67, "CREDITS_LEVEL"},
		//{68, "TIME_TRAVEL"},
		//{72, "MIKKBARGE"},
		//{74, "FINALE_TRANSITION"},
		//{76, "CELTIC_RUINS"},
		//{77, "PACHINKO"},
		//{78, "WAITING_ROOM_DEMO"},
		//{79, "GOO_PARADISE"},
		//{80, "INSIDE_TRAIN_CITY"},
		//{81, "WHEAT_FIELD"},
		//{82, "CLIFFS_OF_NOWHER"},
		//{83, "BRAZIL"},
		//{84, "INSIDE_BRAZIL_TRAIN"}
	};

	var dict = (Dictionary<int, string>)vars.Levels;
	vars.LevelsByName = dict.ToDictionary(kvp => kvp.Value, kvp => kvp.Key);

	settings.Add("End", true, "Ending splits. Split on triggering ...");
		settings.Add("OrbEnding", true, "Orb Ending", "End");
		settings.Add("GrandOpening", true, "Grand Opening", "End");
		settings.Add("YouAREOne", true, "You ARE One", "End");
		settings.Add("Decommissioned", true, "Decommissioned", "End");

	settings.Add("LevelSplits", true, "Split on ENTERING a level for the first time:");

	foreach (var levelName in vars.Levels.Values) {
		settings.Add(levelName, true, levelName, "LevelSplits");
	}

	settings.Add("Reset", true, "Reset");
		settings.Add("ResetOnMainMenu", true, "Reset on quitting to the main menu", "Reset");
		settings.Add("ResetOnExit", true, "Reset on exiting the game", "Reset");

	// SceneTree
	vars.SCENETREE_ROOT_WINDOW_OFFSET        = 0x298; // Window*                           SceneTree::root
	vars.SCENETREE_CURRENT_SCENE_OFFSET      = 0x298; // Node*                             SceneTree::current_scene

	// Node
	vars.OBJECT_SCRIPT_INSTANCE_OFFSET       = 0x068; // ScriptInstance*                   Object::script_instance
	vars.NODE_CHILDREN_OFFSET                = 0x140; // HashMap<StringName, Node*>        Node::Data::children
	vars.NODE_NAME_OFFSET                    = 0x198; // StringName                        Node::Data::name

	// GDScript
	vars.SCRIPT_NAME                         = 0x130; // String                            Resource::name
	vars.GDSCRIPT_MEMBER_MAP_OFFSET          = 0x188; // HashMap<StringName, MemberInfo>   GDScript::member_indices

	// GDScriptInstance
	vars.SCRIPTINSTANCE_SCRIPT_REF_OFFSET    = 0x018; // Ref<GDScript>                     GDScriptInstance::script
	vars.SCRIPTINSTANCE_MEMBERS_OFFSET       = 0x050; // Vector<Variant>                   GDScriptInstance::members

	vars.Info = (Action<string>)((msg) => {
		print("[Funi Raccoon Game ASL] " + msg);
	});
}

init {
	vars.ReadStringName = (Func<IntPtr, string>) ((ptr) => {
		var stringPtr = game.ReadValue<IntPtr>(ptr + 0x8);
		var output = vars.ReadUtf32String(stringPtr);

		return output;
	});

	vars.ReadUtf32String = (Func<IntPtr, string>)((ptr) => {
		var sb = new StringBuilder();
		int utf32char;

		while ((utf32char = game.ReadValue<int>(ptr)) != 0) {
			sb.Append(char.ConvertFromUtf32(utf32char));
			ptr += 4;
		}

		return sb.ToString();
	});

	vars.ListAllChildren = (Action<IntPtr>) ((node) => {
		var result = IntPtr.Zero;
		var childCount     = game.ReadValue<int>   ((IntPtr)(node + vars.NODE_CHILDREN_OFFSET));
		var childArrayPtr  = game.ReadValue<IntPtr>((IntPtr)(node + vars.NODE_CHILDREN_OFFSET + 0x8));

		vars.Info("Children:");

		for (int i = 0; i < childCount; i++) {
			var child = game.ReadValue<IntPtr>(childArrayPtr + (0x8 * i));
			var childName = vars.ReadStringName(game.ReadValue<IntPtr>((IntPtr)(child + vars.NODE_NAME_OFFSET)));

			vars.Info(" - " + childName);
		}
	});

	vars.FindNodeInChildren = (Func<IntPtr, string, IntPtr>) ((node, target) => {
		//vars.Info("Searching for '" + target + "'...");

		var result = IntPtr.Zero;
		var childCount     = game.ReadValue<int>   ((IntPtr)(node + vars.NODE_CHILDREN_OFFSET));
		var childArrayPtr  = game.ReadValue<IntPtr>((IntPtr)(node + vars.NODE_CHILDREN_OFFSET + 0x8));

		for (int i = 0; i < childCount; i++) {
			var child = game.ReadValue<IntPtr>(childArrayPtr + (0x8 * i));
			var childName = vars.ReadStringName(game.ReadValue<IntPtr>((IntPtr)(child + vars.NODE_NAME_OFFSET)));

			if (childName == target) {
				result = child;
				//vars.Info("Found '" + target + "' at 0x" + result.ToString("X") + "!");
				break;
			}
		}

		return result;
	});

	vars.GetLastChild = (Func<IntPtr, IntPtr>) ((node) => {
		var childCount     = game.ReadValue<int>   ((IntPtr)(node + vars.NODE_CHILDREN_OFFSET));
		var childArrayPtr  = game.ReadValue<IntPtr>((IntPtr)(node + vars.NODE_CHILDREN_OFFSET + 0x8));

		return game.ReadValue<IntPtr>(childArrayPtr + (0x8 * (childCount - 1)));
	});

	vars.GetMemberArrayFromNode = (Func<IntPtr, IntPtr>) ((node) => {
		var scriptInstance = game.ReadValue<IntPtr>((IntPtr)(node + vars.OBJECT_SCRIPT_INSTANCE_OFFSET));
		var memberArray    = game.ReadValue<IntPtr>((IntPtr)(scriptInstance + vars.SCRIPTINSTANCE_MEMBERS_OFFSET));
		//vars.Info("Found member array at 0x" + memberArray.ToString("X"));
		return memberArray;
	});

	vars.GetMemberOffsetsFromNode = (Func<IntPtr, Dictionary<string, int>>)((node) => {
		//vars.Info("Getting member offsets...");

		var result = new Dictionary<string, int>();
		var scriptInstance = game.ReadValue<IntPtr>((IntPtr)(node + vars.OBJECT_SCRIPT_INSTANCE_OFFSET));
		var script         = game.ReadValue<IntPtr>((IntPtr)(scriptInstance + vars.SCRIPTINSTANCE_SCRIPT_REF_OFFSET));

		var memberPtr     = game.ReadValue<IntPtr>((IntPtr)(script + vars.GDSCRIPT_MEMBER_MAP_OFFSET));
		var lastMemberPtr = game.ReadValue<IntPtr>((IntPtr)(script + vars.GDSCRIPT_MEMBER_MAP_OFFSET + 0x8));
		int memberSize = 0x18;

		while (memberPtr != IntPtr.Zero) {
			var namePtr = game.ReadValue<IntPtr>(memberPtr + 0x10);
			string memberName = vars.ReadStringName(namePtr);

			var index = game.ReadValue<int>(memberPtr + 0x18);
			var offset = index * memberSize;
			result[memberName] = offset;

			//vars.Info(" - " + memberName + ": 0x" + offset.ToString("X"));

			if (memberPtr == lastMemberPtr)
				break;

			memberPtr = game.ReadValue<IntPtr>(memberPtr);
		}

		//vars.Info("Found offsets for " + result.Count() + " members!");

		return result;
	});

	IntPtr sceneTreePtr = new SignatureScanner(
		game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize)
		.Scan(new SigScanTarget(9, "66 0F 1F 44 00 00 48 89 35 ????????") 
		{ OnFound = (p, _, addr) => addr + 0x4 + game.ReadValue<int>(addr) }
	);

	vars.SceneTree = game.ReadValue<IntPtr>(sceneTreePtr);

	if (vars.SceneTree == IntPtr.Zero) {
		throw new Exception("SceneTree not found - trying again!");
	}

	vars.Info("Found SceneTree at 0x" + vars.SceneTree.ToString("X"));

	vars.Root = game.ReadValue<IntPtr>((IntPtr)(vars.SceneTree + vars.SCENETREE_ROOT_WINDOW_OFFSET));

	if (vars.Root == IntPtr.Zero) {
		throw new Exception("Root not found - trying again!");
	}

	vars.Info("Root at 0x" + vars.Root.ToString("X"));
	vars.ListAllChildren(vars.Root);

	vars.LevelChanger = vars.FindNodeInChildren(vars.Root, "LevelChanger");
	vars.LevelChangerMembers = vars.GetMemberArrayFromNode(vars.LevelChanger);
	vars.LevelChangerOffsets = vars.GetMemberOffsetsFromNode(vars.LevelChanger);

	vars.MenuController = vars.FindNodeInChildren(vars.Root, "MenuController");
	vars.MenuControllerMembers = vars.GetMemberArrayFromNode(vars.MenuController);
	vars.MenuControllerOffsets = vars.GetMemberOffsetsFromNode(vars.MenuController);

	if (vars.MenuController == IntPtr.Zero || vars.MenuControllerMembers == IntPtr.Zero) {
		throw new Exception("MenuController not found - trying again!");
	}

	current.levelPtr = old.levelPtr = IntPtr.Zero;
	current.level = old.level = 0;
	current.isTransitioningLevel = old.isTransitioningLevel = false;
	current.cutscene = old.cutscene = "";
	current.numberOfMenuNodes = old.numberOfMenuNodes = 0;
	current.numberOfRootNodes = old.numberOfRootNodes = 0;
	current.isInMainMenu = old.isInMainMenu = false;
	vars.OrbEndingAnimationPlayer = IntPtr.Zero;
	current.orbEndingPlaying = old.orbEndingPlaying = false;
	vars.firstTimeOrbChamber = true;
	vars.firstTimeMuseum = true;
	vars.MuseumAnimatedSprite = IntPtr.Zero;
	current.triggeredGrandOpening = old.triggeredGrandOpening = false;
	current.triggeredYouAreOne = old.triggeredYouAreOne = false;
	vars.firstTimeHypercubeEnding = true;
	vars.DecommissionedTexture = IntPtr.Zero;
	current.triggeredDecommissionedEnding = old.triggeredDecommissionedEnding = false;
	vars.CompletedSplits = new HashSet<string>();
}

update {
	// LEVEL
	if (vars.LevelChangerOffsets.ContainsKey("current_level")) {
		current.levelPtr = game.ReadValue<IntPtr>((IntPtr)(vars.LevelChangerMembers + vars.LevelChangerOffsets["current_level"] + 0x10));
	}
	
	if (current.levelPtr != old.levelPtr && current.levelPtr != IntPtr.Zero) {
		//vars.ListAllChildren(current.levelPtr);
		var lvlMembers = vars.GetMemberArrayFromNode(current.levelPtr);
		var lvlOffsets = vars.GetMemberOffsetsFromNode(current.levelPtr);

		if (lvlOffsets.ContainsKey("level_id")) {
			current.level = game.ReadValue<int>((IntPtr)(lvlMembers + lvlOffsets["level_id"] + 0x8));
		}
	}
	
	if (current.level != old.level) {
		vars.Info("level: " + old.level + " -> " + current.level);
	}


	// AUTOSTART
	var canvasLayer = vars.GetLastChild(vars.MenuController);

	if (vars.ReadStringName(game.ReadValue<IntPtr>((IntPtr)(canvasLayer + vars.NODE_NAME_OFFSET))) == "CanvasLayer") {
		vars.CanvasLayerMembers = vars.GetMemberArrayFromNode(canvasLayer);
		vars.CanvasLayerOffsets = vars.GetMemberOffsetsFromNode(canvasLayer);

		if (vars.CanvasLayerOffsets.ContainsKey("animation_player")) {
			var animationPlayer = game.ReadValue<IntPtr>((IntPtr)(vars.CanvasLayerMembers + vars.CanvasLayerOffsets["animation_player"] + 0x10));
			
			// https://github.com/godotengine/godot/blob/4.6/scene/animation/animation_player.h#L93
			current.cutscene = vars.ReadStringName(game.ReadValue<IntPtr>(animationPlayer + 0x4F0));   // 4.6.1 had it at 0x4F8  >_<
		}
	}
	else {
		current.cutscene = "";
	}

	if (current.cutscene != old.cutscene) { //  && !String.IsNullOrEmpty(current.cutscene)
		vars.Info("cutscene -> " + current.cutscene);
	}
	

	// ORB
	if (current.level == 69) {
		if (vars.firstTimeOrbChamber) {
			var weightSpawner = vars.FindNodeInChildren(current.levelPtr, "WeightSpawner");
			var weightSpawnerMembers = vars.GetMemberArrayFromNode(weightSpawner);
			var weightSpawnerOffsets = vars.GetMemberOffsetsFromNode(weightSpawner);

			if (weightSpawnerOffsets.ContainsKey("animation_player")) {
				vars.OrbEndingAnimationPlayer = game.ReadValue<IntPtr>((IntPtr)(weightSpawnerMembers + weightSpawnerOffsets["animation_player"] + 0x10));

				if (vars.OrbEndingAnimationPlayer != IntPtr.Zero) {
					vars.firstTimeOrbChamber = false;
				}
			}
		}
		else {
			// https://github.com/godotengine/godot/blob/4.6/scene/animation/animation_player.h#L138
			// C6 83 ??050000 01     - mov byte ptr [rbx+00000551],01 { 1 }
			// 4C 89 FA              - mov rdx,r15
			// 4C 89 E1              - mov rcx,r12

			current.orbEndingPlaying = game.ReadValue<bool>((IntPtr)vars.OrbEndingAnimationPlayer + 0x551); // was 0x559 in 4.6.1
		}
	}
	else {
		vars.OrbEndingAnimationPlayer = IntPtr.Zero;
		vars.firstTimeOrbChamber = true;
	}


	// GRAND OPENING
	if (current.level == 11) {
		if (vars.firstTimeMuseum) {
			var endingController = vars.FindNodeInChildren(vars.FindNodeInChildren(current.levelPtr, "Ending"), "EndingController");
			var endingControllerMembers = vars.GetMemberArrayFromNode(endingController);
			var endingControllerOffsets = vars.GetMemberOffsetsFromNode(endingController);

			if (endingControllerOffsets.ContainsKey("raccoon_plater")) {
				vars.MuseumAnimatedSprite = game.ReadValue<IntPtr>((IntPtr)(endingControllerMembers + endingControllerOffsets["raccoon_plater"] + 0x10));

				if (vars.MuseumAnimatedSprite != IntPtr.Zero) {
					vars.firstTimeMuseum = false;
				}
			}
		}
		else {
			// https://github.com/godotengine/godot/blob/4.6/scene/3d/sprite_3d.h#L233
			// F3 0F10 8C 24 ????0000  - movss xmm1,[rsp+000000E0]
			// C6 86 ??060000 01       - mov byte ptr [rsi+00000658],01 { 1 }
			// 48 8B 86 ????0000       - mov rax,[rsi+00000660]

			current.triggeredGrandOpening = game.ReadValue<bool>((IntPtr)(vars.MuseumAnimatedSprite + 0x658));
		}
	}
	else {
		vars.MuseumAnimatedSprite = IntPtr.Zero;
		vars.firstTimeMuseum = true;
	}
	

	// You ARE One
	if (current.level == 71) {
		var node = vars.GetLastChild(current.levelPtr);

		if (vars.ReadStringName(game.ReadValue<IntPtr>((IntPtr)(node + vars.NODE_NAME_OFFSET))) == "BeenieTheBirthdayBoy") {
			current.triggeredYouAreOne = true;
		}
		else {
			current.triggeredYouAreOne = false;
		}
	}
	else {
		current.triggeredYouAreOne = false;
	}

	// DECOMMISSIONED
	if (current.level == 75) {
		if (vars.firstTimeHypercubeEnding) {
			var credits = (vars.FindNodeInChildren(current.levelPtr, "EndText"));
			var creditsMembers = vars.GetMemberArrayFromNode(credits);
			var creditsOffsets = vars.GetMemberOffsetsFromNode(credits);

			if (creditsOffsets.ContainsKey("texture_background")) {
				vars.DecommissionedTexture = game.ReadValue<IntPtr>((IntPtr)(creditsMembers + creditsOffsets["texture_background"] + 0x10));

				if (vars.DecommissionedTexture != IntPtr.Zero) {
					vars.firstTimeHypercubeEnding = false;
				}
			}
		}
		else {
			// https://github.com/godotengine/godot/blob/4.6/scene/main/canvas_item.h#L106
			// 75 ??                 - jne Funi_Raccoon_Game.exe+114A158
			// 38 91 ????0000        - cmp [rcx+00000350],dl
			// 0F84 ??000000         - je Funi_Raccoon_Game.exe+114A21B
			// 88 91 ????0000        - mov [rcx+00000350],dl
			// 80 B9 ????0000 00     - cmp byte ptr [rcx+00000351],00 { 0 }

			current.triggeredDecommissionedEnding = game.ReadValue<bool>((IntPtr)(vars.DecommissionedTexture + 0x350));
		}
	}
	else {
		vars.DecommissionedTexture = IntPtr.Zero;
		vars.firstTimeHypercubeEnding = true;
	}
}

start {
	return (current.cutscene != old.cutscene && (current.cutscene == "monitor_loop" || current.cutscene == "monitor_drop"));
}

onStart {
	vars.CompletedSplits.Clear();
}

reset {
	if (settings["ResetOnMainMenu"]) {
		current.numberOfRootNodes = game.ReadValue<int>((IntPtr)(vars.Root + vars.NODE_CHILDREN_OFFSET));

		if (current.numberOfRootNodes != old.numberOfRootNodes) {
			if (vars.FindNodeInChildren(vars.Root, "MainMenu") != IntPtr.Zero) {
				current.isInMainMenu = true;
			}
			else {
				current.isInMainMenu = false;
			}
		}

		return (current.isInMainMenu && !old.isInMainMenu);
	}
}

split {
	// LEVEL SPLITS
	if (current.level != old.level) {
		string levelName;

		if (vars.Levels.TryGetValue(current.level, out levelName)) {
			if (settings.ContainsKey(levelName) && settings[levelName] && !vars.CompletedSplits.Contains(levelName)) {
				vars.CompletedSplits.Add(levelName);
				vars.Info("Triggered Split: Entered Level '" + levelName + "'");
				return true;
			}
		}
	}

	// ENDING SPLITS
	if (current.orbEndingPlaying && !old.orbEndingPlaying) {
		if (settings["OrbEnding"] && !vars.CompletedSplits.Contains("OrbEnding")) {
			vars.CompletedSplits.Add("OrbEnding");
			vars.Info("Triggered Split: Triggered Orb Ending");
			return true;
		}
	}
	if (current.triggeredGrandOpening && !old.triggeredGrandOpening) {
		if (settings["GrandOpening"] && !vars.CompletedSplits.Contains("GrandOpening")) {
			vars.CompletedSplits.Add("GrandOpening");
			vars.Info("Triggered Split: Triggered the Grand Opening");
			return true;
		}
	}
	if (current.triggeredYouAreOne && !old.triggeredYouAreOne) {
		if (settings["YouAREOne"] && !vars.CompletedSplits.Contains("YouAREOne")) {
			vars.CompletedSplits.Add("YouAREOne");
			vars.Info("Triggered Split: Triggered Beenie The Birthday Boy (You ARE One)");
			return true;
		}
	}
	if (current.triggeredDecommissionedEnding && !old.triggeredDecommissionedEnding) {
		if (settings["Decommissioned"] && !vars.CompletedSplits.Contains("Decommissioned")) {
			vars.CompletedSplits.Add("Decommissioned");
			vars.Info("Triggered Split: Triggered the True Ending (Decommissioned)");
			return true;
		}
	}
}

exit {
	var phase = timer.CurrentPhase;
	bool reset = settings.ResetEnabled && settings["ResetOnExit"];

	if (phase == TimerPhase.Running && reset) {
		vars.TimerModel.Reset();
	}
}