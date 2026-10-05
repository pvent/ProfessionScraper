### RelicHelper
* **Description:** Designed for hybrid classes (Druids, Shamans, Paladins) on the 2.5.3 client to track and auto-swap class-specific relics, idols, and totems dynamically based on active spells or abilities.
* **How to Use:**
  1. Install the addon and load into the game client.
  2. Configure preferences via addon settings or default slash commands to link specific relics to spell casts.
  3. The addon listens for spell casting events to equip the optimal item on the fly.
* **Known Issues & Gotchas:**
  * **Combat Restrictions:** World of Warcraft security restrictions prevent automated equipment changes for certain slots if rules change mid-cast or while tainted, which can cause item-swapping errors during active combat encounters.
  * **Latency / Spell Queueing:** Rapid spell queueing in TBC can occasionally outpace the server-side equipment swap response window, causing the relic swap to clip.
