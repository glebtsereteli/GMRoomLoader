# Configuration

This page covers GMRoomLoader configuration macros. They define how rooms, layers and assets are loaded, letting you customize debug output, :Loading: parameters and other options that affect performance and behaviors.

## General

### `ROOMLOADER_ENABLE_DEBUG`
> Default: `true`.

Whether to show debug messages in Output (`true`) or not (`false`).

---
### `ROOMLOADER_DEFAULT_XORIGIN`
> Default: `0`.

Default X origin used in :Loading: and :Screenshotting:. [Origins](/pages/api/roomLoader/origin) range from `0` to `1`: `0` is left, `0.5` is center, `1` is right.

---
### `ROOMLOADER_DEFAULT_YORIGIN`
> Default: `0`.

Default Y origin used in :Loading: and :Screenshotting:. [Origins](/pages/api/roomLoader/origin) range from `0` to `1`: `0` is top, `0.5` is center, `1` is bottom.

---
### `ROOMLOADER_DEFAULT_FLAGS`
> Default: `ROOMLOADER_FLAG.CORE`.

Default flags used in :Loading: and :Screenshotting:.

---
### `ROOMLOADER_DELIVER_PAYLOAD`
> Default: `true`.

* If true, :RoomLoader.Load(): returns an instance of :Payload: containing the IDs of all loaded layers and their elements.  
* If `false`, no IDs are collected or returned, improving loading performance.  

:::tip
Set this to `false` if you don't need to manually clean up loaded contents.  
For example, when room switching automatically destroys all instances, layers and assets, or if cleanup is generally irrelevant.
:::

---
### `ROOMLOADER_MERGE_LAYERS`
> Default: `false`.

When loading rooms using :RoomLoader.Load():, whether to merge loaded layers with existing ones (`true`) or keep them separate (`false`).  

- If `true`: merge into existing layers with the same name. If no matching layer exists, a new one will be created.  
- If `false`: a new layer is always created, even if a layer with the same name already exists.  

::: warning
Enabling this may result in layers shared between elements loaded from multiple rooms being unintentionally destroyed during :Payload.Cleanup():.
:::

## Instances

### `ROOMLOADER_INSTANCES_USE_ROOM_PARAMS`
> Default: `true`.

Whether to initialize room parameters for loaded instances (`true`) or not (`false`).  

:::tip
Setting this to `false` improves :Loading: performance.
:::

---
### `ROOMLOADER_INSTANCES_RUN_CREATION_CODE`
>Default: `true`.

Whether to run Creation Code for loaded instances (`true`) or not (`false`).  

:::tip
Setting this to `false` improves :Loading: performance.
:::
