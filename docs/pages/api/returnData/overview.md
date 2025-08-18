# ReturnData

## Overview

When loading rooms using :RoomLoader.Load():, the function returns an instance of the `RoomLoaderReturnData` constructor - a struct that stores the IDs of all created layers and their elements. It can be used to retrieve element IDs and, if necessary, clean up the loaded content (which you might also call "unloading" or "destroying" a loaded room).
:::code-group
```js [Example]
// Load rmExample and store its ReturnData in a variable:
loadedRoomData = RoomLoader.Load(rmExample, 0, 0);

// Fetch the ID of the Collision tilemap:
collisionTilemap = RoomLoader.GetTilemap("Collision");

// Unload the room at some later point:
loadedRoomData.Cleanup();
```
:::

::: warning
The `RoomLoaderReturnData` constructor is intended for internal use by the room loading system and should NOT be instantiated manually outside of its designated context.
:::

Check out the [Getters](/pages/api/returnData/getters) and [Cleanup](/pages/api/returnData/cleanup) sections next to learn about the available methods.

## Exception

This default behavior can be changed if you set the [ROOMLOADER_USE_RETURN_DATA](/pages/api/config/#roomloader-use-return-data) config to `false`. When disabled, :RoomLoader.Load(): will return `undefined` instead of a `RoomLoaderReturnData` struct.

Disabling this can improve loading performance at scale, since element IDs are no longer tracked. This is especially useful in cases where cleanup isn't needed, like when you know that switching rooms will automatically remove all loaded elements.
