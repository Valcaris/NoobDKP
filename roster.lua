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