# Loading

This section covers loading room contents - the core functionality of the library. All loading can be performed at any position and :Origin: in the current room.
* [.Load()](#load) loads entire rooms with all layers and elements, with optional :Scaling:, :Rotation:, and filtering by :Asset Type: and/or :Layer Name:.
* [.LoadInstances()](#loadinstances) loads instances from all layers, placed onto a single layer or depth, with optional :Scaling: and :Rotation:.
* [.LoadTilemap()](#loadtilemap) loads tilemaps from a source layer in the loaded room into a target layer in the current room. It supports optional :Mirroring:, :Flipping:, 90° :Rotation: and custom :Tileset: options.

::: danger ❗ PERFORMANCE NOTE
If room data hasn't been initialized before loading, GMRoomLoader will initialize it automatically. This is fine for quick tests or small rooms, but it **significantly slows down** loading. See the :Initialization: page for best practices.
:::
::: details ℹ️ TRANSFORMED LOADING PERFORMANCE {closed}
All transformed loading making use of :Scaling: or :Rotation: is generally slower than loading without them. This is because each element must be recalculated and repositioned according to the transformation parameters, which increases processing time.

Though loading is still plenty fast, keep this in mind when loading large rooms transformed.

Try loading the same room with and without transformations to see the difference in your particular use case. If :ROOMLOADER_ENABLE_DEBUG: is set to `true` (it is by default), performance benchmarks will be logged in the Output window.
:::

## `.Load()`

> `RoomLoader.Load(room, x, y, [xOrigin], [yOrigin], [flags], [xScale], [yScale], [angle])` ➜ :Struct:.:Payload: or :Undefined:

Loads all layers and elements of the given room at the given coordinates, with optional :Origin:, :Asset Type: filtering, :Scaling: and :Rotation:.

* If [ROOMLOADER_DELIVER_PAYLOAD](/pages/api/config/#roomloader-deliver-payload) is `true`, returns an instance of :Payload: that tracks the IDs of all loaded layers and elements, and can be used to [shift layer depths](/pages/api/payload/depth), [fetch element IDs](/pages/api/payload/getters) and [unload things](/pages/api/payload/cleanup).
* Otherwise returns :Undefined:.

Layers are created at the same depths defined in the Room Editor. See the [Payload/Depth](/pages/api/payload/depth) section if you need to adjust layer depths manually after loading to be above or below a certain layer/depth.

::: details ℹ️ ROOM ELEMENT COVERAGE {closed}
Full room loading supports the following elements.

| Element | Layer Type | Status |
|---|---|---|
| Instance | Instance | ✔️ |
| Tilemap | Tile | ✔️ |
| Sprite | Asset | ✔️ |
| Particle System | Asset | 🚧 Broken, GM bug. Fix coming in 2024.14.1 |
| Sequence | Asset | ✔️ |
| Background | Background | ✔️ |
| Effects | Effect | ✔️ |
| On-layer Effects | Any | ✔️ |
| Creation Code | - | ✔️ |
| Views | - | ❌ Irrelevant |
| Physics | - | ❌ Irrelevant |
| Display Buffer & Viewport Clearing | - | ❌ Irrelevant |
:::
::: details ℹ️ TRANSFORMATION EXCEPTIONS {closed}
* Tilemaps only load if `[xScale/yScale]` is either `-1` or `1` and `[angle]` is an increment of 90 degrees. Otherwise they are ignored.
* Backgrounds only load if `[angle]` is `0`. Otherwise they are ignored.
:::
::: details ℹ️ MERGING TILEMAPS {closed}
If :ROOMLOADER_MERGE_LAYERS: and :ROOMLOADER_MERGE_TILEMAPS: are both true `true`, this method will attempt to merge loaded and existing tilemaps. See the :ROOMLOADER_MERGE_TILEMAPS: page for details.
:::

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to load |
| `x` | :Real: | The x coordinate to load the room at |
| `y` | :Real: | The y coordinate to load the room at |
| `[xOrigin]` | :Real: | The x :Origin: to load the room at [Default: :State.XOrigin: if set, or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y :Origin: to load the room at [Default: :State.YOrigin: if set, or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags used to filter the loaded data [Default: :State.Flags: if set, or :ROOMLOADER_DEFAULT_FLAGS:] |
| `[xScale]` | :Real: | The horizontal scale to load the room at [Default: :State.XScale: if set, or 1] |
| `[yScale]` | :Real: | The vertical scale to load the room at [Default: :State.YScale: if set, or 1] |
| `[angle]` | :Real: | The angle to load the room at [Default: :State.Angle: if set, or 0] |

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
RoomLoader.Angle(0).Load(rmExample, x, y); // [!code highlight]
RoomLoader.Angle(90).Load(rmExample, x, y); // [!code highlight]
RoomLoader.Angle(180).Load(rmExample, x, y); // [!code highlight]
RoomLoader.Angle(270).Load(rmExample, x, y); // [!code highlight]

// Loads rmExample mirrored and flipped in all 4 corners of the room:
RoomLoader.Load(rmExample, 0, 0); // [!code highlight]
RoomLoader.Mirror().Load(rmExample, room_width, 0); // [!code highlight]
RoomLoader.Mirror().Flip().Load(rmExample, room_width, room_height); // [!code highlight]
RoomLoader.Flip().Load(rmExample, 0, room_height); // [!code highlight]
```
:::

## `.LoadInstances()`

> `RoomLoader.LoadInstances(room, x, y, layerOrDepth, [xOrigin], [yOrigin], [xScale], [yScale], [angle])` ➜ :Array: of :Id.Instance:

Loads all instances from the given room at the given coordinates, with optional :Origin:, :Scaling: and :Rotation:. Returns an array of loaded instance IDs.

Unlike :Full Room Loading:, all instances are placed onto the specified layer (or depth) instead of their original room layers.

::: tip CUSTOM LOADING
If you'd like to handle instance creation yourself rather than using GMRoomLoader's built-in method, call [RoomLoader.DataGetInstances()](/pages/api/roomLoader/data/#datagetinstances) to retrieve an array of instance data and apply your own logic to it.
:::

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to load instances from |
| `x` | :Real: | The x coordinate to load instances at |
| `y` | :Real: | The y coordinate to load instances at |
| `layerOrDepth` | :Id.Layer: or :String: or :Real: | The layer ID, layer name, or depth to create instances on |
| `[xOrigin]` | :Real: | The x :Origin: to load the room at [Default: :State.XOrigin: if set, or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y :Origin: to load the room at [Default: :State.YOrigin: if set, or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[xscale]` | :Real: | The horizontal scale transformation [Default: :State.XScale: if set, or 1] |
| `[yscale]` | :Real: | The vertical scale transformation [Default: :State.YScale: if set, or 1] |
| `[angle]` | :Real: | The angle transformation [Default: :State.Angle: if set, or 0] |

:::code-group
```js [Regular]
// Loads instances from rmLevelPartBottom at the bottom-right corner of the room:
RoomLoader.LoadInstances(rmLevelPartBottom, room_width, room_height, depth, 1, 1); // [!code highlight]

// Loads a layout of props to fill the size of the current room:
var _room = rmProps;
var _xscale = room_width / RoomLoader.DataGetWidth(_room);
var _yscale = room_height / RoomLoader.DataGetHeight(_room);
RoomLoader.LoadInstances(_room, 0, 0, depth, _xscale, _yscale); // [!code highlight]

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
var _room = rmProps;
RoomLoader
.XScale(room_width / RoomLoader.DataGetWidth(_room))
.YScale(room_height / RoomLoader.DataGetHeight(_room))
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

## `.LoadTilemap()`

> `RoomLoader.LoadTilemap(room, x, y, sourceLayerName, [targetLayer], [xOrigin], [yOrigin], [mirror], [flip], [angle], [tileset])` ➜ :Id.Tilemap:

Loads a tilemap from the given room and source layer at the given coordinates. The tilemap is created on the target layer at an optional origin, with optional :Mirroring:, :Flipping:, :Rotation: and :Tileset:.

Angle is wrapped around 360° and snapped to a 90° increment.

::: info CUSTOM TILESETS
The optional `[tileset]` parameter can be especially useful for loading:
* The same layout of tiles with different skins based on the set of levels/world/biome/dimension.
* A visual + collision pair of tilemaps. Great for tiles with perspective or detailing that doesn't match with collision 1:1.

When using such tileset groups/pairs, make sure that tiles on all tilesets are perfectly aligned, or you'll get a mess of misplaced tiles.
:::
::: info MERGING
If :ROOMLOADER_MERGE_TILEMAPS: is `true`, GMRoomLoader will attempt to merge loaded and existing tilemaps. See the config macro page for details.
:::
::: details ℹ️ TOP AND/OR LEFT MERGING PERFORMANCE {closed}
When merging a tilemap positioned above (north) or to the left (west) of an existing tilemap, GMRoomLoader must reposition and resize the existing tilemap. This involves shifting all tiles to preserve their visual placement, which requires iterating through the tilemap and moving every non-zero tile.

This process can noticeably impact performance, especially for large tilemaps. To minimize overhead, ensure the existing tilemap already spans the full target area before merging. This way new tiles can be assigned directly, avoiding the need to shift existing tiles.
:::

| Parameter | Type | Description |
| --- | --- | --- |
| `room` | :Asset.GMRoom: | The room to load a tilemap from |
| `x` | :Real: | The x coordinate to load the tilemap at |
| `y` | :Real: | The y coordinate to load the tilemap at |
| `sourceLayerName` | :String: | The source layer name to load a tilemap from |
| `[targetLayer]` | :Id.Layer: or :String: | The target layer to create the tilemap on [Default: if set, `sourceLayerName`] |
| `[xOrigin]` | :Real: | The x origin to load the tilemap at <br> [Default: :State.XOrigin: if set, or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y origin to load the tilemap at <br> [Default: :State.YOrigin: if set, or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[mirror]` | :Bool: | Mirror the loaded tilemap? <br> [Default: (:State.XScale: `< 0`) or :State.Mirror: if set, or `false`] |
| `[flip]` | :Bool: | Flip the loaded tilemap? <br> [Default: (:State.YScale: `< 0`) or :State.Flip: if set, or `false`] |
| `[angle]` | :Real: | The angle to load the tilemap at <br> [Default: :State.Angle: if set, or `0`] |
| `[tileset]` | :Asset.GMTileset: | The tileset to use for the tilemap <br> [Default: :State.Tileset: if set, or source tileset] |

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
// creates it centered in the room on the layer with the same name,
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