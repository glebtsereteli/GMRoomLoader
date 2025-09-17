/// @feather ignore all

#region General

// Whether to show debug messages in Output (true) or not (false).
#macro ROOMLOADER_ENABLE_DEBUG true

// Default X origin used in Loading and Screenshotting.
// Origins range from 0 to 1: 0 is left, 0.5 is center, 1 is right.
#macro ROOMLOADER_DEFAULT_XORIGIN 0

// Default Y origin used in Loading and Screenshotting.
// Origins range from 0 to 1: 0 is top, 0.5 is center, 1 is bottom.
#macro ROOMLOADER_DEFAULT_YORIGIN 0

// Default flags used in Loading and Screenshotting.
#macro ROOMLOADER_DEFAULT_FLAGS ROOMLOADER_FLAG.CORE

// When Loading rooms using RoomLoader.Load(), whether to merge loaded layers with existing ones (true)
// or keep them separate (false).
//
// If true: when Loading a layer, its contents will be merged into an existing layer with the same name.
// If no matching layer exists, a new one will be created.
// 
// If false: a new layer is always created, even if a layer with the same name already exists.
// 
// WARNING: Enabling this may cause shared layers from multiple rooms to be unintentionally destroyed during
// payload.Cleanup().
#macro ROOMLOADER_MERGE_LAYERS false

// If true, RoomLoader.Load() returns a RoomLoaderPayload instance containing the IDs of all loaded layers and their elements.
// If false, no IDs are collected or returned, improving Loading performance.
// 
// NOTE: Set this to false if you don't need to manually clean up loaded contents.
// e.g. When room switching automatically destroys all instances, layers and assets.
#macro ROOMLOADER_DELIVER_PAYLOAD true

#endregion
#region Instances

// Whether to initialize room parameters for loaded instances (true) or not (false).
// 
// NOTE: Setting this to false improves Loading performance.
#macro ROOMLOADER_INSTANCES_USE_ROOM_PARAMS true

// Whether to run Creation Code for loaded instances (true) or not (false).
// 
// NOTE: Setting this to false improves Loading performance.
#macro ROOMLOADER_INSTANCES_RUN_CREATION_CODE true

#endregion
