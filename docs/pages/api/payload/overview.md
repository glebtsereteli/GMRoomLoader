# Payload

When loading rooms using :RoomLoader.Load():, the function returns an instance of the `RoomLoaderPayload()` constructor - a struct that stores the IDs of all created layers and their elements. It can be used to retrieve element IDs and, if necessary, clean up the loaded content (which you might also call "unloading" or "destroying" a loaded room).
:::code-group
```js [Example]
// Load rmExample and store its Payload in a variable:
roomPayload = RoomLoader.Load(rmExample, 0, 0);

// Fetch the ID of the Collision tilemap:
collisionTilemap = RoomLoader.GetTilemap("Collision");

// Unload the room at some later point:
roomPayload.Cleanup();
```
:::

::: warning
The `RoomLoaderPayload()` constructor is intended for internal use by the room loading system and should NOT be instantiated manually outside of its designated context.
:::

Check out the [Getters](/pages/api/payload/getters) and [Cleanup](/pages/api/payload/cleanup) sections next to learn about the available methods.

## Exception

This default behavior can be changed if you set the [ROOMLOADER_DELIVER_PAYLOAD](/pages/api/config/#roomloader-deliver-payload) config to `false`. When disabled, :RoomLoader.Load(): will return :Undefined: instead of a :Struct:.:Payload:.

Disabling this can improve loading performance at scale, since element IDs are no longer tracked. This is especially useful in cases where cleanup isn't needed, like when you know that [switching rooms](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Rooms.htm#:~:text=room_get_info-,Switching%20Rooms,-room_goto) will automatically remove all loaded elements.
