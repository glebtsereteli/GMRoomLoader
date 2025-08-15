import { defineConfig } from 'vitepress'

export default defineConfig({
  base: '/GMRoomLoader/',

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

    sidebar: [
      {
        text: 'Home',
        collapsed: false,
        items: [
          {
            text: 'What is GMRoomLoader?',
            link: '/pages/home/whatIsIt',
          },
        ]
      },
      {
        text: 'API',
        collapsed: false,
        items: [
          { text: 'Overview', link: '/pages/api/overview', },
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
