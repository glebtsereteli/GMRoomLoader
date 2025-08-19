# Loading

::: danger IMPORTANT
Rooms can only be loaded if their data has been initialized. Make sure to [initialize](/pages/api/roomLoader/data/#initialization) the data for any room you intend to load beforehand, or the game will crash.
:::

## `.Load()`

> `RoomLoader.Load(room, x, y, [xorigin], [yorigin], [flags])` ➜ :Struct:.:Payload: or :Undefined:

Loads the given room at the given coordinates and origin, filtered by the given flags.

* If [ROOMLOADER_DELIVER_PAYLOAD](/pages/api/config/#roomloader-use-return-data) is `true`, returns an instance of :Payload:.
* Otherwise returns :Undefined:.

| Parameter   | Type                     | Description                                                                  |
|-------------|--------------------------|------------------------------------------------------------------------------|
| `room`      | :Asset.GMRoom:           | The room to load                                                             |
| `x`         | :Real:                   | The x coordinate to load the room at                                         |
| `y`         | :Real:                   | The y coordinate to load the room at                                         |
| `[xorigin]` | :Real:                   | The x origin to load the room at. Default = :ROOMLOADER_DEFAULT_XORIGIN:     |
| `[yorigin]` | :Real:                   | The y origin to load the room at. Default = :ROOMLOADER_DEFAULT_YORIGIN:     |
| `[flags]`   | :Enum:.:ROOMLOADER_FLAG: | The flags to filter the loaded data by. Default = :ROOMLOADER_DEFAULT_FLAGS: |

:::code-group
```js [Examples]
// Loads rmLevelCastle at arbitrary coordinates:
RoomLoader.Load(rmLevelCastle, someX, someY);

// Loads rmLevelForest centered in the room: 
var _x = room_width / 2;
var _y = room_height / 2;
RoomLoader.Load(rmLevelForest, _x, _y, 0.5, 0.5);

// Loads rmLevelCliff's Sprites and Tilemaps at the bottom-right corner of the room
// and stores the returned instance of Payload in a variable to be cleaned up later:
var _flags = ROOMLOADER_FLAG.SPRITES | ROOMLOADER_FLAG.TILEMAPS;
roomPayload = RoomLoader.Load(rmLevelCliffs, room_width, room_height, 1, 1, _flags);
```
:::

## `.LoadInstances()`
