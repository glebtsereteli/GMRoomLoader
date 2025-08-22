# Cleanup

Cleanup, also known as "unloading" or "destroying" a room, is typically used when the loaded room contexts are no longer needed. For example, if you're doing chunking by dynamically loading and unloading parts of a level as the player approaches.

## `.Cleanup()`

> `payload.Cleanup([destroyLayers?])` ➜ N/A

Destroys all created layers and their elements. After calling this method, the :Payload: instance becomes practically useless and should be dereferenced to be picked up by the [Garbage Collector](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Garbage_Collection/Garbage_Collection.htm).

| Parameter          | Type    | Description                             |
|--------------------|---------|-----------------------------------------|
| `[destroyLayers?]` | :Bool:  | Destroy loaded layers? Default = `true` |

::: tip
Setting `destroy_layers` to `false` can be useful when [ROOMLOADER_MERGE_LAYERS](/pages/api/config/#roomloader-merge-layers) is `true` and you don't want to accidentally destroy layers shared between multiple loaded rooms. This way, only the elements belonging to this :Payload: will be destroyed, while the layers themselves remain untouched.
:::

:::code-group
```js [Example]
// When you load the room:
payload = RoomLoader.Load(rmExample, 0, 0);

// When it's time to unload the room:
payload.Cleanup();
```
:::
