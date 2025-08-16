---
next:
  text: 'ReturnData'
  link: '/pages/api/returnData'
---

# RoomLoader

<!-- <h1>
  RoomLoader
  <span style="display:none">RoomLoader</span>
  <a href="https://github.com/glebtsereteli/GMRoomLoader/blob/main/GMRoomLoader/scripts/RoomLoaderMain/RoomLoaderMain.gml" target="_blank">
    <Badge type="info" text="Source Code" />
  </a>
</h1> -->

## Overview

`RoomLoader` is the main interface of GMRoomLoader. It managers room [data](#data) and [loading](#loading), handles [whitelist](#whitelist) and [blacklist](#blacklist) layer filtering and [taking screenshots](#screenshotting).

It's a function containing static data variables and methods inside, essentially serving as a makeshift GML [namespace](https://learn.microsoft.com/en-us/cpp/cpp/namespaces-cpp?view=msvc-170). It's initialized internally and doesn't require any additional setup from the user.

All methods are called using the following syntax: `RoomLoader.MethodName(arguments...);`. Notice the lack of `()` after `RoomLoader`.

## Data

### Initialization

The following methods initialize room data to be used for [loading](#loading) and [screenshotting](#screenshotting).

::: danger IMPORTANT
Loading is only possible for rooms with initialized data. Ensure that data initialization is completed before using [loading](#loading) or [screenshotting](#screenshotting) functions. Attempting to use a room whose data hasn't been initialized will cause a crash.
:::

::: tip
While GMRoomLoader is optimized for best possible performance, this section is the most resource-intensive because it relies on :room_get_info(): to fetch and process room data.

For best results, call these methods at the very start of your game. If your project involves large amounts of data or requires loading/unloading during gameplay, call them between levels, hidden behind a transition or loading screen.
:::

---
#### `.DataInit()`

`RoomLoader.DataInit(...rooms)` ➜ :Struct:.:RoomLoader:

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
#### `.DataInitArray()`
`RoomLoader.DataInitArray(rooms)` ➜ :Struct:.:RoomLoader:

Initializes data for all rooms in the given array.

| Parameter | Type                      | Description                                |
| --------- | ------------------------- | ------------------------------------------ |
| `rooms`   | :Array: of :Asset.GMRoom: | The array of rooms to initialize data for. |

:::code-group
```js [Example]
// Initializes data for all rooms inside the rooms array:
rooms = [rmLevelCabin, rmLevelAlley, rmLevelBeach];
RoomLoader.DataInitArray(rooms);
```
:::

---
#### `.DataInitPrefix()`

`RoomLoader.DataInitPrefix(prefix)` ➜ :Array: of :Asset.GMRoom:

Initializes data for all rooms starting with the given prefix. Returns an array of found rooms.

| Parameter | Type     | Description                      |
| --------- | -------- | -------------------------------- |
| `prefix`  | :String: | The prefix to filter rooms with. |

::: code-group
```js
// Initializes data for all rooms starting with "rmLevel" and stores found rooms in a variable:
rooms = RoomLoader.DataInitPrefix("rmLevel");
```
:::

---
#### `.DataInitTag()`

`RoomLoader.DataInitTag(tag)` ➜ :Array: of :Asset.GMRoom:

| **Parameter** | **Type** | **Description**              |
| ------------- | -------- | ---------------------------- |
| `tag`         | :String: | The tag to parse rooms from. |

::: code-group
```js
// Initializes data for all rooms with the "RoomsDungeon" tag assigned and stores them in a variable:
dungeonRooms = RoomLoader.DataInitTag("rooms_dungeon");
```
:::

### Removal

#### `.DataRemove()`

#### `.DataRemoveArray()`

#### `.DataRemovePrefix()`

#### `.DataRemoveTag()`

#### `.DataClear()`

### Status & Getters

#### `.DataIsInitialized()`

#### `.DataGetWidth()`

#### `.DataGetHeight()`

## Loading

about...

### `.Load()` {#load}

### `.LoadInstances()` {#loadinstances}

## Layer Filtering

about...

### Whitelist

#### `.LayerWhitelistAdd()`

#### `.LayerWhitelistRemove()`

#### `.LayerWhitelistReset()`

#### `.LayerWhitelistGet()`

### Blacklist

#### `.LayerBlacklistAdd()`

#### `.LayerBlacklistRemove()`

#### `.LayerBlacklistReset()`

#### `.LayerBlacklistGet()`

## Screenshotting

about...

### `.TakeScreenshot()`

### `.TakeScreenshotPart()`
