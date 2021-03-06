//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

/client/proc/show_distribution_map()
	set category = "Debug"
	set name = "Show Distribution Map"
	set desc = "Print the asteroid ore distribution map to the world."

	if(!holder)	return

	if(master_controller && master_controller.asteroid_ore_map)
		master_controller.asteroid_ore_map.print_distribution_map()

/client/proc/remake_distribution_map()
	set category = "Debug"
	set name = "Remake Distribution Map"
	set desc = "Rebuild the asteroid ore distribution map."

	if(!holder)	return

	if(master_controller && master_controller.asteroid_ore_map)
		master_controller.asteroid_ore_map = new /datum/ore_distribution()
		master_controller.asteroid_ore_map.populate_distribution_map()

/client/proc/restart_controller(controller in list("Master","Failsafe","Supply"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	usr = null
	src = null
	switch(controller)
		if("Master")
			new /datum/controller/game_controller()
			master_controller.process()
			feedback_add_details("admin_verb","RMC")
		if("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")
		if("Supply")
			supply_controller.process()
			feedback_add_details("admin_verb","RSupply")
	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")
	return


/client/proc/debug_controller(controller in list("Master","failsafe","Ticker","Air","Jobs","Sun","Radio","Supply","Shuttles","Emergency Shuttle","Configuration","pAI", "Cameras","Garbage", "Transfer Controller","Event","Scheduler"))
	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
			feedback_add_details("admin_verb","DMC")
		if ("failsafe")
			debug_variables(failsafe)
			feedback_add_details("admin_verb", "dfailsafe")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Air")
			debug_variables(air_master)
			feedback_add_details("admin_verb","DAir")
		if("Jobs")
			debug_variables(job_master)
			feedback_add_details("admin_verb","DJobs")
		if("Sun")
			debug_variables(sun)
			feedback_add_details("admin_verb","DSun")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Supply")
			debug_variables(supply_controller)
			feedback_add_details("admin_verb","DSupply")
		if("Shuttles")
			debug_variables(shuttle_controller)
			feedback_add_details("admin_verb","DShuttles")
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
			feedback_add_details("admin_verb","DEmergency")
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("pAI")
			debug_variables(paiController)
			feedback_add_details("admin_verb","DpAI")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Event")
			debug_variables(event_manager)
			feedback_add_details("admin_verb","DEvent")
		if("Garbage")
			debug_variables(garbageCollector)
			feedback_add_details("admin_verb","DGarbage")
		if("Scheduler")
			debug_variables(processScheduler)
			feedback_add_details("admin_verb","DprocessScheduler")

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
	return
