
if (keyboard_check_pressed(ord("1"))) {
	var _x = x + (TILE_SIZE * 8);
	var _y = y + (TILE_SIZE * 8);
	loadedTilemap = RoomLoader.LoadTilemap(rmTestLoad, _x, _y, "Tiles");
	hostTilemap = layer_tilemap_get_id("Tiles");
}
