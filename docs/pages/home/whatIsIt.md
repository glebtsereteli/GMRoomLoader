# GMRoomLoader

## What is GMRoomLoader?

GMRoomLoader is an award-winning [Free and Open Source](https://en.wikipedia.org/wiki/Free_and_open-source_software) GameMaker library that turns rooms into reusable building blocks by loading their contents into the current room at runtime.

Design levels across multiple rooms and combine them seamlessly during gameplay. Build procedural dungeons, chunked open worlds, endless runners, and more.

* ℹ️ Download the `.yymps` local package from the [latest release](https://github.com/glebtsereteli/GMRoomLoader/releases/latest/) page.
* ℹ️ Refer to the [Documentation](https://glebtsereteli.github.io/GMRoomLoader/) for installation instructions, usage examples, and full API reference.

::: warning DISCLAIMER
GMRoomLoader is designed specifically for __loading room contents__.

It does not provide tools for procedural generation or level layout creation of any kind (like deciding which room to load and where to place it). You'll need to handle that yourself.
:::

## Use Cases
* **Procedural Generation**. Design hand-crafted room templates and assemble them at runtime to create unique levels on every run. Build modular worlds, dungeons, endless runners, or anything else that needs multiple rooms loaded into one.
* **Chunking**. Split your world into chunks and load or unload them dynamically as the player moves. Everything happens inside a single room, with no room transitions or loading screens.
* **Stamp Pools**. Design multiple layouts for enemy encounters, NPC placements, or collectible layouts. Load from the pool at random to keep repetitive areas feeling varied.
* **Screenshotting**. Capture screenshots of any room without ever visiting it, and use them for level select menus, building previews, or transition effects between rooms.

## Features
* **Flexible Loading**. Load [Full Rooms](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#load), [Instances](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadinstances) or [Tilemaps](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/loading#loadtilemap) at any position in the current room - all with optional origin, scaling, mirroring, flipping and rotation.
* **Screenshotting**. Capture room [Screenshots](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/screenshotting) from anywhere, without ever visiting target rooms - with optional part definition, scaling and filtering.
* **Full Lifecycle Control**. Manage loaded contents with [Payload](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/overview) tracking - [Fetch IDs](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/getters) and [Destroy](https://glebtsereteli.github.io/GMRoomLoader/pages/api/payload/cleanup) loaded elements.
* **Filtering Options**. Filter elements by [Asset Type](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/assetTypeFiltering) and/or layers by [Layer Name](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/layerNameFiltering).
* **Fluent [State](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/state) Builder**. Configure optional arguments before loading or screenshotting in a simple, English-like flow.
* **Easy Data Handling**. Initialize and remove data in multiple ways: [Single or Multiple](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainit), [Array](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainitarray), [Prefix](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainitprefix), [Tag](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainittag), or [All](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#datainitall). Retrieve core room info with [Getters](https://glebtsereteli.github.io/GMRoomLoader/pages/api/roomLoader/data#status-getters).
* **Quick Debug Loading**. Load any room in the project at the mouse position with fully configurable parameters via the [Debug View](https://glebtsereteli.github.io/GMRoomLoader/pages/api/debugView/debugView) interface. Perfect for quick testing - no code required!

## How does it work?

GMRoomLoader works by calling :room_get_info(): to grab the raw data of a room, parsing that data, optimizing it for loading, and then rebuilding room layers and elements when you use its :Loading: methods.

GameMaker can only have a single room active at a time and GMRoomLoader doesn't magically change that. Instead, it recreates the contents of other rooms inside the current room.

## GameMaker Awards!
GMRoomLoader [won in the Best Tool category](https://gamemaker.io/en/blog/gamemaker-awards-2025) at the GameMaker Awards after being nominated two years in a row in both [2024](https://gamemaker.io/en/blog/gamemaker-awards-2024-winners) and [2025](https://gamemaker.io/en/blog/gamemaker-awards-2025)!

<div style="text-align:center; margin-top:2em;">
  <div style="display:flex;gap:12px;justify-content:center;margin-top:1em;">
    <img src="https://github.com/user-attachments/assets/9b2dee65-a891-4d88-8025-3dffb4549213" alt="2025 Award" style="flex:1.784 1 0;width:0;height:auto;">
    <img src="https://github.com/user-attachments/assets/751e1808-4738-4233-86ba-8d9a373ab2a8" alt="Trophy" style="flex:0.75 1 0;width:0;height:auto;">
    <img src="https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d" alt="2024 Award" style="flex:1.784 1 0;width:0;height:auto;">
  </div>
</div>

## Games Using GMRoomLoader
* [Juju Adams](https://www.jujuadams.com/)' undisclosed [commercial games](https://www.reddit.com/r/gamemaker/comments/1nn84b9/comment/nfjy5v4/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button).
* [DirtWorld](https://krankenhaus-uk.itch.io/dirtworld) by [Joe Baxter-Webb](https://bsky.app/profile/indiegameclinic.bsky.social) (AKA [Indie Game Clinic](https://indiegameclinic.com/) and [KRANKENHAUS](https://krankenhaus-uk.itch.io/)).
* [Horizonite](https://store.steampowered.com/app/2151140/Horizonite/) by [Phablix](https://linktr.ee/phablix).
* [Flashes of Chaos](https://store.steampowered.com/app/3399100/Flashes_of_Chaos/) by [Brainburn Studio](https://x.com/BrainburnStudio).
* [Desukupet](https://www.twitch.tv/grogdev) by [GrogDev](https://grog.dev/) and [PixelatedPope](https://www.pixelatedpope.com/).
* [Canon](https://canonrpg.tumblr.com/) by [sonyPlaytation](https://sonyplaytation.neocities.org/).
* [Goober Launch](https://x.com/GamedevGeoff/status/1867928068767261170) by [Geoff Moore](https://geoffmoore.co.uk/).
* [BloodVeil](https://www.youtube.com/watch?v=VHemNttUmyk) by [Christian de Mander](https://www.youtube.com/@christiandemander4256).
* Project Reality: Shattered by BrewerTheGreater.
* And more to come! Feel free to share your project with me if you'd like it listed here, I'd love to see what you've built! 🙂