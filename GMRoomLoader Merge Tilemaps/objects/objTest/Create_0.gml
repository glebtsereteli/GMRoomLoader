
x = TILE_SIZE * 16;
y = TILE_SIZE * 4;

RoomLoader.DataInitAll([room]);
hostTilemap = RoomLoader.LoadTilemap(rmTestHost, x, y, "Tiles");

screenshot = RoomLoader.MiddleCenter().Screenshot(rmTestLoad);

placing = false;
angle = 0;
