--[[
    TODO list
    - ** initial add to empty roster not working on first time setup!
    - function wrapper to all uses of option table entries
    - Roster Tab
        - Give sort headers a background that is used on mouseover
        - Guild Scan should fix people in/out of the guild
        - Scan should fix class, EPGP, rank of roster
        - Should tolerate/fix spaces in officer notes
        - Should be able to remove alt status from char
        - When char enters raid, check to fix class
        - Clamp scrolling to end of list
    - Events Tab
        - Add color to event listings
        - add indicators when events scroll off the page up or down
        - *allow editing of event entry roster
        - *when virtual event, repopulate raid roster from event entry roster
        - right-click on container = rename event
    - Auctions Tab
        - Add countdown to window when auction started, possibly broadcast to raid (with checkbox)
        - trim need/greed of whitespace
        - * auto-detect for Rotface/Festergut bloods
    - Reports Tab
    - Sync Tab
        - Show/scan/advertise who else has addon and what version
        - Choose to pull EPGP or events (or both)
        - Permissions based on guild rank for who can set what
        - Sync Externals (guildies are just in notes)
        - sync event sends raid roster values to raid for syncing
        - Master arbitration
          - Only one echo in raid chat for bid and boss detection
        - Manual Push/Pull from others (show update timestamp)
        - Change Guild Scan to "Pull Guild Notes into Data"
    - Options Tab
          - Various widgets for the options, may need mulitple pages or scrolling page
          - Refactor Audit Guild Roster, find use for it (different than purge)
          - Move Add External to Roster tab
    - Communications
    - TitanBars Icon
    - README.md, code documentation comments, general cleanup, QDKP acknowledgement
    - Conversion from QDKP T:x N:y to own custom notes E:x G:y
]]

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
    NoobDKP_ToggleView()
  elseif cmd == "hide" then
    -- hides the NoobDKP panel
    NoobDKP_ToggleView()
  elseif cmd == "vi" then
    -- shortcut for roster virt
    NoobDKPVirtualAdd(msg)
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
    text = string.lower(text)
    if text == "noob help" then
      NoobDKP_HelpReply(playerName)
    elseif text == "noob" then
      NoobDKP_QueryReply(playerName)
    elseif text == "need" or text == "greed" or text == "pass" then
      NoobDKP_ParseChat(text, playerName)
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
    local addon = ...
    if addon == "NoobDKP" then
      -- refresh minimap data here. Otherwise tables aren't loaded yet
      minimap:Refresh("NoobDKP", NOOBDKP_g_minimap)
      NoobDKP_HandleSyncOnLoad()
      NoobDKP_UpdateRaidRoster()
    end
  elseif event == "CHAT_MSG_MONSTER_YELL" then
    local text, name = ...
    NoobDKP_HandleMonsterYell(text, name)
  elseif event == "CHAT_MSG_ADDON" then
    local prefix, text, _, sender = ...
    if prefix == "NoobDKP" then
      NoobDKP_HandleSyncMessage(sender, text)
    end
  end
end

function NoobDKP_ParseChat(text, playerName)
  -- admins listen to need/greed, non-admins listen to the admin respons
  if NOOBDKP_g_options["admin_mode"] then
    text = string.lower(text)
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

function NoobDKP_ToggleView()
  if noobMainFrame:IsShown() then
    noobMainFrame:Hide()
  else
    noobMainFrame:Show()
  end
end

-- minimap stuff
minimap = LibStub("LibDBIcon-1.0")

noobldb = LibStub("LibDataBroker-1.1"):NewDataObject("NoobDKP", {
  type = "data source",
  icon = "Interface\\AddOns\\NoobDKP\\TNG.blp",
  OnClick = function(clickedframe, button) NoobDKP_ToggleView() end,
  OnEnter = function(self) 
    local tooltip = getglobal("NoobDKP_tooltip")
    tooltip:SetOwner(self, "ANCHOR_LEFT");
    tooltip:ClearLines();
    tooltip:AddLine("NoobDKP v" .. noobversion);
    tooltip:AddLine("Click to toggle frame");
    tooltip:Show();
  end,
  OnLeave = function(self) 
    local tooltip = getglobal("NoobDKP_tooltip")
    tooltip:Hide();
  end,
})

minimap:Register("NoobDKP", noobldb, NOOBDKP_g_minimap)
-- note: register is done here, but the tables aren't fully loaded
-- at this point, so we refresh the table in the ADDON_LOADED event handler

-- slash command stuff
SLASH_NOOBDKP1 = "/noob"
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands
