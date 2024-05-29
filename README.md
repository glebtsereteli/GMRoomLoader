![Untitled design (2)](https://github.com/glebtsereteli/GMRoomLoader/assets/50461722/e82ecee8-149d-4a04-bf85-4010535ce033)

<h1 align="center">GMRoomLoader v1.6.0</h1>
<p align="center">Runtime room loading for GameMaker 2024.2+ on Windows and Mac</p>

## Overview
GMRoomLoader is an open source GameMaker library designed to streamline room loading at runtime. It provides methods to process the data returned by [room_get_info()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm), use it to load rooms efficiently during gameplay, and clean up created elements when needed.

* Download the .yymps package from the [Releases](https://github.com/glebtsereteli/GMRoomLoader/releases) page.
* Refer to the [Wiki](https://github.com/glebtsereteli/GMRoomLoader/wiki) for detailed documentation.

## Features
- Pure GML library with no external tools required.
- Multiple ways to initialize room data: [single or multiple](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-data_initroom----structroomloader), [array](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-data_init_arrayrooms---structroomloader), [prefix](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-data_init_prefixprefix---arrayassetgmroom).
- Loading rooms at custom coordinates and origins.
- Options to load [full rooms](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-loadroom-x-y-xorigin-yorigin-flags---structroomloaderreturndata) including all layers and elements, or only instances using existing [layers](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-load_instances_layerroom-x-y-layer-xorigin-yorigin---arrayidinstance) or [depth](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-load_instances_depthroom-x-y-depth-xorigin-yorigin---arrayidinstance).
- Element type filtering using [bitwise flags](https://github.com/glebtsereteli/GMRoomLoader/wiki/Enums#roomloader_flag).
- Layer filtering using [whitelisting/blacklisting](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#%E2%84%B9%EF%B8%8F-whitelistblacklist-layer-filtering).
- Tracking loaded elements to [fetch their IDs](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoaderReturnData()-constructor-%E2%80%90-returned-data-handler#%E2%84%B9%EF%B8%8F-getters) and/or [clean them up](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoaderReturnData()-constructor-%E2%80%90-returned-data-handler#%E2%84%B9%EF%B8%8F-cleanup) later.
- Room [screenshotting](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-take_screenshotroom-xorigin-yorigin-flags---idsprite).

## Credits
- Created and maintained by [Gleb Tsereteli](https://twitter.com/glebtsereteli).
- Logos and demo rooms designed by Gleb's wifey - [Kate](https://www.instagram.com/k8te_iv) ❣️
- Originally motivated by and made for [TabularElf](https://twitter.com/TabularElf)'s [Cookbook Jam #1](https://itch.io/jam/cookbook-jam-1).
- Inspired by [YellowAfterlife](https://twitter.com/YellowAfterlife)'s [GMRoomPack](https://yellowafterlife.itch.io/gmroompack).
- Demo art by [Kenney](https://twitter.com/KenneyNL).
