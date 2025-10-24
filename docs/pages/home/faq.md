# Frequently Asked Questions

This page contains answers to frequently asked questions about GMRoomLoader.

## 📍 What platforms does GMRoomLoader support?
| Platform | Status | Notes |
| --- | --- | --- |
| **Windows** | ✅ Yes | Tested |
| **macOS** | ✅ Yes | Tested |
| **GX.games** | ✅ Yes | Tested |
| **Linux** | ✅ Yes | Tested |
| **HTML5** | ❌ No | Use WASM with GX.games |
| **Android** | 🚧 Likely | Untested |
| **iOS** | 🚧 Likely | Untested |
| **PS5** | 🚧 Likely | Untested |
| **Xbox** | 🚧 Likely | Untested |
| **Nintendo Switch** | 🚧 Likely | Untested |

## 📍 What versions of GameMaker does GMRoomLoader support?
The latest Monthly. Currently that's `IDE v2024.13.1.193` and `Runtime v2024.13.1.242`.

## 📍 How is GMRoomLoader licensed? Can I use it in commercial projects?

GMRoomLoader is licensed under the [MIT license](https://github.com/glebtsereteli/GMRoomLoader/blob/main/LICENSE), granting you full freedom to use it for any purpose, including commercial projects. The only requirement is to include the `GMRoomLoader License.txt` file that comes with the library package.

Mentioning my name (Gleb Tsereteli) in your game's credits would be greatly appreciated and would totally make my day, but it's entirely optional 🙂

## 📍 How do I update to the latest version of GMRoomLoader? {#updating}
1. If you've made changes to the `RoomLoaderConfig` script, make a backup of the script before continuing.
2. Delete the `GMRoomLoader` folder from your project.
3. Repeat the [Installation](/pages/home/gettingStarted/gettingStarted/#installation) process.
4. If you've made changes to the `RoomLoaderConfig` script, paste the changes back from your backup.
    ::: warning KEEP IN MIND
    The config setup might change between versions, so make sure to pay attention to the release notes and adjust your pasted configs accordingly.
    :::

## 📍 Can GMRoomLoader assist with procedural generation?
No. GMRoomLoader is designed specifically for loading rooms. Procedural generation, along with any custom logic for determining which room to pick and where it should go, will need to be handled on your own.

## 📍 Can GMRoomLoader be used for modding? Is live reloading supported?
No. GMRoomLoader retrieves data from :room_get_info():, which only provides access to room information initialized at compile time. This means that at runtime, you can only access rooms exactly as they existed when the game was compiled. 

As a result, modding and live reloading aren't possible by design.

If any of this is essential for your project, consider buying [GMRoomPack by YellowAfterlife](https://yellowafterlife.itch.io/gmroompack), the OG library that inspired GMRoomLoader. It works directly with room `.yy` files, which allows for both modding and rather trivial live reloading.

## 📍 I'm loading a room and I think it works, but I can't see some (or all) of the loaded elements. How can I fix that?
Mind your depth! GMRoomLoader creates room layers at the exact depths assigned in the Room Editor. If the room you're loading other rooms into has a few layers, make sure to manage their depths so they are either in front or behind loaded layers, depending on your use case.

The good news is layer depths are easily adjustable and you're not stuck with the default depths from the loaded room. Check out the [Payload Depth](/pages/api/payload/depth) section to see how you can shift depths for loaded layers.

## 📍 My rooms have instances with Variable Definitions and Creation Code. Does GMRoomLoader support those?
It does! :room_get_info(): provides both as scripts for GMRoomLoader to use. 

::: info NOTE
The execution order follows GameMaker's default and is structured like this:
1. Room-defined parameters + Variable Definitions (mixed in a single pre-create struct).
2. Create event.
3. Creation Code.
:::

## 📍 Can I track loaded elements and "destroy" or "unload" a room after loading it?

Of course you can, that's essential! The way you do it depends on what exactly has been loaded: [Full Rooms](/pages/api/roomLoader/loading/#full-rooms), [Instances](/pages/api/roomLoader/loading/#loadinstances) or [Tilemaps](/pages/api/roomLoader/loading/#loadtilemap). Each case is described below.

### Full Rooms

When loading full rooms with :RoomLoader.Load():, it returns a :Payload: struct that has a :.Cleanup(): method for removing all loaded layers and their elements.

First store the struct in a variable when you load the room, and when it's time to destroy the room, call :.Cleanup(): on the returned struct:

:::code-group
```js [Example]
// When you load a room:
payload = RoomLoader.Load(rmExample, x, y);

// When you need to unload a room:
payload.Cleanup(); // [!code highlight]
```
:::

::: warning
GMRoomLoader only tracks layers and elements it loads itself. Anything else you add afterwards must be cleaned up manually.
:::

### Instances

When loading instances with :RoomLoader.LoadInstances():, it returns an array of loaded [Instance IDs](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/Instances.htm).

First store the array in a variable when you load instances, and when it's time to destroy them, loop through the array and call [instance_destroy()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/instance_destroy.htm) on each instance to destroy it:
:::code-group
```js [Example]
// When you load instances:
instances = RoomLoader.LoadInstances(rmExample, x, y);

// When you need to destroy loaded instances:
array_foreach(instances, function(_instance) { // [!code highlight]
    instance_destroy(_instance); // [!code highlight]
}); // [!code highlight]
```
:::

### Tilemaps

When loading tilemaps with :RoomLoader.LoadTilemap():, it returns an :Id.Tilemap:.

First store the ID in a variable, and when it's time to destroy it, call [layer_tilemap_destroy()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Tile_Map_Layers/layer_tilemap_destroy.htm)

:::code-group
```js [Example]
// When you load the tilemap:
tilemap = RoomLoader.LoadTilemap(rmExample, x, y, "Tiles");

// When you need to destroy the tilemap:
layer_tilemap_destroy(tilemap); // [!code highlight]
```
:::

## 📍 How can I collide with loaded tilemaps?

### Separate
When you load a room with a tile layer (with :ROOMLOADER_MERGE_LAYERS: and :ROOMLOADER_MERGE_TILEMAPS: set to `false`), a new tilemap is created.

To collide with this newly loaded tilemap, you need to grab its ID and store it in some variable. If you're currently colliding with, say, a variable holding a tilemap ID, you'll need to change that to a dynamic setup using an array.

::: code-group
```js [Example]
// In some script, initialize a global array of collision tilemaps:
global.collisionTilemaps = [];

// On Room Start (or somewhere else, if relevant), fetch your baseline collision tilemap ID:
global.collisionTilemaps = [layer_tilemap_get_id("CollisionTilemap")];

// When loading a room, grab the collision tilemap ID and push it to the global collision tilemaps array:
payload = RoomLoader.Load(rmExample, x, y);
collisionTilemap = payload.GetTilemap("CollisionTilemap");
array_push(global.collisionTilemaps, collisionTilemap);

// When unloading a room, remove the collision tilemap from the global collision tilemaps array:
var _index = array_get_index(global.collisionTilemaps, collisionTilemap);
array_delete(global.collisionTilemaps, _index, 1);
payload.Cleanup();
```
:::

### Merged
Alternatively, you can make use of :ROOMLOADER_MERGE_LAYERS: and :ROOMLOADER_MERGE_TILEMAPS: to merge loaded tilemaps into existing ones. That way you don't need to juggle multiple tilemap IDs and can keep using a single tilemap for collision, auto-tiling or any other needs where having a single tilemap is preferable.
