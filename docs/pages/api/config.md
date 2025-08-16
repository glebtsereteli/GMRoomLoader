## Meta

### `ROOMLOADER_ENABLE_DEBUG`
> Default: `true`.

Whether to show debug messages in Output (`true`) or not (`false`).

---
### `ROOMLOADER_DEFAULT_XORIGIN`
> Default: `0`.

Default X origin used by :RoomLoader:'s :Loading: and :Screenshotting:. Origins range from `0` to `1`: `0` is left, `0.5` is center, `1` is right.

---
### `ROOMLOADER_DEFAULT_YORIGIN`
> Default: `0`.

Default Y origin used by :RoomLoader:'s :Loading: and :Screenshotting:. Origins range from `0` to `1`: `0` is top, `0.5` is center, `1` is bottom.

---
### `ROOMLOADER_DEFAULT_FLAGS`
> Default: `ROOMLOADER_FLAG.CORE`.

Default flags used by :RoomLoader:'s :Loading: methods.

---
### `ROOMLOADER_USE_RETURN_DATA`
> Default: `true`.

* If true, :RoomLoader.Load(): returns an instance of :ReturnData: containing the IDs of all loaded layers and their elements.  
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
Enabling this may result in layers shared between elements loaded from multiple rooms being unintentionally destroyed during :ReturnData.Cleanup():.
:::

## Assets

### `ROOMLOADER_INSTANCES_USE_ROOM_PARAMS`
> Default: `true`.

Whether to initialize room parameters for loaded instances (`true`) or not (`false`).  

:::tip
Setting this to `false` improves loading performance.
:::

---
### `ROOMLOADER_INSTANCES_RUN_CREATION_CODE`
>Default: `true`.

Whether to run Creation Code for loaded instances (`true`) or not (`false`).  

:::tip
Setting this to `false` improves loading performance.
:::

---
### `ROOMLOADER_INSTANCES_DEFAULT_MULT_SCALE`
> Default: `true`.

When loading instances using :RoomLoader.LoadInstances():, whether to multiply individual instance scale by the overall load scale (`true`) or not (`false`).

This is relevant only when loading instances with a custom scale (values other than `1`).

---
### `ROOMLOADER_INSTANCES_DEFAULT_ADD_ANGLE`
* Default: `true`.

When loading instances using :RoomLoader.LoadInstances():, whether to combine individual instance angle with the overall load angle (`true`) or not (`false`).

This releavant only when loading instances with a custom angle (values other than `0`).

---
### `ROOMLOADER_SEQUENCES_PAUSE`
> Default: `false`.

Whether to pause loaded sequences (`true`) or not (`false`).

---
### `ROOMLOADER_ROOMS_RUN_CREATION_CODE`
> Default: `true`.

Whether to run the Creation Code for loaded rooms (`true`) or not (`false`).
