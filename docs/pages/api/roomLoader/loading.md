# Loading

This section covers loading room contents - the core functionality of the library.

GMRoomLoader can load [full rooms](#full-rooms) with all their layers and elements at any position and :Origin:, with optional filtering by :Asset Type: and/or :Layer Name:. 

It can also load only specific parts of rooms, such as [Instances](#loadinstances) or [Tilemaps](#loadtilemap), and apply optional scaling, mirroring, flipping and rotation transformations.

::: danger IMPORTANT
Rooms can only be loaded if their data has been initialized. Make sure to [Initialize](/pages/api/roomLoader/data/#initialization) the data for any room you intend to load beforehand, or the game will crash.
:::

## Full Rooms

### Coverage

Full room loading supports the following elements.

| Element | Layer Type | Status |
|---|---|---|
| Instance | Instance | ✔️ |
| Tilemap | Tile | ✔️ |
| Sprite | Asset | ✔️ |
| Particle System | Asset | 🚧 Broken because of a GM bug |
| Sequence | Asset | ✔️ |
| Background | Background | ✔️ |
| Filter/Effect | Filter/Effect   | ❌ |
| In-layer Filter/Effect | Any | 🚧 Missing :room_get_info(): data |
| Creation Code | - | ✔️ |
| Views | - | ❌ |
| Physics | - | ❌ |
| Display Buffer & Viewport Clearing | - | ❌ |

---
### `.Load()`

> `RoomLoader.Load(room, x, y, [xOrigin], [yOrigin], [flags])` ➜ :Struct:.:Payload: or :Undefined:

Loads the given room at the given coordinates and origin, filtered by the given flags.

* If [ROOMLOADER_DELIVER_PAYLOAD](/pages/api/config/#roomloader-deliver-payload) is `true`, returns an instance of :Payload:.
* Otherwise returns :Undefined:.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to load |
| `x` | :Real: | The x coordinate to load the room at |
| `y` | :Real: | The y coordinate to load the room at |
| `[xOrigin]` | :Real: | The x origin to load the room at [Default: :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y origin to load the room at [Default: :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags to filter the loaded data by [Default: :ROOMLOADER_DEFAULT_FLAGS:] |

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
payload = RoomLoader.Load(rmLevelCliffs, room_width, room_height, 1, 1, _flags); // [!code highlight]
```
:::

---
### `.LoadExt()` [COMING SOON]

> `RoomLoader.LoadExt(room, x, y, xScale, yScale, angle, [xOrigin], [yOrigin], [flags])` ➜ :Struct:.:Payload: or :Undefined:

Loads the given room at the given coordinates, scale, angle and origin, filtered by the given flags.

Coming Soon:tm:

## Individual Parts
---
### `.LoadInstances()`

> `RoomLoader.LoadInstances(room, x, y, layerOrDepth, [xOrigin], [yOrigin], [xScale], [yScale], [angle], [multScale])` ➜ :Array: of :Id.Instance:

Loads all instances from the given room at the given coordinates and origin, with optional scaling and rotation transformations.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to load instances from |
| `x` | :Real: | The x coordinate to load instances at |
| `y` | :Real: | The y coordinate to load instances at |
| `layerOrDepth` | :Id.Layer: or :String: or :Real: | The layer ID, layer name, or depth to create instances on |
| `[xOrigin]` | :Real: | The x origin to load the room at [Default: :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y origin to load the room at [Default: :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[xscale]` | :Real: | The horizontal scale transformation |
| `[yscale]` | :Real: | The vertical scale transformation |
| `[angle]` | :Real: | The angle transformation |
| `[multScale]` | :Bool: | Scale instances with `xScale/yScale`? [Default: [ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE](/pages/api/config/#roomloader-instances-default-mult-scale)] |
| `[addAngle]` | :Bool: | Rotate instances with `angle`? [Default: [ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE](/pages/api/config/#roomloader-instances-default-add-angle)] |

:::code-group
```js [Examples]
// Loads instances from rmLevelPartBottom at the bottom-right corner of the room:
RoomLoader.LoadInstances(rmLevelPartBottom, room_width, room_height, depth, 1, 1); // [!code highlight]

// Loads a layout of props to fill the size of the current room, while keeping instance scale unaffected:
var _room = rmProps;
var _xscale = room_width / RoomLoader.DataGetWidth(_room);
var _yscale = room_height / RoomLoader.DataGetHeight(_room);
RoomLoader.LoadInstances(_room, 0, 0, depth, _xscale, _yscale, 0, false); // [!code highlight]

// Loads a random arrangement of collectibles randomly rotated at the center of the room:
var _room = choose(rmCollectibles01, rmCollectibles02, rmCollectibles03);
var _x = room_width / 2;
var _y = room_height / 2;
var _angle = random(360);
RoomLoader.LoadInstances(_room, _x, _y, depth,,, _angle); // [!code highlight]

// Loads a random enemy layout in front of the player and stores their IDs in the loadedEnemies array:
var _room = script_execute_ext(choose, enemyLayoutRooms);
var _offset = 200;
var _x = objPlayer.x + lengthdir_x(_offset, objPlayer.angle);
var _y = objPlayer.y + lengthdir_y(_offset, objPlayer.angle);
var _angle = objPlayer.angle - 90;
loadedEnemies = RoomLoader.LoadInstances(_room, _x, _y, depth,,, _angle); // [!code highlight]
```
:::

---
### `.LoadTilemap()`

> `RoomLoader.LoadTilemap(room, x, y, sourceLayerName, targetLayer, [xOrigin], [yOrigin], [mirror], [flip], [angle], [tileset])` ➜ :Id.Tilemap:

Loads a tilemap from the given room and source layer at the given coordinates and origin. The tilemap is created on the target layer with optional mirroring, flipping and rotation transformations, and tileset.

* The loaded tilemap is rotated first, then mirrored and flipped.
* Angle is internally wrapped around 360 degrees and snapped to a 90-degree increment.

#### Custom Tilesets
The optional `[tileset]` parameter can be especially useful for loading:
* The same layout of tiles with different skins based on the current biome or dimension.
* A visual + collision pair of tilemaps. Great for tiles with perspective or detailing that doesn't match with collision 1:1.

When using such tileset groups/pairs, make sure that tiles on both tilesets are perfectly aligned, or you'll get a mess of misplaced tiles.

:::code-group
```js [Examples]
// Loads a tilemap from the "TilesFloor" layer in rmCasinoDetails,
// creates it in the centered in the room on the layer with the same name,
// and randomly mirrors and flips it:
var _x = room_width / 2;
var _y = room_height / 2;
var _layer = "TilesFloor";
var _mirror = choose(true, false);
var _flip = choose(true, false);
floorTilemap = RoomLoader.LoadTilemap(rmCasinoDetails, _x, _y, _layer, _layer, 0.5, 0.5, _mirror, _flip); // [!code highlight] 

// Loads a tilemap from the "WallsLayout" layer in rmLayoutHard on the "Walls" layer,
// using a custom tileset based on the current dimension and rotates it randomly:
var _tileset = DIMENSIONS.GetCurrent().GetWallsTileset();
var _angle = random(360);
tilemap = RoomLoader.LoadTilemap(rmLayoutHard, 0, 0, "WallsLayout", "Walls", 0, 0, false, false, _angle_, _tileset); // [!code highlight]

// Loads a tilemap from the "TilesWalls" layer in rmChunkSpecial01,
// creates it on the newly created collision layer, assigns the tsWallsCollision tileset to it
// and stores its ID in the collisionTilemap variable:
collisionLayer = layer_create(0, "Collision");
collisionTilemap = RoomLoader.LoadTilemap(rmChunkSpecial01, 0, 0, "TilesWalls", collisionLayer, 0, 0, false, false, 0, tsWallsCollision); // [!code highlight]
```
:::