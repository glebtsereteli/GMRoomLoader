
if (keyboard_check_pressed(ord("1"))) {
	var _x = x + (TILE_SIZE * -5);
	var _y = y + (TILE_SIZE * -1);
	RoomLoader.LoadTilemap(rmTestLoad, _x, _y, "Tiles");
	hostTilemap = layer_tilemap_get_id("Tiles");
}
if (keyboard_check_pressed(ord("2"))) {
	var _x = x + (TILE_SIZE * 11);
	var _y = y + (TILE_SIZE * 7);
	RoomLoader.LoadTilemap(rmTestLoad, _x, _y, "Tiles");
	hostTilemap = layer_tilemap_get_id("Tiles");
}
