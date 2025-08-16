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

`RoomLoader` is the main interface of GMRoomLoader. It handles most library operations and is organized into the following modules:
| Module                                                  | Description                                                    |
| ------------------------------------------------------- | -------------------------------------------------------------- |
| [Data](/pages/api/roomLoader/data)                      | Manages room data flow required for loading and screenshotting |
| [Loading](/pages/api/roomLoader/loading)                | Handles the actual loading of rooms and instances              |
| [Layer Filtering](/pages/api/roomLoader/layerFiltering) | Allows sorting rooms by name before loading                    |
| [Screenshotting](/pages/api/roomLoader/screenshotting)  | Captures screenshots of rooms                                  |

## Syntax
`RoomLoader` is a function containing static data variables and methods, effectively acting as a makeshift GML [namespace](https://learn.microsoft.com/en-us/cpp/cpp/namespaces-cpp?view=msvc-170). It's initialized internally and requires no additional setup.

All methods are accessed using the `RoomLoader.MethodName(arguments...)` syntax:
* Initialize data: `RoomLoader.DataInit(rmDungeon);`.
* Load a room: `RoomLoader.Load(rmDungeon, 0, 0);`.

Note the lack of parentheses after `RoomLoader`. Unlike the classic `function_name()` calls you’re used to in GML, this accesses static methods within the `RoomLoader` interface. 

This design offers a single, clean entry point for the entire library, with all internal data and public methods contained within a single "namespace".