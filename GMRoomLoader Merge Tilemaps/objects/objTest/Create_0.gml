
font_enable_effects(fntTest, true, {
	outlineEnable: true,
	outlineDistance: 2,
	outlineColour: c_black,
});

x = TILE_SIZE;
y = TILE_SIZE;

RoomLoader.DataInitAll([room]);
hostTilemap = RoomLoader.LoadTilemap(rmTestHost, x, y, "Tiles");

loadedTilemap = undefined;
