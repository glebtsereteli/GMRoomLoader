![](https://github.com/glebtsereteli/GMRoomLoader/assets/50461722/e82ecee8-149d-4a04-bf85-4010535ce033)

<h1 align="center">GMRoomLoader v2.4.0 </h1>
<p align="center"> Runtime room loading for GameMaker 2024.14 </p>
<!-- <p align="center">
  Runtime room loading for GameMaker 2024.14
  <br><br>
  <img src="https://img.shields.io/badge/Windows-0078D6?logo=windows&logoColor=white" />&nbsp;
  <img src="https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white" />&nbsp;
  <img src="https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black" />&nbsp;
  <img src="https://img.shields.io/badge/GX.games-FF1B2D?logo=opera&logoColor=white" />
</p> -->

# Overview
GMRoomLoader is a pure GML [Free and Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) GameMaker library made for creating room prefabs and loading room contents at runtime, AKA "loading other rooms into the current room".

It provides tools to process the data returned by [room_get_info()](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm), use that data to load room contents efficiently during gameplay, and clean up created elements when needed.

* ℹ️ Download the `.yymps` local package from the [Releases](https://github.com/glebtsereteli/GMRoomLoader/releases) page.
* ℹ️ Refer to the [Documentation](https://glebtsereteli.github.io/GMRoomLoader/) for installation instructions, usage examples and full API reference.

# Use Cases
* **Procedural Generation**. Create custom level templates and place them procedurally throughout your levels (e.g. dungeon rooms, chunks, NPCs or randomized props).
* **Chunking**. Divide large rooms into smaller sections, loading or unloading them dynamically as the player moves closer or farther away.​
* **Room Thumbnails**. Take screenshots of your rooms and use them in level selection menus, seamless room transitions or loading previews. 
* **UI**. Design your interfaces directly in the Room Editor and load them on the fly in-game (as of [2024.13](https://gamemaker.io/en/blog/release-2024-13),​ this is mostly superseded by GameMaker's [UI Layers](https://manual.gamemaker.io/monthly/en/#t=The_Asset_Editors%2FRoom_Properties%2FUI_Layers.htm)​).

# Features
* **Pure GML Implementation**. No extensions or external tools required.
* **Easy Data Handling**. Initialize and remove data in multiple ways: [Single/Multiple](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainit), [Array](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainitarray), [Prefix](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainitprefix), [Tag](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainittag), or [All](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainitall). Retrieve core room info with [Getters](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#status-getters).
* **Flexible Loading**. Load [Full Rooms](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#load), [Instances](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadinstances) or [Tilemaps](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadtilemap) at any position in the current room - all with optional origin, scaling, mirroring, flipping and rotation.
* **Filtering Options**. Filter elements by [Asset Type](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/assetTypeFiltering) and/or layers by [Layer Name](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/layerNameFiltering).
* **Full Lifecycle Control**. Manage loaded contents with [Payload](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/overview) tracking - [Fetch IDs](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/getters) and [Destroy](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/cleanup) loaded elements.
* **Screenshotting**. Capture room [Screenshots](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting) as [Sprites](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotsprite), [Surfaces](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotsurface) or [Buffers](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotbuffer) from anywhere, without ever visiting target rooms - with optional part definition, scaling and filtering.
* **[Fluent State Builder](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state)**. Configure optional arguments before loading or screenshotting in a simple, English-like flow.
* **Quick Debug Loading**. Load any room in the project at the mouse position with fully configurable parameters via the [Debug View](https://glebtsereteli.github.io/GMRoomLoader/pages/api/debugView/debugView) interface. Perfect for quick testing - no code required!

# Credits
- Created and maintained by [Gleb Tsereteli](https://twitter.com/glebtsereteli).
- Logos and demo rooms designed by Gleb's wifey - [Kate](https://www.instagram.com/k8te_iv) ❣️
- Originally motivated by and made for [TabularElf](https://twitter.com/TabularElf)'s [Cookbook Jam #1](https://itch.io/jam/cookbook-jam-1).
- Thank you to [YellowAfterlife](https://twitter.com/YellowAfterlife) for inspiring this library with his OG [GMRoomPack](https://yellowafterlife.itch.io/gmroompack), various help and ideas.
- Thank you to [Topher Anselmo](https://topheranselmo.com/) for inspiration and help with the new [VitePress](https://vitepress.dev/)-based documentation.
- Demo art by [Kenney](https://kenney.nl) the ✨*Asset Jesus*✨.

# GameMaker Awards 2024
GMRoomLoader was nominated for **Best Tool** in the [2024 GameMaker Awards](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners)!
![RoomLoader-Tool](https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d)

# Games Using GMRoomLoader
* [Juju Adams](https://www.jujuadams.com/)' undisclosed [commercial games](https://www.reddit.com/r/gamemaker/comments/1nn84b9/comment/nfjy5v4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button).
* [IndieGameClinic](https://indiegameclinic.com/)'s [DirtWorld](https://jbw-games.itch.io/dirtworld).
* [GrogDev](https://grog.dev/)'s and [PixelatedPope](https://www.pixelatedpope.com/)'s [Desukupet](https://www.twitch.tv/grogdev).
* BrewerTheGreater's [Project Reality: Shattered](https://www.twitch.tv/brewerthegreater).
* [Geoff Moore](https://geoffmoore.co.uk/)'s [Goober Launch](https://x.com/GamedevGeoff/status/1867928068767261170).
* And more to come :)

# Tutorials

* [GMRoomLoader: Simultaneous Room Loading in GameMaker](https://www.youtube.com/watch?v=mZegvOC47dw) by [DragoniteSpam](https://www.youtube.com/c/DragoniteSpam/about). Michael introduces GMRoomLoader basics and goes over a few interesting edge cases.
* More coming soon!