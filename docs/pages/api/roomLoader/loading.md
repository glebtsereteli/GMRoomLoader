# Loading

> [!Important]
> Loading is only possible for rooms with initialized data. Make sure that data [initialization](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-initialization) is performed **before** utilizing the following functions.

## `.Load()`

> `RoomLoader.Load(room, x, y, [xorigin], [yorigin], [flags])` ➜ :Struct:.:ReturnData: or :Undefined:

Loads the given room at the given coordinates and origin, filtered by the given flags.

* If [ROOMLOADER_USE_RETURN_DATA](/pages/api/config/#roomloader-use-return-data) is `true`, returns an instance of :ReturnData:.
* Otherwise returns :Undefined:.

| Parameter   | Type                    | Description & Default                                                        |
| ----------- | ----------------------- | -----------------------------------------------------------------------------|
| `room`      | :Asset.GMRoom:          | The room to load                                                             |
| `x`         | :Real:                  | The x coordinate to load the room at                                         |
| `y`         | :Real:                  | The y coordinate to load the room at                                         |
| `[xorigin]` | :Real:                  | The x origin to load the room at. Default = :ROOMLOADER_DEFAULT_XORIGIN:     |
| `[yorigin]` | :Real:                  | The y origin to load the room at. Default = :ROOMLOADER_DEFAULT_YORIGIN:     |
| `[flags]`   | :Enum:.ROOMLOADER_FLAG: | The flags to filter the loaded data by. Default = :ROOMLOADER_DEFAULT_FLAGS: |

:::code-group
```js [Examples]
// Loads rmLevelCastle at arbitrary coordinates:
RoomLoader.Load(rmLevelCastle, someX, someY);

// Loads rmLevelForest centered in the room: 
var _x = room_width / 2;
var _y = room_height / 2;
RoomLoader.Load(rmLevelForest, _x, _y, 0.5, 0.5);

// Loads rmLevelCliff's Sprites and Tilemaps at the bottom-right corner of the room
// and stores the returned instance of ReturnData in a variable to be cleaned up later:
var _flags = ROOMLOADER_FLAG.SPRITES | ROOMLOADER_FLAG.TILEMAPS;
data = RoomLoader.Load(rmLevelCliffs, room_width, room_height, 1, 1, _flags);
```
:::

## `.LoadInstances()`
