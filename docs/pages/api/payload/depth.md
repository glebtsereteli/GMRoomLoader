# Depth

When loading full rooms with multiple layers, you may want to shift their depths so they appear either above or below a specific depth in the current room.

This is especially useful if you don't want the hassle of manually aligning layer depths across all your host and loaded rooms. With depth shifting, you can load a room with any layer depth setup and then reposition it relative to the host room's depth layout.

The methods below allow you to shift depths for all loaded layers at once.

::: tip
If you need more precise control over individual layer depths, use [.GetLayer()](/pages/api/payload/getters/#getlayer) or [.GetLayers()](/pages/api/payload/getters/#getlayers) Payload methods to fetch layer IDs and [layer_get_depth()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/General_Layer_Functions/layer_get_depth.htm) + [layer_depth()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/General_Layer_Functions/layer_depth.htm) functions to adjust their depths manually.
:::

## `.DepthAbove()`

> `payload.DepthAbove(layerOrDepth, [offset])` -> :Struct:.:Payload:

Shifts all layers to a depth above `layerOrDepth`, with an optional depth offset.

| Parameter | Type | Description |
|---|---|---|
| `layerOrDepth` | :Id.Layer: or :String: or :Real: | The layer or depth to shift depth above |
| `[offset]` | :Real: | The depth offset [Default: `-100`] |

:::code-group
```js [Example]
// Load rmLevelForest and shift all its layers above the "Instances" layer:
payload = RoomLoader.Load(rmLevelForest, x, y);
payload.DepthAbove("Instances"); // [!code highlight]
```
:::

## `.DepthBelow()`

> `payload.DepthBelow(layerOrDepth, [offset])` -> :Struct:.:Payload:

Shifts all layers to a depth above `layerOrDepth`, with an optional depth offset.

| Parameter | Type | Description |
|---|---|---|
| `layerOrDepth` | :Id.Layer: or :String: or :Real: | The layer or depth to shift depth below |
| `[offset]` | :Real: | The depth offset [Default: `100`] |

:::code-group
```js [Example]
// Load rmLevelCave and shift all its layers 500 depth below the "Overlay" layer:
payload = RoomLoader.Load(rmLevelCave);
payload.DepthBelow("Overlay", 500); // [!code highlight]
```
:::