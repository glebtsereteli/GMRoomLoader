# Screenshotting

## Overview

The methods listed on this page allow you to take screenshots of any room in the project without ever visiting it. Screenshots can be baked as [Sprites](#screenshotsprite), [Surfaces](#screenshotsurface) or [Buffers](#screenshotbuffer).

Screenshots can be used in a variety of ways, like displaying previews in a level selection menu, capturing layouts for notes or level design, or previewing rooms in the world before loading them in.

::: danger ❗ PERFORMANCE NOTE
If room data hasn't been initialized before screenshotting, GMRoomLoader will initialize it automatically. This is fine for quick tests or small rooms, but it **significantly slows down** the first screenshotting call for each room. See the :Initialization: page for best practices.
:::

::: tip SCREENSHOTTING ROOM PARTS
Similar to drawing parts of sprites with :draw_sprite_part():, you can use the :.Part(): state method to define a (left/top/width/height) part of the room to capture on the screenshot.
:::

::: tip WORKING AT SCALE
When you need to capture screenshots for many rooms, it's a good idea to use [.ScreenshotSurface()](#screenshotsurface) or [.ScreenshotBuffer()](#screenshotbuffer) to build a dynamic texture group, or a custom sprite atlas to avoid creating a new texture group for every new .ScreenshotSprite() you create. See the [Atlasing](#atlasing) section below for more detail.
:::

## Methods

### `.ScreenshotSprite()`

> `RoomLoader.ScreenshotSprite(room, [xOrigin], [yOrigin], [xScale], [yScale], [flags]` ➜ :Asset.GMSprite:

Takes a screenshot of the given room and returns it as a sprite. If specified, creates the sprite with optional :Origin: and :Scale: and filters captured elements by the given :Flags:.

::: warning
This method returns a :Asset.GMSprite: created by [sprite_create_from_surface()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_create_from_surface.htm).
Make sure to keep track of them and delete them using [sprite_delete()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_delete.htm) when they're no longer needed.
:::

| Parameter | Type | Description |
| --- | --- | --- |
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `[xOrigin]` | :Real: | The x screenshot :Origin: [Default: :State.XOrigin: if set, or :ROOMLOADER_DEFAULT_XORIGIN:] |
| `[yOrigin]` | :Real: | The y screenshot :Origin: [Default: :State.YOrigin: if set, or :ROOMLOADER_DEFAULT_YORIGIN:] |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags used to filter captured elements [Default: :State.Flags: if set, or :ROOMLOADER_FLAG:.`ALL`] |
| `[xScale]` | :Real: | The horizontal screenshot scale [Default: :State.XScale: if set, or `1`] |
| `[yScale]` | :Real: | The vertical screenshot scale [Default: :State.YScale: if set, or `1`] |

:::code-group
```js [Regular]
// Takes a centered sprite screenshot of rmExample with only Tilemaps and Sprites:
var _flags = ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.SPRITES;
screenshot = RoomLoader.ScreenshotSprite(rmExample, 0.5, 0.5, _flags); // [!code highlight]

// Takes a scaled down sprite screenshot of rmExample:
screenshot = RoomLoader.ScreenshotSprite(rmExample, 0, 0, ROOMLOADER_FLAGS.ALL, 0.5, 0.5);
```
```js [State]
// Takes a centered sprite screenshot of rmExample with only Tilemaps and Sprites:
screenshot = RoomLoader.MiddleCenter().Tilemaps().Sprites().ScreenshotSprite(rmExample); // [!code highlight]

// Takes a scaled down sprite screenshot of rmExample:
screenshot = RoomLoader.Scale(0.5).ScreenshotSprite(rmExample);
```
:::

---
### `.ScreenshotSurface()`

> `RoomLoader.ScreenshotSurface(room, [xScale], [yScale], [flags])` ➜ :Id.Surface:

Takes a screenshot of the given room and returns it as a surface. If specified, :Scale:s the output surface and filters captured elements by the given :Flags:.

::: warning
This method returns a :Id.Surface: created by [surface_create()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Drawing/Surfaces/surface_create.htm).
Make sure to keep track of them and free them using [surface_free()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Drawing/Surfaces/surface_free.htm) when they're no longer needed.

Also keep in mind that surface are volatile and don't persist in memory forever - see the [Surface Rules](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Drawing/Surfaces/Surfaces.htm#:~:text=surface_free(surf)%3B-,Surface%20Rules,-Normal%20surfaces%20are) section in the docs.
:::

::: tip
This is especially useful when building your own dynamic texture pages at runtime, see the [Atlasing](#atlasing) section below.
:::

| Parameter | Type | Description |
| --- | --- | --- |
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags used to filter the captured elements [Default: :State.Flags: if set, or :ROOMLOADER_FLAG:.`ALL`] |
| `[xScale]` | :Real: | The horizontal screenshot scale [Default: :State.XScale: if set, or `1`] |
| `[yScale]` | :Real: | The vertical screenshot scale [Default: :State.YScale: if set,  or `1`] |

:::code-group
```js [Regular]
// Takes a surface screenshot of rmExample with only Tilemaps and Sprites:
var _flags = ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.SPRITES;
screenshot = RoomLoader.ScreenshotSurface(rmExample, _flags); // [!code highlight]

// Takes a scaled down surface screenshot of rmExample:
screenshot = RoomLoader.ScreenshotSurface(rmExample, ROOMLOADER_FLAGS.ALL, 0.5, 0.5);
```
```js [State]
// Takes a surface screenshot of rmExample with only Tilemaps and Sprites:
screenshot = RoomLoader.Tilemaps().Sprites().ScreenshotSurface(rmExample); // [!code highlight]

// Takes a scaled down surface screenshot of rmExample:
screenshot = RoomLoader.Scale(0.5).ScreenshotSurface(rmExample);
```
:::

### `.ScreenshotBuffer()`

> `RoomLoader.ScreenshotBuffer(room, [xScale], [yScale], [flags])` ➜ :Struct:

Takes a screenshot of the given room and returns a `{ buffer, width, height }` struct, where `buffer` is the buffer ID filled with image data, `width` is the width of the image, and `height` is the height of the image.

If specified, :Scale:s the output buffer and filters captured elements by the given :Flags:.

::: warning
This method includes a :Id.Buffer: in the returned struct, created by [buffer_create()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Buffers/buffer_create.htm).
Make sure to keep track of them and delete them using [buffer_delete()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Buffers/buffer_delete.htm) when they're no longer needed.
:::

::: tip
This is especially useful when building your own dynamic texture pages at runtime using [texturegroup_add()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Drawing/Textures/texturegroup_add.htm), see the [Atlasing](#atlasing) section below.
:::

| Parameter | Type | Description |
| --- | --- | --- |
| `room` | :Asset.GMRoom: | The room to take a screenshot of |
| `[flags]` | :Enum:.:ROOMLOADER_FLAG: | The flags used to filter the captured elements [Default: :State.Flags: if set, or :ROOMLOADER_FLAG:.`ALL`] |
| `[xScale]` | :Real: | The horizontal scale to create the sprite at [Default: :State.XScale: if set, or `1`] |
| `[yScale]` | :Real: | The vertical scale to create the sprite at [Default: :State.YScale: if set,  or `1`] |

:::code-group
```js [Regular]
// Takes a buffer screenshot of rmExample with only Tilemaps and Sprites:
var _flags = ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.SPRITES;
screenshot = RoomLoader.ScreenshotBuffer(rmExample, _flags); // [!code highlight]

// Takes a scaled down buffer screenshot of rmExample:
screenshot = RoomLoader.ScreenshotBuffer(rmExample, ROOMLOADER_FLAGS.ALL, 0.5, 0.5);
```
```js [State]
// Takes a buffer screenshot of rmExample with only Tilemaps and Sprites:
screenshot = RoomLoader.Tilemaps().Sprites().ScreenshotBuffer(rmExample); // [!code highlight]

// Takes a scaled down buffer screenshot of rmExample:
screenshot = RoomLoader.Scale(0.5).ScreenshotBuffer(rmExample);
```
:::

## Atlasing

working at scale

texturegroup_add

building a canvas texture page