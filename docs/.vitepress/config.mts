import { defineConfig } from 'vitepress'
import MarkdownIt from 'markdown-it'

export default defineConfig({
  base: '/GMRoomLoader/',
  cleanUrls: true,

  ignoreDeadLinks: true,
  lastUpdated: true,

  title: "GMRoomLoader",
  description: "GMRoomLoader Documentation",
  head: [
    ['link', { rel: 'icon', href: 'logo.svg' }],

    // embeds
    ["meta", { property: "og:title", content: "GMRoomLoader Documentation" }],
    ["meta", { property: "og:description", content: "Documentation for the GMRoomLoader GameMaker library. Setup instructions, usage examples and full API coverage." }],
    ["meta", { property: "og:type", content: "website" }],
    ["meta", { property: "og:url", content: "https://glebtsereteli.github.io/GMRoomLoader/" }],
    ["meta", { property: "og:image", content: "https://glebtsereteli.github.io/GMRoomLoader/socialPreview.png" }],

    ["meta", { name: "twitter:card", content: "summary_large_image" }],
    ["meta", { name: "twitter:title", content: "GMRoomLoader Documentation" }],
    ["meta", { name: "twitter:description", content: "Documentation for the GMRoomLoader GameMaker library. Setup instructions, usage examples and full API coverage." }],
    ["meta", { name: "twitter:image", content: "https://glebtsereteli.github.io/GMRoomLoader/socialPreview.png" }],
  
    // analytics
    [
      'script',
      { async: '', src: 'https://www.googletagmanager.com/gtag/js?id=G-5T6N7GGRNE' }
    ],
    [
      'script',
      {},
      `window.dataLayer = window.dataLayer || [];
       function gtag(){dataLayer.push(arguments);}
       gtag('js', new Date());
       gtag('config', 'G-5T6N7GGRNE');`
    ]
  ],

  themeConfig: {
    logo: '/logo.svg',

    search: {
      provider: 'local'
    },

    nav: [
      {
        text: 'Guide',
        items: [
          {
            text: '🏡 Home',
            items: [
              { text: 'What is GMRoomLoader?', link: '/pages/home/whatIsIt' },
              { text: 'Getting Started', link: '/pages/home/gettingStarted/gettingStarted' },
              { text: 'Demos & Tutorials', link: '/pages/home/demosTutorials/demosTutorials' },
              { text: 'FAQ', link: '/pages/home/faq' },
            ]
          },
          {
            text: '🗂️ Others',
            items: [
              { text: 'Contact & Support', link: '/pages/others/contactSupport' },
              { text: 'Upcoming Features', link: '/pages/others/upcomingFeatures' },
              { text: 'Credits', link: '/pages/others/credits' },
            ]
          }
        ]
      },
      { 
        text: 'API',
        activeMatch: '^/pages/api/',
        items: [
          { text: '📖 Overview', link: '/pages/api/overview' },
          { 
            text: '🗺️ RoomLoader',
            items: [
              { text: 'Overview', link: '/pages/api/roomLoader/overview' },
              { text: 'Data', link: '/pages/api/roomLoader/data' },
              { text: 'Loading ⭐', link: '/pages/api/roomLoader/loading' },
              { text: 'Screenshotting', link: '/pages/api/roomLoader/screenshotting' },
              { text: 'Origin', link: '/pages/api/roomLoader/origin' },
              { text: 'State', link: '/pages/api/roomLoader/state' },
              { text: 'Asset Type Filtering', link: '/pages/api/roomLoader/assetTypeFiltering' },
              { text: 'Layer Name Filtering', link: '/pages/api/roomLoader/layerNameFiltering' },
            ]
          },
          {
            text: '📦 Payload',
            items: [
              { text: 'Overview', link: '/pages/api/payload/overview' },
              { text: 'Depth', link: '/pages/api/payload/depth' },
              { text: 'Getters', link: '/pages/api/payload/getters' },
              { text: 'Cleanup', link: '/pages/api/payload/cleanup' },
            ],
          },
          { text: '🏗️ Debug View', link: '/pages/api/debugView/debugView', },
          { text: '⚙️ Configuration', link: '/pages/api/config', },
        ]
      },
      { text: 'Download', link: 'https://github.com/glebtsereteli/GMRoomLoader/releases/v2.3.0' },
    ],
    
    outline: [2, 3],
    sidebar: [
      {
        text: '🏡 Home',
        link: '/pages/home/whatIsIt',
        collapsed: false,
        items: [
          { text: 'What is GMRoomLoader?', link: '/pages/home/whatIsIt' },
          { text: 'Getting Started', link: '/pages/home/gettingStarted/gettingStarted' },
          { text: 'Demos & Tutorials', link: '/pages/home/demosTutorials/demosTutorials' },
          { text: 'FAQ', link: '/pages/home/faq' },
        ]
      },
      {
        text: '💻 API',
        link: '/pages/api/overview',
        collapsed: false,
        items: [
          {
            text: 'RoomLoader',
            link: '/pages/api/roomLoader/overview',
            items: [
              { text: 'Data', link: '/pages/api/roomLoader/data' },
              { text: 'Loading ⭐', link: '/pages/api/roomLoader/loading' },
              { text: 'Screenshotting', link: '/pages/api/roomLoader/screenshotting' },
              { text: 'Origin', link: '/pages/api/roomLoader/origin' },
              { text: 'State', link: '/pages/api/roomLoader/state' },
              { text: 'Asset Type Filtering', link: '/pages/api/roomLoader/assetTypeFiltering' },
              { text: 'Layer Name Filtering', link: '/pages/api/roomLoader/layerNameFiltering' },
            ]
          },
          {
            text: 'Payload',
            link: '/pages/api/payload/overview',
            items: [
              { text: 'Depth', link: '/pages/api/payload/depth' },
              { text: 'Getters', link: '/pages/api/payload/getters' },
              { text: 'Cleanup', link: '/pages/api/payload/cleanup' },
            ]
          },
          { text: 'Debug View', link: '/pages/api/debugView/debugView', },
          { text: 'Configuration', link: '/pages/api/config' },
        ]
      },
      {
          text: '🗂️ Others',
          link: '/pages/others/contactSupport',
          collapsed: false,
          items: [
            { text: 'Contact & Support', link: '/pages/others/contactSupport' },
            { text: 'Upcoming Features', link: '/pages/others/upcomingFeatures' },
            { text: 'Credits', link: '/pages/others/credits' },
          ]
      },
    ],
    
    socialLinks: [
      { icon: 'github', link: 'https://github.com/glebtsereteli/GMRoomLoader' },
      {
        icon: {
          svg: `<svg xmlns="http://www.w3.org/2000/svg" height="235.452" width="261.728" viewBox="0 0 245.37069 220.73612"><path d="M31.99 1.365C21.287 7.72.2 31.945 0 38.298v10.516C0 62.144 12.46 73.86 23.773 73.86c13.584 0 24.902-11.258 24.903-24.62 0 13.362 10.93 24.62 24.515 24.62 13.586 0 24.165-11.258 24.165-24.62 0 13.362 11.622 24.62 25.207 24.62h.246c13.586 0 25.208-11.258 25.208-24.62 0 13.362 10.58 24.62 24.164 24.62 13.585 0 24.515-11.258 24.515-24.62 0 13.362 11.32 24.62 24.903 24.62 11.313 0 23.773-11.714 23.773-25.046V38.298c-.2-6.354-21.287-30.58-31.988-36.933C180.118.197 157.056-.005 122.685 0c-34.37.003-81.228.54-90.697 1.365zm65.194 66.217a28.025 28.025 0 0 1-4.78 6.155c-5.128 5.014-12.157 8.122-19.906 8.122a28.482 28.482 0 0 1-19.948-8.126c-1.858-1.82-3.27-3.766-4.563-6.032l-.006.004c-1.292 2.27-3.092 4.215-4.954 6.037a28.5 28.5 0 0 1-19.948 8.12c-.934 0-1.906-.258-2.692-.528-1.092 11.372-1.553 22.24-1.716 30.164l-.002.045c-.02 4.024-.04 7.333-.06 11.93.21 23.86-2.363 77.334 10.52 90.473 19.964 4.655 56.7 6.775 93.555 6.788h.006c36.854-.013 73.59-2.133 93.554-6.788 12.883-13.14 10.31-66.614 10.52-90.474-.022-4.596-.04-7.905-.06-11.93l-.003-.045c-.162-7.926-.623-18.793-1.715-30.165-.786.27-1.757.528-2.692.528a28.5 28.5 0 0 1-19.948-8.12c-1.862-1.822-3.662-3.766-4.955-6.037l-.006-.004c-1.294 2.266-2.705 4.213-4.563 6.032a28.48 28.48 0 0 1-19.947 8.125c-7.748 0-14.778-3.11-19.906-8.123a28.025 28.025 0 0 1-4.78-6.155 27.99 27.99 0 0 1-4.736 6.155 28.49 28.49 0 0 1-19.95 8.124c-.27 0-.54-.012-.81-.02h-.007c-.27.008-.54.02-.813.02a28.49 28.49 0 0 1-19.95-8.123 27.992 27.992 0 0 1-4.736-6.155zm-20.486 26.49l-.002.01h.015c8.113.017 15.32 0 24.25 9.746 7.028-.737 14.372-1.105 21.722-1.094h.006c7.35-.01 14.694.357 21.723 1.094 8.93-9.747 16.137-9.73 24.25-9.746h.014l-.002-.01c3.833 0 19.166 0 29.85 30.007L210 165.244c8.504 30.624-2.723 31.373-16.727 31.4-20.768-.773-32.267-15.855-32.267-30.935-11.496 1.884-24.907 2.826-38.318 2.827h-.006c-13.412 0-26.823-.943-38.318-2.827 0 15.08-11.5 30.162-32.267 30.935-14.004-.027-25.23-.775-16.726-31.4L46.85 124.08c10.684-30.007 26.017-30.007 29.85-30.007zm45.985 23.582v.006c-.02.02-21.863 20.08-25.79 27.215l14.304-.573v12.474c0 .584 5.74.346 11.486.08h.006c5.744.266 11.485.504 11.485-.08v-12.474l14.304.573c-3.928-7.135-25.79-27.215-25.79-27.215v-.006l-.003.002z" fill="currentColor"/></svg>`,
        },
        link: 'https://glebtsereteli.itch.io/gmroomloader',
      },
      { icon: 'discord', link: 'https://discord.gg/gamemakerkitchen' },
      { icon: 'twitter', link: 'https://x.com/glebtsereteli' }, 
    ],

    footer: {
      message: 'Released under the <a href="https://github.com/glebtsereteli/GMRoomLoader/blob/main/LICENSE">MIT License</a>. Built with <a href="https://vitepress.dev/">VitePress</a>.',
      copyright: 'Copyright © 2024-2025 <a href="https://github.com/glebtsereteli">Gleb Tsereteli</a>'
    },

    lastUpdated: {
      text: 'Last modified on',
      formatOptions: {
        dateStyle: 'long',
        timeStyle: 'short'
      }
    },
  },

  markdown: {
    config: (md: MarkdownIt) => {
      const shortcuts: Record<string, string> = {
        // types
        'Real': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Data_Types.htm',
        'Bool': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Data_Types.htm',
        'String': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Strings/Strings.htm',
        'Array': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Arrays.htm',
        'Struct': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Structs.htm',
        'Undefined': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Data_Types.htm',
        'Noone': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Instance%20Keywords/noone.htm',
        'Enum': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Variables/Constants.htm#:~:text=of%20this%20page.-,Enums,-An%20enum%20is',

        // assets
        'Asset.GMRoom': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Rooms.htm',
        'Asset.GMObject': 'https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Asset_Management/Objects/Objects.htm',
        'Asset.GMSprite': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprites.htm',
        'Asset.GMTileset': 'https://manual.gamemaker.io/monthly/en/Quick_Start_Guide/Creating_Tile_Sets.htm',
        'Asset.GMSequence': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sequences/Sequences.htm',

        // IDs
        'Id.Layer': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/General_Layer_Functions/General_Layer_Functions.htm',
        'Id.Tilemap': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Tile_Map_Layers/Tile_Map_Layers.htm',
        'Id.Instance': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Instances/Instances.htm',
        'Id.Function': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Script_Functions.htm',
        'Id.Background': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Background_Layers/Background_Layers.htm',

        // functions
        'room_get_info()': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm',
        
        // links
        'New Issue': 'https://github.com/glebtsereteli/GMRoomLoader/issues/new',
        'Debug Overlay': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Debugging/The_Debug_Overlay.htm',
        
        'RoomLoader': '/pages/api/roomLoader/overview',
        'Origin': '/pages/api/roomLoader/origin',
        'Payload': '/pages/api/payload/overview',
        'Flags': '/pages/api/roomLoader/assetTypeFiltering',
        'Debug View': '/pages/api/debugView/debugView',

        'Asset Type': '/pages/api/roomLoader/assetTypeFiltering',
        'Layer Name': '/pages/api/roomLoader/layerNameFiltering',
        'Asset Type Filtering': '/pages/api/roomLoader/assetTypeFiltering',
        'Layer Name Filtering': '/pages/api/roomLoader/layerNameFiltering',
        
        'Data': '/pages/api/roomLoader/data',
        'Data Getters': '/pages/api/roomLoader/data#status-getters',
        'Initialization': '/pages/api/roomLoader/data#initialization',
        'Loading': '/pages/api/roomLoader/loading',
        'Screenshotting': '/pages/api/roomLoader/screenshotting',
        'Cleanup': '/pages/api/payload/cleanup',
        'RoomLoader.Load()': '/pages/api/roomLoader/loading#load',
        'RoomLoader.LoadInstances()': '/pages/api/roomLoader/loading#loadinstances',
        'RoomLoader.LoadTilemap()': '/pages/api/roomLoader/loading#loadtilemap',
        'Payload.Cleanup()': '/pages/api/payload/cleanup',
        '.Cleanup()': '/pages/api/payload/cleanup',
        
        'Full Room Loading': '/pages/api/roomLoader/loading#load',
        'Full Rooms': '/pages/api/roomLoader/loading#load',
        'Instances': '/pages/api/roomLoader/loading#loadinstances',
        'Tilemaps': '/pages/api/roomLoader/loading#loadtilemap',
        
        'ROOMLOADER_FLAG': '/pages/api/roomLoader/assetTypeFiltering#roomloader-flag',

        'ROOMLOADER_ENABLE_DEBUG': '/pages/api/config#roomloader-enable-debug',
        'ROOMLOADER_DEFAULT_XORIGIN': '/pages/api/config#roomloader-default-xorigin',
        'ROOMLOADER_DEFAULT_YORIGIN': '/pages/api/config#roomloader-default-yorigin',
        'ROOMLOADER_DEFAULT_FLAGS': '/pages/api/config#roomloader-default-flags',
        'ROOMLOADER_MERGE_LAYERS': '/pages/api/config#roomloader-merge-layers',
        'ROOMLOADER_MERGE_TILEMAPS': '/pages/api/config#roomloader-merge-tilemaps',
        'ROOMLOADER_DEBUG_VIEW_ENABLED': '/pages/api/config#roomloader-debug-view-enabled',
        'ROOMLOADER_DEBUG_VIEW_START_VISIBLE': '/pages/api/config#roomloader-debug-view-start-visible',
        'ROOMLOADER_DEBUG_VIEW_LOAD_KEY': '/pages/api/config#roomloader-debug-view-key',
        'ROOMLOADER_DEBUG_VIEW_ROOMS': '/pages/api/config#roomloader-debug-view-rooms',
        
        // state
        'State': '/pages/api/roomLoader/state',
        'State.XOrigin': '/pages/api/roomLoader/state#xorigin',
        'State.YOrigin': '/pages/api/roomLoader/state#yorigin',
        'State.Flags': '/pages/api/roomLoader/state#flags',
        'State.XScale': '/pages/api/roomLoader/state#xscale',
        'State.YScale': '/pages/api/roomLoader/state#yscale',
        'State.Mirror': '/pages/api/roomLoader/state#mirror',
        'State.Flip': '/pages/api/roomLoader/state#flip',
        'State.Angle': '/pages/api/roomLoader/state#angle',
        'State.Tileset': '/pages/api/roomLoader/state#tileset',
        
        'Scaling': '/pages/api/roomLoader/state#scale',
        'Scale': '/pages/api/roomLoader/state#scale',
        'Rotation': '/pages/api/roomLoader/state#angle',
        'Mirroring': '/pages/api/roomLoader/state#mirror',
        'Flipping': '/pages/api/roomLoader/state#flip',
        'Tileset': '/pages/api/roomLoader/state#tileset',
      }

      md.inline.ruler.before('link', 'shortcuts', (state, silent) => {
        for (const key in shortcuts) {
          const tokenText = `:${key}:`
          if (state.src.startsWith(tokenText, state.pos)) {
            if (!silent) {
              const token = state.push('link_open', 'a', 1)
              token.attrs = [['href', shortcuts[key]]]
              state.push('text', '', 0).content = key
              state.push('link_close', 'a', -1)
            }
            state.pos += tokenText.length
            return true
          }
        }
        return false
      })
    }
  },
})
