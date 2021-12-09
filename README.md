# NoobDKP
DKP/EPGP Addon for &lt;The Noob Guild>

## Overview
This addon was created to help manage the loot system of &lt;The Noob Guild>. I looked at EPGP_Lootmaster, but it wouldn't work for me out of the box and just didn't feel like it did what I wanted to. QDKP was closer, but it's more geared for DKP rather than EPGP. I tried it in a raid, and it had several issues such as not telling people what their final score was and not letting people with more GP than EP bid.

This addon has the following tabs:
- Roster
  - This shows the characters that the addon knows about. A guild view and raid view are available. The raid view will update as characters enter and leave the raid. The guild view attempts to synchronize its values with your guild's Officer Notes. Characters not in your guild are held internally (see Syncing below).
- Events
  - This holds the history of what the addon recorded during events (raids) starting with the currently active raid, if any.
  - This allows a user to add EP to the currently active raid
- Auction
  - This shows when an item is being bid for as well as everyone who has indicated that they want the item, sorted by need/greed, then by score.
  - This allows a user to add GP to the bid winner.
- Reports
  - This prints various reports to text which can then be copy-pasted to wherever the user wishes in case they need to maintain an offline backup/audit of all looting activities.
- Sync
  - This manages various ways in which this addon communicates with the game and other users of the addon
  - A list of all detected users of NoobDKP and their version is displayed
  - Functions are available to send/receive data (mostly external characters and event logs)
- Options
  - Allows access to the various configurable variables.

# Slash Commands
Type "/noob" at the WoW chat to see the latest commands and their options

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