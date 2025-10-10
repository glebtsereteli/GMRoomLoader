# Screenshotting

The following methods allow taking screenshots of initialized rooms. 

Screenshots can be used in a variety of ways, like displaying previews in a level selection menu, capturing layouts for notes or level design, or previewing rooms in the world before loading them in.

::: danger ❗ PERFORMANCE NOTE
If room data hasn't been initialized before screenshotting, GMRoomLoader will initialize it automatically. This is fine for quick tests or small rooms, but it **significantly slows down** loading. See the :Initialization: page for best practices.
:::

::: warning
Screenshotting methods return new sprites created by [sprite_create_from_surface()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_create_from_surface.htm).
Make sure to keep track of them and delete them using [sprite_delete()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_delete.htm) when they're no longer needed.
:::

## `.Screenshot()`

> `RoomLoader.Screenshot(room, [xOrigin], [yOrigin], [xScale], [yScale], [flags]` ➜ :Asset.GMSprite:

Takes a screenshot of the given room. If specified, assigns the optional :Origin: and scale to the created sprite and filters the captured elements by the given :Flags:.

Returns the created :Asset.GMSprite:.

| Parameter | Type | Description |
|-----------|------|-------------|
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `[xOrigin]` | :Real: | The x sprite :Origin: [Default: :State.XOrigin: if set, or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y sprite :Origin: [Default: :State.YOrigin: if set, or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[xScale]` | :Real: | The horizontal sprite scale [Default: :State.XScale: if set, or `1`] |
| `[yScale]` | :Real: | The vertical sprite scale [Default: :State.YScale: if set, or `1`] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags used to filter captured elements [Default: :State.Flags: if set, or :ROOMLOADER_FLAG:.`ALL`] |

:::code-group
```js [Regular]
// Takes a screenshot of rmExample with a Middle Center origin, captures only
// Tilemaps and Sprites:
var _flags = ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.SPRITES;
screenshot = RoomLoader.Screenshot(rmExample, 0.5, 0.5, _flags); // [!code highlight]
```
```js [State]
// Takes a screenshot of rmExample with a Middle Center origin, captures only
// Tilemaps and Sprites:
screenshot = RoomLoader.MiddleCenter().Tilemaps().Sprites().Screenshot(rmExample); // [!code highlight]
```
:::

## `.ScreenshotPart()`

> `RoomLoader.ScreenshotPart(room, left, top, width, height, [xOrigin], [yOrigin], [xScale], [yScale], [flags])` ➜ :Asset.GMSprite:

Takes a screenshot part of the given room, with the captured area defined by `left`, `top`, `width` and `height` parameters, just like [draw_sprite_part()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Drawing/Sprites_And_Tiles/draw_sprite_part.htm). If specified, assigns the optional :Origin: and scale to the created sprite and filters the captured elements by the given :Flags:.

Returns the created :Asset.GMSprite:.

| Parameter | Type | Description |
|-----------|------|-------------|
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `left` | :Real: | The x position on the sprite of the top-left corner of the area to capture (`0–1` percentage) |
| `top` | :Real: | The y position on the sprite of the top-left corner of the area to capture (`0–1` percentage) |
| `width` | :Real: | The width of the area to capture (`0–1` percentage) |
| `height` | :Real: | The height of the area to capture (`0–1` percentage) |
| `[xOrigin]` | :Real: | The x sprite :Origin: [Default: :State.XOrigin: if set, or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y sprite :Origin: [Default: :State.YOrigin: if set, or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[xScale]` | :Real: | The horizontal scale to create the sprite at [Default: :State.XScale: if set, or `1`] |
| `[yScale]` | :Real: | The vertical scale to create the sprite at [Default: :State.YScale: if set,  or `1`] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags used to filter the captured elements [Default: :State.Flags: if set, or :ROOMLOADER_FLAG:.`ALL`] |

:::code-group
```js [Regular]
// Takes a screenshot of the top-left quadrant of rmExample with a Middle Center origin,
// scales it up by a factor of 2, and captures only Instances:
screenshot = RoomLoader.ScreenshotPart(rmExample, 0, 0, 0.5, 0.5, 0.5, 0.5, 2, 2, ROOMLOADER_FLAG.INSTANCES); // [!code highlight]
```
```js [State]
// Takes a screenshot of the top-left quadrant of rmExample with a Middle Center origin,
// scales it up by a factor of 2, and captures only Instances:
screenshot = RoomLoader
.MiddleCenter().Scale(2).Instances()
.ScreenshotPart(rmExample, 0, 0, 0.5, 0.5); // [!code highlight]
```
:::
