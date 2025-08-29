# Frequently Asked Questions

This page contains answers to frequently asked questions about GMRoomLoader.

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

## 📍 How do I update to the latest version of GMRoomLoader? {#updating}
1. If you've made changes to the `RoomLoaderConfig` script, make a backup of the script before continuing.
2. Delete the `GMRoomLoader` folder from your project.
3. Repeat the [Installation](/pages/home/gettingStarted/#installation) process.
4. If you've made changes to the `RoomLoaderConfig` script, paste the changes back from your backup.
    ::: warning KEEP IN MIND
    The config setup might change between versions, so make sure to pay attention to the release notes and adjust your pasted configs accordingly.
    :::

## 📍 Can GMRoomLoader assist with procedural generation?
No. GMRoomLoader is designed specifically for loading rooms. Procedural generation, along with any custom logic for determining which room to pick and where it should go, will need to be handled on your own.

## 📍 Can GMRoomLoader be used for modding? Is live reloading supported?
No. GMRoomLoader retrieves data from :room_get_info():, which only provides access to room information initialized at compile time. This means that at runtime, you can only access rooms exactly as they existed when the game was compiled. 

As a result, modding and live reloading aren't possible by design.

If any of this is essential for your project, consider buying [GMRoomPack by YellowAfterlife](https://yellowafterlife.itch.io/gmroompack), the OG library that inspired GMRoomLoader. While it's not as modern and fancy as GMRoomLoader, it works directly with room `.yy` files, which allows for both modding and rather trivial live reloading.

## 📍 I'm loading a room and it I think it works, but I can't see some (or all) of the loaded elements. How can I fix that?
Mind your depth! GMRoomLoader creates room layers at the exact depths assigned in the Room Editor. If the room you're loading other rooms into has a few layers, make sure to manage their depths so they are either in front or behind loaded layers, depending on your use case.

The good news is layer depths are easily adjustable and you're not locked into those default depths from the loaded room. Check out the [Payload Depth](/pages/api/payload/depth) section to see how you can shift depths for loaded layers.

## 📍 My rooms have instances with Variable Definitions and Creation Code. Does GMRoomLoader support those?
It does! :room_get_info(): provides both as scripts for GMRoomLoader to use. 

::: info NOTE
The execution order follows GameMaker's default and is structured like this:
1. Room-defined parameters + Variable Definitions (mixed in a single pre-create struct).
2. Create event.
3. Creation Code.
:::

## 📍 Can I "destroy" or "unload" a room after loading it?
* If you're loading full rooms with :RoomLoader.Load():, it returns an instance of :Payload:, which has a [.Cleanup()](/pages/api/payload/cleanup/#cleanup-1) method for removing all loaded layers and their elements.
:::code-group
```js [Example]
// When you load a room:
payload = RoomLoader.Load(rmExample, someX, someY);

// When you need to unload a room:
payload.Cleanup();
```
:::

::: warning
GMRoomLoader only tracks layers and elements it loads itself. Anything else you add afterwards must be cleaned up manually.
:::

* If you're loading instances with :RoomLoader.LoadInstances():, it return an array of loaded instance IDs. Loop through the array and call [instance_destroy()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/instance_destroy.htm) on each instance to remove them.
:::code-group
```js [Example]
// When you load instances:
loadedInstances = RoomLoader.LoadInstances(rmExample, 0, 0);

// When you need to destroy loaded instances:
array_foreach(loadedInstances, function(_instance) {
    instance_destroy(_instance);
});
```
:::

## 📍 How can I collide with loaded tilemaps?
When you load a room with a tile layer, a new tilemap is created. To collide with this newly loaded tilemap, you need to grab its ID and store it somewhere.

If you're currently colliding with, say, a variable holding a tilemap ID, you'll need to change that to a dynamic setup using an array.

::: code-group
```js [Example]
// In some script, initialize a global array of collision tilemaps:
global.collisionTilemaps = [];

// On Room Start (or somewhere else, if relevant), fetch your baseline collision tilemap ID:
global.collisionTilemaps = [layer_tilemap_get_id("CollisionTilemap")];

// When loading a room, grab the collision tilemap ID and push it to the global collision tilemaps array:
payload = RoomLoader.Load(rmExample, someX, someY);
var _collisionTilemap = payload.GetTilemap("CollisionTilemap");
array_push(global.collisionTilemaps, _collisionTilemap);

// When unloading a room, remove the collision tilemap from the global collision tilemaps array:
var _collisionTilemap = payload.GetTilemap("CollisionTilemap");
var _collisionTilemapIndex = array_get_index(global.collisionTilemaps, _collisionTilemap);
if (_index != -1) {
    array_delete(global.collisionTilemaps, _collisionTilemapIndex, 1);
}
payload.Cleanup();
```
:::
