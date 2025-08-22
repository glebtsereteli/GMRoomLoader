---

layout: home

hero:
  name: "GMRoomLoader"
  text: Runtime room loading for GameMaker
  tagline: Room prefabs and runtime content loading made effortless with GMRoomLoader's robust interface.
  actions:
    - theme: brand
      text: Get Started
      link: '/pages/home/whatIsIt'
    - theme: alt
      text: View on GitHub
      link: import01.png

features:
  - title: 🗺️ Procedural Generation
    details: Create reusable level templates for rooms, NPCs or props, and place them procedurally throughout your levels.
  - title: 🧩 Chunking
    details: Divide big worlds into smaller sections that dynamically load or unload as players approach.
  - title: 🏗️ Flexible Rooms
    details: Load and position rooms at custom coordinates and origins, with filtering by layer type or name.
  - title: 📐 Dynamic Instances
    details: In addition to positions and origins, load instances at custom angles and scales. Great for enemy layouts, collectibles and effects.
  - title: ⚙️ Full Control
    details: From merging or creating new layers to tracking and removing loaded elements, you have full control of the loading process.
  - title: 🖼️ Screenshots
    details: Capture room screenshots without ever visiting rooms on game start. Could be used for level selection, marketing, design feedback or notes.

---

<hr style="border: none; border-top: 2px solid #888; margin:4em 0 1em;" />

<div style="text-align:center; font-size:1.1em; color:#555; margin-bottom:2em;">
  <strong>GMRoomLoader</strong> Team
</div>

<script setup>
import { VPTeamMembers } from 'vitepress/theme'

const team = [
  {
    avatar: 'https://avatars.githubusercontent.com/u/50461722?v=4',
    name: 'Gleb Tsereteli',
    title: 'Developer',
    links: [
      { icon: 'github', link: 'https://github.com/GlebTsereteli' },
      { icon: 'twitter', link: 'https://x.com/GlebTsereteli' },
    ]
  },
  {
    avatar: 'https://avatars.githubusercontent.com/u/159041753?v=4',
    name: 'Kate',
    title: 'Visuals, Testing, Demo Levels',
    links: [
      { icon: 'linkedin', link: 'https://www.linkedin.com/in/kate-ivanova22/' },
      { icon: 'instagram', link: 'https://www.instagram.com/k8te_iv' },
    ]
  }
]
</script>

<VPTeamMembers :members="team" />