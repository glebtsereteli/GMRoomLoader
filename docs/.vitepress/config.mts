import { defineConfig } from 'vitepress'
import MarkdownIt from 'markdown-it'

export default defineConfig({
  base: '/GMRoomLoader/',

  ignoreDeadLinks: true,

  title: "GMRoomLoader",
  description: "GMRoomLoader Documentation",
  themeConfig: {
    search: {
      provider: 'local'
    },

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/pages/home/whatIsIt' },
      { text: 'API', link: '/pages/api/overview' },
      { text: 'Releases', link: 'https://github.com/glebtsereteli/GMRoomLoader/releases' },
    ],
    
    outline: [2, 3],
    sidebar: [
      {
        text: '🏡 Home',
        collapsed: false,
        items: [
          { text: 'What is GMRoomLoader?', link: '/pages/home/whatIsIt' },
          { text: 'Getting Started', link: '/pages/home/gettingStarted/gettingStarted' },
          { text: 'Demo', link: '/pages/home/demo' },
          { text: 'FAQ', link: '/pages/home/faq' },
        ]
      },
      {
        text: '💻 API',
        collapsed: false,
        items: [
          { text: 'Overview', link: '/pages/api/overview' },
          {
            text: 'RoomLoader',
            collapsed: true,
            link: '/pages/api/roomLoader/overview',
            items: [
              { text: 'Data', link: '/pages/api/roomLoader/data' },
              { text: 'Loading', link: '/pages/api/roomLoader/loading' },
              { text: 'Layer Filtering', link: '/pages/api/roomLoader/layerFiltering' },
              { text: 'Screenshotting', link: '/pages/api/roomLoader/screenshotting' },
            ]
          },
          {
            text: 'ReturnData',
            collapsed: true,
            link: '/pages/api/returnData/overview',
            items: [
              { text: 'Getters', link: '/pages/api/returnData/getters' },
              { text: 'Cleanup', link: '/pages/api/returnData/cleanup' },
            ]
          },
          { text: 'Enums', link: '/pages/api/enums' },
          { text: 'Configuration', link: '/pages/api/config' },
        ]
      },
      {
          text: '🗂️ Others',
          collapsed: false,
          items: [
            { text: 'Help & Support', link: '/pages/others/helpSupport' },
            { text: 'Upcoming Features', link: '/pages/others/upcomingFeatures' },
            { text: 'Credits', link: '/pages/others/credits' },
          ]
      },
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/glebtsereteli/GMRoomLoader' },
      { icon: 'twitter', link: 'https://x.com/glebtsereteli' },
    ],

    footer: {
      message: 'Released under the <a href="https://github.com/glebtsereteli/GMRoomLoader/blob/main/LICENSE">MIT License</a>. Built with <a href="https://vitepress.dev/">VitePress</a>.',
      copyright: 'Copyright © 2025 <a href="https://github.com/glebtsereteli">Gleb Tsereteli</a>'
    },
  },

   markdown: {
    config: (md: MarkdownIt) => {
      const shortcuts: Record<string, string> = {
        // types
        'Real': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Variables/Real.htm',
        'String': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Variables/Strings.htm',
        'Array': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Arrays.htm',
        'Struct': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Overview/Structs.htm',

        // assets
        'Asset.GMRoom': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/Rooms.htm',
        
        // functions
        'room_get_info()': 'https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Rooms/room_get_info.htm',
        
        // links
        'RoomLoader': '/pages/api/roomloader/overview',
        'ReturnData': '/pages/api/returndata/overview',

        'Loading': '/pages/api/roomloader/loading',
        'Screenshotting': '/pages/api/roomloader/screenshotting',
        'RoomLoader.Load()': '/pages/api/roomloader/loading#load',
        'RoomLoader.LoadInstances()': '/pages/api/roomloader/loading#loadinstances',
        'ReturnData.Cleanup()': '/pages/api/returndata/cleanup',
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
