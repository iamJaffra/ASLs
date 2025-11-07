state("scummvm") {}

startup {
	Assembly.Load(File.ReadAllBytes("Components/scummvm-help")).CreateInstance("Mohawk_Riven");

	vars.TimerModel = new TimerModel { CurrentState = timer };

#region Settings
	var cat = "BestEnding";
	settings.Add(cat, false, "Best Ending splits");

	settings.Add(cat + "_Temple->Jungle",     true, "Travel from Temple Island to Jungle Island.",           cat);
	settings.Add(cat + "_ExitJungleElevator", true, "Go back down the whark statue elevator.",               cat);
	settings.Add(cat + "_Village",            true, "Enter the submarine.",                                  cat);
	settings.Add(cat + "_Gallows",            true, "Go up the gallows.",                                    cat);
	settings.Add(cat + "_Jungle->Tay",        true, "Link to Tay.",                                          cat);
	settings.Add(cat + "_Jungle->Boiler",     true, "Travel from Jungle Island to Boiler Island.",           cat);
	settings.Add(cat + "_ReadGehnsJournal",   true, "Read Gehn's Journal.",                                  cat);
	settings.Add(cat + "_ReachWaffle",        true, "Arrive at the Waffle Maker.",                           cat);
	settings.Add(cat + "_Power",              true, "Power up the domes.",                                   cat);
	settings.Add(cat + "_ReachTempleDome",    true, "Arrive at the Temple Island dome.",                     cat);
	settings.Add(cat + "_CallGehn",           true, "Call Gehn.",                                            cat);
	settings.Add(cat + "_TrapGehn",           true, "Trap Gehn.",                                            cat);
	settings.Add(cat + "_ReachPrisonDome",    true, "Return to the Prison Island dome.",                     cat);
	settings.Add(cat + "_EnterPrisonDome",    true, "Enter the Prison Island dome",                          cat);
	settings.Add(cat + "_Fissure",            true, "Open the fissure.",                                     cat);

	cat = "BadEnding";
	settings.Add(cat, false, "Bad Ending splits");

	settings.Add(cat + "_Temple->Jungle",     true, "Travel from Temple Island to Jungle Island.",           cat);
	settings.Add(cat + "_ExitJungleElevator", true, "Go back down the whark statue elevator.",               cat);
	settings.Add(cat + "_Village",            true, "Enter the submarine.",                                  cat);
	settings.Add(cat + "_Gallows",            true, "Go up the gallows.",                                    cat);
	settings.Add(cat + "_Jungle->Tay",        true, "Link to Tay.",                                          cat);
	settings.Add(cat + "_Jungle->Temple",     true, "Travel from Jungle Island to Temple Island.",           cat);
	settings.Add(cat + "_Fissure",            true, "Open the fissure.",                                     cat);

	cat = "ImpossibleEnding";
	settings.Add(cat, false, "Impossible Ending splits");

	settings.Add(cat + "_Fissure",            true, "Open the fissure.",                                     cat);
	
	cat = "Opera";
	settings.Add(cat, false, "Opera splits");

	settings.Add(cat + "_ExitMaglevTemple1",  true, "Exit the Maglev on Temple Island.",                     cat);
	settings.Add(cat + "_Egg",                true, "Leave the node containing the Egg hotspot.",            cat);
	settings.Add(cat + "_ExitMaglevTemple2",  true, "Exit the Maglev on Temple Island for the second time.", cat);
	settings.Add(cat + "_ExitJungleElevator", true, "Go back down the whark statue elevator.",               cat);
	settings.Add(cat + "_Gallows",            true, "Go up the gallows.",                                    cat);
	settings.Add(cat + "_Jungle->Tay",        true, "Link to Tay.",                                          cat);
	settings.Add(cat + "_ExitTunnel",         true, "Exit the rebel tunnel to Jungle Island.",               cat);
	settings.Add(cat + "_Sub",                true, "Leave the sub after the Sub easter egg.",               cat);
	settings.Add(cat + "_Jungle->Boiler",     true, "Travel from Jungle Island to Boiler Island.",           cat);
	settings.Add(cat + "_RAWA",               true, "Leave the node containing the RAWA hotspot.",           cat);
	settings.Add(cat + "_CallGehn",           true, "Call Gehn.",                                            cat);
	settings.Add(cat + "_TrapGehn",           true, "Trap Gehn.",                                            cat);
	settings.Add(cat + "_OSoleMio",           true, "Trigger O Sole Mio.",                                   cat);
#endregion
}

