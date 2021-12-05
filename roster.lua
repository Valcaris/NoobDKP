
local noobcolor = "|cfff0ba3c"

--[[
    TODO list
    - Roster Tab
        - Roster can be guild or raid (need checkboxes to toggle)
        - Link Roster List to Roster Data
        - Scrolling Roster List
        - Right-Click Context menu on List buttons
            - @see Roster functions
    - Events Tab
    - Auctions Tab
    - Reports Tab
    - Sync Tab
    - Options Tab
    - Communications
        - Member requests for information
        - Detect member rolls
]]


-- handler for /noob member
function NoobDKPHandleRoster(msg)
    local syntax = "roster\n-scan: scans the guild and adds members to roster\n-add [name]: adds a character name as an external\n-remove [name]: removes a character name from the roster (for externals)\n-alt [nameA] [nameB]: sets nameA as an alt of nameB\n-set [name] [Net] [Total]: Sets the values of name to Net value and Total value"
    print("Handle Roster: " .. msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if cmd == "scan" then
        NoobDKP_ScanRoster()
    elseif cmd == "add" then
        if args == "" then
            print("No character found to add!")
            print(noobcolor .. syntax)
        else
            NoobDKP_AddRoster(args)
        end
    elseif cmd == "remove" then
        if args == "" then
            print("No character found to remove!")
            print(noobcolor .. syntax)
        else
            NoobDKP_RemoveRoster(args)
        end
    elseif cmd == "alt" then
        if args == "" then
            print("No characters found to set alt!")
            print(noobcolor .. syntax)
        else
            NoobDKP_AltRoster(args)
        end
    elseif cmd == "set" then
        if args == "" then
            print("No values found for set!")
            print(noobcolor .. syntax)
        else
            NoobDKP_SetRoster(args)
        end
    else
        print(noobcolor .. syntax)
    end
end

-- scans the guild for members and adds them to NOOBDKP_g_roster variable
function NoobDKP_ScanRoster()
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
function NoobDKP_AltRoster(args)
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

function NoobDKP_SetRoster(args)
    print("Set values: " .. args)
    local _, _, char, net, total = string.find(args, "%s?(%w+)%s?(-?%d+)%s?(-?%d+)")
    print("Char: " .. char .. ", Net: " .. net .. ", Total: " .. total)

    local main = NOOBDKP_find_main(char)
    if main ~= "" then
        print("Found main of " .. char .. " is " .. main .. ". Setting values...")
        NOOBDKP_g_roster[main][3] = "N:" .. net .. " T:" .. total
    else
        print("Can't find main of " .. char)
    end
end

function NoobDKP_ScanOnClick()
    print("Scan On Click!")
    local i = 1
    local nameFrame, priorityFrame, scoreFrame, EPFrame, GPFrame
    for key, value in pairs(NOOBDKP_g_roster) do
        nameFrame = getglobal("myTabPage1_entry" .. i .. "_name")
        nameFrame:SetText(key)
        i = i + 1
    end
end

function NoobDKP_RosterItemOnClick(self)
    print("Bob Loblaw " .. self:GetName())
    local nameFrame = getglobal(self:GetName() .. "_name")
    nameFrame:SetText("bob")
end

function NoobDKP_SortbyName(self)
    print("Sort by Name...")
end

function NoobDKP_SortbyRank(self)
    print("Sort by Rank...")
end

function NoobDKP_SortbyScore(self)
    print("Sort by Score...")
end

function NoobDKP_SortbyEP(self)
    print("Sort by EP...")
end

function NoobDKP_SortbyGP(self)
    print("Sort by GP...")
end