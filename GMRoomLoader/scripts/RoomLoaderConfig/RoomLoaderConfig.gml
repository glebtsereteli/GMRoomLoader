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

// If true, RoomLoader.Load() returns a RoomLoaderReturnData instance containing the IDs of all loaded elements.
// If false, no IDs are collected or returned, improving loading performance.
// 
// NOTE: Set this to false if you don't need to manually clean up loaded contents.
// e.g. When room switching automatically destroys all instances, layers and assets.
#macro ROOMLOADER_USE_RETURN_DATA true

// When loading rooms using RoomLoader.Load(), whether to merge loaded layers with existing ones (true)
// or keep them separate (false).
//
// If true: when loading a layer, its contents will be merged into an existing layer with the same name.
// If no matching layer exists, a new one will be created.
// 
// If false: a new layer is always created, even if a layer with the same name already exists.
// 
// WARNING: Enabling this may result in layers shared between elements loaded from multiple rooms to be
// unintentionally destroyed during RoomLoaderReturnData.cleanup().
#macro ROOMLOADER_MERGE_LAYERS false

// Whether to initialize room parameters for loaded instances (true) or not (false).
// 
// NOTE: Setting this to false improves loading performance.
#macro ROOMLOADER_INSTANCES_USE_ROOM_PARAMS true

// Whether to run Creation Code for loaded instances (true) or not (false).
// 
// NOTE: Setting this to false improves loading performance.
#macro ROOMLOADER_INSTANCES_RUN_CREATION_CODE true

// When loading instances using RoomLoader.LoadInstances(), whether to multiply individual instance scale
// by the overall load scale (true) or not (false).
// 
// NOTE: This comes into play only when loading instances with a custom (not 1) scale.
#macro ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE true

// When loading instances using RoomLoader.LoadInstances(), whether to combine individual instance angle
// with the overall load angle (true) or not (false).
// 
// NOTE: This comes into play only when loading instances with a custom (not 0) angle.
#macro ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE true

// Whether to pause loaded sequences (true) or not (false).
#macro ROOMLOADER_SEQUENCES_PAUSE false

/* [@FIX] GM bug, currently broken.
// Steps to progress loaded particle systems by.
// 
// NOTE: Increasing this value reduces loading performance.
#macro ROOMLOADER_PARTICLE_SYSTEMS_STEPS 0
*/

// Whether to run the Creation Code for loaded rooms (true) or not (false).
#macro ROOMLOADER_ROOMS_RUN_CREATION_CODE true
