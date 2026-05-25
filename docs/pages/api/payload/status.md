# Status

## Overview

This section covers methods for querying the current state of a :Payload: instance.

::: info NOTE
All code examples on this page assume you have an existing instance of :Payload: retrieved from :RoomLoader.Load(): and stored in a `payload` variable.
:::

## Methods

### `.IsInView()`

> `payload.IsInView([camera], [padding])` ➜ :Bool:

Returns whether the loaded room overlaps the given camera's view (`true`) or not (`false`). Handles any combination of camera and loaded room positioning, scaling, and rotation.

Positive padding expands the view bounds outward, negative padding shrinks them inward.

| Parameter | Type | Description |
| --- | --- | --- |
| `[camera]` | :Id.Camera: | The camera to check against [Default: `view_camera[0]`] |
| `[padding]` | :Real: | The padding to apply to the view bounds [Default: `0`] |

:::code-group
```js [Example]
// Cleans up the loaded room when it leaves the camera's view
if (not payload.IsInView()) { // [!code highlight]
    payload.Cleanup();
}

// Cleans up only after the room is 512 pixels outside the view
if (not payload.IsInView(view_camera[0], 512)) { // [!code highlight]
    payload.Cleanup();
}
```
:::

---

### `.IsPointInside()`

> `payload.IsPointInside(x, y)` ➜ :Bool:

Returns whether the given point falls inside the loaded room's bounds (`true`) or not (`false`), accounting for any combination of position, origin, scale, and rotation.

| Parameter | Type | Description |
| --- | --- | --- |
| `x` | :Real: | The x coordinate of the point to check |
| `y` | :Real: | The y coordinate of the point to check |

:::code-group
```js [Example]
// Check if the player is inside the loaded room
if (payload.IsPointInside(player.x, player.y)) { // [!code highlight]
    show_debug_message("Player is inside the room!");
}
```
:::

---

### `.IsCleanedUp()`

> `payload.IsCleanedUp()` ➜ :Bool:

Returns whether the payload has been cleaned up (`true`) or not (`false`).

:::code-group
```js [Example]
// Logs a warning if trying to use an already cleaned up payload
if (payload.IsCleanedUp()) { // [!code highlight]
    show_debug_message("Warning: payload has already been cleaned up!");
}
```
:::