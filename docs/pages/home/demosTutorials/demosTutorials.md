# Demos & Tutorials

<!-- <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; border-radius: 8px;">
  <iframe 
    src="https://www.youtube.com/embed/dQw4w9WgXcQ"
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
    allowfullscreen
    style="position: absolute; top:0; left:0; width:100%; height:100%;">
  </iframe>
</div> -->

## First Setup

As mentioned in the [First Setup](/pages/home/gettingStarted/gettingStarted/#first-setup) section of [Getting Started](/pages/home/gettingStarted/gettingStarted), this is a simple project demonstrating how to load a room centered at the mouse coordinates when pressing 1 and unload it when pressing 2.

> ℹ️ Download the [GMRoomLoader First Setup.yyz](https://github.com/glebtsereteli/GMRoomLoader/raw/main/docs/public/GMRoomLoader%20First%20Setup.yyz) example project.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/gettingStarted/firstSetup.mp4" type="video/mp4">
  </video>
</div>

## Demo Project

GMRoomLoader comes with a demo project showcasing all core features of the library. The demo includes a DBG ImGui control panel with demo cycling and custom controls for each example.

> ℹ️ Download the [GMRoomLoader Demo.yyz](https://github.com/glebtsereteli/GMRoomLoader/raw/main/docs/public/GMRoomLoader%20Demo.yyz) project. @TODO add project

---
### General

This is an example of using :RoomLoader.Load(): to load Full Rooms with all layers and elements, with controls for position, :Origin:, :Scaling:, :Rotation:, :Flags:, Whitelist and Blacklist :Layer Name Filtering:.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/demosTutorials/demo01general.mp4" type="video/mp4">
  </video>
</div>

---
### Instances

This is an example of using :RoomLoader.LoadInstances(): to load all room Instances at a single depth, with controls for position, :Origin:, :Scaling: and :Rotation:.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/demosTutorials/demo02instances.mp4" type="video/mp4">
  </video>
</div>

---
### Tilemaps

This is an example of using :RoomLoader.LoadTilemap(): to load Tilemaps, with controls for position, :Origin:, :Mirroring:, :Flipping:, :Rotation: and :Tileset:.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/demosTutorials/demo03tilemaps.mp4" type="video/mp4">
  </video>
</div>

---
### Merge Tilemaps

This is an example of merging existing and loaded tilemaps when loading :Full Rooms: or :Tilemaps:. The existing tilemap is repositioned and resized to fit loaded tilemaps. See the :ROOMLOADER_MERGE_TILEMAPS: config macro for detailed info.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/demosTutorials/demo04mergeTilemaps.mp4" type="video/mp4">
  </video>
</div>

---
### Screenshots

This is an example of using :Screenshotting: methods to take room screenshots, with controls for :Origin:, :Flags:, Left/Top position, Width/Height of the sprite area to capture (in 0-1 percentages), and the final sprite :Scale:.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/demosTutorials/demo05screenshots.mp4" type="video/mp4">
  </video>
</div>

---
### Base

This is an example of an enemy base composed of multiple "Room Slots", each filled with randomized GameMaker rooms to create a unique level. First we load a Host room, then fill each Slot with a random room. This shows 2 "layers" of room loading working together.

<div style="width: 100%; max-width: 100%;">
  <video style="width: 100%; height: auto;" controls>
    <source src="/pages/home/demosTutorials/demo06base.mp4" type="video/mp4">
  </video>
</div>

## Tutorials

* [GMRoomLoader: Simultaneous Room Loading in GameMaker](https://www.youtube.com/watch?v=mZegvOC47dw) by [DragoniteSpam](https://www.youtube.com/c/DragoniteSpam/about). Michael introduces GMRoomLoader basics and goes over a few interesting edge cases.

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; border-radius: 8px;">
  <iframe 
    src="https://www.youtube.com/embed/mZegvOC47dw"
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
    allowfullscreen
    style="position: absolute; top:0; left:0; width:100%; height:100%;">
  </iframe>
</div>