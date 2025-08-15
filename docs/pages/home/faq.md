# Frequently Asked Questions

## 📍 What platforms does GMRoomLoader support?
| Platform            | Status   | Notes                                   |
| ------------------- | -------- | --------------------------------------- |
| **Windows**         | ✅ Yes    | Fully tested and stable                 |
| **macOS**           | ✅ Yes    | Fully tested and stable                 |
| **GX.games**        | ✅ Yes    | Fully tested and stable                 |
| **Linux**           | 🚧 Likely | Untested                                |
| **HTML5**           | ❌ No     | Cursed. Use WASM with GX.games          |
| **Android**         | 🚧 Likely | Untested                                |
| **iOS**             | 🚧 Likely | Untested                                |
| **PS5**             | 🚧 Likely | Untested                                |
| **Xbox**            | 🚧 Likely | Untested                                |
| **Nintendo Switch** | 🚧 Likely | Untested                                |

## 📍 What versions of GameMaker does GMRoomLoader support?
The latest Monthly. Currently that's `IDE v2024.13.1.193` and `Runtime v2024.13.1.242`.

## 📍 How do I update to the latest version of GMRoomLoader?
1. If you've made changes to the `RoomLoaderConfig` script, make a backup of the script before continuing.
2. Delete the `GMRoomLoader` folder from your project.
3. Repeat the [Installation](/pages/home/gettingStarted/#installation) process.
4. If you've made changes to the `RoomLoaderConfig` script, paste the changes back from your backup.

::: warning KEEP IN MIND
The config setup might change between versions, so make sure to pay attention to the release notes and adjust your pasted configs accordingly.
:::

## 📍 Can GMRoomLoader assist with procedural generation?
No. GMRoomLoader is designed specifically for loading rooms. Procedural generation, along with any custom logic for determining which room to pick and where it should go, will need to be handled on your own.

## 📍 How does GMRoomLoader actually "load rooms" if GameMaker can only have a single room active at a time? Does the library get around that somehow?
GameMaker can indeed only have a single room active at a time. GMRoomLoader doesn't change that.

When we say "load a room", what we really mean is "recreate a room" or "load room contents". GMRoomLoader does this by taking the data from [room_get_info()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm), processing it for optimized loading, and using it to recreate room layers and their respective elements.

## 📍 I'm loading a room and it appears to work (?), but I can't see some (or all) of the loaded layers/instances. How can I fix that?
Mind your depth! GMRoomLoader creates room layers at the exact depths assigned in the Room Editor. If the room you're loading other rooms into has a few layers, make sure to manage their depths so they are either in front or behind loaded layers, depending on your use case.

## 📍 My rooms have instances with Variable Definitions and Creation Code. Does GMRoomLoader support those?
It does! [room_get_info()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm) provides both as scripts for GMRoomLoader to use. 

::: info NOTE
The execution order follows GameMaker's default and is structured like this:
1. Room-defined parameters + Variable Definitions (mixed in a single pre-create struct).
2. Create event.
3. Creation Code.
:::

## 📍 Can I "destroy" or "unload" a room after loading it?
* If you're loading full rooms with [RoomLoader.Load()](/pages/api/roomLoader/#load), it returns an instance of [ReturnData](/pages/api/returnData), which includes a [.Cleanup()](/pages/api/returnData/#cleanup-1) method for removing all loaded layers and their elements.
* If you're loading instances with [RoomLoader.LoadInstances()](/pages/api/roomLoader.md/#loadinstances), those methods return an array of loaded instance IDs. Loop through the array and call [instance_destroy()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/instance_destroy.htm) on each instance to remove them.

::: info NOTE
GMRoomLoader only tracks layers and elements it loads itself. Anything else you add afterwards must be cleaned up manually.
:::

## 📍 How can I collide with loaded tilemaps?
When you load a room with a tile layer, a new tilemap is created. To collide with this newly loaded tilemap, you need to grab its ID and store it somewhere.

If you're currently colliding with, say, a variable holding a tilemap ID, you'll need to change that to a dynamic setup using an array.

::: info EXAMPLE
```js
// In some script, initialize a global array of collision tilemaps:
global.collisionTilemaps = [];

// On Room Start (or somewhere else, if relevant), fetch your baseline collision tilemap ID:
global.collisionTilemaps = [layer_tilemap_get_id("CollisionTilemap")];

// When loading a room, grab the collision tilemap ID and push it to the global collision tilemaps array:
roomData = RoomLoader.Load(rmExample, 0, 0);
var _collisionTilemap = roomData.GetTilemap("CollisionTilemap");
array_push(global.collisionTilemaps, _collisionTilemap);

// When unloading a room, remove the collision tilemap from the global collision tilemaps array:
var _collisionTilemap = roomData.GetTilemap("CollisionTilemap");
var _collisionTilemapIndex = array_get_index(global.collisionTilemaps, loadedRoom.collisionTilemap);
if (_collisionTilemapIndex != -1) {
    array_delete(global.collisionTilemaps, _collisionTilemapIndex, 1);
}
loadedRoom.returnData();
```
:::
