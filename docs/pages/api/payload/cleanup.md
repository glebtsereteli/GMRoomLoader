# Cleanup

Cleanup, also known as "unloading" or "destroying" a room, is typically used when the loaded room contexts are no longer needed. For example, if you're doing chunking by dynamically loading and unloading parts of a level as the player approaches.

::: warning NEWLY CREATED INSTANCES
* If you create instances on a layer tracked by :Payload:, they will be destroyed, since :.Cleanup(): also destroys all loaded layers, which in turn destroy all instances on them (including both instances coming from :RoomLoader.Load(): AND any instances you create yourself afterward). This can be prevented by:
    * A. Avoiding creating new instances on loaded layers by creating them on other layers, or using [instance_create_depth()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/instance_create_depth.htm) to create them at depths instead of layers.
    * B. Setting :.Cleanup():'s `[destroyLayers?]` optional argument to `false` (e.g. if you have layer merging enabled via :ROOMLOADER_MERGE_LAYERS: and need to preserve shared layers).
* If you create instances on a layer not tracked by :Payload:, their IDs will not be tracked and thus they won't be destroyed during :.Cleanup():. Be careful and deal with such instances accordingly.
:::

## `.Cleanup()`

> `payload.Cleanup([destroyLayers?])` ➜ N/A

Destroys all created layers and their elements. After calling this method, the :Payload: instance becomes practically useless and should be dereferenced to be picked up by the [Garbage Collector](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Garbage_Collection/Garbage_Collection.htm).

|Parameter|Type|Description|
|---|---|---|
|`[destroyLayers?]`|:Bool:|Destroy loaded layers? [Default: `true`]|

::: tip
Setting `destroyLayers` to `false` can be useful when [ROOMLOADER_MERGE_LAYERS](/pages/api/config/#roomloader-merge-layers) is `true` and you don't want to accidentally destroy layers shared between multiple loaded rooms. This way, only the elements belonging to this :Payload: will be destroyed, while the layers themselves remain untouched.
:::

:::code-group
```js [Example]
// When you load the room:
payload = RoomLoader.Load(rmExample, x, y);

// When it's time to unload the room:
payload.Cleanup(); // [!code highlight]
```
:::
