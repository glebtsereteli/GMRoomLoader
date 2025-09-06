# State

State is an alternative way of preconfiguring :Loading: and :Screenshotting: parameters before calling the methods.

It defines how rooms are positioned, filtered by flags, transformed, and adjusted in other ways during :Loading: and :Screenshotting:. The intended workflow goes like this:
1. Set state before calling any :Loading: or :Screenshotting: methods.
2. Call any :Loading: or :Screenshotting: method.
3. State resets automatically afterwards. If you want to apply the same configuration again, you'll need to re-specify it before the next call.

---

This system uses a [Builder](https://refactoring.guru/design-patterns/builder) pattern with a [Fluent Interface](https://en.wikipedia.org/wiki/Fluent_interface), meaning you can chain methods together in a natural, English-like flow to set up optional parameters in any order before :Loading: or :Screenshotting: a room.

:::code-group
```js [Examples]
// Loads rmExample's sprites and sequences centered in the room and randomly rotated:
payload = RoomLoader
.Sprites().Sequences() // [!code highlight]
.MiddleCenter().Angle(random(360)) // [!code highlight]
.Load(rmExample, room_width / 2, room_height / 2);

// Loads rmExample's instances scaled up by x2:
instances = RoomLoader.Scale(2).LoadInstances(rmExample, x, y); // [!code highlight]

// When working with perspective visuals, turns a visual walls tilemap into
// a collision tilemap:
collisionTilemap = RoomLoader
.Tileset(tsWallsCollision) // [!code highlight]
.LoadTilemap(rmExample, 0, 0, "Walls", collisionLayer);
```
:::

The State system does not replace normal optional arguments - those are still available in all :Loading: and :Screenshotting: methods.
Instead, it provides a more verbose and cleaner alternative, letting you cherry-pick only the arguments you care about without writing long calls.

---

The following sections break down the available state categories
* [Origin](#origin) - Where the room is anchored.
* [Flags](#flags) - Which asset types to include.
* [Transformation](#transformation) - Scaling, mirroring, flipping and rotating options.
* [Miscellaneous](#miscellaneous) - Extra parameters like custom tilesets when loading tilemaps, maybe more in the future.

## Origin

### `.XOrigin()`

> `RoomLoader.XOrigin(xOrigin)` ➜ :Struct:.:RoomLoader:

Sets the X Origin state to use in the next :Loading: or :Screenshotting: call.

|Parameter|Type|Description|
|---|---|---|
|`xOrigin`|:Real:|The X Origin to use in the next :Loading: or :Screenshotting: call |

:::code-group
```js [Example]
// Loads rmExample with a Top-Center origin:
RoomLoader.XOrigin(0.5).Load(rmExample, x, y); // [!code highlight]
```
:::

### `.YOrigin()`

> `RoomLoader.YOrigin(yOrigin)` ➜ :Struct:.:RoomLoader:

Sets the Y Origin state to use in the next :Loading: or :Screenshotting: call.

|Parameter|Type|Description|
|---|---|---|
|`yOrigin`|:Real:|The Y Origin to use in the next :Loading: or :Screenshotting: call |

:::code-group
```js [Example]
// Loads rmExample with a Middle-Left origin:
RoomLoader.YOrigin(0.5).Load(rmExample, x, y); // [!code highlight]
```
:::

### `.Origin()`

> `RoomLoader.Origin(xOrigin, [yOrigin])` ➜ :Struct:.:RoomLoader:

Sets the X and Y Origin states to use in the next :Loading: or :Screenshotting: call.

|Parameter|Type|Description|
|---|---|---|
|`xOrigin`|:Real:|The X Origin to use in the next :Loading: or :Screenshotting: call |
|`[yOrigin]`|:Real:|The Y Origin to use in the next :Loading: or :Screenshotting: call [Default: `xOrigin`] |

:::code-group
```js [Example]
// Loads rmExample with a Middle-Center origin:
RoomLoader.Origin(0.5, 0.5).Load(rmExample, x, y); // [!code highlight]
```
:::

### Presets

For convenience, GMRoomLoader provides a set of built-in origin presets. These are shorthand methods with common values mimicking the GameMaker's sprite origin presets layout, so the pattern should feel immediately familiar.

The goal with these is readability: the methods create a natural English-like flow in code. Instead of raw numbers, you can write what you mean directly, e.g. "load the room at the top right" or "get a centered screenshot".

| Method | X Origin | Y Origin |
|---|---|---|
| `.TopLeft()` | `0.0` | `0.0` |
| `.TopCenter()` | `0.5` | `0.0` |
| `.TopRight()` | `1.0` | `0.0` |
| `.MiddleLeft()` | `0.0` | `0.5` |
| `.MiddleCenter()` | `0.5` | `0.5` |
| `.MiddleRight()` | `1.0` | `0.5` |
| `.BottomLeft()` | `0.0` | `1.0` |
| `.BottomCenter()` | `0.5` | `1.0` |
| `.BottomRight()` | `1.0` | `1.0` |

::: code-group
```js [Examples]
// Load rmExample at the top-right corner of the room with Top-Right origin:
payload = RoomLoader.TopRight().Load(rmExample, room_width, room_height); // [!code highlight]

// Take a centered screenshot of rmExample:
screenshot = RoomLoader.MiddleCenter().Screenshot(rmExample); // [!code highlight]
```
:::

## Flags

### `.Flags()`

> `RoomLoader.Flags(flags)` ➜ :Struct:.:RoomLoader:

Sets the Flags to use in the next :Loading: or :Screenshotting: call. Check out filtering by :Asset Type: for more information.

|Parameter|Type|Description|
|---|---|---|
|`flags`|:Enum:.:ROOMLOADER_FLAG:|The flags to filter the loaded elements by|

:::code-group
```js [Example]
// Loads rmExample's Tilemaps and Sequences:
var _flags = ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.SEQUENCES;
RoomLoader.Flags(_flags).Load(rmExample, x, y); // [!code highlight]
```
:::

### Builder

The **Flags Builder** lets you define what elements of the room should be included in the next :Loading: or :Screenshotting: call.

Each Builder method corresponds to a specific :ROOMLOADER_FLAG: enum member and adds it to the internal Flags state.
* The first call to any of these methods before :Loading: or :Screenshotting: resets the state and sets it to that method's flag, so you always start clean from the one you choose.
* Subsequent calls add their flags on top, letting you combine multiple asset types.

Similar to [Origin Presets](#presets) above, this approach makes the code read in an English-like flow and provides an alternative interface if you don't like dealing with bitwise operators.

| Method | Flag |
|---|---|
| `.Instances()` | :ROOMLOADER_FLAG:.`INSTANCES` |
| `.Tilemaps()` | :ROOMLOADER_FLAG:.`TILEMAPS` |
| `.Sprites()` | :ROOMLOADER_FLAG:.`SPRITES` |
| `.Sequences()` | :ROOMLOADER_FLAG:.`SEQUENCES` |
| `.Texts()` | :ROOMLOADER_FLAG:.`TEXTS` |
| `.Backgrounds()` | :ROOMLOADER_FLAG:.`BACKGROUNDS` |

::: code-group
```js [Examples]
// Load rmExample's Instances: 
RoomLoader.Instances().Load(rmExample, x, y); // [!code highlight]

// Load rmExample's Instances, Tilemaps and Backgrounds
RoomLoader.Instances().Tilemaps().Backgrounds().Load(rmExample, x, y); // [!code highlight]

// Take a screenshot of rmExample with only Sprites and Tilemaps visible:
RoomLoader.Sprites().Tilemaps().Screenshot(rmExample); // [!code highlight]
```
```js [Breakdown]
RoomLoader
// First call, flags are reset to only Instances.
// Current flags representation: ROOMLOADER_FLAG.INSTANCES
.Instances() // [!code highlight]
// Second call, Tilemaps are added.
// Current flags representation: ROOMLOADER_FLAG.INSTANCES | ROOMLOADER_FLAG.TILEMAPS
.Tilemaps() // [!code highlight]
// Third call, Backgrounds are added.
// Current flags representation: ROOMLOADER_FLAG.INSTANCES | ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.BACKGROUNDS
.Backgrounds() // [!code highlight]
// Load rmExample's Instances, Tilemaps and Backgrounds:
.Load(rmExample, x, y);

// And in one line:
RoomLoader.Instances().Tilemaps().Backgrounds().Load(rmExample, x, y); // [!code highlight]
```
:::

## Transformation

### `.XScale()`

> `RoomLoader.XScale(xScale)` ➜ :Struct:.:RoomLoader:

Horizontally scales the next :Loading: by setting **State.XScale**.

|Parameter|Type|Description|
|---|---|---|
|`xScale`|:Real:|The horizontal scale state to use in the next :Loading: or :Screenshotting: call |

:::code-group
```js [Example]
// Loads rmExample horizontally scaled up by 2:
RoomLoader.XScale(2).Load(rmExample, x, y); // [!code highlight]
```
:::

### `.YScale()`

> `RoomLoader.YScale(yScale)` ➜ :Struct:.:RoomLoader:

Vertically scales the next :Loading: by setting **State.YScale**.

|Parameter|Type|Description|
|---|---|---|
|`yScale`|:Real:|The vertical scale to use in the next :Loading: or :Screenshotting: call |

:::code-group
```js [Example]
// Loads rmExample vertically scaled up by 2:
RoomLoader.YScale(2).Load(rmExample, x, y); // [!code highlight]
```
:::

### `.Scale()`

> `RoomLoader.Scale(xScale, [yScale])` ➜ :Struct:.:RoomLoader:

Sets horizontal and vertical scale states to be used in the next :Loading: or :Screenshotting: call.

|Parameter|Type|Description|
|---|---|---|
|`xScale`|:Real:|The horizontal scale to use in the next :Loading: or :Screenshotting: call|
|`[yScale]`|:Real:|The vertical scale to use in the next :Loading: or :Screenshotting: call [Default: `xScale`]|

:::code-group
```js [Example]
// Loads rmExample scaled to half-size:
RoomLoader.Scale(0.5).Load(rmExample, x, y); // [!code highlight]
```
:::

### `.Mirror()`

> `RoomLoader.Mirror([mirror?])` ➜ :Struct:.:RoomLoader:

When `true`, mirrors the next :Loading: by setting **State.XScale** to -1.

|Parameter|Type|Description|
|---|---|---|
|`[mirror?]`|:Bool:|Mirror the next :Loading: call? [Default: `true`]|

:::code-group
```js [Example]
// Loads a mirrored tilemap from the "Tilemap" layer in rmExample:
RoomLoader.Mirror().LoadTilemap(rmExample, x, y, "Tilemap"); // [!code highlight]
```
:::

### `.Flip()`

> `RoomLoader.Flip([flip?])` ➜ :Struct:.:RoomLoader:

When `true`, flips the next :Loading: by setting **State.YScale** to `-1`.

|Parameter|Type|Description|
|---|---|---|
|`[flip?]`|:Bool:|Flip the next :Loading: call? [Default: `true`]|

:::code-group
```js [Example]
// Loads a flipped tilemap from the "Tilemap" layer in rmExample:
RoomLoader.Flip().LoadTilemap(rmExample, x, y, "Tilemap"); // [!code highlight]
```
:::

### `.Angle()`

> `RoomLoader.Angle(angle)` ➜ :Struct:.:RoomLoader:

Rotates the next :Loading: by setting **State.Angle**.

:::code-group
```js [Example]
// Loads rmExample's instances centered and randomly rotated:
RoomLoader.Angle(random(360)).MiddleCenter().LoadInstances(rmExample, x, y); // [!code highlight]
```
:::

### `.MultScale()`

> `RoomLoader.MultScale(multiplicative?)` ➜ :Struct:.:RoomLoader:

Sets the next :Loading:'s elements' `image_xscale/yscale` to be multiplied by `xScale/yScale` arguments (`true`) or not (`false`).

|Parameter|Type|Description|
|---|---|---|
|`multiplicative?`|:Bool:|Multiply next :Loading:'s elements' `image_xscale/yscale` by `xScale/yScale` arguments (`true`) or not (`false`)?|

:::code-group
```js [Example]
// Loads rmExample's instances scaled to fit the room, while keeping their own
// individual scales untouched:
RoomLoader
.XScale(room_width / RoomLoader.DataGetWidth(rmExample))
.YScale(room_height / RoomLoader.DataGetHeight(rmExample))
.MultScale(false) // [!code highlight]
.LoadInstances(rmExample, x, y);
```
:::

### `.AddAngle()`

> `RoomLoader.AddAngle(additive?)` ➜ :Struct:.:RoomLoader:

Sets the next :Loading:'s elements' `image_angle` to be combined with `angle` arguments (`true`) or not (`false`).

|Parameter|Type|Description|
|---|---|---|
|`additive?`|:Bool:|Combine next :Loading:'s elements' `image_angle` with `angle` arguments (`true`) or not (`false`)?|

:::code-group
```js [Example]
// Loads rmExample's instances randomly rotated, while keeping their own
// individual angles untouched:
RoomLoader.AddAngle(false).Angle(random(360)).LoadInstances(rmExample, x, y); // [!code highlight]
```
:::

## Miscellaneous

### `.Tileset()`

> `RoomLoader.Tileset(tileset)` ➜ :Struct:.:RoomLoader:

Sets the tileset to use in the next :RoomLoader.LoadTilemap(): call.

|Parameter|Type|Description|
|---|---|---|
|`tileset`|:Asset.GMTileset:|The tileset to use in the next :RoomLoader.LoadTilemap(): call|

:::code-group
```js [Example]
// When working with perspective visuals, turns a visual walls tilemap into
// a collision tilemap:
collisionTilemap = RoomLoader
.Tileset(tsWallsCollision) // [!code highlight]
.LoadTilemap(rmExample, 0, 0, "Walls", collisionLayer);
```
:::