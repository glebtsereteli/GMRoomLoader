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
RoomLoader.Load(rmLevelCastle, someX, someY); // [!code highlight]

// Loads rmLevelForest centered in the room: 
var _x = room_width / 2;
var _y = room_height / 2;
RoomLoader.Load(rmLevelForest, _x, _y, 0.5, 0.5); // [!code highlight]

// Loads rmLevelCliff's Sprites and Tilemaps at the bottom-right corner of the room
// and stores the returned instance of Payload in a variable to be cleaned up later:
var _flags = ROOMLOADER_FLAG.SPRITES | ROOMLOADER_FLAG.TILEMAPS;
roomPayload = RoomLoader.Load(rmLevelCliffs, room_width, room_height, 1, 1, _flags); // [!code highlight]
```
:::

## `.LoadInstances()`

> `RoomLoader.LoadInstances(room, x, y, layerOrDepth, [xScale], [yScale], [angle], [multScale])` ➜ :Array: of :Id.Instance:

Loads all instances from the given room, with optional scaling and rotation transformations.

| Parameter | Type | Description |
|-----------|------|-------------|
| `room` | :Asset.GMRoom: | The room to load instances from |
| `x` | :Real: | The x coordinate to load instances at |
| `y` | :Real: | The y coordinate to load instances at |
| `layerOrDepth` | :Id.Layer: or :String: or :Real: | The layer ID, layer name, or depth to create instances on |
| `[xscale]` | :Real: | The horizontal scale transformation |
| `[yscale]` | :Real: | The vertical scale transformation |
| `[angle]` | :Real: | The angle transformation |
| `[multScale]` | :Bool: | Scale instances with `xscale/yscale`? [Default: `ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE`] |
| `[addAngle]` | :Bool: | Rotate instances with `angle`? [Default: `ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE`] |
| `xOrigin` | :Real: | The x origin to load the room at. [Default: `ROOMLOADER_DEFAULT_XORIGIN`] |
| `yOrigin` | :Real: | The y origin to load the room at. [Default: `ROOMLOADER_DEFAULT_YORIGIN`] |

:::code-group
```js [Examples]
// Loads instances from rmLevelPartBottom at the bottom-right corner of the room:
RoomLoader.LoadInstances(rmLevelPartBottom, room_width, room_height, depth,,,,,, 1, 1); // [!code highlight]

// Loads a layout of props to fill the size of the current room, while keeping instance scale unaffected:
var _room = rmProps;
var _xscale = room_width / RoomLoader.DataGetWidth(_room);
var _yscale = room_height / RoomLoader.DataGetHeight(_room);
RoomLoader.LoadInstances(rmProps, 0, 0, depth, _xscale, _yscale, 0, false); // [!code highlight]

// Loads a random arrangement of collectible randomly rotated at the center of the room:
var _room = choose(rmCollectibles01, rmCollectibles02, rmCollectibles03);
var _x = room_width / 2;
var _y = room_height / 2;
var _angle = random(360);
RoomLoader.LoadInstances(_room, _x, _y, depth,,, _angle); // [!code highlight]

// Loads a random enemy layout in front of the player and stores their IDs in the "loadedEnemies" array:
var _room = script_execute_ext(choose, enemyLayoutRooms);
var _offset = 200;
var _x = objPlayer.x + lengthdir_x(_offset, objPlayer.angle);
var _y = objPlayer.y + lengthdir_y(_offset, objPlayer.angle);
var _angle = objPlayer.angle - 90;
loadedEnemies = RoomLoader.LoadInstances(_room, _x, _y, depth,,, _angle); // [!code highlight]
```
:::

## `.LoadTilemap()`

> `RoomLoader.LoadTilemap(room, x, y, sourceLayer, [targetLayer], [tileset], [mirror], [flip], [angle])` ➜ :Id.Tilemap:

Coming soon:tm:
