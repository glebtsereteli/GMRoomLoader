# Screenshotting

The following methods allow taking screenshots of initialized rooms. 

Screenshots can be used in a variety of ways, like displaying previews in a level selection menu, capturing layouts for notes or level design, or previewing rooms in the world before loading them in.

::: danger IMPORTANT
Rooms can only be screenshotted if their data has been initialized. Make sure to [Initialize](/pages/api/roomLoader/data/#initialization) the data for any room you intend to screenshot beforehand, or the game will crash.
:::

::: warning
Screenshotting methods return new sprites created by [sprite_create_from_surface()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_create_from_surface.htm).
Make sure to keep track of them and delete them using [sprite_delete()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_delete.htm) when they're no longer needed.
:::

## `.Screenshot()`

> `RoomLoader.Screenshot(room, [xOrigin], [yOrigin], [scale], [flags]` ➜ :Asset.GMSprite:

Takes a screenshot of the given room. Assigns the given origin and scale to the created sprite and filters the captured elements by the given flags.

Returns the created :Asset.GMSprite: reference.

| Parameter | Type | Description |
|-----------|------|-------------|
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `[xOrigin]` | :Real: | The x sprite :Origin: [Default: :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y sprite :Origin: [Default: :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[scale]` | :Real: | The sprite scale [Default: `1`] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags to filter captured elements by [Default: :ROOMLOADER_FLAG:.`ALL`] |

:::code-group
```js [Example]
// Create event.
// Take a screenshot of the rmExample room with a Middle Center origin,
// capture only Tilemaps and Sprites:
var _flags = ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.SPRITES;
screenshot = RoomLoader.Screenshot(rmExample, 0.5, 0.5, _flags); // [!code highlight]

// Draw GUI event. Draw screenshot centered on the screen:
var _x = display_get_gui_width() / 2;
var _y = display_get_gui_height() / 2;
draw_sprite(screenshot, 0, _x, _y);
```
:::

## `.ScreenshotPart()`

> `RoomLoader.ScreenshotPart(room, left, top, width, height, [xOrigin], [yOrigin], [scale], [flags])` ➜ :Asset.GMSprite:

Takes a screenshot part of the given room defined by `left`, `top`, `width` and `height` parameters, just like [draw_sprite_part()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Drawing/Sprites_And_Tiles/draw_sprite_part.htm).

Assigns the given origin and scale to the created sprite and filters the captured elements by the given flags. Returns the created :Asset.GMSprite: ref.

| Parameter | Type | Description |
|-----------|------|-------------|
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `left` | :Real: | The x position on the sprite of the top-left corner of the area to capture (`0–1` percentage) |
| `top` | :Real: | The y position on the sprite of the top-left corner of the area to capture (`0–1` percentage) |
| `width` | :Real: | The width of the area to capture (`0–1` percentage) |
| `height` | :Real: | The height of the area to capture (`0–1` percentage) |
| `[xOrigin]` | :Real: | The x sprite :Origin: [Default: :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y sprite :Origin: [Default: :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[scale]` | :Real: | The scale to create the sprite at [Default: `1`] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags to filter the captured elements by [Default: :ROOMLOADER_FLAG:.`ALL`] |

:::code-group
```js [Example]
// Create event.
// Take a screenshot of the top-left quadrant of the rmExample room with a Middle Center origin,
// scale it up by a factor of 2, and capture only Instances:
screenshot = RoomLoader.ScreenshotPart(rm_chunk_easy_01, 0, 0, 0.5, 0.5, 0.5, 0.5, 2, ROOMLOADER_FLAG.INSTANCES); // [!code highlight]

// Draw GUI event. Draw screenshot centered on the screen:
var _x = display_get_gui_width() / 2;
var _y = display_get_gui_height() / 2;
draw_sprite(screenshot, 0, _x, _y);
```
:::
