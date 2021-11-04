
local noobversion = GetAddOnMetadata("NoobDKP", "Version")
print("NoobDKP v" .. noobversion)

local helpString = "NoobDKP Syntax\n-help: This text\n-version\n-member add | remove | alt | scan \n-event start | stop | load\n-options\n-sync\n-report guild | event | member\n-value add | set"

local function NoobDKPAddonCommands(msg, editbox)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if cmd == "version" then
        -- prints the current addon's version
        print("NoobDKP Version: " .. noobversion)
    elseif cmd == "member" and args ~= "" then
        -- member roster manipulation
        NoobDKPHandleMember(args)
--        print("Member, args: " .. args)
    elseif cmd == "event" and args ~= "" then
        -- event manipulation
        print("Event, args: " .. args)
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
    else
        -- prints the help syntax to the user
        print(helpString)
    end
end

SLASH_NOOBDKP1 = '/noob'
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands

--[[ local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");

local NoobDKP_Loaded = false;

function frame:OnEvent(event, arg1)
    if (event == "ADDON_LOADED" and arg1 == "NoobDKP") then
        NoobDKP_Loaded = true
    end
end
fame:SetScript("OnEvent", frame.OnEvent);
 ]]
function NoobDKPHandleMember(args)
    print("Handle Member, args: " .. args)
    --print("Is loaded: " .. NoobDKP_Loaded)
    --GetGuildInfo("player")
    NoobDKP_ScanGuild()
end

function NoobDKP_ScanGuild()
    SetGuildRosterShowOffline(true)
    local a = GetNumGuildMembers()
    print("Found " .. a .. " members")

   local t = {};
   local j = 0;
   for i = 1, a do
       local name, rank, _, _, class, _, _, note = GetGuildRosterInfo(i)
       t[name] = {rank, class, note}
       j = j + 1
   end

   print("Roster table size: " .. j)
   print("First 10 entries:")
   for k = 1, 10 do
        local name = GetGuildRosterInfo(k)
        local a = t[name][1]
        local b = t[name][2]
        local c = t[name][3]
        print(name .. ": " .. a .. " " .. b .. " " .. c)
   end

   SetGuildRosterShowOffline(false)
end