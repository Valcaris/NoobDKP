

local roster_index = 1
local roster_type = 0 -- 0 = guild, 1 = raid

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
            print(NoobDKP_color .. syntax)
        else
            NoobDKP_AddRoster(args)
        end
    elseif cmd == "remove" then
        if args == "" then
            print("No character found to remove!")
            print(NoobDKP_color .. syntax)
        else
            NoobDKP_RemoveRoster(args)
        end
    elseif cmd == "alt" then
        if args == "" then
            print("No characters found to set alt!")
            print(NoobDKP_color .. syntax)
        else
            NoobDKP_AltRoster(args)
        end
    elseif cmd == "set" then
        if args == "" then
            print("No values found for set!")
            print(NoobDKP_color .. syntax)
        else
            NoobDKP_SetRoster(args)
        end
    else
        print(NoobDKP_color .. syntax)
    end
end

-- scans the guild for members and adds them to NOOBDKP_g_roster variable
function NoobDKP_ScanRoster()
    SetGuildRosterShowOffline(true)
    local a = GetNumGuildMembers()
    print(NoobDKP_color .. "NoobDKP Guild scan found " .. a .. " members")

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

    SetGuildRosterShowOffline(false)
    NoobDKP_UpdateRoster()
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
    NoobDKP_ScanRoster()
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

function NoobDKP_VerticalScroll(self, offset)
    roster_index = roster_index + offset
    local tableSize = getTableSize(NOOBDKP_g_roster)

    if roster_index > (tableSize - 14) then
        roster_index = tableSize - 14
    end

    if roster_index < 1 then
        roster_index = 1
    end
    NoobDKP_UpdateRoster()
end

function NoobDKP_UpdateRaidRoster()
  NOOBDKP_g_raid_roster = {}

  for idx = 1, 40 do
    local name, _, _, _, class = GetRaidRosterInfo(idx);
    local score, ep, gp 

    if name ~= nil and class ~= nil then
      if NOOBDKP_g_roster[name] == nil then
        NOOBDKP_g_roster[name] = {"*external*", class, ""}
        ep = 0
        gp = 0
        score = 100
      else
        NOOBDKP_g_roster[name][2] = class
        score, ep, gp = NoobDKP_ParseOfficerNote(NOOBDKP_g_roster[name][3])
      end

      NOOBDKP_g_raid_roster[name] = { class, score, ep, gp }
    end
  end

  roster_type = 1
  roster_index = 1
  NoobDKP_UpdateRoster();
end

function NoobDKP_UpdateGuildRoster()
  roster_type = 0
  roster_index = 1
  NoobDKP_UpdateRoster();
end

function NoobDKP_UpdateRoster()
    local i = 1 -- index into the table
    local pos = 1 -- index into the frame list
    local nameFrame, rankFrame, scoreFrame, EPFrame, GPFrame
    local whichRoster

    if(roster_type == 0) then
      whichRoster = NOOBDKP_g_roster
    else
      whichRoster = NOOBDKP_g_raid_roster
      if NOOBDKP_g_raid_roster == nil then
        NOOBDKP_g_raid_roster = {}
      end
    end

    for key, value in pairs(whichRoster) do
        if i >= roster_index then
            nameFrame = getglobal("myTabPage1_entry" .. pos .. "_name")
            nameFrame:SetText(key)
            local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[key][2])
            nameFrame:SetVertexColor(r, g, b, a)
            rankFrame = getglobal("myTabPage1_entry" .. pos .. "_rank")
            rankFrame:SetText(value[1])
            local score, ep, gp = NoobDKP_ParseOfficerNote(NOOBDKP_g_roster[key][3])
            scoreFrame = getglobal("myTabPage1_entry" .. pos .. "_score")
            scoreFrame:SetText(score)
            EPFrame = getglobal("myTabPage1_entry" .. pos .. "_EP")
            EPFrame:SetText(ep)
            GPFrame = getglobal("myTabPage1_entry" .. pos .. "_GP")
            GPFrame:SetText(gp)
            pos = pos + 1
            if pos > 15 then
                break
            end
        end
        i = i + 1
    end

    if pos <= 15 then
        for j = pos, 15 do
            nameFrame = getglobal("myTabPage1_entry" .. j .. "_name")
            nameFrame:SetText("")
            rankFrame = getglobal("myTabPage1_entry" .. j .. "_rank")
            rankFrame:SetText("")
            scoreFrame = getglobal("myTabPage1_entry" .. j .. "_score")
            scoreFrame:SetText("")
            EPFrame = getglobal("myTabPage1_entry" .. j .. "_EP")
            EPFrame:SetText("")
            GPFrame = getglobal("myTabPage1_entry" .. j .. "_GP")
            GPFrame:SetText("")
        end
    end
end