/// @feather ignore all

enum ROOM_LOADER_FLAG {
	NONE = 0,
	INSTANCES = 1,
	SPRITES = 2,
	TILEMAPS = 4,
	PARTICLE_SYSTEMS = 8,
	ALL = (ROOM_LOADER_FLAG.INSTANCES | ROOM_LOADER_FLAG.SPRITES | ROOM_LOADER_FLAG.TILEMAPS | ROOM_LOADER_FLAG.PARTICLE_SYSTEMS),
}
enum ROOM_LOADER_ORIGIN {
	TOP_LEFT, TOP_CENTER, TOP_RIGHT,
	MIDDLE_LEFT, MIDDLE_CENTER, MIDDLE_RIGHT,
	BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT,
}

function __room_loader_noop() {}
function __room_loader_get_offset_x(_x, _width, _origin) {
	static _offsets = [
		+0.0, -0.5, -1.0,
		+0.0, -0.5, -1.0,
		-0.0, -0.5, -1.0,
	];
	return (_x + (_width * _offsets[_origin]));
}
function __room_loader_get_offset_y(_y, _height, _origin) {
	static _offsets = [
		+0.0, +0.0, +0.0,
		-0.5, -0.5, -0.5,
		-1.0, -1.0, -1.0,
	];
	return (_y + (_height * _offsets[_origin]));
}
