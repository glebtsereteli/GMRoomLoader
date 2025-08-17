# Data

This section covers room data management - GMRoomLoader's entry point and the beginning of its intended workflow. It's divided into three modules:
* [Initialization](#initialization) - essential for setting up room data.
* [Removal](#removal) - optional, for cleaning up data that's no longer needed.
* [Status & Getters](#status-getters) - situational, for checking or retrieving room data.

## Initialization

The following methods initialize room data to be used for [loading](#loading) and [screenshotting](#screenshotting).

::: danger IMPORTANT
Loading is only possible for rooms with initialized data. Ensure that data initialization is completed before using [loading](#loading) or [screenshotting](#screenshotting) functions. Attempting to use a room whose data hasn't been initialized will cause a crash.
:::

::: tip
While GMRoomLoader is optimized to handle data efficiently, this section is the most resource-intensive because it relies on :room_get_info(): to fetch and process room data.

For best results, call these methods at the very start of your game. If your project involves large amounts of data or requires loading/unloading during gameplay, call them between levels, hidden behind a transition or loading screen.
:::

---
### `.DataInit()`

> `RoomLoader.DataInit(...rooms)` ➜ :Struct:.:RoomLoader:

Initializes data for all given rooms.

| Parameter | Type           | Description                                        |
| --------- | -------------- | -------------------------------------------------- |
| `room`    | :Asset.GMRoom: | The room to initialize data for.                   |
| `...`     | :Asset.GMRoom: | Additional rooms. Accepts any number of arguments. |

:::code-group
```js [Example]
// Initializes data for rmLevelCastle:
RoomLoader.DataInit(rmLevelCastle);

// Initializes data for rmLevelPlains, rmLevelForest and rmLevelCliffs:
RoomLoader.DataInit(rmLevelPlains, rmLevelForest, rmLevelCliffs);
```
:::

---
### `.DataInitArray()`

> `RoomLoader.DataInitArray(rooms)` ➜ :Struct:.:RoomLoader:

Initializes data for all rooms in the given array.

| Parameter | Type                      | Description                               |
| --------- | ------------------------- | ----------------------------------------- |
| `rooms`   | :Array: of :Asset.GMRoom: | The array of rooms to initialize data for |

:::code-group
```js [Example]
// Initializes data for all rooms inside the rooms array:
rooms = [rmLevelCabin, rmLevelAlley, rmLevelBeach];
RoomLoader.DataInitArray(rooms);
```
:::

---
### `.DataInitPrefix()`

> `RoomLoader.DataInitPrefix(prefix)` ➜ :Array: of :Asset.GMRoom:

Initializes data for all rooms starting with the given prefix. Returns an array of found rooms.

| Parameter | Type     | Description                     |
| --------- | -------- | ------------------------------- |
| `prefix`  | :String: | The prefix to filter rooms with |

::: code-group
```js [Example]
// Initializes data for all rooms starting with "rmLevel" and stores found room IDs in a variable:
rooms = RoomLoader.DataInitPrefix("rmLevel");
```
:::

---
### `.DataInitTag()`

> `RoomLoader.DataInitTag(tag)` ➜ :Array: of :Asset.GMRoom:

| Parameter | Type     | Description                 |
| --------- | -------- | --------------------------- |
| `tag`     | :String: | The tag to parse rooms from |

::: code-group
```js [Example]
// Initializes data for all rooms with the "Dungeon" tag assigned and stores their IDs in a variable:
dungeonRooms = RoomLoader.DataInitTag("Dungeon");
```
:::

---
### `.DataInitAll()`

> `RoomLoader.DataInitAll(blacklist)` ➜ :Struct:.:RoomLoader:

Initializes data for all rooms in the project, except the ones listed in the `blacklist` array.

| Parameter   | Type                      | Description                                                |
| ----------- | ------------------------- | ---------------------------------------------------------- |
| `blacklist` | :Array: of :Asset.GMRoom: | The rooms to **not** initialize data for (default = empty) |

::: code-group
```js [Example]
// Initializes data for all rooms in the project BUT rmInit:
RoomLoader.DataInitAll([rmInit]);
```
:::

## Removal

Although initialized room data takes up little space, you may still want to remove it for rooms that are no longer needed. The following methods follow the [Initialization](#initialization) structure and remove the corresponding data from [RoomLoader](#roomloader)'s internal pool.

---
### `.DataRemove()`

> `RoomLoader.DataRemove(...rooms)` ➜ :Struct:.:RoomLoader:

Removes data for all given rooms.

| Parameter | Type           | Description                                        |
| --------- | -------------- | -------------------------------------------------- |
| `room`    | :Asset.GMRoom: | The room to remove data for.                       |
| `...`     | :Asset.GMRoom: | Additional rooms. Accepts any number of arguments. |

:::code-group
```js [Example]
// Removes data for rmLevelCastle:
RoomLoader.DataRemove(rmLevelCastle);

// Removes data for rmLevelPlains, rmLevelForest and rmLevelCliffs:
RoomLoader.DataRemove(rmLevelPlains, rmLevelForest, rmLevelCliffs);
```
:::

---
### `.DataRemoveArray()`

> `RoomLoader.DataRemoveArray(rooms)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms in the given array.
| Parameter | Type                      | Description                            |
| --------- | ------------------------- | -------------------------------------- |
| `rooms`   | :Array: of :Asset.GMRoom: | The array of rooms to remove data for. |

:::code-group
```js [Example]
// Removes data for all rooms inside the rooms array:
rooms = [rmLevelCabin, rmLevelAlley, rmLevelBeach];
RoomLoader.DataRemoveArray(rooms);
```
:::

---
### `.DataRemovePrefix()`

> `RoomLoader.DataRemovePrefix(prefix)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms starting with the given prefix.

| Parameter | Type     | Description                     |
| --------- | -------- | ------------------------------- |
| `prefix`  | :String: | The prefix to filter rooms with |

::: code-group
```js [Example]
// Removes data for all rooms starting with "rmLevel":
RoomLoader.DataRemovePrefix("rmLevel");
```
:::

---
### `.DataRemoveTag()`

> `RoomLoader.DataRemoveTag(tag)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms with the given tag.

| Parameter | Type     | Description                 |
| --------- | -------- | --------------------------- |
| `tag`     | :String: | The tag to parse rooms from |

::: code-group
```js [Example]
// Removes data for all rooms with the "Dungeon" tag assigned:
RoomLoader.DataRemoveTag("Dungeon");
```
:::

---
### `.DataRemoveAll()`

> `RoomLoader.DataRemoveAll(blacklist)` ➜ :Struct:.:RoomLoader:

Removes data for all rooms, except the ones listed in the `blacklist` array.

| Parameter   | Type                      | Description                                           |
| ----------- | ------------------------- | ----------------------------------------------------- |
| `blacklist` | :Array: of :Asset.GMRoom: | The rooms to **not** remove data for. Default = empty |

::: code-group
```js [Example]
// Removes data for all rooms in the project BUT rmHub:
RoomLoader.DataRemoveAll([rmHub]);
```
:::

## Status & Getters

### `.DataIsInitialized()`

>`RoomLoader.DataIsInitialized(room)` -> :Bool:

Checks whether the data for the given room is initialized (returns `true`) or not (return `false`).

| Parameter | Type           | Description       |
|-----------|----------------|-------------------|
| `room`    | :Asset.GMRoom: | The room to check |

:::code-group
```js [Example]
if (RoomLoader.DataIsInitialized(rmLevelTower)) {
    // Yay, the data for rmLevelTower is initialized!
}
```
:::

---
### `.DataGetWidth()`

> `RoomLoader.DataGetWidth(room)` ➜ :Real:

Returns the width of the given room.

| Argument | Type           | Description                   |
|----------|----------------|-------------------------------|
| `room`   | :Asset.GMRoom: | The room to get the width of  |

:::code-group
```js [Example]
// Gets the width of rmLevelDungeon:
var _width = RoomLoader.DataGetWidth(rmLevelDungeon);
```
:::

---
### `.DataGetHeight()`

> `RoomLoader.DataGetHeight(room)` ➜ :Real:

Returns the height of the given room.

| Argument | Type           | Description                    |
|----------|----------------|--------------------------------|
| `room`   | :Asset.GMRoom: | The room to get the height of  |

:::code-group
```js [Example]
// Gets the height of rmLevelDungeon:
var _height = RoomLoader.DataGetHeight(rmLevelDungeon);
```
:::