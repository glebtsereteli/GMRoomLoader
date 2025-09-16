# Data

This section covers room data management - GMRoomLoader's entry point and the beginning of its intended workflow. It's divided into three modules:
* [Initialization](#initialization) - essential for setting up room data.
* [Removal](#removal) - optional, for cleaning up data that's no longer needed.
* [Status & Getters](#status-getters) - situational, for checking or retrieving room data.

## Initialization

The following methods initialize room data to be used for :Loading: and :Screenshotting:.

::: danger IMPORTANT
Loading is only possible for rooms with initialized data. Ensure that data initialization is completed before using :Loading: or :Screenshotting: methods. Attempting to use a room whose data hasn't been initialized will cause a crash.
:::

::: tip
While GMRoomLoader is optimized to handle data efficiently, this section is the most resource-intensive because it relies on :room_get_info(): to fetch and process room data.

For best results, call these methods at the very start of your game. If your project involves large amounts of data or requires loading/unloading during gameplay, call them between levels, hidden behind a transition or loading screen.
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

> `RoomLoader.DataInitAll(blacklist)` ➜ :Struct:.:RoomLoader:

Initializes data for all rooms in the project, except the ones listed in the `blacklist` array.

| Parameter | Type | Description |
|---|---|---|
| `blacklist` | :Array: of :Asset.GMRoom: | The rooms to **not** initialize data for [Default: empty] |

::: code-group
```js [Example]
// Initializes data for all rooms in the project BUT rmInit:
var _blacklist = [rmInit];
RoomLoader.DataInitAll(_blacklist); // [!code highlight]
```
:::

## Removal

Although initialized room data takes up little space, you may still want to remove it for rooms that are no longer needed. The following methods follow the [Initialization](#initialization) structure and remove the corresponding data from [RoomLoader](#roomloader)'s internal pool.

---
### `.DataRemove()`

> `RoomLoader.DataRemove(...rooms)` ➜ :Struct:.:RoomLoader:

Removes data for all given rooms.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to remove data for                       |
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
### `.DataRemoveAll()`

> `RoomLoader.DataRemoveAll(blacklist)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms, except the ones listed in the `blacklist` array.

| Parameter | Type | Description |
|---|---|---|
| `blacklist` | :Array: of :Asset.GMRoom: | The rooms to **not** remove data for [Default: empty] |

::: code-group
```js [Example]
// Removes data for all rooms in the project BUT rmHub:
var _blacklist = [rmHub];
RoomLoader.DataRemoveAll(_blacklist); // [!code highlight]
```
:::

## Status & Getters

### `.DataIsInitialized()`

>`RoomLoader.DataIsInitialized(room)` -> :Bool:

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

### `.DataGetLayerNames()`

> `RoomLoader.DataGetLayerNames(room)` ➜ :Array: of :String:

Returns an array of layer names for the given room, in the order defined in the room editor. Can be safely operated on with array functions since the internal data is not touched.

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get an array of layer names for |

:::code-group
```js [Example]
// Fetches layers names from rmLevelGarden and whitelists 3 random layers before loading:
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

> `RoomLoader.DataGetInstances(room)` ➜ :Array: of :Struct:

Returns an array of instance data structs for the given room. Format listed [below](#struct-format).

::: danger IMPORTANT
This method fetches the original internal data structs, which should NOT be changed externally. Doing so might affect future loading in undesirable ways. If you need to edit the returned structs, clone the array first using [variable_clone()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Variable_Functions/variable_clone.htm).
:::

| Parameter | Type | Description |
|---|---|---|
| `room` | :Asset.GMRoom: | The room to get an array of instance data for |

:::code-group
```js [Example]
// Fetches instance data for rmExample:
var _instancesData = RoomLoader.DataGetInstances(rmExample); // [!code highlight]

// Maps the data array to an array of instance IDs using a custom instance creation function:
instances = array_map(_instancesData, function(_instanceData) {
    var _instanceId = ...; // Use _instanceData for custom instance creation.
    // More custom logic...
    return _instanceId;
});
```
:::

#### Struct Format
| Property | Type |
|----------|------|
| ├─ `x` | :Real: |
| ├─ `y` | :Real: |
| ├─ `id` | :Id.Instance: |
| ├─ `object` | :Asset.GMObject: |
| ├─ `sprite` | :Asset.GMSprite: |
| ├─ `creationCode` | :Id.Function: |
| └─ `preCreate` | :Struct: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_xscale` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_yscale` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_angle` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_speed` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_index` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;├─ `image_alpha` | :Real: |
| &nbsp;&nbsp;&nbsp;&nbsp;└─ `image_blend` | :Real: |
