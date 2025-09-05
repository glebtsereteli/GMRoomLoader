# Payload

When loading full rooms using :RoomLoader.Load():, the method returns a `RoomLoaderPayload()` instance - a struct that stores the IDs of all created layers and their elements and provides methods organized into the following sections:
* [Depth](/pages/api/payload/depth) allows you to shift layer depths to be above or below a certain layer or depth.
* [Getters](/pages/api/payload/getters) provide options to retreive an ID of any loaded layer or element.
* [Cleanup](/pages/api/payload/cleanup) is used for cleaning up loaded contents. This is also often called "unloading" or "destroying" a loaded room.

::: warning
The `RoomLoaderPayload()` constructor is intended for internal use by the room loading system and should NOT be instantiated manually outside of its designated context.
:::

::: tip
This default behavior can be changed if you set the [ROOMLOADER_DELIVER_PAYLOAD](/pages/api/config/#roomloader-deliver-payload) config to `false`. When disabled, :RoomLoader.Load(): will return :Undefined: instead of a :Struct:.:Payload:.

Disabling this can improve loading performance at scale, since element IDs are no longer tracked.

This is especially useful when you're loading MANY elements at scale and cleanup isn't needed, like when you know that [switching rooms](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Rooms.htm#:~:text=room_get_info-,Switching%20Rooms,-room_goto) will automatically remove all loaded elements.
:::
