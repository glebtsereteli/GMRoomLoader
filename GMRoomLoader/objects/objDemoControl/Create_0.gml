
randomize();
texture_prefetch("Default");

DEMOS = new Demos();
DEMOS.Init();

RoomLoader.LoadTilemap(rmDemoGeneral01, room_width / 2, room_height / 2, "TilesMid", layer, 0.5, 0.5);
