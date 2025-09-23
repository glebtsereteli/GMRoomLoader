
font_enable_effects(fntTest, true, {
	outlineEnable: true,
	outlineDistance: 2,
	outlineColour: c_black,
});

RoomLoader.DataInitAll([room]);
hostTilemap = RoomLoader.LoadTilemap(rmTestHost, 0, 0, "Tiles");

loadedTilemap = undefined;
