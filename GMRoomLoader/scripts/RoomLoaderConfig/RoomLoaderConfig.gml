/// @feather ignore all

#macro ROOMLOADER_LAYER_PREFIX					"__roomloader__"			// String prefix added to RoomLoader-created layers.
#macro ROOMLOADER_DEFAULT_ORIGIN				ROOMLOADER_ORIGIN.TOP_LEFT	// Default origin used by RoomLoader's load methods.
#macro ROOMLOADER_DEFAULT_FLAGS					ROOMLOADER_FLAG.CORE		// Default flags used by RoomLoader's load methods.
#macro ROOMLOADER_INSTANCE_USE_ROOM_PARAMS		true						// Whether to use loaded instances' room parameters (true) or not (false).
#macro ROOMLOADER_INSTANCE_RUN_CREATION_CODE	true						// Whether to run loaded instances' Creation Code (true) or not (false).
#macro ROOMLOADER_SEQUENCES_PAUSE				false						// Whether to pause loaded sequences (true) or not (false).
#macro ROOMLOADER_PARTICLE_SYSTEMS_STEPS		0							// Steps to progress loaded particle systems by. NOTE: this will affect performance.
#macro ROOMLOADER_ROOM_RUN_CREATION_CODE		true						// Whether to run the loaded room's Creation Code (true) or not (false).
