# Asset Type Filtering

When loading rooms with :RoomLoader.Load(): or using :Screenshotting: methods, you might want to filter target room data by asset type, so that only assets of the specified types are loaded or screenshotted.

This section explains how to achieve this using the :ROOMLOADER_FLAG: :Enum:.

## `ROOMLOADER_FLAG`

> `ROOMLOADER_FLAG.INSTANCES`

Asset type flags are stored in the `ROOMLOADER_FLAG` enum. In most cases, you'll use these:
* Individually to target a single asset type.
* Combined using the bitwise OR `|` operator to target multiple asset types.

::: tip STATE HANDLING
If you're not a fan of bitwise operations, see the alternative way to filter by asset type via :State.Flags:, and the **State** examples below.
:::

| Member | Description |
| --- | --- |
| `NONE` | Doesn't load anything|
| `INSTANCES` | Loads Instances from Instance layers|
| `TILEMAPS` | Loads Tilemaps from Tile layers|
| `SPRITES` | Loads Sprites from Asset layers|
| `SEQUENCES` | Loads Sequences from Asset layers|
| `TEXTS` | Loads Texts from Asset layers|
| `BACKGROUNDS` | Loads Backgrounds from Background layers|
| `EFFECTS` | Loads Effect layers and on-layer Effects|
| `CORE` | Includes `INSTANCES`, `SPRITES` and `TILEMAPS`|
| `EXTENDED` | Includes `SEQUENCES`, `TEXTS`, `BACKGROUNDS` and `EFFECTS`|
| `ALL` | Includes all asset types (`CORE` + `EXTENDED`). Used by default via the :ROOMLOADER_DEFAULT_FLAGS: config macro|

:::code-group
```js [Regular]
// Loads rmLevelCastle01's Tilemaps centered:
RoomLoader.Load(rmLevelCastle01, x, y, 0.5, 0.5, ROOMLOADER_FLAG.TILEMAPS); // [!code highlight]

// Loads rmLevelMaze11's Instances and Sprites: 
var _flags = ROOMLOADER_FLAG.INSTANCES | ROOMLOADER_FLAG.TILEMAPS; // [!code highlight]
RoomLoader.Load(rmMaze11, x, y, 0, 0, _flags);

// Loads rmLevelRoof with flags set to All BUT Sequences:
var _flags = ROOMLOADER_FLAG.ALL & ~ROOMLOADER_FLAG.SEQUENCES; // [!code highlight]
RoomLoader.Load(rmLevelRoof, x, y, 0, 0, _flags);
```
```js [State]
// Loads rmLevelCastle01's Tilemaps centered:
RoomLoader.MiddleCenter().Tilemaps().Load(rmLevelCastle01, x, y); // [!code highlight]

// Loads rmLevelMaze11's Instances and Sprites: 
RoomLoader.Instances().Tilemaps().Load(rmMaze11, x, y); // [!code highlight]

// Loads rmLevelRoof with flags set to All BUT Sequences:
var _flags = ROOMLOADER_FLAG.ALL & ~ROOMLOADER_FLAG.SEQUENCES;
RoomLoader.Flags(_flags).Load(rmLevelRoof, x, y); // [!code highlight]
```
:::