init {
	vars.ScummVM.Init();

	vars.IS64BIT = game.Is64Bit();
	vars.PTRSIZE = vars.IS64BIT ? 0x8 : 0x4;
	
	vars.ScummVM.TryLoad = (Func<dynamic, bool>)(svm => {
		svm["stack"] = svm.Watch<ushort>("_stack", "_id");
		svm["card"] = svm.Watch<ushort>("_card", "_id");

		svm["videos"] = vars.IS64BIT
			? svm.Watch<ulong>("_video")
			: svm.Watch<uint>("_video");
		
		var globalsDict = new Dictionary<string, string> {
			{ "aPower",        "power"          },
			{ "tTelescope",    "telescopePos"   }, 
			//{ "aDomeCombo",    "domeCombo"      },
			//{ "tCorrectOrder", "telescopeCombo" }, 
			//{ "pCorrectOrder", "prisonCombo"    },
		};
		
		var size = svm.Read<int>("_vars", "_mask");

		foreach (var global in globalsDict) {
			bool globalFound = false;

			for (int i = 0; i < size; i++) {
				string key = svm.ReadString("_vars", "_storage", i * vars.PTRSIZE, "_key");	

				if (global.Key == key) {
					svm[global.Value] = svm.Watch<int>("_vars", "_storage", i * vars.PTRSIZE, "_value");
					globalFound = true;
					print(global + " found");
				}
			}

			if (!globalFound) {
				print(global + " not found!");
				return false;
			}
		} 

		return true;
	});

	vars.Move = (Func<int, int, int, int, bool>)((oldStack, oldCard, currentStack, currentCard) => {
	return (vars.ScummVM["stack"].Old == oldStack) &&
	       (vars.ScummVM["card"].Old == oldCard) &&
	       (vars.ScummVM["stack"].Current == currentStack) &&
	       (vars.ScummVM["card"].Current == currentCard);
	});

	vars.completedSplits = new HashSet<string>();
	vars.triggeredEnding = false;
}

update {
	if (game.ReadPointer((IntPtr)vars.ScummVM.GEngine) == IntPtr.Zero) {
		return false;
	}

	vars.ScummVM.Update();
	
	// FINAL CUTSCENES
	if (current.telescopePos == 1 || (current.stack == 1 && current.card == 10)) {
		if (current.videos != 0) {
			var anchor = (IntPtr)current.videos + (int)vars.PTRSIZE;
			var next = game.ReadPointer((IntPtr)anchor + (int)vars.PTRSIZE);
			
			while (next != anchor) {
				var data = game.ReadPointer(next + 2 * (int)vars.PTRSIZE);

				var id = game.ReadValue<ushort>(data + 2 * (int)vars.PTRSIZE);
				var playing = game.ReadValue<bool>(data + 2 * (int)vars.PTRSIZE + 0xA);

				if ((id == 45 && playing && settings["BestEnding_Fissure"]      ) ||
				    (id == 47 && playing && settings["BadEnding_Fissure"]       ) ||
				    (id == 48 && playing && settings["ImpossibleEnding_Fissure"]) ||
				    (id ==  3 && playing && settings["Opera_OSoleMio"]          )) {
					if (!vars.triggeredEnding) {
						vars.TimerModel.Split();
						vars.triggeredEnding = true;
					}

					break;
				}
		
				next = game.ReadPointer(next + (int)vars.PTRSIZE);
			}
		}
	}
	
	// START/RESET
	if ((current.stack == 8 && old.card == 1 && current.card == 2) ||
	    (current.stack == 4 && old.card == 1 && current.card == 159)) {
		var phase = timer.CurrentPhase;
		bool startEnabled = settings.StartEnabled;
		bool resetEnabled = settings.ResetEnabled;
		
		if (phase == TimerPhase.NotRunning && startEnabled) {
			vars.TimerModel.Start();
		}
		else if (phase == TimerPhase.Running && resetEnabled) {
			vars.TimerModel.Reset();

			if (startEnabled) {
				vars.TimerModel.Start();
			}
		}
	}
}

reset { return false; }

start { return false; }

onStart {
	vars.completedSplits.Clear();
	vars.triggeredEnding = false;
}

