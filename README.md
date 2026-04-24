![](https://github.com/glebtsereteli/GMRoomLoader/assets/50461722/e82ecee8-149d-4a04-bf85-4010535ce033)

# GMRoomLoader [![Release](https://img.shields.io/github/v/release/glebtsereteli/GMRoomLoader?style=flat&logo=github&logoColor=white)](https://github.com/glebtsereteli/GMRoomLoader/releases)

GMRoomLoader is an award-winning [Free and Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) GameMaker library that lets you load any room's contents into the current room at runtime. Build procedural dungeons and chunked worlds, capture room screenshots, and more.

* ℹ️ Download the `.yymps` local package for [GameMaker Monthly](https://releases.gamemaker.io/#:~:text=GameMaker%20Release%20Notes-,Monthly,-Released%20roughly%20every) from the [Releases](https://github.com/glebtsereteli/GMRoomLoader/releases) page.
* ℹ️ Refer to the [Documentation](https://glebtsereteli.github.io/GMRoomLoader/) for installation instructions, usage examples, and full API reference.
* ℹ️ See the [Getting Started](https://glebtsereteli.github.io/GMRoomLoader/pages/home/gettingStarted/gettingStarted#getting-started) page to load your first room.

<table style="width: 100%; table-layout: fixed; border-collapse: separate; border-spacing: 10px;">
  <tr>
    <td style="width: 50%;"><a href="https://github.com/user-attachments/assets/c08c826b-010d-4164-80e3-f626db18e95d"><img src="https://github.com/user-attachments/assets/c08c826b-010d-4164-80e3-f626db18e95d" style="width: 100%; display: block;"></a></td>
    <td style="width: 50%;"><a href="https://github.com/user-attachments/assets/ced01379-2775-436a-a073-e54a791a1456"><img src="https://github.com/user-attachments/assets/ced01379-2775-436a-a073-e54a791a1456" style="width: 100%; display: block;"></a></td>
  </tr>
  <tr>
    <td style="width: 50%;"><a href="https://github.com/user-attachments/assets/c18c9b35-b3a2-4124-a898-9c1c29b17b68"><img src="https://github.com/user-attachments/assets/c18c9b35-b3a2-4124-a898-9c1c29b17b68" style="width: 100%; display: block;"></a></td>
    <td style="width: 50%;"><a href="https://github.com/user-attachments/assets/28c2808d-466d-42e4-89c8-034774c80f60"><img src="https://github.com/user-attachments/assets/28c2808d-466d-42e4-89c8-034774c80f60" style="width: 100%; display: block;"></a></td>
  </tr>
</table>

# Use Cases
* **Procedural Generation**. Design hand-crafted room templates and assemble them at runtime to create fresh levels every time. Build modular worlds, Spelunky-style dungeons, endless runners, or anything else where you need multiple rooms in one.
* **Chunking**. Split your world into chunks and load or unload them dynamically as the player moves. Everything happens inside a single room, with no room switching or loading screens.
* **Room Screenshots**. Capture screenshots of any room without visiting it. Use them for level select menus, map previews, or seamless room transitions.

# Features
* **Flexible Loading**. Load [Full Rooms](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#load), [Instances](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadinstances) or [Tilemaps](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadtilemap) anywhere in the current room, with optional [origin](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/origin), [scaling](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#scale), [mirroring](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#mirror), [flipping](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#flip) and [rotation](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#angle).
* **Full Lifecycle Control**. Track everything loaded with [Payload](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/overview). [Fetch IDs](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/getters), [adjust depths](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/depth), and [clean up](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/cleanup) whenever you're done.
* **Powerful Screenshotting**. Capture any room as a [Sprite](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotsprite), [Surface](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotsurface) or [Buffer](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotbuffer) without ever visiting it, with optional [part definition](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state/#part), scaling and filtering.
* **Filtering Options**. Filter elements by [Asset Type](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/assetTypeFiltering) and/or layers by [Layer Name](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/layerNameFiltering) for precise control over what gets loaded.
* **[Fluent State Builder](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state)**. Configure optional parameters before loading or screenshotting in a clean, English-like flow.
* **Quick Debug Loading**. Load any room at the mouse position with fully configurable parameters via the [Debug View](https://glebtsereteli.github.io/GMRoomLoader/pages/api/debugView/debugView). Perfect for testing with zero code required.
* **Easy Data Access**. Query room data before ever loading it. Retrieve [layer names](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datagetlayernames), [instance data](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datagetinstances), [room dimensions](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datagetwidth) and more with built-in [Getters](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#status-getters).

# GameMaker Awards!
GMRoomLoader [won in the Best Tool category](https://gamemaker.io/en/blog/gamemaker-awards-2025) at the GameMaker Awards after being nominated two years in a row in both [2024](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners) and [2025](https://gamemaker.io/en/blog/voting-gamemaker-awards-2025)!
<table style="width: 100%; table-layout: fixed; border-collapse: separate; border-spacing: 10px;">
  <tr>
    <td style="width: 50%;"><a href="https://github.com/user-attachments/assets/9b2dee65-a891-4d88-8025-3dffb4549213"><img src="https://github.com/user-attachments/assets/9b2dee65-a891-4d88-8025-3dffb4549213" style="width: 100%; display: block;"></a></td>
    <td style="width: 50%;"><a href="https://github.com/user-attachments/assets/faea3207-85af-419b-b0fa-03e8f833dd57"><img src="https://github.com/user-attachments/assets/faea3207-85af-419b-b0fa-03e8f833dd57" style="width: 100%; display: block;"></a></td>
  </tr>
</table>

# Credits
- Created and maintained by [Gleb Tsereteli](https://twitter.com/glebtsereteli).
- Wonderful promo art by the very talented [neerikiffu](https://bsky.app/profile/neerikiffu.bsky.social)!
- Additional art and demo rooms designed by my wife [Kate](https://www.linkedin.com/in/kate-ivanova22/) ❣️
- Motivated by and made for [TabularElf](https://twitter.com/TabularElf)'s [Cookbook Jam #1](https://itch.io/jam/cookbook-jam-1).
- Thank you to [YellowAfterlife](https://twitter.com/YellowAfterlife) for inspiring this library with his OG [GMRoomPack](https://yellowafterlife.itch.io/gmroompack), various help and ideas.
- Thank you to [Topher Anselmo](https://topheranselmo.com/) for inspiration and help with [VitePress](https://vitepress.dev/)-based documentation.
- Demo art by [Kenney](https://kenney.nl) the ✨*Asset Jesus*✨.

# Games Using GMRoomLoader
* [Juju Adams](https://www.jujuadams.com/)' undisclosed [commercial games](https://www.reddit.com/r/gamemaker/comments/1nn84b9/comment/nfjy5v4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button).
* [DirtWorld](https://krankenhaus-uk.itch.io/dirtworld) by [Joe Baxter-Webb](https://bsky.app/profile/indiegameclinic.bsky.social) (AKA [Indie Game Clinic](https://indiegameclinic.com/) and [KRANKENHAUS](https://krankenhaus-uk.itch.io/)).
* [Horizonite](https://store.steampowered.com/app/2151140/Horizonite/) by [Phablix](https://linktr.ee/phablix).
* [Desukupet](https://www.twitch.tv/grogdev) by [GrogDev](https://grog.dev/) and [PixelatedPope](https://www.pixelatedpope.com/).
* [Flashes of Chaos](https://store.steampowered.com/app/3399100/Flashes_of_Chaos/) by [Brainburn Studio](https://x.com/BrainburnStudio).
* [Project Reality: Shattered](https://www.twitch.tv/brewerthegreater) by BrewerTheGreater.
* [Canon](https://canonrpg.tumblr.com/) by [sonyPlaytation](https://sonyplaytation.neocities.org/).
* [Goober Launch](https://x.com/GamedevGeoff/status/1867928068767261170) by [Geoff Moore](https://geoffmoore.co.uk/).
* [BloodVeil](https://www.youtube.com/watch?v=VHemNttUmyk) by [Christian de Mander](https://www.youtube.com/@christiandemander4256).
* And there's more to come! Feel free to share your project with me if you'd like it to be listed here, I'd love to see what you've built with it! 🙂

# Tutorials
* [GMRoomLoader: Simultaneous Room Loading in GameMaker](https://www.youtube.com/watch?v=mZegvOC47dw) by [DragoniteSpam](https://www.youtube.com/c/DragoniteSpam/about). Michael introduces GMRoomLoader basics and goes over a few interesting edge cases.
* More coming soon!
