state("barbie") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();

	vars.MainMissions = new Dictionary<string, string> {
		{ "01_gameintro_01_headtostables", "Head to the stable" },
		{ "01_gameintro_02_meethorses", "Pet the horses" },
		{ "01_gameintro_03_petpepper", "Pet the horses" },
		{ "01_gameintro_04_mounthorse", "Mount your horse" },
		{ "01_gameintro_05_followladycasron", "Follow Lady Carson" },
		{ "01_gameintro_06_followtheranger", "Follow Ranger Quinn" },
		{ "01_gameintro_07_continueriding", "Follow Ranger Quinn" },
		{ "01_gameintro_08_followtheranger", "Follow Ranger Quinn" },
		{ "01_gameintro_09_returntostables", "Return to the stable" },
		{ "01_gameintro_09a_groompepper", "Groom Pepper" },
		{ "01_gameintro_09b_dresspepper", "Dress Pepper at the Hitching Post" },
		{ "01_gameintro_09c_feedpepper", "Feed Pepper a Snack" },
		{ "01_gameintro_09d_petlucky", "Pet Lucky" },
		{ "01_gameintro_10_meetheadranger", "Meet the Head Ranger" },
		{ "02_scenicphotography101_01_findmrroberts", "Find Mr. Roberts" },
		{ "02_scenicphotography101_02_cameraintro", "Take a photo of Barbie" },
		{ "02_scenicphotography101_03_findlocation", "Find the photo location" },
		{ "02_scenicphotography101_04_takephoto", "Take a photo of the lake" },
		{ "02_scenicphotography101_05_returntomrroberts", "Return to Mr. Roberts" },
		{ "03_headrangertrailmarking_01_speaktoranger", "Speak to Ranger Annalise" },
		{ "03_headrangertrailmarking_02_gototrailhead", "Go to the trailhead" },
		{ "03_headrangertrailmarking_03_marktrail", "Place trail markers along the trail" },
		{ "03_headrangertrailmarking_04_investigatewithhorse", "Investigate with Lucky" },
		{ "03_headrangertrailmarking_05_marktrail", "Place trail markers along the trail" },
		{ "03_headrangertrailmarking_06_returntoranger", "Return to Ranger Annalise" },
		{ "04_archeology101_01_speaktodrpotts", "Speak to Dr. Potts" },
		{ "04_archeology101_02_findartifact", "Find an artifact on Manzanita Bluff's winding ridge" },
		{ "04_archeology101_03_returnartifact", "Return the artifact to Dr. Potts" },
		{ "04_archeology101_04_minigame", "Put the artifact pieces together" },
		{ "05_headrangerphoto_01_speaktoranger", "Speak to Ranger Annalise" },
		{ "05_headrangerphoto_02_takephoto", "Take a photo of a Green Anole Lizard during the day" },
		{ "05_headrangerphoto_03_returntoranger", "Return to Ranger Annalise" },
		{ "06_ladycarsonrace_01_speaktoladycarson", "Speak to Lady Carson" },
		{ "06_ladycarsonrace_02_completetherace", "Complete the race" },
		{ "07_secondartifact_01_speaktodrpotts", "Speak to Dr. Potts" },
		{ "07_secondartifact_02_findartifact", "Find the artifact in the Sequoia Valley mountain region" },
		{ "07_secondartifact_03_returnartifact", "Return the artifact to Dr. Potts" },
		{ "07_secondartifact_04_minigame", "Put the artifact pieces together" },
		{ "08_backpackquest_01_speaktogeorge", "Speak to Mr. Roberts" },
		{ "08_backpackquest_02_searchforitem01", "Look around the trail entrance for Mr. Roberts' backpack" },
		{ "08_backpackquest_03_searchforitem02", "Look around the trail entrance for Mr. Roberts' backpack" },
		{ "08_backpackquest_04_searchforitem03", "Look around the trail entrance for Mr. Roberts' backpack" },
		{ "08_backpackquest_05_returnitems", "Return to Mr. Roberts" },
		{ "09_accessorycollection_01_speaktoladycarson", "Speak to Lady Carson" },
		{ "09_accessorycollection_02_finditem01", "Look around the Fernbrush Grove Campsite for the bridle" },
		{ "09_accessorycollection_03_finditem02", "Look around the general store for the saddle" },
		{ "09_accessorycollection_04_finditem03", "Look around the Lupine Dell Cabins for the saddle blanket" },
		{ "09_accessorycollection_05_returntoladycarson", "Speak to Lady Carson" },
		{ "09_accessorycollection_06_takephotos", "Take photos of Lucky, Tornado, and Pepper" },
		{ "10_thirdartifact_01_speaktodrpotts", "Speak to Dr. Potts" },
		{ "10_thirdartifact_02_findartifact", "Find an artifact in Manzanita Bluff's northwest mountain region" },
		{ "10_thirdartifact_03_returnartifact", "Return the artifact to Dr. Potts" },
		{ "10_thirdartifact_04_minigame", "Put the artifact pieces together" },
		{ "11_findmysteryhorse_01_speaktodrpotts", "Speak to Dr. Potts" },
		{ "11_findmysteryhorse_02_takephoto", "Take a photo of the Silver Canyon Mustang" },
		{ "11_findmysteryhorse_03_returntodrpotts", "Show the photo of the Silver Canyon Mustang to Dr. Potts" },
		{ "12_completeapplication_01_speaktoranger", "Speak to Ranger Annalise about your packet progress" },
		{ "12_completeapplication_01a_completeprogress", "Complete side quests and catalog the park to finish the preserve packet" },
		{ "12_completeapplication_01b_speaktoranger", "Speak to Ranger Annalise about your packet progress" },
		{ "12_completeapplication_02_speaktoladycarson", "Speak to Lady Carson about the nature preserve certificate" },
		{ "13_mrrobertsscrapbook_01_speaktomrroberts", "Speak to Mr. Roberts" },
		{ "13_mrrobertsscrapbook_02_askfriends", "Ask friends to join the group photo" },
		{ "13_mrrobertsscrapbook_02a_a-askheadranger", "Speak to Ranger Annalise" },
		{ "13_mrrobertsscrapbook_02b_b-askladycarson", "Speak to Lady Carson" },
		{ "13_mrrobertsscrapbook_02c_c-askarcheologist", "Speak to Dr. Potts" },
		{ "13_mrrobertsscrapbook_02d_d-askbarbie", "Speak to Barbie" },
		{ "13_mrrobertsscrapbook_03_askfriendsorreturn", "Ask more friends to join or take the group photo" },
		{ "13_mrrobertsscrapbook_04_returnforphoto", "Return to take the group photo" },
		{ "13_mrrobertsscrapbook_05_takegroupphoto", "Take a group selfie" },
		//{ "14_epilogue_01_speaktobarbie", "Speak to Barbie" },
		//{ "deliverapples_01_talktoladycarson", "Speak to Lady Carson" },
		//{ "deliverapples_02_takeapples", "Take the bucket of apples" },
		//{ "deliverapples_03_deliverapples", "Deliver the bucket of apples to the stable" },
		//{ "placetrailmarkers_01_talktoranger", "Speak to Ranger Quinn" },
		//{ "placetrailmarkers_02_ridetothemeadow", "Ride to the meadow" },
		//{ "placetrailmarkers_03_placetrailmarkers", "Place trail markers along the hiking trail" },
	};

	vars.SideMissions = new Dictionary<string, string> {
		{ "daisylofimix_00-meetdaisy", "Speak to Daisy" },
		{ "daisylofimix_01-recordsound01", "Record the first sound at the waterfall in Manzanita Bluff" },
		{ "daisylofimix_02-returntodaisy01", "Return to Daisy" },
		{ "daisylofimix_03-recordsound02", "Record the second sound at the Starside Lake shore" },
		{ "daisylofimix_04-returntodaisy02", "Return to Daisy" },
		{ "daisylofimix_05-recordsound03", "Record the third sound of the owl in Fernbrush Grove at night" },
		{ "daisylofimix_06-returntodaisy03", "Return to Daisy" },
		{ "kenurgentdelivery_00-meetken", "Speak to Ken" },
		{ "kenurgentdelivery_01-pickupkit", "Retrieve the first aid kit from Sequoia Valley" },
		{ "kenurgentdelivery_02-returntoken", "Return the first aid kit to Ken" },
		{ "lettycamping_00-meetletty", "Speak to Letty" },
		{ "lettycamping_01-visitcampsite1", "Visit the Fernbrush Grove Campsite" },
		{ "lettycamping_02_visitcampsite2", "Visit the Manzanita Bluff Campsite" },
		{ "lettycamping_03-returntoletty", "Report your campsite conclusions to Letty" },
		{ "nikkifashionphotography_00-meetnikki", "Talk to Nikki" },
		{ "nikkifashionphotography_01-takephotos", "Take photos in different outfits for Nikki" },
		{ "nikkifashionphotography_02-returntonikki", "Talk to Nikki" },
		{ "reneesnackattack_00-meetrenee", "Speak to Renee" },
		{ "reneesnackattack_01-pickupsnack", "Pick up almond butter at the general store" },
		{ "reneesnackattack_02-returntorenee", "Return to Renee" },
		{ "teresastickerswap_00-meetteresa", "Speak to Teresa" },
		{ "teresastickerswap_01-getsticker01", "Look for a park logo sticker at the park entrance" },
		{ "teresastickerswap_02-returntoteresa01", "Swap your new sticker with Teresa" },
		{ "teresastickerswap_03-getsticker02", "Look for a horse sticker at the stables" },
		{ "teresastickerswap_04-returntoteresa02", "Swap your new sticker with Teresa" },
		{ "teresastickerswap_05-getsticker03", "Look for a vintage scenic spot sticker at the overlook" },
		{ "teresastickerswap_06-returntoteresa03", "Swap your new sticker with Teresa" },
		{ "photographalizard_01_takephoto", "Photograph a lizard" },
		{ "photographalizard_02_returntoranger", "Return to Ranger Riley" },
		{ "photographlake_01_takephoto", "Photograph your horse by the lake at night" },
		{ "photographlake_02_returntogerorge", "Return to Mr. Roberts" },
		{ "astronomer_01_constellations_00-meetstella", "Speak to Stella" },
		{ "astronomer_01_constellations_01-minigame", "Talk to Stella at night and help her look for constellations" },
		{ "astronomer_02_constellations_01-findastronomer", "Find Stella at night and help her look for more constellations" },
		{ "astronomer_02_constellations_02-minigame", "Find Stella at night and help her look for more constellations" },
		{ "astronomer_03_constellations_01-findastronomer", "Find Stella at night and help her look for more constellations" },
		{ "astronomer_03_constellations_02-minigame", "Find Stella at night and help her look for more constellations" },
		{ "astronomer_04_constellations_01-talktoastronomer", "Speak to Stella" },
		{ "astronomer_04_constellations_02-takemeteorphoto", "Take a photo of the meteor shower from Manzanita Bluff's lookout spot at night" },
		{ "astronomer_04_constellations_03-returnphoto", "Return to Stella with the photo" },
		{ "astronomer_05_constellations_01-talktoastronomer", "Speak to Stella" },
		{ "astronomer_05_constellations_02-pickuppackage", "Pick up the package at the general store" },
		{ "astronomer_05_constellations_03-returnpackage", "Return to Stella with the package" },
		{ "botanist_01_samplesnafu_00_meetdrgreen", "Talk to Dr. Green" },
		{ "botanist_01_samplesnafu_01_findsample", "Head to Fernbrush Grove to find the sample collection" },
		{ "botanist_01_samplesnafu_02_returnsample", "Return the samples to Dr. Green" },
		{ "botanist_02_plantsorting01_01_talktodrgreen", "Sort the leaf samples for Dr. Green" },
		{ "botanist_02_plantsorting01_02_sortminigame01", "Sort the leaf samples for Dr. Green" },
		{ "botanist_03_plantsorting02-01_talktodrgreen", "Sort the leaf samples for Dr. Green" },
		{ "botanist_03_plantsorting02-02_sortminigame02", "Sort the leaf samples for Dr. Green" },
		{ "botanist_04_plantsorting03-01_talktodrgreen", "Sort the leaf samples for Dr. Green" },
		{ "botanist_04_plantsorting03-02_sortminigame03", "Sort the leaf samples for Dr. Green" },
		{ "botanist_05_samplephoto_01_talktodrgreen", "Talk to Dr. Green" },
		{ "botanist_05_samplephoto_02_takephoto", "Take a photo of the pink monkeyflower for Dr. Green" },
		{ "botanist_05_samplephoto_03_returnphoto", "Return to Dr. Green with the photo" },
		{ "sideranger_01_trailmarking_00_meetsideranger1", "Talk to Ranger Rory" },
		{ "sideranger_01_trailmarking_01_gototrailhead", "Head to the Sequoia Valley River trailhead" },
		{ "sideranger_01_trailmarking_02_marktrail", "Place trail markers along the trail" },
		{ "sideranger_01_trailmarking_03_marktrail_part2", "Place trail markers along the trail" },
		{ "sideranger_01_trailmarking_04_returntoranger", "Return to Ranger Rory" },
		{ "sideranger_02_sunfallphoto_01-talktoranger", "Talk to Ranger Rory" },
		{ "sideranger_02_sunfallphoto_02-takephoto", "Take a photo of Saddletail Falls at sunset" },
		{ "sideranger_02_sunfallphoto_03-returntoranger", "Show the photo to Ranger Rory" },
		{ "sideranger_03_trailmarking_01_talktoranger", "Talk to Ranger Quinn" },
		{ "sideranger_03_trailmarking_02_gototrailhead", "Head to the trailhead in Fernbrush Grove" },
		{ "sideranger_03_trailmarking_03_marktrail", "Place trail markers along the trail" },
		{ "sideranger_03_trailmarking_04_marktrail-part2", "Place trail markers along the trail" },
		{ "sideranger_03_trailmarking_05_takescenicphoto", "Take a photo of the scenic view" },
		{ "sideranger_03_trailmarking_06_returntoranger", "Return to Ranger Quinn" },
		{ "sideranger_04_fireflylake_01-talktoranger", "Talk to Ranger Quinn" },
		{ "sideranger_04_fireflylake_02-takephoto", "Take a photo of fireflies above the lake during the evening" },
		{ "sideranger_04_fireflylake_03-returntoranger", "Show the photo to Ranger Quinn" },
		{ "sideranger_05_birdphoto_01-talktoranger", "Talk to Ranger Quinn" },
		{ "sideranger_05_birdphoto_02-takephoto", "Take a photo of house finches in Fernbrush Grove during the day" },
		{ "sideranger_05_birdphoto_03-returntoranger", "Show the photo to Ranger Quinn" },
	};

	settings.Add("Reset", true, "Reset");
		settings.Add("ResetMainMenu", true, "Reset on returning to the Main Menu", "Reset");

	settings.Add("Splits", true, "Splits");
		settings.Add("Credits", true, "Trigger the credits", "Splits");
		settings.Add("MainQuests", true, "Main Quests", "Splits");
		settings.Add("SideQuests", true, "Side Quests", "Splits");

    foreach (var mission in vars.MainMissions) {
		string id = mission.Key;
		string text = mission.Value;

		settings.Add(id, false, id, "MainQuests");
		settings.SetToolTip(id, text);
	}
    foreach (var mission in vars.SideMissions) {
		string id = mission.Key;
		string text = mission.Value;

		settings.Add(id, false, id, "SideQuests");
		settings.SetToolTip(id, text);
	}
	
	settings.Add("OtherSplits", true, "Other", "Splits");
		settings.Add("ShopSplit", false, "Split when opening the shop for the first time", "OtherSplits");

	settings.Add("Utility", true, "Utility");
		settings.Add("FastCredits", false, "Fast Credits (when Space is held)", "Utility");
		settings.Add("EnableDebugMenu", false, "Enable Debug Menu", "Utility");
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
		var missionManager = mono["BarbieGame", "MissionManager", 1];
		vars.Helper["Mission"] = mono.MakeString(
			missionManager, 
			"instance",  
			0x50,        // <trackedMission>k__BackingField
			0x10,        // missionSO
			0x18         // id
		);

		vars.Helper["MissionLog"] = mono.Make<IntPtr>(missionManager, "instance");

		var shopManager = mono["BarbieGame", "ShopMenuManager", 1];
		vars.Helper["ShopOpen"] = mono.Make<bool>(shopManager, "instance", 0xC8);

		var applicationConfig = mono["BarbieGame", "ApplicationConfig_SO", 1];
		vars.Helper["AppConfig"] = mono.Make<IntPtr>(applicationConfig, "_instance");

		var creditsManager = mono["BarbieGame", "CreditsManager", 1];
		vars.Helper["CreditsManager"] = mono.Make<IntPtr>(creditsManager, "instance");
		vars.Helper["RollingCredits"] = mono.Make<bool>(creditsManager, "instance", 0x44);

		var missionDatabase = mono["BarbieGame", "MissionDatabase", 1];
		vars.Helper["MissionDatabase"] = mono.Make<IntPtr>(missionDatabase, "_instance");
		
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

			IntPtr titleTexto = new DeepPointer(mission + 0x38).Deref<IntPtr>(game);
			IntPtr titleLines = new DeepPointer(titleTexto + 0x68, 0x10).Deref<IntPtr>(game);
			int titleLineCount = game.ReadValue<int>(titleLines + 0x18);

			string title = "";
			for (int j = 0; j < titleLineCount; j++) {
				IntPtr textoLine = game.ReadValue<IntPtr>(titleLines + 0x20 + (j * 0x8));
				int language = game.ReadValue<int>(textoLine + 0x18);
				if (language == 1) {
					title = new DeepPointer(textoLine + 0x10, 0x14).DerefString(game, 256);
					break;
				}
			}

			if (title == "")
				title = "[NO ENGLISH]";

			string missionType = new DeepPointer(
				mission
				+ 0x28,   // missionCollection
				0x18,     // collectionName
				0x14      // _firstChar
			)
			.DerefString(game, 100);

			print("[]" + id + " : " + title + " - " + missionType);
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

	if (settings["FastCredits"]) {
		if (current.RollingCredits) {
			float creditsScrollSpeedBonus = game.ReadValue<float>((IntPtr)current.CreditsManager + 0x34);
			if (creditsScrollSpeedBonus == 800.0f) {
				float newBonus = 100000.0f;
				byte[] bytes = BitConverter.GetBytes(newBonus);
				game.WriteBytes((IntPtr)current.CreditsManager + 0x34, bytes);
				vars.Log("Set credits scroll speed bonus to " + newBonus + ".");
			}
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
	if (settings["Credits"] && current.RollingCredits && !old.RollingCredits) {
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
	//vars.PrintAllMissions();
}

isLoading {
	return vars.IsLoading;
}