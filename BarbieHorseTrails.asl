state("barbie") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();

	vars.MainMissions = new HashSet<string> {
		"01_gameintro_01_headtostables",
		"01_gameintro_02_meethorses",
		"01_gameintro_03_petpepper",
		"01_gameintro_04_mounthorse",
		"01_gameintro_05_followladycasron",
		"01_gameintro_06_followtheranger",
		"01_gameintro_07_continueriding",
		"01_gameintro_08_followtheranger",
		"01_gameintro_09_returntostables",
		"01_gameintro_09a_groompepper",
		"01_gameintro_09b_dresspepper",
		"01_gameintro_09c_feedpepper",
		"01_gameintro_09d_petlucky",
		"01_gameintro_10_meetheadranger",
		"02_scenicphotography101_01_findmrroberts",
		"02_scenicphotography101_02_cameraintro",
		"02_scenicphotography101_03_findlocation",
		"02_scenicphotography101_04_takephoto",
		"02_scenicphotography101_05_returntomrroberts",
		"03_headrangertrailmarking_01_speaktoranger",
		"03_headrangertrailmarking_02_gototrailhead",
		"03_headrangertrailmarking_03_marktrail",
		"03_headrangertrailmarking_04_investigatewithhorse",
		"03_headrangertrailmarking_05_marktrail",
		"03_headrangertrailmarking_06_returntoranger",
		"04_archeology101_01_speaktodrpotts",
		"04_archeology101_02_findartifact",
		"04_archeology101_03_returnartifact",
		"04_archeology101_04_minigame",
		"05_headrangerphoto_01_speaktoranger",
		"05_headrangerphoto_02_takephoto",
		"05_headrangerphoto_03_returntoranger",
		"06_ladycarsonrace_01_speaktoladycarson",
		"06_ladycarsonrace_02_completetherace",
		"07_secondartifact_01_speaktodrpotts",
		"07_secondartifact_02_findartifact",
		"07_secondartifact_03_returnartifact",
		"07_secondartifact_04_minigame",
		"08_backpackquest_01_speaktogeorge",
		"08_backpackquest_02_searchforitem01",
		"08_backpackquest_03_searchforitem02",
		"08_backpackquest_04_searchforitem03",
		"08_backpackquest_05_returnitems",
		"09_accessorycollection_01_speaktoladycarson",
		"09_accessorycollection_02_finditem01",
		"09_accessorycollection_03_finditem02",
		"09_accessorycollection_04_finditem03",
		"09_accessorycollection_05_returntoladycarson",
		"09_accessorycollection_06_takephotos",
		"10_thirdartifact_01_speaktodrpotts",
		"10_thirdartifact_02_findartifact",
		"10_thirdartifact_03_returnartifact",
		"10_thirdartifact_04_minigame",
		"11_findmysteryhorse_01_speaktodrpotts",
		"11_findmysteryhorse_02_takephoto",
		"11_findmysteryhorse_03_returntodrpotts",
		"12_completeapplication_01_speaktoranger",
		"12_completeapplication_01a_completeprogress",
		"12_completeapplication_01b_speaktoranger",
		"12_completeapplication_02_speaktoladycarson",
		"13_mrrobertsscrapbook_01_speaktomrroberts",
		"13_mrrobertsscrapbook_02_askfriends",
		"13_mrrobertsscrapbook_02a_a-askheadranger",
		"13_mrrobertsscrapbook_02b_b-askladycarson",
		"13_mrrobertsscrapbook_02c_c-askarcheologist",
		"13_mrrobertsscrapbook_02d_d-askbarbie",
		"13_mrrobertsscrapbook_03_askfriendsorreturn",
		"13_mrrobertsscrapbook_04_returnforphoto",
		"13_mrrobertsscrapbook_05_takegroupphoto",
		"14_epilogue_01_speaktobarbie",
		//"deliverapples_01_talktoladycarson",
		//"deliverapples_02_takeapples",
		//"deliverapples_03_deliverapples",
		//"placetrailmarkers_01_talktoranger",
		//"placetrailmarkers_02_ridetothemeadow",
		//"placetrailmarkers_03_placetrailmarkers"
	};

	vars.SideMissions = new HashSet<string> {
		"daisylofimix_00-meetdaisy",
		"daisylofimix_01-recordsound01",
		"daisylofimix_02-returntodaisy01",
		"daisylofimix_03-recordsound02",
		"daisylofimix_04-returntodaisy02",
		"daisylofimix_05-recordsound03",
		"daisylofimix_06-returntodaisy03",
		"kenurgentdelivery_00-meetken",
		"kenurgentdelivery_01-pickupkit",
		"kenurgentdelivery_02-returntoken",
		"lettycamping_00-meetletty",
		"lettycamping_01-visitcampsite1",
		"lettycamping_02_visitcampsite2",
		"lettycamping_03-returntoletty",
		"nikkifashionphotography_00-meetnikki",
		"nikkifashionphotography_01-takephotos",
		"nikkifashionphotography_02-returntonikki",
		"reneesnackattack_00-meetrenee",
		"reneesnackattack_01-pickupsnack",
		"reneesnackattack_02-returntorenee",
		"teresastickerswap_00-meetteresa",
		"teresastickerswap_01-getsticker01",
		"teresastickerswap_02-returntoteresa01",
		"teresastickerswap_03-getsticker02",
		"teresastickerswap_04-returntoteresa02",
		"teresastickerswap_05-getsticker03",
		"teresastickerswap_06-returntoteresa03",
		"photographalizard_01_takephoto",
		"photographalizard_02_returntoranger",
		"photographlake_01_takephoto",
		"photographlake_02_returntogerorge",
		"astronomer_01_constellations_00-meetstella",
		"astronomer_01_constellations_01-minigame",
		"astronomer_02_constellations_01-findastronomer",
		"astronomer_02_constellations_02-minigame",
		"astronomer_03_constellations_01-findastronomer",
		"astronomer_03_constellations_02-minigame",
		"astronomer_04_constellations_01-talktoastronomer",
		"astronomer_04_constellations_02-takemeteorphoto",
		"astronomer_04_constellations_03-returnphoto",
		"astronomer_05_constellations_01-talktoastronomer",
		"astronomer_05_constellations_02-pickuppackage",
		"astronomer_05_constellations_03-returnpackage",
		"botanist_01_samplesnafu_00_meetdrgreen",
		"botanist_01_samplesnafu_01_findsample",
		"botanist_01_samplesnafu_02_returnsample",
		"botanist_02_plantsorting01_01_talktodrgreen",
		"botanist_02_plantsorting01_02_sortminigame01",
		"botanist_03_plantsorting02-01_talktodrgreen",
		"botanist_03_plantsorting02-02_sortminigame02",
		"botanist_04_plantsorting03-01_talktodrgreen",
		"botanist_04_plantsorting03-02_sortminigame03",
		"botanist_05_samplephoto_01_talktodrgreen",
		"botanist_05_samplephoto_02_takephoto",
		"botanist_05_samplephoto_03_returnphoto",
		"sideranger_01_trailmarking_00_meetsideranger1",
		"sideranger_01_trailmarking_01_gototrailhead",
		"sideranger_01_trailmarking_02_marktrail",
		"sideranger_01_trailmarking_03_marktrail_part2",
		"sideranger_01_trailmarking_04_returntoranger",
		"sideranger_02_sunfallphoto_01-talktoranger",
		"sideranger_02_sunfallphoto_02-takephoto",
		"sideranger_02_sunfallphoto_03-returntoranger",
		"sideranger_03_trailmarking_01_talktoranger",
		"sideranger_03_trailmarking_02_gototrailhead",
		"sideranger_03_trailmarking_03_marktrail",
		"sideranger_03_trailmarking_04_marktrail-part2",
		"sideranger_03_trailmarking_05_takescenicphoto",
		"sideranger_03_trailmarking_06_returntoranger",
		"sideranger_04_fireflylake_01-talktoranger",
		"sideranger_04_fireflylake_02-takephoto",
		"sideranger_04_fireflylake_03-returntoranger",
		"sideranger_05_birdphoto_01-talktoranger",
		"sideranger_05_birdphoto_02-takephoto",
		"sideranger_05_birdphoto_03-returntoranger"
	};

	settings.Add("Reset", true, "Reset");
		settings.Add("ResetMainMenu", true, "Reset on returning to the Main Menu", "Reset");

	settings.Add("Splits", true, "Splits");
		settings.Add("Credits", true, "Trigger the credits", "Splits");
		settings.Add("MainQuests", true, "Main Quests", "Splits");
		settings.Add("SideQuests", true, "Side Quests", "Splits");

    foreach (var mission in vars.MainMissions)
        settings.Add(mission, false, mission, "MainQuests");
    foreach (var mission in vars.SideMissions)
        settings.Add(mission, false, mission, "SideQuests");
	
	settings.Add("OtherSplits", true, "Other", "Splits");
		settings.Add("ShopSplit", false, "Split when opening the shop for the first time", "OtherSplits");

	settings.Add("Debug", true, "Debug");
		settings.Add("EnableDebugMenu", false, "Enable Debug Menu", "Debug");
}

init {
	vars.JitSave = vars.Uhara.CreateTool("Unity", "DotNet", "JitSave");
	vars.Utils = vars.Uhara.CreateTool("Unity", "Utils");
	vars.Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");

	vars.JitSave.SetOuter("BarbieGame.dll");
	IntPtr FinishCharacterCreation = vars.JitSave.AddFlag("CharacterCreationManager", "FinishCharacterCreation");
	IntPtr StartRollingCredits = vars.JitSave.AddFlag("CreditsManager", "StartRollingCredits");
	IntPtr StartLoadingScreen = vars.JitSave.AddFlag("LoadingScreen", "Start");
	IntPtr DestroyLoadingScreen = vars.JitSave.AddFlag("LoadingScreen", "OnDestroy");

	vars.JitSave.ProcessQueue();

	vars.Resolver.Watch<ulong>("FinishCharacterCreation", FinishCharacterCreation);
	vars.Resolver.Watch<ulong>("StartRollingCredits", StartRollingCredits);
	vars.Resolver.Watch<ulong>("StartLoadingScreen", StartLoadingScreen);
	vars.Resolver.Watch<ulong>("DestroyLoadingScreen", DestroyLoadingScreen);

	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
		var mm = mono["BarbieGame", "MissionManager", 1];
		vars.Helper["Mission"] = mono.MakeString(
			mm, 
			"instance",  
			0x50,        // <trackedMission>k__BackingField
			0x10,        // missionSO
			0x18         // id
		);

		vars.Helper["MissionLog"] = mono.Make<IntPtr>(mm, "instance");

		var sm = mono["BarbieGame", "ShopMenuManager", 1];
		vars.Helper["ShopOpen"] = mono.Make<bool>(sm, "instance", 0xC8);

		var ac = mono["BarbieGame", "ApplicationConfig_SO", 1];
		vars.Helper["AppConfig"] = mono.Make<IntPtr>(ac, "_instance");

		var md = mono["BarbieGame", "MissionDatabase", 1];
		vars.Helper["MissionDatabase"] = mono.Make<IntPtr>(md, "_instance");
		
		return true;
	});

	vars.PrintAllMissions = (Action)(() => {
		IntPtr missions = new DeepPointer(
				(IntPtr)vars.Helper["MissionDatabase"].Current 
				+ 0x18,   // objects
				0x10      // _items
			)
			.Deref<IntPtr>(game);
		
		int size = game.ReadValue<int>(missions + 0x18);

		for (int i = 0; i < size; i++) {
			IntPtr mission = new DeepPointer(
				missions 
				+ 0x20 
				+ (i * 0x8)
			)
			.Deref<IntPtr>(game);

			string id = new DeepPointer(
				mission
				+ 0x18,   // id
				0x14      // _firstChar
			)
			.DerefString(game, 100);

			string missionType = new DeepPointer(
				mission
				+ 0x28,   // missionCollection
				0x18,     // collectionName
				0x14      // _firstChar
			)
			.DerefString(game, 100);

			vars.Log(id + " - " + missionType);
		}
	});

	vars.completedSplits = new HashSet<string>();

	vars.EnabledDebugMenu = false;

	current.ActiveScene = "";
	vars.IsLoading = false;
}

update {
	vars.Uhara.Update();

	current.ActiveScene = vars.Utils.GetActiveSceneName() ?? current.ActiveScene;

	if (current.ActiveScene != old.ActiveScene) {
		vars.Log("Scene: " + old.ActiveScene + " -> " + current.ActiveScene);
	}

	if (!vars.IsLoading) {
		if (current.StartLoadingScreen != old.StartLoadingScreen && current.StartLoadingScreen != 0) {
			vars.Log("Created LoadingScreen.");
			vars.IsLoading = true;
		}
	}
	if (vars.IsLoading) {
		if (current.DestroyLoadingScreen != old.DestroyLoadingScreen && current.DestroyLoadingScreen != 0) {
			vars.Log("Destroyed LoadingScreen.");
			vars.IsLoading = false;
		}
	}

	if (settings["EnableDebugMenu"] && !vars.EnabledDebugMenu) {
		if (current.AppConfig != IntPtr.Zero) {
			vars.Log("Enabling Debug Menu!");
			game.WriteBytes((IntPtr)current.AppConfig + 0x19, new byte[] { 1 });
			vars.EnabledDebugMenu = true;
		}
	}
}

reset {
	return 
		current.ActiveScene == "MainMenu" 
		&& current.ActiveScene != old.ActiveScene
		&& settings["ResetMainMenu"];
}

