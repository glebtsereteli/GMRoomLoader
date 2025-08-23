# RoomLoader

<!-- <h1>
  RoomLoader
  <span style="display:none">RoomLoader</span>
  <a href="https://github.com/glebtsereteli/GMRoomLoader/blob/main/GMRoomLoader/scripts/RoomLoaderMain/RoomLoaderMain.gml" target="_blank">
    <Badge type="info" text="Source Code" />
  </a>
</h1> -->

`RoomLoader` is the main interface of GMRoomLoader. It handles most library operations and is organized into the following modules:

- [Data](/pages/api/roomLoader/data) manages room data flow required for :Loading: and :Screenshotting:.  
- [Loading](/pages/api/roomLoader/loading) is the fun part, it handles the actual loading of rooms and instances.  
- [Screenshotting](/pages/api/roomLoader/screenshotting) captures screenshots of rooms.
- [Origin](/pages/api/roomLoader/origin) defines the Origin system used in all :Loading: and :Screenshotting: methods.
- :Asset Type: and :Layer Name: filtering allow filtering layers by asset type and name respectively when using :RoomLoader.Load(): and :Screenshotting: methods.

## Static Namespace

`RoomLoader` is a global script function containing static data variables and methods, effectively acting as a makeshift [namespace](https://learn.microsoft.com/en-us/cpp/cpp/namespaces-cpp?view=msvc-170)-like construct. It's initialized internally and requires no extra setup.

All methods are accessed using the `RoomLoader.MethodName(arguments...)` syntax:
* Initialize data: `RoomLoader.DataInit(rmDungeon);`.
* Load a room: `RoomLoader.Load(rmDungeon, someX, someY);`.

Note the lack of parentheses after `RoomLoader`. Unlike the classic `function_name()` calls you’re used to in GML, this accesses static methods within the `RoomLoader` interface. 

This design offers a single, clean entry point for the entire library, with all internal data and public methods contained within a single "namespace".

## Fluent Interface

@TODO
