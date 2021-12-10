--[[
    TODO list
    - Roster Tab
        - Guild vs Raid checkbox
        - Right-Click Context menu on List buttons
            - @see Roster functions
        - Give sort headers a background that is used on mouseover
        - Figure out proper mouse wheel scrolling
        - Default view to raid roster?
        - slash command to directly set EP or GP
        - Last update timestamp
        - **Send local values back to guild notes
        - Rank shows class
        - Refresh raid view (to force people in/out of raid)
    - Events Tab
        - Current Raid description, action list
        - List of raids in history
        - Detect people in the raid (and when they leave the raid)
    - Auctions Tab
        - Detect Loot Window, queue up auctions?
        - Set GP according to Loot detection
        - Add countdown to window when auction started, possibly broadcast to raid (with checkbox)
        - Option to have Declare Winner set GP and close auction all at once (or have separate actions)
        - trim need/greed of whitespace
    - Reports Tab
    - Sync Tab
        - Show who else has addon and what version
        - Permissions based on guild rank for who can set what
        - Auction and Event updates in real time
        - Sync Externals (guildies are just in notes)
    - Options Tab
          - Make Options table in SavedVariables
          - Various widgets for the options, may need mulitple pages or scrolling page
    - Communications
    - Minimap Icon
    - TitanBars Icon
    - README.md, code documentation comments, general cleanup, QDKP acknowledgement
    - Conversion from QDKP T:x N:y to own custom notes E:x G:y

    <OnMouseDown> if arg1 == "RightButton"
        elseif arg1 == "LeftButton"
        ...
    <OnEnterPressed>
    <OnLeave> for tooltips
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
        print("NoobDKP Version: " .. noobversion)
    elseif cmd == "roster" then
        -- member roster manipulation
        NoobDKPHandleRoster(args)
    elseif cmd == "event" then
        -- event manipulation
        NoobDKPHandleEvents(args)
    elseif cmd == "options" then
        -- options dialog
        print("Options")
    elseif cmd == "sync" then
        -- attempts to sync this data with other found addons
        print("Sync")
    elseif cmd == "report" and args ~= "" then
        -- creates various reports
        print("Report, args: " .. args)
    elseif cmd == "value" and args ~= "" then
        -- manipulates DKP values directly
        print("Values, args: " .. args)
    elseif cmd == "auction" and args ~= "" then
        NoobDKPHandleAuction(args)
    elseif cmd == "show" then
        noobMainFrame:Show();
    elseif cmd == "hide" then
      noobMainFrame:Hide();
      else
        -- prints the help syntax to the user
        print(NoobDKP_color .. syntax)
    end
end

function NoobDKP_OnEvent(self, event, ...)
  if event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
    local text, playerName = ...;
    if text == "need" or text == "greed" then 
      NoobDKP_BidAuction(playerName .. " " .. text)
    end
  elseif event == "CHAT_MSG_WHISPER" then
    local text, playerName = ...;
    if text == "noob" then
      NoobDKP_QueryReply(playerName)
    end
  elseif event == "RAID_ROSTER_UPDATE" then
    NoobDKP_UpdateRaidRoster()
  end
end

SLASH_NOOBDKP1 = "/noob"
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands
