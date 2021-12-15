

local roster_index = 1
local roster_type = 1  -- 0 = guild, 1 = raid, 2 = main
local sort_type = 0 -- 0 = name, 1 = rank, 2 = score, 3 = ep, 4 = gp
local sort_order = 0 -- 0 = incrementing, 1 = decrementing

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
            NOOBDKP_g_roster[name] = {rank, class, note}
        j = j + 1
    end

    SetGuildRosterShowOffline(false)
    NoobDKP_UpdateRoster()
end

-- add a character to the roster as an external
function NoobDKP_AddRoster(name)
  name = NoobDKP_FixName(name)
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
  name = NoobDKP_FixName(name)
    print("Removing member: " .. name)
    NOOBDKP_g_roster[name] = nil
end

-- set a character as an alt of another character
function NoobDKP_AltRoster(args)
    local _, _, alt, main = string.find(args, "%s?(%w+)%s?(.*)")
    alt = NoobDKP_FixName(alt)
    main = NoobDKP_FixName(main)
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
    local _, _, char, net, total = string.find(args, "%s?(%w+)%s?(-?%d+)%s?(-?%d+)")
    char = NoobDKP_FixName(char)
    print("Char: " .. char .. ", Net: " .. net .. ", Total: " .. total)

    local main = NOOBDKP_find_main(char)
    if main ~= "" then
        print("Found main of " .. char .. " is " .. main .. ". Setting values...")
        NOOBDKP_g_roster[main][3] = "N:" .. net .. " T:" .. total
    else
        print("Can't find main of " .. char)
    end
end

function NoobDKP_RosterItemOnClick(self)
    print("Bob Loblaw " .. self:GetName())
    local nameFrame = getglobal(self:GetName() .. "_name")
    nameFrame:SetText("bob")
end

function NoobDKP_SortBy(type)
  if sort_type == type then
    if sort_order == 0 then
      sort_order = 1
    else
      sort_order = 0
    end
  else
    sort_order = 0
    sort_type = type
  end
  NoobDKP_UpdateRoster()
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
    local name, _, _, _, class = GetRaidRosterInfo(idx)
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

      NOOBDKP_g_raid_roster[name] = { "", score, ep, gp }
    end
  end

  roster_type = 1
  roster_index = 1
  NoobDKP_UpdateRoster()
end

function NoobDKP_UpdateGuildRoster()
  roster_type = 0
  roster_index = 1
  NoobDKP_UpdateRoster();
end

function NoobDKP_UpdateMainRoster()
  roster_type = 2
  roster_index = 1
  NoobDKP_UpdateRoster();
end

function NoobDKP_NameSort(a, b)
  if sort_order == 0 then
    return a[1] < b[1]
  else
    return a[1] > b[1]
  end
end

function NoobDKP_RankSort(a, b)
  if sort_order == 0 then
    return a[6] < b[6]
  else
    return a[6] > b[6]
  end
end

function NoobDKP_ScoreSort(a, b)
  if sort_order == 0 then
    return tonumber(a[7]) < tonumber(b[7])
  else
    return tonumber(a[7]) > tonumber(b[7])
  end
end

function NoobDKP_EPSort(a, b)
  if sort_order == 0 then
    return tonumber(a[8]) < tonumber(b[8])
  else
    return tonumber(a[8]) > tonumber(b[8])
  end
end

function NoobDKP_GPSort(a, b)
  if sort_order == 0 then
    return tonumber(a[9]) < tonumber(b[9])
  else
    return tonumber(a[9]) > tonumber(b[9])
  end
end

