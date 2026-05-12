# Asset Type Filtering

## Overview

When loading rooms with :RoomLoader.Load(): or using :Screenshotting: methods, you might want to filter target room contents by asset type, so that only assets of the specified types are loaded or screenshotted.

This section explains how to achieve this using the `ROOMLOADER_FLAG_` macros.

## `ROOMLOADER_FLAG_` Macros

> `ROOMLOADER_FLAG_INSTANCES`

Asset type flags are defined as `ROOMLOADER_FLAG_` macros. In most cases, you'll use these:
* Individually to target a single asset type.
* Combined using the bitwise OR `|` operator to target multiple asset types.

::: tip STATE HANDLING
If you're not a fan of bitwise operations, see the alternative way to filter by asset type via :State.Flags:, and the **State** examples below.
:::

| Macro | Description |
| --- | --- |
| `ROOMLOADER_FLAG_NONE` | Doesn't load anything |
| `ROOMLOADER_FLAG_INSTANCES` | Loads Instances from Instance layers |
| `ROOMLOADER_FLAG_TILEMAPS` | Loads Tilemaps from Tile layers |
| `ROOMLOADER_FLAG_SPRITES` | Loads Sprites from Asset layers |
| `ROOMLOADER_FLAG_SEQUENCES` | Loads Sequences from Asset layers |
| `ROOMLOADER_FLAG_PARTICLES` | Loads Particle Systems from Asset layers |
| `ROOMLOADER_FLAG_TEXTS` | Loads Texts from Asset layers |
| `ROOMLOADER_FLAG_BACKGROUNDS` | Loads Backgrounds from Background layers |
| `ROOMLOADER_FLAG_EFFECTS` | Loads Effect layers and on-layer Effects |
| `ROOMLOADER_FLAG_CORE` | Includes `ROOMLOADER_FLAG_INSTANCES`, `ROOMLOADER_FLAG_SPRITES` and `ROOMLOADER_FLAG_TILEMAPS` |
| `ROOMLOADER_FLAG_EXTENDED` | Includes `ROOMLOADER_FLAG_SEQUENCES`, `ROOMLOADER_FLAG_TEXTS`, `ROOMLOADER_FLAG_BACKGROUNDS` and `ROOMLOADER_FLAG_EFFECTS` |
| `ROOMLOADER_FLAG_ALL` | Includes all asset types (`ROOMLOADER_FLAG_CORE` + `ROOMLOADER_FLAG_EXTENDED`). Used by default via the :ROOMLOADER_DEFAULT_FLAGS: config macro |

:::code-group
```js [Regular]
// Loads rmLevelCastle01's Tilemaps centered
RoomLoader.Load(rmLevelCastle01, x, y, 0.5, 0.5, ROOMLOADER_FLAG_TILEMAPS); // [!code highlight]

// Loads rmLevelMaze11's Instances and Tilemaps
var _flags = ROOMLOADER_FLAG_INSTANCES | ROOMLOADER_FLAG_TILEMAPS; // [!code highlight]
RoomLoader.Load(rmMaze11, x, y, 0, 0, _flags);

// Loads rmLevelRoof with flags set to All BUT Sequences
var _flags = ROOMLOADER_FLAG_ALL & ~ROOMLOADER_FLAG_SEQUENCES; // [!code highlight]
RoomLoader.Load(rmLevelRoof, x, y, 0, 0, _flags);
```
```js [State]
// Loads rmLevelCastle01's Tilemaps centered
RoomLoader.MiddleCenter().Tilemaps().Load(rmLevelCastle01, x, y); // [!code highlight]

// Loads rmLevelMaze11's Instances and Tilemaps
RoomLoader.Instances().Tilemaps().Load(rmMaze11, x, y); // [!code highlight]

// Loads rmLevelRoof with flags set to All BUT Sequences
var _flags = ROOMLOADER_FLAG_ALL & ~ROOMLOADER_FLAG_SEQUENCES;
RoomLoader.Flags(_flags).Load(rmLevelRoof, x, y); // [!code highlight]
```
:::