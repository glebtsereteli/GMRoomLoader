# What is GMRoomLoader?

GMRoomLoader is a pure GML [Free and Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) GameMaker library made for creating room prefabs and loading room contents at runtime, AKA "loading other rooms into the current room".

It provides tools to process the data returned by :room_get_info():, use that data to load room contents efficiently during gameplay, and clean up created elements when needed.

## Use Cases
* **Procedural Generation**. Create custom level templates and place them procedurally throughout your levels (e.g. dungeon rooms, chunks, NPCs or randomized props).
* **Chunking**. Divide large worlds into smaller chunks that dynamically load when players approach and unload when they move away.
* **Room Thumbnails**. Take screenshots of your rooms and use them in level selection menus, seamless room transitions or loading previews. 
* **UI**. Design your interfaces directly in the Room Editor and load them on the fly in-game (as of [2024.13](https://gamemaker.io/en/blog/release-2024-13),​ this is mostly superseded by GameMaker's [UI Layers](https://manual.gamemaker.io/monthly/en/#t=The_Asset_Editors%2FRoom_Properties%2FUI_Layers.htm)​).

::: warning DISCLAIMER
GMRoomLoader is designed specifically for __loading room contents__.

It does NOT provide tools for procedural generation or level layout creation of any kind (like deciding which room to load and where to place it). You'll need to handle that yourself.
:::

## Features
- **Pure GML Implementation**. No extensions or external tools required.
- **Easy Data Handling**. Initialize and remove data in multiple ways: [Single or Multiple](/pages/api/roomLoader/data/#datainit), [Array](/pages/api/roomLoader/data/#datainitarray), [Prefix](/pages/api/roomLoader/data/#datainitprefix), [Tag](/pages/api/roomLoader/data/#datainittag), [All](/pages/api/roomLoader/data/#datainitall). Retrieve core room parameters with [Getters](/pages/api/payload/getters).
- **Flexible Loading**. Load [Full Rooms](/pages/api/roomLoader/loading/#full-rooms), [Instances](/pages/api/roomLoader/loading/#loadinstances) or [Tilemaps](/pages/api/roomLoader/loading/#loadtilemap) at any position in the current room, with optional origin, scaling, mirroring, flipping and rotation.
- **Filtering Options**. Filter elements by :Asset Type: and/or layers by :Layer Name:.
- **Full Lifecycle Control**. Manage loaded contents with :Payload: tracking - [Fetch IDs](/pages/api/payload/getters) and [Destroy](/pages/api/payload/cleanup) loaded elements.
- **Screenshotting**. Capture room [Screenshots](/pages/api/roomLoader/screenshotting) from anywhere, without ever visiting target rooms — with optional part definition, scaling and filtering.
- **Fluent :State: Builder**. Configure optional arguments before loading or screenshotting in a simple, English-like flow.

## How does it work?

GMRoomLoader works by calling :room_get_info(): to grab the raw data of a room, parsing that data, optimizing it for loading, and then rebuilding room layers and elements when you use its :Loading: methods.

GameMaker can only have a single room active at a time and GMRoomLoader doesn't magically change that. Instead, it recreates the contents of other rooms inside the current room.

## GameMaker Awards 2024
GMRoomLoader was nominated for **Best Tool** in the [2024 GameMaker Awards](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners)!
![RoomLoader-Tool](https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d)
