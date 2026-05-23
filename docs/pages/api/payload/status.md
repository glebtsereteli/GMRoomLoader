# Status

## Overview

This section covers methods for querying the current state of a :Payload: instance.

::: info NOTE
All code examples on this page assume you have an existing instance of :Payload: retrieved from :RoomLoader.Load(): and stored in a `payload` variable.
:::

## Methods

### `.IsInView()`

> `payload.IsInView(camera, [padding])` ➜ :Bool:

Returns whether the loaded room's bounding box overlaps the given camera's view (`true`) or not (`false`).

Positive padding expands the view bounds outward, negative padding shrinks them inward.

Does not account for camera rotation.

| Parameter | Type | Description |
| --- | --- | --- |
| `camera` | :Id.Camera: | The camera to check against |
| `[padding]` | :Real: | The padding to apply to the view bounds [Default: `0`] |

:::code-group
```js [Example]
// Cleans up the loaded room when it leaves the camera's view
if (not payload.IsInView(camera_get_active())) { // [!code highlight]
    payload.Cleanup();
}

// Cleans up only after the room is 512 pixels outside the view
if (not payload.IsInView(camera_get_active(), 512)) { // [!code highlight]
    payload.Cleanup();
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
