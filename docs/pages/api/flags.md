# Flags

## Overview

Flags stored in the `ROOMLOADER_FLAG` enum are used to filter room elements by type during :Loading: and :Screenshotting:. In most cases, you'll use them either individually or combined with the bitwise OR `|` operator to work with multiple asset types at once. 

## `ROOMLOADER_FLAG`

| Member  | Description |
| ------------- | ------------- |
| `NONE` | Doesn't load anything. |
| `INSTANCES` | Loads Instances from Instance layers. |
| `TILEMAPS` | Loads Tilemaps from Tile layers. |
| `SPRITES` | Loads Sprites from Asset layers. |
| `SEQUENCES` | Loads Sequences from Asset layers. |
| `TEXTS` | Loads Texts from Asset layers. |
| `BACKGROUNDS` | Loads Backgrounds from Background layers. |
| `CORE` | Includes `INSTANCES`, `SPRITES` and `TILEMAPS`. Used by default via the [ROOMLOADER_DEFAULT_FLAGS](/pages/api/config/#roomloader-default-flags) config macro. |
| `EXTENDED` | Includes `SEQUENCES`, `TEXTS`, and `BACKGROUNDS`. |
| `ALL` | Includes `CORE` and `EXTENDED`. |

:::code-group
```js [Examples]
// Loads rmLevelCastle01's Tilemaps centered:
RoomLoader.load(rmLevelCastle01, 0, 0, 0.5, 0.5, ROOMLOADER_FLAG.TILEMAPS);

// Loads rmLevelMaze11's Instances, Sprites and Particle Systems: 
var _flags = (ROOMLOADER_FLAG.INSTANCES | ROOMLOADER_FLAG.TILEMAPS | ROOMLOADER_FLAG.PARTICLE_SYSTEMS);
RoomLoader.load(rmMaze11, 0, 0, 0, 0, _flags);

// Loads rmLevelRoof's with flags set to All BUT Sequences:
var _flags = (ROOMLOADER_FLAG.ALL & ~ROOMLOADER_FLAG.SEQUENCES);
RoomLoader.load(rmLevelRoof, 0, 0, 0, 0, _flags);
```
:::
