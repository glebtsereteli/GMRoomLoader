import { defineConfig } from 'vitepress'

export default defineConfig({
  base: '/GMRoomLoader/',

  ignoreDeadLinks: true,

  vite: {
    define: {
      ROOM_GET_INFO: JSON.stringify('/pages/home/gettingStarted/#installation')
    }
  },

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
          { text: 'Getting Started', link: '/pages/home/gettingStarted' },
          { text: 'Demo Guide', link: '/pages/home/demoGuide' },
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
            link: '/pages/api/roomLoader',
            items: [
              { text: 'Data', link: '/pages/api/roomLoader/#data' },
              { text: 'Loading', link: '/pages/api/roomLoader/#loading' },
              { text: 'Layer Filtering', link: '/pages/api/roomLoader/#layer-filtering' },
              { text: 'Screenshotting', link: '/pages/api/roomLoader/#screenshotting' },
            ]
          },
          {
            text: 'Return Data',
            collapsed: true,
            link: '/pages/api/returnData',
            items: [
              { text: 'Getters', link: '/pages/api/returnData/#getters' },
              { text: 'Cleanup', link: '/pages/api/returnData/#cleanup' },
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
  }
})
