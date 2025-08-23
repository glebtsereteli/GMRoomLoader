# What is GMRoomLoader?

GMRoomLoader is a pure GML open source ([FOSS](https://en.wikipedia.org/wiki/Free_and_open-source_software)) GameMaker library for creating room prefabs and loading room contents at runtime.

Also known as "loading other rooms into the current room".

It provides tools to process the data returned by :room_get_info():, use that data to load room contents efficiently during gameplay, and clean up created elements when needed.

## Use Cases
* **Procedural Generation**. Create custom level templates and place them procedurally throughout your levels (e.g. dungeon rooms, NPCs or randomized props).
* **Chunking**. Divide large rooms into smaller sections, loading or unloading them dynamically as the player moves closer or farther away.​
* **Room Thumbnails**. Take screenshots of your rooms and use them in level selection menus, seamless room transitions or loading previews. 
* **UI**. Design your interfaces directly in the Room Editor and load them on the fly in-game (as of [2024.13](https://gamemaker.io/en/blog/release-2024-13),​ this is mostly superseded by GameMaker's [UI Layers](https://manual.gamemaker.io/monthly/en/#t=The_Asset_Editors%2FRoom_Properties%2FUI_Layers.htm)​).

::: warning DISCLAIMER
GMRoomLoader is designed specifically for __loading room contents__.

It does NOT provide tools for procedural generation or level layout creation of any kind (like deciding which room to load and where to place it). You'll need to handle that yourself.
:::

## Features
- Pure GML library with no external tools required.
- Multiple ways to handle room data: [Single or Multiple](/pages/api/roomLoader/data/#datainit), [Array](/pages/api/roomLoader/data/#datainitarray), [Prefix](/pages/api/roomLoader/data/#datainitprefix), [Tag](/pages/api/roomLoader/data/#datainittag), [All](/pages/api/roomLoader/data/#datainitall).
- Loading [Full Rooms](/pages/api/roomLoader/loading/#full-rooms) including all layers and elements, or just [Instances](/pages/api/roomLoader/loading/#loadinstances) or [Tilemaps](/pages/api/roomLoader/loading/#loadtilemap) (with optional scale/mirror/flip and rotation transformations) at any position and origin.
- Element filtering by :Asset Type:.
- :Layer Name: filtering with [Whitelisting](/pages/api/roomLoader/layerNameFiltering/#whitelist) and [Blacklisting](/pages/api/roomLoader/layerNameFiltering/#blacklist).
- Full control over loaded contents: :Payload: tracking, fetching element IDs and cleanup - unloading/destroying loaded elements.
- Room :Screenshotting:.

## How does it work?

GameMaker only ever runs one active room at a time, that never changes. GMRoomLoader works around this by recreating the contents of other rooms inside the current one.

It does this by calling :room_get_info(): to grab the raw data of a room. The library then parses that data, optimizes it for loading, and finally rebuilds the room's layers and elements when you use its :Loading: methods.

## GameMaker Awards 2024
GMRoomLoader was nominated for Best Tool in the [2024 GameMaker Awards](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners)!
![RoomLoader-Tool](https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d)