function NoobDKP_UpdateRoster()
    local nameFrame, rankFrame, scoreFrame, EPFrame, GPFrame
    local whichRoster
    local sorted = {}

    if roster_type == 0 then
      whichRoster = NOOBDKP_g_roster
    elseif roster_type == 1 then
      whichRoster = NOOBDKP_g_raid_roster
      if NOOBDKP_g_raid_roster == nil then
        NOOBDKP_g_raid_roster = {}
      end
    else
      whichRoster = NOOBDKP_g_roster
    end

    for key, value in pairs(whichRoster) do
          local nameText = key
          local skip = false
          if NOOBDKP_g_roster[NOOBDKP_g_roster[key][3] ] ~= nil then
            if roster_type == 2 then
              skip = true
            else
              nameText = nameText .. " (" .. NOOBDKP_g_roster[key][3] .. ")"
            end
          end
          
          if skip == false then
            local rank = value[1]
            local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[key][2])
            local score, ep, gp = NoobDKP_ParseOfficerNote(NOOBDKP_g_roster[key][3])
            local t = {nameText, r, g, b, a, rank, score, ep, gp}
            table.insert(sorted, t)
          end
    end

    if sort_type == 0 then
      table.sort(sorted, NoobDKP_NameSort)
    elseif sort_type == 1 then
      table.sort(sorted, NoobDKP_RankSort)
    elseif sort_type == 2 then
      table.sort(sorted, NoobDKP_ScoreSort)
    elseif sort_type == 3 then
      table.sort(sorted, NoobDKP_EPSort)
    elseif sort_type == 4 then
      table.sort(sorted, NoobDKP_GPSort)
    end

    local i = 1 -- index into the table
    local pos = 1 -- index into the frame list
    for key, value in ipairs(sorted) do
      if i >= roster_index then
        nameFrame = getglobal("myTabPage1_entry" .. pos .. "_name")
        nameFrame:SetText(value[1])
        nameFrame:SetVertexColor(value[2], value[3], value[4], value[5])
        rankFrame = getglobal("myTabPage1_entry" .. pos .. "_rank")
        rankFrame:SetText(value[6])
        scoreFrame = getglobal("myTabPage1_entry" .. pos .. "_score")
        scoreFrame:SetText(value[7])
        EPFrame = getglobal("myTabPage1_entry" .. pos .. "_EP")
        EPFrame:SetText(value[8])
        GPFrame = getglobal("myTabPage1_entry" .. pos .. "_GP")
        GPFrame:SetText(value[9])
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

function NoobDKP_AuditRoster()
  -- check that all guild characters are still in the guild
  SetGuildRosterShowOffline(true)
  local a = GetNumGuildMembers()
  local tempTable = {}

  for i = 1, a do
    local name = GetGuildRosterInfo(i)
    tempTable[name] = 1
  end

  for key, value in pairs(NOOBDKP_g_roster) do
    if value[1] ~= "*external*" then
      if tempTable[key] ~= 1 then
        print("Found " .. key .. " left the guild!")
        NOOBDKP_g_roster[key][1] = "*external*"
      end
    end
  end

  -- find characters whose main left the guild
  for key, value in pairs(NOOBDKP_g_roster) do
    local main = NOOBDKP_find_main(key)
    if main == "" or main == nil then
      print("Found " .. key .. "'s main left the guild!")
      NOOBDKP_g_roster[key][3] = ""
    end
  end

  -- remove all characters with 0 EP
  for key, value in pairs(NOOBDKP_g_roster) do
    local score, ep, gp = NoobDKP_ParseOfficerNote(value[3])
    if ep == 0 or ep == "0" then
      print("Found " .. key .. " has no EP, removing!")
      NOOBDKP_g_roster[key] = nil
    end
  end

  SetGuildRosterShowOffline(false)
  NoobDKP_UpdateRoster()

end

function NoobDKP_PushRoster()
  if NOOBDKP_g_roster == nil or CanEditOfficerNote() == false then
    return ""
  end

  SetGuildRosterShowOffline(true)
  local a = GetNumGuildMembers()

  for i = 1, a do
      local name = GetGuildRosterInfo(i)
      if NOOBDKP_g_roster[name] ~= nil then
        GuildRosterSetOfficerNote(i, NOOBDKP_g_roster[name][3])
      end
  end

  SetGuildRosterShowOffline(false)
end