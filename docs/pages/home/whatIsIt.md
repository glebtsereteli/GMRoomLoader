# What is GMRoomLoader?

GMRoomLoader is a pure GML open source ([FOSS](https://en.wikipedia.org/wiki/Free_and_open-source_software)) GameMaker library created for making room prefabs and loading room contents at runtime.

It provides tools to process the data returned by :room_get_info():, use it to load rooms contents efficiently during gameplay, and clean up created elements when needed.

## Use Cases
* **Procedural Generation**. Create custom level templates and place them procedurally throughout your levels (e.g. dungeon rooms, NPCs or randomized props).
* **Chunking**. Divide large rooms into smaller sections, loading or unloading them dynamically as the player moves closer or farther away.​
* **Room Thumbnails**. Take screenshots of your rooms and use them in your level selection menu.
* **UI**. Design your interfaces directly in the Room Editor and load them on the fly in-game (as of [2024.13](https://gamemaker.io/en/blog/release-2024-13),​ this is mostly superseded by GM's [UI Layers](https://manual.gamemaker.io/monthly/en/#t=The_Asset_Editors%2FRoom_Properties%2FUI_Layers.htm)​).

## Features
- Pure GML library with no external tools required.
- Multiple ways to initialize room data: [single or multiple](/pages/api/roomLoader/data/#datainit), [array](/pages/api/roomLoader/data/#datainitarray), [prefix](/pages/api/roomLoader/data/#datainitprefix), [tag](/pages/api/roomLoader/data/#datainittag), [all](/pages/api/roomLoader/data/#datainitall).
- Loading [full rooms](/pages/api/roomLoader/loading/#load) including all layers and elements, or [just instances](/pages/api/roomLoader/loading/#loadinstances) (with optional scale and rotation transformations) at custom coordinates and origins.
- Element type filtering using [bitwise flags](https://github.com/glebtsereteli/GMRoomLoader/wiki/Enums#roomloader_flag).
- Layer filtering using [whitelisting/blacklisting](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#%E2%84%B9%EF%B8%8F-whitelistblacklist-layer-filtering).
- Full control over loaded contents: :Payload: tracking, fetching element IDs and cleanup - unloading/destroying loaded elements.
- Room [screenshotting](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-take_screenshotroom-xorigin-yorigin-flags---idsprite).

## GameMaker Awards 2024
GMRoomLoader was nominated for Best Tool in the [2024 GameMaker Awards](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners)!
![RoomLoader-Tool](https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d)
