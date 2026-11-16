# Changelog

## [30] - 2026-11-16

- Fix: A house where the swap tick places and removes nothing is finished instead of being arranged and sent back into swap. When one slot of a limit remains and nothing of that limit can be picked up, that slot is used for one inbound item.
- Fix: A sort no longer switches Retrieve To to Inventory. A normal pickup keeps the bag selected on Before We Begin. The selected bag is filled first, and the backpack is used only when that bag is full. Placements are taken from the selected bag first. Only a vault-mode store sets Retrieve To to the Furniture Vault.
- Fix: Items at or above the vault threshold are not placed back out of the Furniture Vault. That had been placing a vault copy and storing it again on the next tick.
- Fix: The sorting-time estimate counts one placement per item in a stack. Copies already in the Furniture Vault are not counted as another place-and-store.
- Feat: Item names in the action log are bracketed item links. Left-click opens the item tooltip.

## [29] - 2026-11-16

- Feat: The status line stays on one remaining-time total for sorting, lights, and arranging. Per-item lines stay in the action log. Sorting and lights use the 800ms housing tick. Arranging uses the 130ms move tick.
- Fix: A backpack placement consumes a Furniture Vault copy of that item first. Vault-bound stacks are now placed until the backpack is empty, which needs room for the backpack and vault copies together, and only then put away into the vault.
- Feat: Taneth suite `/taneth MagicSorter` covers settings, light-state names, item links, vault slot counts, and Retrieve To. For a Rough Cup in both the backpack and the Furniture Vault, it checks the bag counts, that a vault put-away waits until the backpack is empty, that the house has room for both stacks together, and that one backpack placement consumes a vault copy.
- Fix: The sort reads the current house's Traditional and Special slots from the housing editor before it places. It keeps one slot of a limit free and removes an outbound item of that limit before using the last slot. A Traditional or Special cap stops further placement requests for that tick. The Storage Houses list and its tooltip keep their existing layout.

## [28] - 2026-11-16

