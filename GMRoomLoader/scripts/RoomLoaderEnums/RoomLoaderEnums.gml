/// @feather ignore all

enum ROOMLOADER_FLAG {
	NONE = 0,
	INSTANCES = 1,
	SPRITES = 2,
	TILEMAPS = 4,
	PARTICLE_SYSTEMS = 8,
	SEQUENCES = 16,
	BACKGROUNDS = 32,
	
	CORE = (ROOMLOADER_FLAG.INSTANCES | ROOMLOADER_FLAG.SPRITES | ROOMLOADER_FLAG.TILEMAPS),
	EXTENDED = (ROOMLOADER_FLAG.PARTICLE_SYSTEMS | ROOMLOADER_FLAG.SEQUENCES | ROOMLOADER_FLAG.BACKGROUNDS),
	ALL = (ROOMLOADER_FLAG.CORE | ROOMLOADER_FLAG.EXTENDED),
}
enum ROOMLOADER_ORIGIN {
	TOP_LEFT, TOP_CENTER, TOP_RIGHT,
	MIDDLE_LEFT, MIDDLE_CENTER, MIDDLE_RIGHT,
	BOTTOM_LEFT, BOTTOM_CENTER, BOTTOM_RIGHT,
}
