# Asset Type Filtering

When loading rooms with :RoomLoader.Load(): or using :Screenshotting: methods, you may want to filter target room data by asset type, so that only assets of the specified types are loaded/screenshotted.

This section explains how to achieve this using the `ROOMLOAD_FLAG` :Enum:.

## `ROOMLOADER_FLAG`

> `ROOMLOADER_FLAG.INSTANCES`

Asset type flags are stored in the `ROOMLOADER_FLAG` enum. In most cases, you'll use them:
* Individually to target a single asset type.
* Combined together using the bitwise OR `|` operator to target multiple asset types. 

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
RoomLoader.Load(rmLevelCastle01, 0, 0, 0.5, 0.5, ROOMLOADER_FLAG.TILEMAPS); // [!code highlight]

// Loads rmLevelMaze11's Instances and Sprites: 
var _flags = (ROOMLOADER_FLAG.INSTANCES | ROOMLOADER_FLAG.TILEMAPS); // [!code highlight]
RoomLoader.Load(rmMaze11, 0, 0, 0, 0, _flags);

// Loads rmLevelRoof's with flags set to All BUT Sequences:
var _flags = (ROOMLOADER_FLAG.ALL & ~ROOMLOADER_FLAG.SEQUENCES); // [!code highlight]
RoomLoader.Load(rmLevelRoof, 0, 0, 0, 0, _flags);
```
:::