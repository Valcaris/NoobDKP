local noobversion = GetAddOnMetadata("NoobDKP", "Version")
local noobcolor = "|cfff0ba3c"
print(noobcolor .. "NoobDKP v" .. noobversion)

local function NoobDKPAddonCommands(msg, editbox)
    -- handle nil tables
    if NOOBDKP_g_roster == nil then
        NOOBDKP_g_roster = {}
    end
    if NOOBDKP_g_events == nil then
        NOOBDKP_g_events = {}
    end

    local syntax =
        "NoobDKP Syntax\n-help: This text\n-version\n-member add | remove | alt | scan \n-event open | remove | award | loot\n-options\n-sync\n-report guild | event | member\n-value add | set"
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if cmd == "version" then
        -- prints the current addon's version
        print("NoobDKP Version: " .. noobversion)
    elseif cmd == "member" then
        -- member roster manipulation
        NoobDKPHandleMember(args)
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
    else
        -- prints the help syntax to the user
        print("|cff0000ff" .. syntax)
    end
end

SLASH_NOOBDKP1 = "/noob"
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands

-- handler for /noob member
function NoobDKPHandleMember(msg)
    local syntax = "/noob member\n-scan: scans the guild and adds members to roster\n-add [name]: adds a character name as an external\n-remove [name]: removes a character name from the roster (for externals)\n-alt [nameA] [nameB]: sets nameA as an alt of nameB"
    print("Handle Member: " .. msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if cmd == "scan" then
        NoobDKP_ScanGuild()
    elseif cmd == "add" then
        if args == "" then
            print("No character found to add!")
            print("|cff0000ff" .. syntax)
        else
            NoobDKP_AddRoster(args)
        end
    elseif cmd == "remove" then
        if args == "" then
            print("No character found to remove!")
            print("|cff0000ff" .. syntax)
        else
            NoobDKP_RemoveRoster(args)
        end
    elseif cmd == "alt" then
        if args == "" then
            print("No characters found to set alt!")
            print("|cff0000ff" .. syntax)
        else
            NoobDKP_Alt(args)
        end
    else
        print("|cff0000ff" .. syntax)
    end
end

-- scans the guild for members and adds them to NOOBDKP_g_roster variable
function NoobDKP_ScanGuild()
    SetGuildRosterShowOffline(true)
    local a = GetNumGuildMembers()
    print("Found " .. a .. " members")

    if NOOBDKP_g_roster == nil then
        NOOBDKP_g_roster = {}
    end

    local j = 0
    for i = 1, a do
        local name, rank, _, _, class, _, _, note = GetGuildRosterInfo(i)
        if NOOBDKP_g_roster[name] ~= nil then
            NOOBDKP_g_roster[name] = {rank, class, note}
        end
        j = j + 1
    end

    print("Roster table size: " .. j)

    SetGuildRosterShowOffline(false)
end

-- -- prints the first ten members in the guild roster to console, for debugging
-- function NoobDKP_ShowRoster()
--     print("First 10 entries:")
--     for k = 1, 10 do
--         local name = GetGuildRosterInfo(k)
--         if name ~= nil and NOOBDKP_g_roster[name] ~= nil then
--             local a = NOOBDKP_g_roster[name][1]
--             local b = NOOBDKP_g_roster[name][2]
--             local c = NOOBDKP_g_roster[name][3]
--             print(name .. ": " .. a .. " " .. b .. " " .. c)
--         end
--     end
-- end

-- add a character to the roster as an external
function NoobDKP_AddRoster(name)
    print("Add member: " .. name)
    if NOOBDKP_g_roster[name] == nil then
        print("Not found! adding...")
        NOOBDKP_g_roster[name] = {"*external*", "unknown", ""}
    else
        print("Found! skipping...")
    end
end

-- remove a character from the roster (should only be used on externals)
function NoobDKP_RemoveRoster(name)
    print("Removing member: " .. name)
    NOOBDKP_g_roster[name] = nil
end

-- set a character as an alt of another character
function NoobDKP_Alt(args)
    print("Set alt: " .. args)
    local _, _, alt, main = string.find(args, "%s?(%w+)%s?(.*)")
    print("Alt: " .. alt .. ", Main: " .. main)
    if NOOBDKP_g_roster[alt] == nil then
        print("Unable to find alt: " .. alt)
    elseif NOOBDKP_g_roster[main] == nil then
        print("Unable to find main: " .. main)
    else
        NOOBDKP_g_roster[alt][3] = main
    end
end

function NoobDKPHandleEvents(msg)
    print("Handle Events: " .. msg)
    local syntax = "/noob event\n-open [description][timestamp]: opens an event/raid by the name of description created at timestamp. Creates new if not found. Timestamp defaults to now if creating. Find first raid if no timestamp and multiple same descriptions are found.\n-remove [description]: deletes an event/raid with the name description\n-award [dkp]([description]): applies an award of dkp to the raid (can be negative) with an optional description\n-loot [name][dkp]([description]): applies dkp (can be negative) to name with an optional description (can be an item ID)"

    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if cmd == "open" then
        if args == "" then
            print("No description found!")
        else
            NoobDKP_OpenEvent(args)
        end
    elseif cmd == "remove" and args ~= "" then
        NoobDKP_RemoveEvent(args)
    elseif cmd == "award" and args ~= "" then
        NoobDKP_AwardEvent(args)
    elseif cmd == "loot" and args ~= "" then
        NoobDKP_LootEvent(args)
    else
        print("|cff0000ff" .. syntax)
    end
end

function NoobDKP_OpenEvent(msg)
    local _, _, desc = string.find(msg, "%s?(%w+)%s?(.*)")
    print("Open Event: " .. desc)
    -- if NOOBDKP_g_events[desc] == nil then
        -- NOOBDKP_g_events[desc] = {}
    -- end
end

function NoobDKP_RemoveEvent(msg)
end

function NoobDKP_AwardEvent(msg)
end

function NoobDKP_LootEvent(msg)
end
