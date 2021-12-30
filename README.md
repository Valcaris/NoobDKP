# NoobDKP
DKP/EPGP Addon for &lt;The Noob Guild>

## Overview
This addon was created to help manage the loot system of &lt;The Noob Guild>. I looked at EPGP_Lootmaster, but it wouldn't work for me out of the box and just didn't feel like it did what I wanted to. QDKP was closer, but it's more geared for DKP rather than EPGP. I tried it in a raid, and it had several issues such as not telling people what their final score was and not letting people with more GP than EP bid.

This addon has the following tabs:
- Roster
  - This shows the character information. The view defaults to charcters in the current raid, if any. The Guild view shows everyone in your guild. The main view is the same as guild, but all alts are removed.
    - Characters that join the raid, but aren't found in the last scan of the guild roster will be marked as "*external*"
    - The roster will attempt to update its information as people bid on items since the master looter will call out all of their information as a part of accepting their bid.
- Events
  - This holds the history of what the addon recorded during events (raids) starting with the currently active raid, if any.
  - This allows a user to add EP to the currently active raid
- Auction
  - This shows when an item is being bid for as well as everyone who has indicated that they want the item, sorted by need/greed, then by score.
  - If an item is found in the internal loot table and has a need an/or greed description, those descriptions will be sent to the raid during the auction.
  - The "Declare Winner" button detects the highest need score (or greed score if no needs). Ties are automatically resolved with a /roll.
  - The "DQ" column is for disqualifying a character from an auction (if someone rolls on something they can't use for example). It is only valid for that auction and is reset on every auction.
  - This allows a user to add GP to the bid winner.
- Reports
  - This prints various reports to text which can then be copy-pasted to wherever the user wishes in case they need to maintain an offline backup/audit of all looting activities.
    - The Full Report has everyone's values including mains and alts
    - The Brief Report only shows main characters that aren't at 0 EP and 0 GP
    - The Alt Report shows all main characters followed by their alts, no EPGP values are given.
- Sync
  - This manages various ways in which this addon communicates with the game and other users of the addon
  - A list of all detected users of NoobDKP and their version is displayed
  - Functions are available to send/receive data (mostly external characters and event logs)
- Options
  - Allows access to the various configurable variables.
  - The Guild Scan will add guild members which are not in your local roster and will update all EPGP values according to the officer notes
  - The Audit Roster will remove people who are no longer in your guild
  - The Add External will add the given character as an external (non-guild) character
  - Admin mode is for Raid Leaders and Loot Masters. It determines if the addon will talk to the raid when an auction is underway. Only one person in a raid should have this enabled, otherwise the addon can talk back and forth a lot.
  - Populate Loot Table sends items that are shift-clicked into the internal loot table. No need/greed information is added. At this time, need/greed informaiton must be entered manually into the saved variables NoobDKP.lua file.
  - Decay percent is the percentage of EPGP decay that can be applied (should be 1-100). Click the "Run Decay Now" to apply the decay to everyone on the roster.

# Slash Commands
Type "/noob" at the WoW chat to see the latest commands and their options
- Use "/noob show" to show the window if it is closed.

# Use Cases
This is a run-through of how a typical user is expected to use NoobDKP

## Raid Forms
- A raid forms. The addon detects people as they join
  - New characters or characters not in the guild join
  - A person comes on a new/previously unknown alt

## Boss Kill
- A boss is defeated. EP is automatically added to all characters currently in the raid.
- Modifiers are needed to the default EP

## Loot Drop
- An Item drops. An auction is started announcing to the raid what the item is.
- GP is automatically calculated for the item
- Modifiers are needed to the default GP
- Various characters declare "need" or "greed"
  - Characters under the minimum EP are forced to "greed" bids
  - Characters change their bid between need and greed
  - Multiple characters have top the score
- A character in the raid wishes to know what their current score is and where they are in the auction list
- A winner is declared based on their EPGP score (with the addon performing an internal roll for tie breakers).
- The winner receives the item. GP appropriate for the loot is added to the winner.
- The auction is closed.

## End-of-Raid Report
- The user reviews everything that happened during the raid
- A report is generated and saved off to the guild website or Discord server so that everyone knows what happened

## Syncing
- A new user wishes to download all EPGP information so that they can see where they are at in the loot list
- An officer wishes to download the latest event report, EPGP changes, and any new external characters
- A user wishes to see scores while an auction is going on (and where they are relative to everyone else)

## Maintenance
- Members contribute to the gbank and are awarded EP (or are awarded EP for other reasons)
- Errors were discovered which need EP or GP corrections
- Logs need to be modified to add/remove/modify entries
  - The wrong person received loot
  - The wrong EP or GP was applied or missed
- Members declare alt characters or wish to switch main characters
- Characters not in the guild wish to be added to the EPGP system
- EP and/or GP decay occurs every few weeks/months
- EP values are rebalanced for boss kills
- GP values are rebalanced for loot