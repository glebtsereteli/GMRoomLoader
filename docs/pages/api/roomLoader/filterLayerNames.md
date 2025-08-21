# Filtering Layer Names

In addition to filtering by :Asset Type:, GMRoomLoader allows you to filter layers by name using [Whitelisting](#whitelist) and [Blacklisting](#blacklist).
* Just like :Asset Type: filtering, these name-based filters apply to all methods that work with layers, including :RoomLoader.Load(): and :Screenshotting:.
* Filters are fully user-managed and are not reset automatically after loading.
* Both filters have their own sets of methods and can be used independently or together. You can also combine them with :Asset Type: filtering in any configuration.
* The Blacklist takes precedence over the Whitelist: any layer that appears in both will not be loaded.

::: code-group
```js [Loading With Filters]
// Whitelists "Trees", "Rocks" and "Grass" layers, only those will be loaded:
RoomLoader.LayerWhitelistAdd("Trees", "Rocks", "Grass");

// Blacklists the "Rocks" layer. Now only "Trees" and "Grass" will be loaded:
RoomLoader.LayerBlacklistAdd("rocks");

payload = RoomLoader.load(rmForest, someX, someY);

// Reset both filters:
RoomLoader.LayerWhitelistReset().LayerBlackListReset();
```
:::

## Whitelist

When Whitelist has entries, only layers with speficied names will be loaded.

---
### .LayerWhitelistAdd()

> `RoomLoader.LayerWhitelistAdd(...layerNames)`

Adds the given layers to the Whitelist.

::: code-group
```js [Example]

```
:::

### `.LayerWhitelistRemove()`
> `RoomLoader.LayerWhitelistRemove(...layerNames)`




### `.LayerWhitelistReset()`
@TODO

### `.LayerWhitelistGet()`
@TODO

## Blacklist

Blacklisting loads all layers BUT those with speficied names.


### `.LayerBlacklistAdd()`
@TODO

### `.LayerBlacklistRemove()`
@TODO

### `.LayerBlacklistReset()`
@TODO

### `.LayerBlacklistGet()`
@TODO
