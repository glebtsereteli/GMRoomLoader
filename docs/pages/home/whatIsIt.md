# What is GMRoomLoader?

GMRoomLoader is an award-winning [Free and Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) GameMaker library that lets you load any room's contents into the current room at runtime. Build procedural dungeons, dynamic chunk systems, room previews and more.

Getting started is effortless! Loading an entire room takes just a single line of code:
```js
RoomLoader.Load(rmExample, x, y);
```
* ℹ️ Download the `.yymps` local package for [GameMaker Monthly](https://releases.gamemaker.io/#:~:text=GameMaker%20Release%20Notes-,Monthly,-Released%20roughly%20every) from the [Releases](https://github.com/glebtsereteli/GMRoomLoader/releases) page.
* ℹ️ Refer to the [Documentation](https://glebtsereteli.github.io/GMRoomLoader/) for installation instructions, usage examples and full API reference.

## Use Cases
* **Procedural Generation**. Design hand-crafted room templates and place them procedurally at runtime. Build Spelunky-style dungeons, modular levels, randomized prop layouts, and more.
* **Chunking**. Split your world into chunks and load or unload them dynamically as the player moves, enabling seamless open-world exploration without loading screens.
* **Room Screenshots**. Capture screenshots of any room without ever visiting it and use them for level selection menus, map previews or seamless room transitions.

::: warning DISCLAIMER
GMRoomLoader is designed specifically for __loading room contents__.

It does NOT provide tools for procedural generation or level layout creation of any kind (like deciding which room to load and where to place it). You'll need to handle that yourself.
:::

## Features

* **Flexible Loading**. Load [Full Rooms](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#load), [Instances](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadinstances) or [Tilemaps](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadtilemap) anywhere in the current room, with optional [origin](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/origin), [scaling](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#scale), [mirroring](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#mirror), [flipping](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#flip) and [rotation](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state#angle).
* **Full Lifecycle Control**. Track everything loaded with [Payload](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/overview). [Fetch IDs](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/getters), [adjust depths](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/depth), and [clean up](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/cleanup) whenever you're done.
* **Powerful Screenshotting**. Capture any room as a [Sprite](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotsprite), [Surface](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotsurface) or [Buffer](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting#screenshotbuffer) without ever visiting it, with optional [part definition](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state/#part), scaling and filtering.
* **Filtering Options**. Filter elements by [Asset Type](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/assetTypeFiltering) and/or layers by [Layer Name](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/layerNameFiltering) for precise control over what gets loaded.
* **[Fluent State Builder](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state)**. Configure optional parameters before loading or screenshotting in a clean, English-like flow.
* **Quick Debug Loading**. Load any room at the mouse position with fully configurable parameters via the [Debug View](https://glebtsereteli.github.io/GMRoomLoader/pages/api/debugView/debugView). Perfect for testing with zero code required.
* **Easy Data Access**. Query room data before ever loading it. Retrieve [layer names](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datagetlayernames), [instance data](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datagetinstances), [room dimensions](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datagetwidth) and more with built-in [Getters](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#status-getters).

## How does it work?

GMRoomLoader works by calling :room_get_info(): to grab the raw data of a room, parsing that data, optimizing it for loading, and then rebuilding room layers and elements when you use its :Loading: methods.

GameMaker can only have a single room active at a time and GMRoomLoader doesn't magically change that. Instead, it recreates the contents of other rooms inside the current room.

## GameMaker Awards!
GMRoomLoader [won in the Best Tool category](https://gamemaker.io/en/blog/gamemaker-awards-2025) at the GameMaker Awards after being nominated two years in a row in both [2024](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners) and [2025](https://gamemaker.io/en/blog/voting-gamemaker-awards-2025)!

<div style="text-align:center; margin-top:2em;">
  <div style="display:flex;gap:12px;justify-content:center;margin-top:1em;">
    <img src="https://github.com/user-attachments/assets/9b2dee65-a891-4d88-8025-3dffb4549213" alt="2024 Award" style="flex:1 1 0;width:0;height:auto;">
    <img src="https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d" alt="2025 Award" style="flex:1 1 0;width:0;height:auto;">
  </div>
</div>

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
