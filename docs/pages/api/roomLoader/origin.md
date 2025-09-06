# Origin

All :Loading: and :Screenshotting: methods have optional `[xOrigin]` and `[yOrigin]` parameters that define the origin point for the target room.

These parameters are relative, ranging from `0` (no offset) to `1` (full width/height). Any value between `0` and `1` (inclusive) is valid.
* `xOrigin` determines the horizontal origin. `0` aligns to the left, `0.5` to the center, and `1` to the right. Defaults to the :ROOMLOADER_DEFAULT_XORIGIN: config macro.
* `yOrigin` determines the vertical origin. `0` aligns to the top, `0.5` to the center, and `1` to the bottom. Defaults to the :ROOMLOADER_DEFAULT_YORIGIN: config macro.

::: tip
In addition to using origins as optional arguments, they can also be preconfigured before :Loading: or :Screenshotting: using the [Origin State](/pages/api/roomLoader/state/#origin) system.
:::

::: code-group
```js [Regular]
// Loads rmChunkEasy01 at the bottom right corner of the current room:
RoomLoader.Load(rmChunkEasy01, room_width, room_height, 1, 1); // [!code highlight]

// Takes a screenshot of rmLevelCliffs with a centered origin:
screenshot = RoomLoader.Screenshot(rmLevelCliffs, 0.5, 0.5); // [!code highlight]
```
```js [State]
// Loads rmChunkEasy01 at the bottom right corner of the current room:
RoomLoader.BottomRight().Load(rmChunkEasy01, room_width, room_height); // [!code highlight]

// Takes a screenshot of rmLevelCliffs with a centered origin:
screenshot = RoomLoader.MiddleCenter().Screenshot(rmLevelCliffs); // [!code highlight]
```
:::
