/// @feather ignore all

#macro __ROOM_LOADER_LAYER_PREFIX "____room_loader____"

enum ROOM_LOADER_FLAG {
	NONE = 0,
	INSTANCES = 1,
	SPRITES = 2,
	TILEMAPS = 4,
	ALL = (ROOM_LOADER_FLAG.INSTANCES | ROOM_LOADER_FLAG.SPRITES | ROOM_LOADER_FLAG.TILEMAPS),
}

function __room_loader_noop() {}
