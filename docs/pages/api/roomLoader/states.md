# States

States define how rooms are positioned, filtered by flags, transformed, and adjusted in other ways during :Loading: and :Screenshotting:. The expected workflow is:
1. Set states before calling any loading/screenshotting methods.
2. Perform loading/screenshotting.
3. States reset automatically afterwards. If you want to apply the same configuration again, you'll need to re-specify it before the next call.

---

This system uses a [Builder](https://refactoring.guru/design-patterns/builder)-like pattern with a [Fluent Interface](https://en.wikipedia.org/wiki/Fluent_interface), meaning you can chain methods together in a natural, English-like flow to set up optional parameters in any order before loading or screenshotting a room.

:::code-group
```js [Examples]
// Loads rmExample's instances and sprites centered in the room
// and randomly rotated:
payload = RoomLoader
    .Instances().Sprites()
    .MiddleCenter().Angle(random(360)))
    .Load(rmExample, room_width / 2, room_height / 2);

// Loads rmExample's instances scaled up by x2:
instances = RoomLoader.Scale(2).LoadInstances(rmExample, someX, someY);

// Whene working with perspective visuals, turns a visual walls tilemap into
// a collision tilemap:
collisionTilemap = RoomLoader
    .Tileset(tsWallsCollision)
    .LoadTilemap(rmExample, 0, 0, "Walls", collisionLayer);
```
:::

The States system does not replace normal optional arguments - those are still available in all :Loading: and :Screenshotting: methods.
Instead, it provides a more verbose and cleaner alternative, letting you cherry-pick only the arguments you care about without writing long method calls.

---

The following sections break down the available state categories
* [Origin](#origin) - Where the room is anchored.
* [Flags](#flags) - Which asset types to include.
* [Transformation](#transformation) - Scaling, mirorring, flipping and rotating options.
* [Miscellaneous](#miscellaneous) - Extra parameters like multiplicative scaling and additive rotation when loading full rooms or instances, and custom tilesets when loading tilemaps.

## Origin

### `.XOrigin()`

> `RoomLoader.XOrigin(xOrigin)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.YOrigin()`

> `RoomLoader.YOrigin(yOrigin)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.Origin()`

> `RoomLoader.YOrigin(xOrigin, [yOrigin])` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### Presets

@TODO

| Method | X Origin | Y Origin |
|---|---|---|
| `.TopLeft()` | `0` | `0` |
| `.TopCenter()` | `0.5` | `0` |
| `.TopRight()` | `1` | `0` |
| `.MiddleLeft()` | `0` | `0.5` |
| `.MiddleCenter()` | `0.5` | `0.5` |
| `.MiddleRight()` | `1` | `0.5` |
| `.BottomLeft()` | `0` | `1` |
| `.BottomCenter()` | `0.5` | `1` |
| `.BottomRight()` | `1` | `1` |

## Flags

@TODO

### `.Flags()`

> `RoomLoader.Flags(flags)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### Builder

@TODO

| Method | Flag |
|---|---|
| `.Instances()` | ROOMLOADER_FLAG.INSTANCES |
| `.Tilemaps()` | ROOMLOADER_FLAG.TILEMAPS |
| `.Sprites()` | ROOMLOADER_FLAG.SPRITES |
| `.Sequences()` | ROOMLOADER_FLAG.SEQUENCES |
| `.Texts()` | ROOMLOADER_FLAG.TEXTS |
| `.Backgrounds()` | ROOMLOADER_FLAG.BACKGROUNDS |

@TODO

## Transformation

### `.XScale()`

> `RoomLoader.XScale(XScale)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.YScale()`

> `RoomLoader.YScale(yScale)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.Scale()`

> `RoomLoader.Scale(xScale, [yScale])` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.Mirror()`

> `RoomLoader.Mirror()` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.Flip()`

> `RoomLoader.Flip()` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.Angle()`

> `RoomLoader.Flip()` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

## Miscellaneous

### `.MultScale()`

> `RoomLoader.Flip(tileset)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.AddAngle()`

> `RoomLoader.Flip(tileset)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::

### `.Tileset()`

> `RoomLoader.Flip(tileset)` ➜ :Struct:.:RoomLoader:

@TODO

:::code-group
```js [Example]

```
:::