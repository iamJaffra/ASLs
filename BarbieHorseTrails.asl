state("barbie") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	Assembly.Load(File.ReadAllBytes("Components/uhara9")).CreateInstance("Main");
	vars.Uhara.EnableDebug();

	vars.Missions = new Dictionary<string, string> {
		{ "02_scenicphotography101_01_findmrroberts",    "Welcome To Canterbury Trails" },
		{ "03_headrangertrailmarking_01_speaktoranger",  "Scenic Photography 101" },
		{ "04_archeology101_01_speaktodrpotts",          "Trailmarking 101" },
		{ "05_headrangerphoto_01_speaktoranger",         "Archeology 101" },
		{ "06_ladycarsonrace_01_speaktoladycarson",      "Wildlife Photography 101" },
		{ "07_secondartifact_01_speaktodrpotts",         "Horse Race" },
		{ "08_backpackquest_01_speaktogeorge",           "Mystery Horse: Second Artifact" },
		{ "09_accessorycollection_01_speaktoladycarson", "Backpack Quest" },
		{ "10_thirdartifact_01_speaktodrpotts",          "Website Quest" },
		{ "11_findmysteryhorse_01_speaktodrpotts",       "Silver Canyon Mustang: The Final Artifact" },
		{ "12_completeapplication_01_speaktoranger",     "Silver Canyon Mustang: The Thrilling Conclusion" },
		{ "13_mrrobertsscrapbook_01_speaktomrroberts",   "Packet Progress" },
		{ "14_epilogue_01_speaktobarbie",                "Golden Moments" }
	};

	settings.Add("Missions", true, "Missions");

	foreach (var mission in vars.Missions) {
		var id = mission.Key;
		var desc = mission.Value;

		settings.Add(id, true, desc, "Missions");
	}
	
	settings.Add("Credits", true, "Best Friends Forever (Trigger the credits)", "Missions");
}

init {
	vars.JitSave = vars.Uhara.CreateTool("Unity", "DotNet", "JitSave");
	vars.Utils = vars.Uhara.CreateTool("Unity", "Utils");
	vars.Instance = vars.Uhara.CreateTool("Unity", "DotNet", "Instance");

	vars.JitSave.SetOuter("BarbieGame.dll");
	IntPtr FinishCharacterCreation = vars.JitSave.AddFlag("CharacterCreationManager", "FinishCharacterCreation");
	IntPtr StartRollingCredits = vars.JitSave.AddFlag("CreditsManager", "StartRollingCredits");
	
	vars.JitSave.ProcessQueue();

	vars.Resolver.Watch<ulong>("FinishCharacterCreation", FinishCharacterCreation);
	vars.Resolver.Watch<ulong>("StartRollingCredits", StartRollingCredits);

	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
		var gm = mono["BarbieGame", "MissionManager", 1];
		vars.Helper["Mission"] = mono.MakeString(
			gm, 
			"instance",  
			0x50,        // <trackedMission>k__BackingField
			0x10,        // missionSO
			0x18         // id
		);
		
		return true;
	});

	current.ActiveScene = "";
	current.Mission = "";

	vars.completedSplits = new HashSet<string>();
}

update {
	vars.Uhara.Update();

	current.ActiveScene = vars.Utils.GetActiveSceneName() ?? current.ActiveScene;

	if (current.Mission != old.Mission) {
		vars.Log("Mission -> " + current.Mission);
	}
}

reset {
	return current.ActiveScene == "MainMenu" && current.ActiveScene != old.ActiveScene;
}

start {
	return current.FinishCharacterCreation != old.FinishCharacterCreation &&
	       current.FinishCharacterCreation != 0;
}

split {
	// Credits
	if (settings["Credits"] && current.StartRollingCredits != old.StartRollingCredits && current.StartRollingCredits != 0) {
		return true;
	}

	// Quests
	if (current.Mission != old.Mission) {
		if (vars.Missions.ContainsKey(current.Mission) && settings[current.Mission] && vars.completedSplits.Add(current.Mission)) {
			return true;
		}
	}
}