- Feat: Swap to using `KEYBINDINGS_MANAGER:SetChordingAlwaysEnabled(true)` instead of overriding method.
- Feat: Dialog version label supports dual format. `28` shows "Version 28", `28100` shows "Version 28.1", `28105` shows "Version 28.1.5".
- Fix: Housing editor "Retrieve To" is switched to Inventory while a sort runs and restored when the sort stops. Previously, if Retrieve To was set to the Furniture Vault, bank, or a storage chest, picked-up furniture went there instead of the inventory.
- Fix: Off-by-one in the inventory slot loop when building the placeable furniture list.
- Feat: Optional Furniture Vault mode on the "Before We Begin..." screen. Furnishings with at least the chosen number of copies (inventory + vault + storage homes) are stored in the Furniture Vault; furnishings below it are placed from the vault into their storage home. Requires ESO Plus and the Furnishing Vault collectible.
- Feat: "Retrieve To" button on the "Before We Begin..." screen cycles through your available Retrieve To containers, so you don't have to open the housing editor to change it. Left-click goes to the next container, right-click to the previous one.
- Feat: Storage house tooltips show Furniture Vault counts (to vault / from vault) when vault mode is on.
- Feat: Reworked the "Before We Begin..." layout. The option tiles and the vault/Retrieve To settings are centered as one group, the threshold reads "Vault at N+ copies", and Back / Start Quick Sort / Start Full Sort are equal-width and centered.
- Feat: Higher resolution icon for the "Use Furniture Vault" tile.
- Fix: Furniture removed to the Furniture Vault could land in the inventory instead. Retrieve To is now left on the removal's destination until the next removal, instead of being switched back to Inventory immediately after the request.
- Fix: After a sort, the housing editor's Place list could show stale entries under "Uncategorized" until a UI reload. The list is now rebuilt the first time the housing editor furniture browser opens after a sort.
- Fix: The Storage Houses tab stayed blank when a sort was started in the house being sorted. The tab now fills in as soon as the progress window opens, refreshes on a steady interval during the sort instead of being pushed back by every sort event, and refreshes immediately when the tab or "Show Details" is clicked.
- Debug: Vault failures and the Retrieve To bag used for each removal are written to the debug log.
- Feat: Optional lights tile on the "Before We Begin..." screen. Click cycles leave lights alone, turn them off, or turn them on. Lighting furnishings are switched while each storage home is sorted, before that home is arranged. Lights the sort places are switched when that placement completes. The state is taken from the variation name when that name says on or off (issue #1).
- Feat: While lights already in a home are being switched off, the status line shows the estimated time remaining.

## [27] - 2026-06-24

- Fix: swap usage of UI_SHORTCUT_REPORT_PLAYER to MAGIC_SORTER so keybind can show correctly.

## [26] - 2026-06-23

- API update.
- KEYBINDING_MANAGER -> KEYBINDINGS_MANAGER rename
- Fix: default keybind now works. F10. Change in the Controls -> Keybindings section.

## [25] - 2025-11-14

- Fixed an issue where items weren't being moved from houses with no categories assigned to houses with parent categories assigned (e.g., "Conservatory, All"). The system now correctly checks both subcategory and parent category assignments when determining where items can be placed.
- Removed the requirement that target houses must be visited before items can be moved to them, allowing items to be moved to any house with appropriate category assignments regardless of visit order.

## [23] - 2025-06-02

- API update.
- Bug Fixes.

## [20] - 2021-03-13

- API update.

## [19] - 2021-03-07

- API update.

## [18] - 2020-05-26

- API update.

## [17] - 2020-03-05

- API update.

## [16] - 2019-12-30

- Added a new Quick Sort mode that will perform an abbreviated sort in significantly less time.
  - Quick Sort works by remembering your storage homes' inventories after your first full sort is completed.
  - Please enable Magic Sorter for all of your characters in order to make sure that Magic Sorter's knowledge of your homes' inventories remains accurate and up-to-date.
  - A full sort will always be required after adding or removing storage homes or changing category or style assignments.
- Furniture item tool tips will now indicate the furniture subcategory and style in order to better assist you in planning your storage allocation.
- After having visited your home for the first time, the Magic Sorter wizard will show the currently number of Traditional item slots used (as well as Special item slots in the associated tool tip).
- The Magic Sorter wizard will now show tool tips on furniture category tags that indicate which storage home(s) the category is assigned to.
- The Magic Sorter wizard will now show tool tips on selected storage homes that indicate which racial style(s) are assigned to the home.
- Bug fixes.

## [15] - 2019-12-27

- Bug fixes.

## [14] - 2019-12-24

- Bug fixes.

## [12] - 2019-12-24

- Now you may optionally assign specific furniture style(s) to each storage house. When one or more style(s) are assigned to a storage house, only furnishings of that style will be stored there.

## [11] - 2019-12-22

- Revised the completion summary report to instead list furniture categories, if any, for which there was insufficient room to store those types of items based on your storage house category assignments.
- The last sort's completion summary report will be shown side-by-side with the wizard's House Selection and Category Assignment screens to allow you to more easily adjust your houses/category assignments to address insufficient storage capacity, if necessary.

## [10] - 2019-12-21

- Resolved an issue that would place sorted furniture a great distance from the home's entrance when the "Organize Furniture" option was disabled.
- Added a summary of the number of items that could not be stored due to a lack of capacity to the final sort report; these figures are broken down by Storage House as well as your inventory.

## [9] - 2019-12-18

- Resolved an issue that could cause sorting to fail whenever your character had stolen furnishings in their inventory.
- Split the details panel into two separate tabs: Storage Houses and Action Log.
- The Action Log now scrolls and shows up to the last 1,000 actions taken by Magic Sorter.
- Upon completion, Magic Sorter now shows the Action Log for your review.
- Renamed the "Stack Furniture" option to "Organize Furniture" for clarity.
- Further refined the organizational layout of stored items when the "Organize Furniture" option is enabled for additional compactness.

## [8] - 2019-12-12

- Resolved an error that would appear when leaving a house.
- Resolved an error that would appear when attempting to sort from outside one of your own homes.
- Resolved an issue that could prevent a storage house with no assigned categories from being visited for the removal of items destined for other homes.
- Added a "Stack Furniture" option to the Storage Wizard that will automatically layout stored items neatly; disable this option to leave already stored items undisturbed.
- Added the number of Traditional and Special Furnishing slots available to the list of storage homes on the detail panel.
- Added tool tips, to the list of storage homes on the detail panel, that list the category(ies) assigned to each home.
- Updated the "Stack Furniture" option to organize furniture into tiered, fanned and more presentable stacks that are sized more appropriately for the size of the home.
- Storage will automatically suspend operation upon receiving an Activity Finder ready check or when entering a Battleground or an Alliance War campaign.
- Magic Sorter will no longer stack items on top of your character in some homes if you disable the "Stack Furniture" option.
- Further optimized the storage algorithm.

## [4] - 2019-12-11

- Renamed to Magic Sorter: Furniture Storage Automation for clarification of the purpose of this addon.
- Sorting now requires at least 1 available inventory slot when starting; please don't actually try to sort with only 1 available inventory slot.
- Sorting now initially visits each storage home at least once to assess the available storage capacity.
- Sorting will no longer stop functioning properly if your inventory becomes nearly full with items that cannot be placed in another storage home.
- The five most recent actions (placements, removals, house jumps) will now show just below the detail panel while sorting.
- Removed the non-functional "Furniture, All" category.
- Further optimized the storage algorithm.
- Minor user interface adjustments.

## [3] - 2019-12-09

- Updated to prefer the placement of smaller stacks of items in order to free inventory space more quickly.
- Updated to prefer the removal of larger stacks of the same item type in order to use inventory space more efficiently.
- Reaching the Special Furnishing limit will no longer prevent additional Traditional Furnishings from being stored in the home.
- The "Resume" button will now work properly.
- Minor user interface adjustments.

## [2] - 2019-12-08

- Added detail panel to Magic Sorter status window that lists each storage houses' name and the number of remaining outbound and inbound items.
- Your character will now automatically jump to the home's entry when starting Magic Sorter.
- Your furnishings will be placed slightly further back into the home to avoid placing larger items in a manner that overlaps the home's entry point.

## [1] - 2019-12-07

- First release.
