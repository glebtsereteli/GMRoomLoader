# [THE LIBRARY IS BEING SET UP. README, WIKI & RELEASES ARE WIP]

![Untitled design (2)](https://github.com/glebtsereteli/GMRoomLoader/assets/50461722/e82ecee8-149d-4a04-bf85-4010535ce033)

<h1 align="center">GMRoomLoader v1.0.0</h1>
<p align="center">Runtime room loading for GameMaker 2023.11+</p>

## Overview
GMRoomLoader streamlines the process of loading GameMaker rooms at runtime with minimal setup required. It provides a set of methods to cache the data returned by [room_get_info()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm), load it efficiently during gameplay, and clean it up when needed.
* Download the .yymps package from the [Releases](https://github.com/glebtsereteli/GMRoomLoader/releases) tab.
* Refer to the [Wiki](https://github.com/glebtsereteli/GMRoomLoader/wiki) for detailed documentation.

## Features
- Pure GML library with no external tools required.
- Multiple ways to initialize room data: single or multiple, array, prefix.
- Loading rooms at custom coordinates and [origins](https://github.com/glebtsereteli/GMRoomLoader-Docs/tree/main?tab=readme-ov-file#roomloader_flag), like Middle Center or Bottom Right, GameMaker sprite style.
- Options to load full rooms including all layers and elements, or only instances using existing layers or depth.
- Element type filtering using [bitwise blags](https://github.com/glebtsereteli/GMRoomLoader-Docs/tree/main?tab=readme-ov-file#roomloader_flag).
- Layer filtering using Whitelisting/Blacklisting.
- Keeping track of loaded elements to [fetch their IDs](https://github.com/glebtsereteli/GMRoomLoader-Docs/tree/main?tab=readme-ov-file#getters) and/or [clean them up](https://github.com/glebtsereteli/GMRoomLoader-Docs/tree/main?tab=readme-ov-file#cleanup) later.

## Credits
- Created and maintained by [Gleb Tsereteli](https://twitter.com/glebtsereteli).
- Originally motivated by and made for [TabularElf](https://github.com/tabularelf)'s [Cookbook Jam #1](https://itch.io/jam/cookbook-jam-1).
- Demo art by [Kenney](https://twitter.com/KenneyNL).
- Demo room design by [k8te-iv](https://github.com/k8te-iv) ❣️
