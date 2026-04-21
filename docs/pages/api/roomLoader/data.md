# Data

## Overview

This section covers room data management in GMRoomLoader. It's divided into three modules:
* [Initialization](#initialization) prepares room data for :Loading:, :Screenshotting: and :Data Getters:. It happens automatically when needed, but initializing upfront is strongly recommended for best performance.
* [Removal](#removal) cleans up initialized data that is no longer needed. Mostly relevant at scale, when working with many rooms and keeping memory usage in check matters.
* [Status & Getters](#status-getters) provides tools for retrieving room data such as dimensions, layer names, instance data and more.

## Initialization

The following methods initialize room data for use in :Loading:, :Screenshotting: and :Data Getters:.

::: danger ❗ PERFORMANCE NOTE
Room data is initialized automatically the first time it's needed, so these methods are never strictly required. However, automatic initialization runs during gameplay, which can severely slow down the first :Loading: or :Screenshotting: call for each room. Initializing explicitly at the start of your game or behind a loading screen avoids this entirely.
:::

---
### `.DataInit()`

> `RoomLoader.DataInit(...rooms)` ➜ :Struct:.:RoomLoader:

Initializes data for all given rooms.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to initialize data for |
| `...` | :Asset.GMRoom: | Additional rooms. Accepts any number of arguments |

:::code-group
```js [Example]
// Initializes data for rmLevelCastle:
RoomLoader.DataInit(rmLevelCastle); // [!code highlight]

// Initializes data for rmLevelPlains, rmLevelForest and rmLevelCliffs:
RoomLoader.DataInit(rmLevelPlains, rmLevelForest, rmLevelCliffs); // [!code highlight]
```
:::

---
### `.DataInitArray()`

> `RoomLoader.DataInitArray(rooms)` ➜ :Struct:.:RoomLoader:

Initializes data for all rooms in the given array.

| Parameter | Type | Description |
|---|---|---|
| `rooms` | :Array: of :Asset.GMRoom: | The array of rooms to initialize data for |

:::code-group
```js [Example]
// Initializes data for all rooms inside the rooms array:
rooms = [rmLevelCabin, rmLevelAlley, rmLevelBeach];
RoomLoader.DataInitArray(rooms); // [!code highlight]
```
:::

---
### `.DataInitPrefix()`

> `RoomLoader.DataInitPrefix(prefix)` ➜ :Array: of :Asset.GMRoom:

Initializes data for all rooms starting with the given prefix. Returns an array of found rooms.

| Parameter | Type | Description |
|---|---|---|
| `prefix` | :String: | The prefix used to filter room names |

::: code-group
```js [Example]
// Initializes data for all rooms starting with "rmLevel" and stores found room IDs in a variable:
rooms = RoomLoader.DataInitPrefix("rmLevel"); // [!code highlight]
```
:::

---
### `.DataInitTag()`

> `RoomLoader.DataInitTag(tag)` ➜ :Array: of :Asset.GMRoom:

Initializes data for all rooms with the given tag assigned. Returns an array of found rooms.

| Parameter | Type | Description |
|---|---|---|
| `tag` | :String: | The tag to parse rooms from |

::: code-group
```js [Example]
// Initializes data for all rooms with the "Dungeon" tag assigned and stores their IDs in a variable:
dungeonRooms = RoomLoader.DataInitTag("Dungeon"); // [!code highlight]
```
:::

---
### `.DataInitAll()`

> `RoomLoader.DataInitAll(blacklist)` ➜ :Array: of :Asset.GMRoom:

Initializes data for all rooms in the project, except the ones listed in the `blacklist` array.

| Parameter | Type | Description |
|---|---|---|
| `blacklist` | :Array: of :Asset.GMRoom: | The rooms to **not** initialize data for [Default: empty] |

::: code-group
```js [Example]
// Initializes data for all rooms in the project BUT rmInit:
RoomLoader.DataInitAll([rmInit]); // [!code highlight]
```
:::

## Removal

The following methods remove initialized room data from :RoomLoader:'s internal pool. While data takes up little memory, removing it for rooms that are no longer needed is good practice at scale, especially when working with a large number of rooms.

---
### `.DataRemove()`

> `RoomLoader.DataRemove(...rooms)` ➜ :Struct:.:RoomLoader:

Removes data for all given rooms.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to remove data for |
| `...` | :Asset.GMRoom: | Additional rooms. Accepts any number of arguments |

:::code-group
```js [Example]
// Removes data for rmLevelCastle:
RoomLoader.DataRemove(rmLevelCastle); // [!code highlight]

// Removes data for rmLevelPlains, rmLevelForest and rmLevelCliffs:
RoomLoader.DataRemove(rmLevelPlains, rmLevelForest, rmLevelCliffs); // [!code highlight]
```
:::

---
### `.DataRemoveArray()`

> `RoomLoader.DataRemoveArray(rooms)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms in the given array.

| Parameter | Type | Description |
|---|---|---|
| `rooms` | :Array: of :Asset.GMRoom: | The array of rooms to remove data for |

:::code-group
```js [Example]
// Removes data for all rooms inside the rooms array:
rooms = [rmLevelCabin, rmLevelAlley, rmLevelBeach];
RoomLoader.DataRemoveArray(rooms); // [!code highlight]
```
:::

---
### `.DataRemovePrefix()`

> `RoomLoader.DataRemovePrefix(prefix)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms starting with the given prefix.

| Parameter | Type | Description |
|---|---|---|
| `prefix` | :String: | The prefix used to filter room names |

::: code-group
```js [Example]
// Removes data for all rooms starting with "rmLevel":
RoomLoader.DataRemovePrefix("rmLevel"); // [!code highlight]
```
:::

---
### `.DataRemoveTag()`

> `RoomLoader.DataRemoveTag(tag)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms with the given tag.

| Parameter | Type | Description |
|---|---|---|
| `tag` | :String: | The tag to parse rooms from |

::: code-group
```js [Example]
// Removes data for all rooms with the "Dungeon" tag assigned:
RoomLoader.DataRemoveTag("Dungeon"); // [!code highlight]
```
:::

---
### `.DataClear()`

> `RoomLoader.DataClear()` ➜ :Struct:.:RoomLoader:

Clears all initialized room data.

:::code-group
```js [Example]
// Clears all initialized room data:
RoomLoader.DataClear(); // [!code highlight]
```
:::

## Status & Getters

### `.DataIsInitialized()`

>`RoomLoader.DataIsInitialized(room)` ➜ :Bool:

Checks whether the data for the given room is initialized (returns `true`) or not (returns `false`).

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to check |

:::code-group
```js [Example]
if (RoomLoader.DataIsInitialized(rmLevelTower)) { // [!code highlight]
    // Yay, the data for rmLevelTower is initialized!
}
```
:::

---
### `.DataGetWidth()`

> `RoomLoader.DataGetWidth(room)` ➜ :Real:

Returns the width of the given room.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get the width of  |

:::code-group
```js [Example]
// Gets the width of rmLevelDungeon:
var _width = RoomLoader.DataGetWidth(rmLevelDungeon); // [!code highlight]
```
:::

---
### `.DataGetHeight()`

> `RoomLoader.DataGetHeight(room)` ➜ :Real:

Returns the height of the given room.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get the height of  |

:::code-group
```js [Example]
// Gets the height of rmLevelDungeon:
var _height = RoomLoader.DataGetHeight(rmLevelDungeon); // [!code highlight]
```
:::

---
### `.DataGetLayerNames()`

> `RoomLoader.DataGetLayerNames(room)` ➜ :Array: of :String:

Returns an array of layer names from the given room, in the order defined in the room editor. Can be safely operated on with array functions since the internal data is not touched.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get an array of layer names from |

:::code-group
```js [Example]
// Fetches layer names from rmLevelGarden and whitelists 3 random layers before loading:
var _room = rmLevelGarden;
var _layerNames = RoomLoader.DataGetLayerNames(_room); // [!code highlight]
array_shuffle_ext(_layerNames);
array_resize(_layerNames, 3);
array_foreach(_layerNames, function(_layerName) {
    RoomLoader.LayerWhitelistAdd(_layerName);
});
RoomLoader.Load(_room, x, y);
RoomLoader.LayerWhitelistReset();
```
:::

---
### `.DataGetInstances()`

> `RoomLoader.DataGetInstances(room, [object])` ➜ :Array: of :Struct:

Returns an array of instance data structs from the given room. See the format listed [below](#struct-format).

You can also provide the optional `[object]` argument to return data only for instances of the given object.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get an array of instance data from |
| `[object]` | :Asset.GMObject: | The object to filter instances by. Only instances of the given object will be included [Default: `undefined` (no filter)] |

:::code-group
```js [Custom Instance Creation]
// Fetches instance data from rmExample:
var _instancesData = RoomLoader.DataGetInstances(rmExample); // [!code highlight]

// Maps the data array to an array of instance IDs using a custom instance creation function:
instances = array_map(_instancesData, function(_instanceData) {
    var _instanceId = ...; // Use _instanceData for custom instance creation.
    // More custom logic...
    return _instanceId;
});
```
```js [Fetching Doors]
// Fetches objDoor instance data from rmExample:
var _doorsData = RoomLoader.DataGetInstances(rmExample, objDoor); // [!code highlight]
// ...
```
:::

---
### `.DataGetInstance()`

> `RoomLoader.DataGetInstance(room, id)` ➜ :Struct:

Returns an instance data struct for the given room instance inside the given room. See the format listed [below](#struct-format).

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get instance data from |
| `id` | :Id.Instance: | The room ID of the instance to get data for |

:::code-group
```js [Example]
var _leftDoor = RoomLoader.DataGetInstance(rmExample, inst_2C16415); // [!code highlight]
// ...
```
:::

#### Struct Format
| Property | Type |
|----------|------|
| ├─ `x` | :Real: |
| ├─ `y` | :Real: |
| ├─ `id` | :Id.Instance: |
| ├─ `object` | :Asset.GMObject: |
| ├─ `creationCode` | :Id.Function: |
| └─ `preCreate` | :Struct: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `sprite_index` | :Asset.GMSprite: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_index` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_speed` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_xscale` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_yscale` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_angle` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_blend` | :Constant.Color:, :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;└─ `image_alpha` | :Real: |

Any variables adjusted through the [Variable Definitions](https://manual.gamemaker.io/monthly/en/The_Asset_Editors/Object_Properties/Object_Variables.htm) tab are also included in the struct. Variables with untouched default values are ignored - :room_get_info(): doesn't provide any data for those.

---
### `.DataGetTilemap()`

> `RoomLoader.DataGetTilemap(room, layerName)` ➜ :Struct:

Returns a `{tileset, width, height, tiles}` data struct for the tilemap from the given layer in the given room.

The `tiles` array is laid out in `x, y, tileData` data sets for each tile: `[x, y, tileData, x, y, tileData, ...]`,
where `x` and `y` are tile coordinates in tilemap space and `tileData` is the tile data used in [tilemap functions](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Tile_Map_Layers/Tile_Map_Layers.htm).

::: details ℹ️ WHY THIS FORMAT? {closed}
* Why not a 2d array? Tilemap loading is optimized by removing empty 0 tiles from internal data, and there's no need to track empty cells in the resulting array used for creating tilemaps.
* Why not an array of structs? Having a single flat 1d array is both faster and more memory efficient compared to an array of structs.
:::

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get tilemap data from |
| `layerName` | :String: | The Tile layer name to get tilemap data from |

:::code-group
```js [Example]
// Fetches tilemap data from rmExample's "Tiles" layer:
var _tilemapData = RoomLoader.DataGetTilemap(rmExample, "Tiles"); // [!code highlight]

// Loops through the 'tiles' array:
var _tiles = _tilemapData.tiles;
var _i = 0; repeat (array_length(_tiles) / 3) {
    var _x = _tiles[_i];
    var _y = _tiles[_i + 1];
    var _tile = _tiles[_i + 2];
    // Does something really cool with each tile...
    _i += 3;
}
```
:::