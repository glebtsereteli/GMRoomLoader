/// @feather ignore all

// Whether to show debug messages in Output (true) or not (false).
#macro ROOMLOADER_ENABLE_DEBUG true

// Default origins used by RoomLoader's loading and screenshotting.
// Origins range from 0 to 1 (full size).
// For x: 0 is left, 0.5 is center, 1 is right.
// For y: 0 is top, 0.5 is center, 1 is bottom.
#macro ROOMLOADER_DEFAULT_XORIGIN 0
#macro ROOMLOADER_DEFAULT_YORIGIN 0

// Default flags used by RoomLoader's load methods.
#macro ROOMLOADER_DEFAULT_FLAGS ROOMLOADER_FLAG.CORE

// Whether to merge loaded layers with existing ones (true) not (false).
// When loading a room layer, if a layer with the same name exists,
// the contents of the loaded layer will be merged into the existing layer.
// If no such layer exists, a new one will be created.
// WARNING: Enabling this may cause shared layers to be destroyed during ReturnData cleanup.
#macro ROOMLOADER_MERGE_LAYERS false

// Whether to initialize room parameters for loaded instances (true) or not (false).
// NOTE: setting this to false improves loading performance at scale.
#macro ROOMLOADER_INSTANCES_USE_ROOM_PARAMS true

// Whether to run Creation Code for loaded instances (true) or not (false).
// NOTE: setting this to false improves loading performance at scale.
#macro ROOMLOADER_INSTANCES_RUN_CREATION_CODE true

 // Whether to pause loaded sequences (true) or not (false).
#macro ROOMLOADER_SEQUENCES_PAUSE false

// Steps to praogress loaded particle systems by. 
// NOTE: increasing this value negatively affects loading performance.
#macro ROOMLOADER_PARTICLE_SYSTEMS_STEPS 0

// Whether to run the Creation Code for loaded rooms (true) or not (false).
#macro ROOMLOADER_ROOMS_RUN_CREATION_CODE true