split {
#region Best Ending
	if (settings["BestEnding"]) {
		if (settings["BestEnding_Temple->Jungle"] && vars.Move(4, 55, 7, 810)) {
			return true;
		}
		else if (settings["BestEnding_ExitJungleElevator"] && vars.Move(7, 361, 7, 392)) {
			return true;
		} 
		else if (settings["BestEnding_Village"] && vars.Move(7, 726, 7, 529)) {
			return true;
		}
		else if (settings["BestEnding_Gallows"] && vars.Move(7, 287, 7, 263)) {
			return true;
		} 
		else if (settings["BestEnding_Jungle->Tay"] && vars.Move(7, 227, 3, 3)) {
			return true;
		} 
		else if (settings["BestEnding_Jungle->Boiler"] && vars.Move(7, 609, 5, 1)) {
			return true;
		} 
		else if (settings["BestEnding_ReadGehnsJournal"] && vars.Move(5, 278, 5, 277) && vars.completedSplits.Add("ReadGehnsJournal")) {
			return true;
		} 
		else if (settings["BestEnding_ReachWaffle"] && vars.Move(4, 227, 4, 229) && vars.completedSplits.Add("ReachWaffle")) {
			return true;
		} 
		else if (settings["BestEnding_Power"] && old.power == 0 && current.power == 1) {
			return true;
		}
		else if (settings["BestEnding_ReachTempleDome"] && vars.Move(4, 389, 4, 392) && vars.completedSplits.Add("ReachTempleDome")) {
			return true;
		}
		else if (settings["BestEnding_CallGehn"] && vars.Move(1, 33, 1, 2)) {
			return true;
		} 
		else if (settings["BestEnding_TrapGehn"] && vars.Move(1, 2, 1, 7)) {
			return true;
		} 
		else if (settings["BestEnding_ReachPrisonDome"] && vars.Move(2, 2, 2, 42)) {
			return true;
		}
		else if (settings["BestEnding_EnterPrisonDome"] && vars.Move(2, 2, 2, 43)) {
			return true;
		}
	}
#endregion

#region Bad Ending
	if (settings["BadEnding"]) {
		if (settings["BadEnding_Temple->Jungle"] && vars.Move(4, 55, 7, 810)) {
			return true;
		}
		else if (settings["BadEnding_ExitJungleElevator"] && vars.Move(7, 361, 7, 392)) {
			return true;
		} 
		else if (settings["BadEnding_Village"] && vars.Move(7, 726, 7, 529)) {
			return true;
		}
		else if (settings["BadEnding_Gallows"] && vars.Move(7, 287, 7, 263)) {
			return true;
		} 
		else if (settings["BadEnding_Jungle->Tay"] && vars.Move(7, 227, 3, 3)) {
			return true;
		} 
		else if (settings["BadEnding_Jungle->Temple"] && vars.Move(7, 811, 4, 54)) {
			return true;
		} 
	}
#endregion

#region Opera
	if (settings["Opera"]) {
		if (settings["Opera_ExitMaglevTemple1"] && vars.Move(7, 810, 7, 809) && vars.completedSplits.Add("Opera_ExitMaglevTemple1")) {
			return true;
		}
		else if (settings["Opera_Egg"] && vars.Move(5, 257, 5, 256)) {
			return true;
		}
		else if (settings["Opera_ExitMaglevTemple2"] && vars.Move(7, 810, 7, 809) && vars.completedSplits.Add("Opera_ExitMaglevTemple2")) {
			return true;
		}
		else if (settings["Opera_ExitJungleElevator"] && vars.Move(7, 361, 7, 392)) {
			return true;
		}
		else if (settings["Opera_Gallows"] && vars.Move(7, 287, 7, 263)) {
			return true;
		}
		else if (settings["Opera_Jungle->Tay"] && vars.Move(7, 227, 3, 3)) {
			return true;
		}
		else if (settings["Opera_ExitTunnel"] && vars.Move(7, 191, 7, 187)) {
			return true;
		}
		else if (settings["Opera_Sub"] && vars.Move(7, 590, 7, 582)) {
			return true;
		}
		else if (settings["Opera_Jungle->Boiler"] && vars.Move(7, 30, 5, 248)) {
			return true;
		}
		else if (settings["Opera_RAWA"] && current.stack == 4 && old.card == 60 && current.card != 60) {
			return true;
		}
		else if (settings["Opera_CallGehn"] && vars.Move(1, 33, 1, 2)) {
			return true;
		}
		else if (settings["Opera_TrapGehn"] && vars.Move(1, 2, 1, 7)) {
			return true;
		}		
	}
#endregion
}