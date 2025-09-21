# Layer Name Filtering

When loading full rooms with :RoomLoader.Load(): or using :Screenshotting: methods, you may want to filter target room layers by name, so that only layers with the specified names are loaded/screenshotted.

This section explains how to achieve this using [Whitelisting](#whitelist) and [Blacklisting](#blacklist).
* Both filters are fully user-managed and do not reset automatically after loading.
* Both filters have their own sets of methods and can be used independently or together. You can also combine them with :Asset Type Filtering: in any configuration.
* Blacklist takes precedence over Whitelist - layers included in both filters are ignored.

::: warning WARNING
Just like everywhere else in GameMaker, layer names are case-sensitive and must match the room editor layer names exactly.
:::

::: code-group
```js [Loading With Filters]
// Whitelists "Trees", "Rocks" and "Grass" layers, only those will be loaded:
RoomLoader.LayerWhitelistAdd("Trees", "Rocks", "Grass"); // [!code highlight]

// Blacklists the "Rocks" layer. Now only "Trees" and "Grass" will be loaded:
RoomLoader.LayerBlacklistAdd("Rocks"); // [!code highlight]

payload = RoomLoader.Load(rmForest, x, y);

// Reset both filters:
RoomLoader.LayerWhitelistReset().LayerBlacklistReset(); // [!code highlight]
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
// Whitelists the "Buildings" layer name:
RoomLoader.LayerWhitelistAdd("Buildings");

// Whitelists the "Trees" and "Rocks" layer names:
RoomLoader.LayerWhitelistAdd("Trees", "Rocks");
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
// Removes the "Buildings" layer name from Whitelist:
RoomLoader.LayerWhitelistRemove("Buildings");

// Removes "Trees" and "Rocks" layer names from Whitelist:
RoomLoader.LayerWhitelistRemove("Trees", "Rocks");
```
:::

---
### `.LayerWhitelistSet()`

> `RoomLoader.LayerWhitelistSet(layerNames)` ➜ :Struct:.:RoomLoader:

Sets the Whitelist layer filter to the given array of layer names.

| Parameter | Type | Description |
|---|---|---|
| `layerNames` | :Array: of :String: | An array of layer names to whitelist |

::: code-group
```js [Example]
// Whitelists "Bushes", "Trees" and "Flowers" array from the _whitelist array:
var _whitelist = ["Bushes", "Trees", "Flowers"];
RoomLoader.LayerWhitelistSet(_whitelist);
```
:::

---
### `.LayerWhitelistReset()`

> `RoomLoader.LayerWhitelistReset()` ➜ :Struct:.:RoomLoader:

Resets the Whitelist layer filter by removing all names from it.

::: code-group
```js [Example]
RoomLoader.LayerWhitelistReset(); // Resets the Whitelist.
```
:::

---
### `.LayerWhitelistGet()`

> `RoomLoader.LayerWhitelistGet()` ➜ :Array: of :String:

Returns an array of whitelisted layer names.

::: code-group
```js [Example]
// Gets an array of whitelisted layer names, blacklists them and resets Whitelist:
array_foreach(RoomLoader.LayerWhitelistGet(), function(_layerName) { // [!code highlight]
    RoomLoader.LayerBlacklistAdd(_layerName);
});
RoomLoader.LayerWhitelistReset();
```
:::

## Blacklist

When Blacklist contains entries, layers with blacklisted names are ignored. Other layers are loaded. 

### `.LayerBlacklistAdd()`

> `RoomLoader.LayerBlacklistAdd(...layerNames)` ➜ :Struct:.:RoomLoader:

Adds all given layer names to the Blacklist layer filter.

| Parameter | Type | Description |
|---|---|---|
| `...layerNames` | :String: | The layer names to blacklist, supports any amount of arguments |

::: code-group
```js [Example]
// Blacklists the "Buildings" layer name:
RoomLoader.LayerBlacklistAdd("Buildings");

// Blacklists the "Trees" and "Rocks" layer names:
RoomLoader.LayerBlacklistAdd("Trees", "Rocks");
```
:::

### `.LayerBlacklistRemove()`

> `RoomLoader.LayerBlacklistRemove(...layerNames)` ➜ :Struct:.:RoomLoader:

Removes all given layer names from the Blacklist layer filter.

::: code-group
```js [Example]
// Removes the "Buildings" layer name from Blacklist:
RoomLoader.LayerBlacklistRemove("Buildings");

// Removes "Trees" and "Rocks" layer names from Blacklist:
RoomLoader.LayerBlacklistRemove("Trees", "Rocks");
```
:::

---
### `.LayerBlacklistSet()`

> `RoomLoader.LayerBlacklistSet(layerNames)` ➜ :Struct:.:RoomLoader:

Sets the Blacklist layer filter to the given array of layer names.

| Parameter | Type | Description |
|---|---|---|
| `layerNames` | :Array: of :String: | An array of layer names to blacklist |

::: code-group
```js [Example]
// Blacklists "Bushes", "Trees" and "Flowers" array from the _blacklist array:
var _blacklist = ["Bushes", "Trees", "Flowers"];
RoomLoader.LayerBlacklistSet(_blacklist);
```
:::

### `.LayerBlacklistReset()`

> `RoomLoader.LayerBlacklistReset()` ➜ :Struct:.:RoomLoader:

Resets the Blacklist layer filter by removing all previously added layer names.

::: code-group
```js [Example]
RoomLoader.LayerBlacklistReset(); // Resets the Blacklist.
```
:::

### `.LayerBlacklistGet()`

> `RoomLoader.LayerBlacklistGet()` ➜ :Array: of :String:

Returns an array of blacklisted layer names.

::: code-group
```js [Example]
// Gets an array of blacklisted layer names, whitelists them and resets Blacklist:
array_foreach(RoomLoader.LayerBlacklistGet(), function(_layerName) { // [!code highlight]
    RoomLoader.LayerWhitelistAdd(_layerName);
});
RoomLoader.LayerBlacklistReset();
```
:::
