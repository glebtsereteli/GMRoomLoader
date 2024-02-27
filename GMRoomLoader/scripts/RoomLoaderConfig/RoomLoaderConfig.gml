/// @feather ignore all

#macro ROOMLOADER_LAYER_PREFIX					"__roomloader__"			// String prefix added to RoomLoader-created layers.
#macro ROOMLOADER_DEFAULT_ORIGIN				ROOMLOADER_ORIGIN.TOP_LEFT	// Default origin used by RoomLoader's load methods.
#macro ROOMLOADER_DEFAULT_FLAGS					ROOMLOADER_FLAG.CORE		// Default flags used by RoomLoader's load methods.
#macro ROOMLOADER_INSTANCES_USE_ROOM_PARAMS		true						// Whether to initialize room parameters for loaded instances (true) or not (false). NOTE: setting this to false improves loading performance at scale.
#macro ROOMLOADER_INSTANCES_RUN_CREATION_CODE	true						// Whether to run Creation Code for loaded instances (true) or not (false). NOTE: setting this to false improves loading performance at scale.
#macro ROOMLOADER_SEQUENCES_PAUSE				false						// Whether to pause loaded sequences (true) or not (false).
#macro ROOMLOADER_PARTICLE_SYSTEMS_STEPS		0							// Steps to progress loaded particle systems by. NOTE: increasing this value negatively affects loading performance.
#macro ROOMLOADER_ROOMS_RUN_CREATION_CODE		true						// Whether to run the Creation Code for loaded rooms (true) or not (false).
