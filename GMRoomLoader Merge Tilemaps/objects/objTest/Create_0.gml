
font_enable_effects(fntTest, true, {
	outlineEnable: true,
	outlineDistance: 2,
	outlineColour: c_black,
});

x = TILE_SIZE * 8;
y = TILE_SIZE * 2;

RoomLoader.DataInitAll([room]);
hostTilemap = RoomLoader.LoadTilemap(rmTestHost, x, y, "Tiles");
