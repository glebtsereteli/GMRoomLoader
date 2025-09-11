# Loading

This section covers loading room contents - the core functionality of the library.

GMRoomLoader can load [Full Rooms](#load) with all their layers and elements at any position, with optional :Origin:, scaling, rotation, filtering by :Asset Type: and/or :Layer Name:. 

It can also load [Instances](#loadinstances) and [Tilemaps](#loadtilemap) separately, also with optional transformation parameters.

::: danger IMPORTANT
Rooms can only be loaded if their data has been initialized. Make sure to [Initialize](/pages/api/roomLoader/data/#initialization) the data for any room you intend to load beforehand, or the game will crash.
:::

## `.Load()`

> `RoomLoader.Load(room, x, y, [xOrigin], [yOrigin], [flags], [xScale], [yScale], [angle], [multScale], [addAngle])` ➜ :Struct:.:Payload: or :Undefined:

Loads all layers and elements of the given room at the given coordinates, with optional :Origin:, :Asset Type: filtering, scaling and rotation.

Layers are created at the same depths defined in the Room Editor. See the [Payload/Depth](/pages/api/payload/depth) section if you need to adjust layer depths manually after loading to be above or below a certain layer/depth.

* If [ROOMLOADER_DELIVER_PAYLOAD](/pages/api/config/#roomloader-deliver-payload) is `true`, returns an instance of :Payload:.
* Otherwise returns :Undefined:.

::: details ℹ️ ROOM ELEMENT COVERAGE {closed}
Full room loading supports the following elements.

| Element | Layer Type | Status |
|---|---|---|
| Instance | Instance | ✔️ |
| Tilemap | Tile | ✔️ |
| Sprite | Asset | ✔️ |
| Particle System | Asset | 🚧 Broken, GM bug |
| Sequence | Asset | ✔️ |
| Background | Background | ✔️ |
| Filter/Effect | Filter/Effect   | ❌ |
| In-layer Filter/Effect | Any | 🚧 GM Bug, missing :room_get_info(): data |
| Creation Code | - | ✔️ |
| Views | - | ❌ |
| Physics | - | ❌ |
| Display Buffer & Viewport Clearing | - | ❌ |
:::
::: details ℹ️ TRANSFORMATION EXCEPTIONS {closed}
* Tilemaps only load if `[x/yScale]` is either `-1` or `1` and `[angle]` is an increment of 90 degrees. Otherwise they are ignored.
* Backgrounds only load if `[angle]` is `0`. Otherwise they are ignored.
:::

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to load |
| `x` | :Real: | The x coordinate to load the room at |
| `y` | :Real: | The y coordinate to load the room at |
| `[xOrigin]` | :Real: | The x :Origin: to load the room at [Default: :State.XOrigin: or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y :Origin: to load the room at [Default: :State.YOrigin: or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags to filter the loaded data by [Default: :State.Flags: or :ROOMLOADER_DEFAULT_FLAGS:] |
| `[xScale]` | :Real: | The horizontal scale to load the room at [Default: :State.XScale: or 1] |
| `[yScale]` | :Real: | The vertical scale to load the room at [Default: :State.YScale: or 1] |
| `[angle]` | :Real: | The angle to load the room at [Default: :State.Angle: or 0] |
| `[multScale]` | :Bool: | Scale elements with `xScale/yScale`? [Default: :State.MultScale: or [ROOMLOADER_DEFAULT_MULT_SCALE](/pages/api/config/#roomloader-default-mult-scale)] |
| `[addAngle]` | :Bool: | Rotate elements with `angle`? [Default: :State.AddAngle: or [ROOMLOADER_DEFAULT_ADD_ANGLE](/pages/api/config/#roomloader-default-add-angle)] |

:::code-group
```js [Basic]
// Loads rmLevelCastle at arbitrary coordinates:
RoomLoader.Load(rmLevelCastle, x, y); // [!code highlight]

// Loads rmLevelForest centered in the room: 
var _x = room_width / 2;
var _y = room_height / 2;
RoomLoader.Load(rmLevelForest, _x, _y, 0.5, 0.5); // [!code highlight]

// Loads rmLevelCliff's Sprites and Tilemaps at the bottom-right corner of the room
// and stores the returned instance of Payload in a variable to be cleaned up later:
var _flags = ROOMLOADER_FLAG.SPRITES | ROOMLOADER_FLAG.TILEMAPS;
payload = RoomLoader.Load(rmLevelCliffs, room_width, room_height, 1, 1, _flags); // [!code highlight]
```
```js [State]
// Loads rmLevelForest centered in the room: 
var _x = room_width / 2;
var _y = room_height / 2;
RoomLoader.MiddleCenter().Load(rmLevelForest, _x, _y); // [!code highlight]

// Loads rmLevelCliff's Sprites and Tilemaps at the bottom-right corner of the room
// and stores the returned instance of Payload in a variable to be cleaned up later:
payload = RoomLoader
.BottomRight().Sprites().Tilemaps()
.Load(rmLevelCliffs, room_width, room_height); // [!code highlight]
```
```js [Transformed]
// Loads rmExample stretched to fill the room:
RoomLoader
.XScale(room_width / RoomLoader.DataGetWidth(rmExample))
.YScale(room_height / RoomLoader.DataGetHeight(rmExample))
.Load(rmExample, 0, 0); // [!code highlight]

// Loads rmExample's instances randomly scaled and rotated:
RoomLoader
.Scale(random_range(0.8, 1.2)).Angle(random(360))
.Instances().Load(rmExample, x, y); // [!code highlight]

// Loads rmExample 4 times rotated around a point:
RoomLoader
.Angle(0).Load(rmExample, x, y) // [!code highlight]
.Angle(90).Load(rmExample, x, y) // [!code highlight]
.Angle(180).Load(rmExample, x, y) // [!code highlight]
.Angle(270).Load(rmExample, x, y); // [!code highlight]

// Loads rmExample mirrored and flipped in all 4 corners of the room:
RoomLoader
.Load(rmExample, 0, 0) // [!code highlight]
.Mirror().Load(rmExample, room_width, 0) // [!code highlight]
.Mirror().Flip().Load(rmExample, room_width, room_height) // [!code highlight]
.Flip().Load(rmExample, 0, room_height); // [!code highlight]
```
:::

## `.LoadInstances()`

> `RoomLoader.LoadInstances(room, x, y, layerOrDepth, [xOrigin], [yOrigin], [xScale], [yScale], [angle], [multScale], [addAngle])` ➜ :Array: of :Id.Instance:

Loads all instances from the given room at the given coordinates, with optional :Origin:, scaling and rotation.

Unlike :Full Room Loading:, all instances are placed onto the specified layer (or depth) instead of their original room layers.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to load instances from |
| `x` | :Real: | The x coordinate to load instances at |
| `y` | :Real: | The y coordinate to load instances at |
| `layerOrDepth` | :Id.Layer: or :String: or :Real: | The layer ID, layer name, or depth to create instances on |
| `[xOrigin]` | :Real: | The x :Origin: to load the room at [Default: :State.XOrigin: or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y :Origin: to load the room at [Default: :State.XOrigin: or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[xscale]` | :Real: | The horizontal scale transformation [Default: :State.XScale: or 1] |
| `[yscale]` | :Real: | The vertical scale transformation [Default: :State.YScale: or 1] |
| `[angle]` | :Real: | The angle transformation [Default: :State.Angle: or 0] |
| `[multScale]` | :Bool: | Scale instances with `xScale/yScale`? [Default: :State.MultScale: or [ROOMLOADER_DEFAULT_MULT_SCALE](/pages/api/config/#roomloader-instances-default-mult-scale)] |
| `[addAngle]` | :Bool: | Rotate instances with `angle`? [Default: :State.AddAngle: or [ROOMLOADER_DEFAULT_ADD_ANGLE](/pages/api/config/#roomloader-instances-default-add-angle)] |

:::code-group
```js [Regular]
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
```js [State]
// Loads instances from rmLevelPartBottom at the bottom-right corner of the room:
RoomLoader.BottomRight().LoadInstances(rmLevelPartBottom, room_width, room_height, depth); // [!code highlight]

// Loads a layout of props to fill the size of the current room,
// while keeping instance scale unaffected:
var _room = rmProps;
RoomLoader
.XScale(room_width / RoomLoader.DataGetWidth(_room))
.YScale(room_height / RoomLoader.DataGetHeight(_room))
.MultScale(false)
.LoadInstances(_room, 0, 0, depth); // [!code highlight]

// Loads a random arrangement of collectibles randomly rotated at the center
// of the room:
var _room = choose(rmCollectibles01, rmCollectibles02, rmCollectibles03);
var _x = room_width / 2;
var _y = room_height / 2;
RoomLoader.Angle(random(360)).LoadInstances(_room, _x, _y, depth); // [!code highlight]

// Loads a random enemy layout in front of the player and stores their IDs
// in the loadedEnemies array:
var _room = script_execute_ext(choose, enemyLayoutRooms);
var _offset = 200;
var _x = objPlayer.x + lengthdir_x(_offset, objPlayer.angle);
var _y = objPlayer.y + lengthdir_y(_offset, objPlayer.angle);
enemies = RoomLoader.Angle(objPlayer.angle - 90).LoadInstances(_room, _x, _y, depth); // [!code highlight]
```
:::

---
## `.LoadTilemap()`

> `RoomLoader.LoadTilemap(room, x, y, sourceLayerName, [targetLayer], [xOrigin], [yOrigin], [mirror], [flip], [angle], [tileset])` ➜ :Id.Tilemap:

Loads a tilemap from the given room and source layer at the given coordinates and origin. The tilemap is created on the target layer with optional mirroring, flipping and rotation transformations, and tileset.

Angle is internally wrapped around 360 degrees and snapped to a 90-degree increment.

#### Custom Tilesets
The optional `[tileset]` parameter can be especially useful for loading:
* The same layout of tiles with different skins based on the current biome or dimension.
* A visual + collision pair of tilemaps. Great for tiles with perspective or detailing that doesn't match with collision 1:1.

When using such tileset groups/pairs, make sure that tiles on all tilesets are perfectly aligned, or you'll get a mess of misplaced tiles.

| Parameter | Type | Description |
| --- | --- | --- |
| `room` | :Asset.GMRoom: | The room to load a tilemap from |
| `x` | :Real: | The x coordinate to load the tilemap at |
| `y` | :Real: | The y coordinate to load the tilemap at |
| `sourceLayerName` | :String: | The source layer name to load a tilemap from |
| `[targetLayer]` | :Id.Layer: or :String: | The target layer to create the tilemap on [Default: `sourceLayerName`] |
| `[xOrigin]` | :Real: | The x origin to load the tilemap at <br> [Default: :State.XOrigin: or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y origin to load the tilemap at <br> [Default: :State.YOrigin: or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[mirror]` | :Bool: | Mirror the loaded tilemap? <br> [Default: (:State.XScale: `< 0`) or :State.Mirror: or `false`] |
| `[flip]` | :Bool: | Flip the loaded tilemap? <br> [Default: (:State.YScale: `< 0`) or :State.Flip: or `false`] |
| `[angle]` | :Real: | The angle to load the tilemap at <br> [Default: :State.Angle: or `0`] |
| `[tileset]` | :Asset.GMTileset: | The tileset to use for the tilemap <br> [Default: :State.Tileset: or source tileset] |

:::code-group
```js [Regular]
// Loads a tilemap from the "TilesFloor" layer in rmCasinoDetails,
// creates it centered in the room on the layer with the same name,
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
```js [State]
// Loads a tilemap from the "TilesFloor" layer in rmCasinoDetails,
// creates it in the centered in the room on the layer with the same name,
// and randomly mirrors and flips it:
var _x = room_width / 2;
var _y = room_height / 2;
floorTilemap = RoomLoader
.MiddleCenter()
.Mirror(choose(true, false))
.Flip(choose(true, false))
.LoadTilemap(rmCasinoDetails, _x, _y, "TilesFloor"); // [!code highlight] 

// Loads a tilemap from the "WallsLayout" layer in rmLayoutHard on the "Walls" layer,
// using a custom tileset based on the current dimension and rotates it randomly:
tilemap = RoomLoader
.Angle(random(360))
.Tileset(DIMENSIONS.GetCurrent().GetWallsTileset())
.LoadTilemap(rmLayoutHard, 0, 0, "WallsLayout", "Walls"); // [!code highlight]

// Loads a tilemap from the "TilesWalls" layer in rmChunkSpecial01,
// creates it on the newly created collision layer, assigns the tsWallsCollision tileset to it
// and stores its ID in the collisionTilemap variable:
collisionLayer = layer_create(0, "Collision");
collisionTilemap = RoomLoader
.Tileset(tsWallsCollision)
.LoadTilemap(rmChunkSpecial01, 0, 0, "TilesWalls", collisionLayer); // [!code highlight]
```
:::