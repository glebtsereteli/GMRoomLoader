# [THE LIBRARY IS BEING SET UP. README, WIKI & RELEASES ARE WIP]

![Untitled design (2)](https://github.com/glebtsereteli/GMRoomLoader/assets/50461722/e82ecee8-149d-4a04-bf85-4010535ce033)

<h1 align="center">GMRoomLoader v1.0.0</h1>
<p align="center">Runtime room loading for GameMaker 2023.11+</p>

## Overview
GMRoomLoader is an open source GameMaker library designed to streamline room loading at runtime. It provides methods to process the data returned by [room_get_info()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm), use it to load rooms efficiently during gameplay, and clean up created elements when needed.

* Download the .yymps package from the [Releases](https://github.com/glebtsereteli/GMRoomLoader/releases) tab.
* Refer to the [Wiki](https://github.com/glebtsereteli/GMRoomLoader/wiki) for detailed documentation.

## Features
- Pure GML library with no external tools required.
- Multiple ways to initialize room data: [single or multiple](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-data_initroom----structroomloader), [array](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-data_init_arrayrooms---structroomloader), [prefix](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-data_init_prefixprefix---structroomloader).
- Loading rooms at custom coordinates and [origins](https://github.com/glebtsereteli/GMRoomLoader/wiki/Enums#roomloader_origin), like Middle Center or Bottom Right, GameMaker sprite style.
- Options to load [full rooms](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-loadroom-x-y-originroomloader_default_origin-flagsroomloader_default_flags---structroomloaderreturndata-or-undefined) including all layers and elements, or only instances using existing [layers](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-load_instances_layerroom-x-y-layer-originroomloader_default_origin---arrayidinstance-or-undefined) or [depth](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#-load_instances_depthroom-x-y-depth-originroomloader_default_origin---arrayidinstance-or-undefined).
- Element type filtering using [bitwise flags](https://github.com/glebtsereteli/GMRoomLoader/wiki/Enums#roomloader_flag).
- Layer filtering using [whitelisting/blacklisting](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoader()-static-constructor-%E2%80%90-main-interface#%E2%84%B9%EF%B8%8F-whitelistblacklist-layer-filtering).
- Keeping track of loaded elements to [fetch their IDs](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoaderReturnData()-constructor-%E2%80%90-returned-data-handler#%E2%84%B9%EF%B8%8F-getters) and/or [clean them up](https://github.com/glebtsereteli/GMRoomLoader/wiki/RoomLoaderReturnData()-constructor-%E2%80%90-returned-data-handler#%E2%84%B9%EF%B8%8F-cleanup) later.

## Credits
- Created and maintained by [Gleb Tsereteli](https://twitter.com/glebtsereteli).
- Logos and demo rooms designed by Gleb's wifey - [Kate](https://www.instagram.com/k8te_iv) ❣️
- Originally motivated by and made for [TabularElf](https://twitter.com/TabularElf)'s [Cookbook Jam #1](https://itch.io/jam/cookbook-jam-1).
- Inspired by [YellowAfterLife](https://twitter.com/YellowAfterlife)'s [GMRoomPack](https://yellowafterlife.itch.io/gmroompack).
- Demo art by [Kenney](https://twitter.com/KenneyNL).
