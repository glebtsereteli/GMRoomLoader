# Cleanup

## Overview

Cleanup, also known as "unloading" or "destroying" a room, is typically used when the loaded room contents are no longer needed. For example, if you're doing chunking by dynamically loading and unloading parts of a level as the player approaches, or regenerating a procedural layout and need to clean up the previous one before loading a new one.

::: info MERGED LAYERS
When [ROOMLOADER_MERGE_LAYERS](/pages/api/config/#roomloader-merge-layers) is enabled, layers reused from the host room are not tracked by :Payload: and will not be destroyed during :.Cleanup():.
:::

::: warning NEWLY CREATED INSTANCES
* Instances you create on a :Payload:-tracked layer will be destroyed during :.Cleanup():, since destroying a layer destroys everything on it. To avoid this, create such instances on untracked layers or use [instance_create_depth()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/instance_create_depth.htm) instead.
* Instances you create on an untracked layer won't be destroyed during :.Cleanup():. Make sure to handle their cleanup manually.
:::

## `.Cleanup()`

> `payload.Cleanup()` ➜ :Struct:.:Payload:

Destroys all created layers and their elements. After calling this method, the :Payload: instance should be dereferenced to be picked up by the [Garbage Collector](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Garbage_Collection/Garbage_Collection.htm).

:::code-group
```js [Example]
// When you load the room
payload = RoomLoader.Load(rmExample, x, y);

// When it's time to unload the room
payload.Cleanup(); // [!code highlight]
```
:::