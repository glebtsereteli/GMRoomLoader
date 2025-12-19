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

<h2 style="text-align:center;">GameMaker Awards</h2>

<div style="text-align:center;">
  GMRoomLoader <a href="https://gamemaker.io/en/blog/gamemaker-awards-2025" target="_blank" rel="noopener noreferrer">won in the Best Tool category</a> at the GameMaker Awards after being nominated two years in a row in both
  <a href="https://gamemaker.io/en/blog/gamemaker-awards-2024-winners" target="_blank" rel="noopener noreferrer">2024</a> 
  and 
  <a href="https://gamemaker.io/en/blog/voting-gamemaker-awards-2025" target="_blank" rel="noopener noreferrer">2025</a>!
</div>

<div style="text-align:center; margin-top:2em;">
  <div style="display:flex;gap:12px;justify-content:center;margin-top:1em;">
    <img src="https://github.com/user-attachments/assets/9b2dee65-a891-4d88-8025-3dffb4549213" alt="2025 Award" style="flex:1 1 0;width:0;height:auto;">
    <img src="https://github.com/user-attachments/assets/9f24ea91-21da-4f2c-9427-f8ab9cfb778d" alt="2024 Award" style="flex:1 1 0;width:0;height:auto;">
  </div>
</div>

<h2 style="text-align:center;">GMRoomLoader Team</h2>

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
      { icon: 'bluesky', link: 'https://bsky.app/profile/glebtsereteli.bsky.social' }, 
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