/*
# Main Mission Tasks

01_gameintro_01_headtostables
01_gameintro_02_meethorses
01_gameintro_03_petpepper
01_gameintro_05_followladycasron
01_gameintro_06_followtheranger
01_gameintro_07_continueriding
01_gameintro_08_followtheranger
01_gameintro_09_returntostables
01_gameintro_09a_groompepper
01_gameintro_09b_dresspepper
01_gameintro_09c_feedpepper
01_gameintro_09d_petlucky
01_gameintro_10_meetheadranger
02_scenicphotography101_01_findmrroberts
02_scenicphotography101_02_cameraintro
02_scenicphotography101_03_findlocation
02_scenicphotography101_04_takephoto
02_scenicphotography101_05_returntomrroberts
03_headrangertrailmarking_01_speaktoranger
03_headrangertrailmarking_02_gototrailhead
03_headrangertrailmarking_03_marktrail
03_headrangertrailmarking_04_investigatewithhorse
03_headrangertrailmarking_05_marktrail
03_headrangertrailmarking_06_returntoranger
04_archeology101_01_speaktodrpotts
04_archeology101_02_findartifact
04_archeology101_03_returnartifact
04_archeology101_04_minigame
05_headrangerphoto_01_speaktoranger
05_headrangerphoto_02_takephoto
05_headrangerphoto_03_returntoranger
06_ladycarsonrace_01_speaktoladycarson
06_ladycarsonrace_02_completetherace
07_secondartifact_01_speaktodrpotts
07_secondartifact_02_findartifact
07_secondartifact_03_returnartifact
07_secondartifact_04_minigame
08_backpackquest_01_speaktogeorge
08_backpackquest_02_searchforitem01
08_backpackquest_03_searchforitem02
08_backpackquest_04_searchforitem03
08_backpackquest_05_returnitems
09_accessorycollection_01_speaktoladycarson
09_accessorycollection_02_finditem01
09_accessorycollection_03_finditem02
09_accessorycollection_04_finditem03
09_accessorycollection_05_returntoladycarson
09_accessorycollection_06_takephotos
10_thirdartifact_01_speaktodrpotts
10_thirdartifact_02_findartifact
10_thirdartifact_03_returnartifact
10_thirdartifact_04_minigame
11_findmysteryhorse_01_speaktodrpotts
11_findmysteryhorse_02_takephoto
11_findmysteryhorse_03_returntodrpotts
12_completeapplication_01_speaktoranger
12_completeapplication_01a_completeprogress
12_completeapplication_01b_speaktoranger
12_completeapplication_02_speaktoladycarson
13_mrrobertsscrapbook_01_speaktomrroberts
13_mrrobertsscrapbook_02a_a-askheadranger
13_mrrobertsscrapbook_02b_b-askladycarson
13_mrrobertsscrapbook_02c_c-askarcheologist
13_mrrobertsscrapbook_02d_d-askbarbie
13_mrrobertsscrapbook_03_askfriendsorreturn
13_mrrobertsscrapbook_05_takegroupphoto
14_epilogue_01_speaktobarbie

vars.Missions = new Dictionary<string, string> {
		{ "01_gameintro_01_headtostables",               "Welcome To Canterbury Trails" },
		{ "02_scenicphotography101_01_findmrroberts",    "Scenic Photography 101" },
		{ "03_headrangertrailmarking_01_speaktoranger",  "Trailmarking 101" },
		{ "04_archeology101_01_speaktodrpotts",          "Archeology 101" },
		{ "05_headrangerphoto_01_speaktoranger",         "Wildlife Photography 101" },
		{ "06_ladycarsonrace_01_speaktoladycarson",      "Horse Race" },
		{ "07_secondartifact_01_speaktodrpotts",         "Mystery Horse: Second Artifact" },
		{ "08_backpackquest_01_speaktogeorge",           "Backpack Quest" },
		{ "09_accessorycollection_01_speaktoladycarson", "Website Quest" },
		{ "10_thirdartifact_01_speaktodrpotts",          "Silver Canyon Mustang: The Final Artifact" },
		{ "11_findmysteryhorse_01_speaktodrpotts",       "Silver Canyon Mustang: The Thrilling Conclusion" },
		{ "12_completeapplication_01_speaktoranger",     "Packet Progress" },
		{ "13_mrrobertsscrapbook_01_speaktomrroberts",   "Golden Moments" },
		{ "14_epilogue_01_speaktobarbie",                "Best Friends Forever" }
	};
*/