
randomize();
texture_prefetch("Default");

DEMOS = new Demos();
DEMOS.Init();

RoomLoader.DataInit(rmTilemapTest);
//RoomLoader.LoadTilemap(rmTilemapTest, 100 + 000, 100, "Test", layer, false, false, 0);
//RoomLoader.LoadTilemap(rmTilemapTest, 100 + 320, 100, "Test", layer, false, false, 90);
//RoomLoader.LoadTilemap(rmTilemapTest, 100 + 640, 100, "Test", layer, false, false, 180);
//RoomLoader.LoadTilemap(rmTilemapTest, 100 + 960, 100, "Test", layer, false, false, 270);

RoomLoader.LoadTilemap(rmTilemapTest, 600, 300, "Test", layer, false, false, -90, TileSet3_1);
