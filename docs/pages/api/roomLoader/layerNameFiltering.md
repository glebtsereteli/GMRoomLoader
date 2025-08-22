# Layer Name Filtering

When loading rooms with :RoomLoader.Load(): or using :Screenshotting: methods, you may want to filter target room data by layer name, so that only layers with the specified names are loaded/screenshotted.

This section explains how to achieve this using [Whitelisting](#whitelist) and [Blacklisting](#blacklist).
* Both filters are fully user-managed and are not reset automatically after loading.
* Both filters have their own sets of methods and can be used independently or together. You can also combine them with :Asset Type: filtering in any configuration.
* Blacklist takes precedence over Whitelist - any layer that appears in both will not be loaded.

::: code-group
```js [Loading With Filters]
// Whitelists "Trees", "Rocks" and "Grass" layers, only those will be loaded:
RoomLoader.LayerWhitelistAdd("Trees", "Rocks", "Grass"); // [!code highlight]

// Blacklists the "Rocks" layer. Now only "Trees" and "Grass" will be loaded:
RoomLoader.LayerBlacklistAdd("Rocks"); // [!code highlight]

payload = RoomLoader.load(rmForest, someX, someY);

// Reset both filters:
RoomLoader.LayerWhitelistReset().LayerBlackListReset(); // [!code highlight]
```
:::

## Whitelist

When Whitelist contains entries, only the layers with whitelisted names are loaded. Other layers are ignored.

---
### `.LayerWhitelistAdd()`

> `RoomLoader.LayerWhitelistAdd(...layerNames)` ➜ :Struct:.:RoomLoader:

Adds all given layer names to the Whitelist layer filter.

| Parameter | Type | Description |
|---|---|---|
| `...layerNames` | :String: | The layer names to whitelist, supports any amount of arguments |

::: code-group
```js [Example]

```
:::

---
### `.LayerWhitelistRemove()`

> `RoomLoader.LayerWhitelistRemove(...layerNames)` ➜ :Struct:.:RoomLoader:

Removes all given layer names from the Whitelist layer filter.

| Parameter | Type | Description |
|---|---|---|
| `...layerNames` | :String: | The layer names to remove from the whitelist, supports any amount of arguments |

::: code-group
```js [Example]

```
:::

---
### `.LayerWhitelistReset()`

> `RoomLoader.LayerWhitelistReset()` ➜ :Struct:.:RoomLoader:

Resets the Whitelist layer filter by removing all names from it.

::: code-group
```js [Example]

```
:::

---
### `.LayerWhitelistGet()`

> `RoomLoader.LayerWhitelistGet()` ➜ :Array: of :String:

Returns an array of whitelisted layer names.

## Blacklist

When Blacklist contains entries, layers with blacklisted names are ignored. Other layers are loaded. 

::: code-group
```js [Example]

```
:::

### `.LayerBlacklistAdd()`
@TODO

::: code-group
```js [Example]

```
:::

### `.LayerBlacklistRemove()`
@TODO

::: code-group
```js [Example]

```
:::

### `.LayerBlacklistReset()`
@TODO

::: code-group
```js [Example]

```
:::

### `.LayerBlacklistGet()`
@TODO

::: code-group
```js [Example]

```
:::
