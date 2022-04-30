--[[
    TODO list
    - ** initial add to empty roster not working on first time setup!
    - function wrapper to all uses of option table entries
    - Roster Tab
        - Give sort headers a background that is used on mouseover
        - Last update timestamp
    - Events Tab
        - Add color to event listings
        - sync event sends raid roster values to raid for syncing
        - add indicators when events scroll off the page up or down
        - *allow editing of event entry roster
        - *when virtual event, repopulate raid roster from event entry roster
        - **when creating event with nil name, create a default name
    - Auctions Tab
        - Add countdown to window when auction started, possibly broadcast to raid (with checkbox)
        - Option to have Declare Winner set GP and close auction all at once (or have separate actions)
        - trim need/greed of whitespace
        - * auto-detect for Rotface/Festergut bloods
    - Reports Tab
    - Sync Tab
        - Show who else has addon and what version
        - Permissions based on guild rank for who can set what
        - Sync Externals (guildies are just in notes)
        - Master arbitration
    - Options Tab
          - Various widgets for the options, may need mulitple pages or scrolling page
    - Communications
    - Minimap Icon
    - TitanBars Icon
    - README.md, code documentation comments, general cleanup, QDKP acknowledgement
    - Conversion from QDKP T:x N:y to own custom notes E:x G:y
]]
local noobversion = GetAddOnMetadata("NoobDKP", "Version")

print(NoobDKP_color .. "NoobDKP v" .. noobversion)

local function NoobDKPAddonCommands(msg, editbox)
  -- handle nil tables
  if NOOBDKP_g_roster == nil then
    NOOBDKP_g_roster = {}
  end
  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end
  if NOOBDKP_g_raid_roster == nil then
    NOOBDKP_g_raid_roster = {}
  end

  local syntax =
    "NoobDKP Syntax\n-help: This text\n-version\n-roster add | remove | alt | scan | set\n-event open | remove | award | loot\n-options\n-sync\n-report guild | event | member\n-value add | set\n-auction create | cancel | finish | bid"
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

  if cmd == "version" then
    -- prints the current addon's version
    print(NoobDKP_color .. "NoobDKP Version: " .. noobversion)
  elseif cmd == "roster" then
    -- member roster manipulation
    NoobDKPHandleRoster(args)
  elseif cmd == "event" then
    -- event manipulation
    NoobDKPHandleEvents(args)
  elseif cmd == "options" then
    -- options dialog
    print(NoobDKP_color .. "Options")
  elseif cmd == "sync" then
    -- attempts to sync this data with other found addons
    print(NoobDKP_color .. "Sync")
  elseif cmd == "report" and args ~= "" then
    -- creates various reports
    print(NoobDKP_color .. "Report, args: " .. args)
  elseif cmd == "value" and args ~= "" then
    -- manipulates EPGP values directly
    print(NoobDKP_color .. "Values, args: " .. args)
  elseif cmd == "auction" and args ~= "" then
    -- manipulates auctions directoy
    NoobDKPHandleAuction(args)
  elseif cmd == "show" then
    -- shows the NoobDKP panel
    noobMainFrame:Show()
  elseif cmd == "hide" then
    -- hides the NoobDKP panel
    noobMainFrame:Hide()
  else
    -- prints the help syntax to the user
    print(NoobDKP_color .. syntax)
  end
end

function NoobDKP_OnEvent(self, event, ...)
  -- handle raid chat messages
  if event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
    local text, playerName = ...
    NoobDKP_ParseChat(text, playerName)
  -- handle whispers
  elseif event == "CHAT_MSG_WHISPER" then
    local text, playerName = ...
    if text == "noob help" then
      NoobDKP_HelpReply(playerName)
    elseif text == "noob" then
      NoobDKP_QueryReply(playerName)
    end
  -- handle changes in the raid roster
  elseif event == "RAID_ROSTER_UPDATE" then
    if NOOBDKP_g_events["virtual"] ~= true then
      NoobDKP_UpdateRaidRoster()
    end
  -- handle unit deaths (to detect boss kills)
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local _, subEvent, _, _, _, _, name = ...
    NoobDKP_CombatLog(subEvent, name)
  elseif event == "ADDON_LOADED" then
    NoobDKP_UpdateRaidRoster()
  elseif event == "CHAT_MSG_MONSTER_YELL" then
    local text, name = ...
    NoobDKP_HandleMonsterYell(text, name)
  end
end

function NoobDKP_ParseChat(text, playerName)
  -- admins listen to need/greed, non-admins listen to the admin respons
  if NOOBDKP_g_options["admin_mode"] then
    -- pass will remove character from bidding (if they bid)
    if text == "pass" then
      NoobDKP_HandleAddBid(playerName, text)
      NoobDKP_HandleAuctionResponse("bid_pass", playerName)
      NoobDKP_HandleUpdateAuction()
    -- need or greed will add character to bidding
    elseif text == "need" or text == "greed" then
      NoobDKP_HandleAddBid(playerName, text)
      NoobDKP_HandleUpdateAuction()
      local score, ep, gp = NoobDKP_GetEPGP(playerName)
      NoobDKP_HandleAuctionResponse("bid", playerName, text, score, ep, gp)
    end
  else
    -- if not admin, just listen to the admin to keep updated
    local _, _, cmd = string.find(text, "NoobDKP: (%w+)(.*)")
    -- handle a new bid
    if cmd == "Bid" then
      local _, _, char, val, score, ep, gp =
        string.find(text, "NoobDKP: Bid (%w+) (%w+) for (%d+) accepted (%d+)/(%d+)")
      NoobDKP_SetEPGP(char, ep, gp)
      NoobDKP_UpdateRoster()
      local score = NoobDKP_calculateScore(ep, gp)
      NOOBDKP_g_auction[char] = {}
      NOOBDKP_g_auction[char]["_score"] = score
      NOOBDKP_g_auction[char]["_type"] = val
      NoobDKP_HandleUpdateAuction()
    -- handle removing a bid
    elseif cmd == "Pass" then
      local _, _, char =
        string.find(text, "NoobDKP: Pass (%w+) is passing this roll")
      NOOBDKP_g_auction[char] = {}
      NoobDKP_HandleUpdateAuction()
    -- handle a new auction
    elseif cmd == "Auction" then
      local _, _, item = string.find(text, "NoobDKP: Auction starting for item (.*)")
      NoobDKP_ShiftClickItem(item)
    -- handle GP being added
    elseif cmd == "GP" then
      local _, _, gp, char = string.find(text, "NoobDKP: GP (-?%d+) to (%w+)")
      local main = NOOBDKP_find_main(char)
      local ep = NOOBDKP_g_raid_roster[char][3]
      local oldgp = NOOBDKP_g_raid_roster[char][4]
      local newgp = oldgp + gp
      NoobDKP_SetEPGP(main, ep, newgp)
      NoobDKP_UpdateRoster()
      NoobDKP_HandleUpdateAuction()
    elseif cmd == "EP" then
      print(NoobDKP_color .. "EP event detected!")
      local _, _, ep, reason = string.find(text, "NoobDKP: EP Adding (-?%d+) EP to the raid for (.*)")
      print(NoobDKP_color .. "EP event results: " .. ep .. " reasons: " .. reason)
      getglobal("noobDKP_page2_amount"):SetText(ep)
      getglobal("noobDKP_page2_reason"):SetText(reason)
      NoobDKP_AddRaidEP()
    end
  end
end

SLASH_NOOBDKP1 = "/noob"
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands
