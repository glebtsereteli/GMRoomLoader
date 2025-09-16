---

layout: home

hero:
  name: "GMRoomLoader"
  text: Runtime room loading for GameMaker
  tagline: Room prefabs and runtime content loading made effortless with GMRoomLoader's robust interface.
  actions:
    - theme: brand
      text: What is GMRoomLoader?
      link: '/pages/home/whatIsIt'
    - theme: alt
      text: Get Started
      link: '/pages/home/gettingStarted/gettingStarted'
  image:
    src: /logo.svg
    alt: Icon

features:
  - title: 🗺️ Procedural Generation
    details: Create reusable level templates for rooms, NPCs or props, and place them procedurally throughout your levels.
  - title: 🧩 Chunking
    details: Divide large worlds into smaller chunks that dynamically load when players approach and unload when they move away.
  - title: 🏗️ Flexible Loading
    details: Load Full Rooms, Instances or Tilemaps at any position in the current room — all with optional origin, filtering, scaling and rotation.
  - title: 📐 Fluent State Management
    details: Configure optional arguments before loading or screenshotting in a simple English-like flow via the Fluent State Builder.
  - title: ⚙️ Full Lifecycle Control
    details: From merging or creating new layers to Payload tracking and removing loaded elements, you have full control of the loading process.
  - title: 🖼️ Screenshots
    details: Capture room Screenshots from anywhere, without ever visiting target rooms — with optional part definition, scaling and filtering.

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
