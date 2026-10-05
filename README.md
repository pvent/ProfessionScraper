### ProfessionScraper
* **Description:** Dynamically scans active profession windows on the 2.5.3 client (supporting standard trade skills and Enchanting's legacy `CraftFrame`) and cross-references them with cached recipe databases (such as Sigma's data structure).
* **How to Use:**
  1. Place the folder into `Interface\AddOns\` ensuring the folder name and `.toc` match (`ProfessionScraper`).
  2. Open any profession window in-game (e.g., Blacksmithing, Alchemy, or Enchanting).
  3. Type `/pscrape` in chat to scan the open window and match known recipe IDs against the loaded cache.
* **Known Issues & Gotchas:**
  * **API Split:** Enchanting utilizes the legacy `CraftFrame` (`GetNumCrafts()`, `GetCraftInfo()`) instead of the standard `TradeSkillFrame` API. Mixing these up returns zero entries.
  * **Global Table Namespace:** Data files loaded via `.toc` must register into globally accessible tables or shared addon namespaces (`ns`), or lookup failures will occur if keys differ from localized strings.
![Uploading image.png…]()
