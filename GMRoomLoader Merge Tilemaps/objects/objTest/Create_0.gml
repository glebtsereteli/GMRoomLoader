
font_enable_effects(fntTest, true, {
	outlineEnable: true,
	outlineDistance: 2,
	outlineColour: c_black,
});

RoomLoader.DataInit(rmTestBase);
tilemap = RoomLoader.LoadTilemap(rmTestBase, 0, 0, "Tiles");
