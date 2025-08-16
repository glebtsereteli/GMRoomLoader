---
next:
  text: 'ReturnData'
  link: '/pages/api/returnData'
---

# RoomLoader

<!-- <h1>
  RoomLoader
  <span style="display:none">RoomLoader</span>
  <a href="https://github.com/glebtsereteli/GMRoomLoader/blob/main/GMRoomLoader/scripts/RoomLoaderMain/RoomLoaderMain.gml" target="_blank">
    <Badge type="info" text="Source Code" />
  </a>
</h1> -->

## Overview

`RoomLoader` is the main interface of GMRoomLoader. It managers room [data](#data) and [loading](#loading), handles [whitelist](#whitelist) and [blacklist](#blacklist) layer filtering and [taking screenshots](#screenshotting).

It's a function containing static data variables and methods inside, essentially serving as a makeshift GML [namespace](https://learn.microsoft.com/en-us/cpp/cpp/namespaces-cpp?view=msvc-170). It's initialized internally and doesn't require any additional setup from the user.

All methods are called using the following syntax: `RoomLoader.MethodName(arguments...);`. Notice the lack of `()` after `RoomLoader`.

## Data

about...

### Initialization

#### `.DataInit()`

#### `.DataInitArray()`

#### `.DataInitPrefix()`

#### `.DataInitTag()`

### Removal

#### `.DataRemove()`

#### `.DataRemoveArray()`

#### `.DataRemovePrefix()`

#### `.DataRemoveTag()`

#### `.DataClear()`

### Status & Getters

#### `.DataIsInitialized()`

#### `.DataGetWidth()`

#### `.DataGetHeight()`

## Loading

about...

### `.Load()` {#load}

### `.LoadInstances()` {#loadinstances}

## Layer Filtering

about...

### Whitelist

#### `.LayerWhitelistAdd()`

#### `.LayerWhitelistRemove()`

#### `.LayerWhitelistReset()`

#### `.LayerWhitelistGet()`

### Blacklist

#### `.LayerBlacklistAdd()`

#### `.LayerBlacklistRemove()`

#### `.LayerBlacklistReset()`

#### `.LayerBlacklistGet()`

## Screenshotting

about...

### `.TakeScreenshot()`

### `.TakeScreenshotPart()`