start {
	return current.FinishCharacterCreation != old.FinishCharacterCreation &&
	       current.FinishCharacterCreation != 0;
}

onStart {
	vars.completedSplits.Clear();
}

split {
	// Credits
	if (settings["Credits"] && current.StartRollingCredits != old.StartRollingCredits && current.StartRollingCredits != 0) {
		return true;
	}

	// Shop
	if (settings["ShopSplit"] && !old.ShopOpen && current.ShopOpen && vars.completedSplits.Add("Shop")) {
		return true;
	}

	// Quests
	IntPtr missionsPtr = new DeepPointer((IntPtr)current.MissionLog + 0x58, 0x10).Deref<IntPtr>(game);
	int count = game.ReadValue<int>(missionsPtr + 0x18);
	
	for (int i = 0; i < count; i++) {
		IntPtr missionLogEntry = game.ReadValue<IntPtr>(missionsPtr + 0x20 + (i * 0x8));
		if (missionLogEntry == IntPtr.Zero) continue;

		string id = new DeepPointer(missionLogEntry + 0x10, 0x18, 0x14).DerefString(game, 100);
		bool completed = game.ReadValue<bool>(missionLogEntry + 0x21);

		if (!string.IsNullOrEmpty(id) && settings.ContainsKey(id) && settings[id] && completed && !vars.completedSplits.Contains(id)) {
			vars.completedSplits.Add(id);
			vars.Log("SPLIT! Completed Quest: " + id);
			return true;
		}
	}
}

onSplit {
	/*
	IntPtr missionsPtr = new DeepPointer((IntPtr)current.MissionLog + 0x58, 0x10).Deref<IntPtr>(game);
	int count = game.ReadValue<int>(missionsPtr + 0x18);
	
	for (int i = 0; i < count; i++) {
		IntPtr missionLogEntry = game.ReadValue<IntPtr>(missionsPtr + 0x20 + (i * 0x8));
		if (missionLogEntry == IntPtr.Zero) continue;

		string id = new DeepPointer(missionLogEntry + 0x10, 0x18, 0x14).DerefString(game, 100);
		bool completed = game.ReadValue<bool>(missionLogEntry + 0x21);

		vars.Log(id + ": completed = " + completed);
	}
	*/
}

isLoading {
	return vars.IsLoading;
}