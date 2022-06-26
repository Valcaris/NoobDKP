local roster_index = 1
local roster_type = 1 -- 0 = guild, 1 = raid, 2 = main
local sort_type = 0 -- 0 = name, 1 = rank, 2 = score, 3 = ep, 4 = gp
local sort_order = 0 -- 0 = incrementing, 1 = decrementing

if NOOBDKP_g_roster == nil then
  NOOBDKP_g_roster = {}
end

function NoobDKPVirtualAdd(msg)
  local _, _, cmd, args =  string.find(msg, "%s?(%w+)%s?(.*)")
  args = NoobDKP_FixName(args)
  if NOOBDKP_g_roster[args] == nil then
    print(NoobDKP_color .. "Could not find char: " .. args)
  else
    getglobal("roster_menu_name"):SetText(args)
    NoobDKP_RosterContextAddVirtual()
    NoobDKP_UpdateRoster()
    print(NoobDKP_color .. "Added to virtual raid: " .. args)
  end
end

-- handler for /noob member
function NoobDKPHandleRoster(msg)
  local syntax =
    "roster\n-scan: scans the guild and adds members to roster\n-add [name]: adds a character name as an external\n-remove [name]: removes a character name from the roster (for externals)\n-alt [nameA] [nameB]: sets nameA as an alt of nameB\n-set [name] [Net] [Total]: Sets the values of name to Net value and Total value\n-epgp [name] [ep] [gp]"
  print(NoobDKP_color .. "Handle Roster: " .. msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "scan" then
    -- performs a roster scan
    NoobDKP_ScanRoster()
  elseif cmd == "virt" then
    -- adds a member to a virtual raid
    NoobDKPVirtualAdd(msg)
  elseif cmd == "add" then
    -- adds a member to the roster (usually not guilded)
    if args == "" then
      print(NoobDKP_color .. "No character found to add!")
      print(NoobDKP_color .. syntax)
    else
      NoobDKP_AddRoster(args)
    end
  elseif cmd == "remove" then
    -- removes a member from the roster (usually when they leave the guild)
    if args == "" then
      print(NoobDKP_color .. "No character found to remove!")
      print(NoobDKP_color .. syntax)
    else
      NoobDKP_RemoveRoster(args)
    end
  elseif cmd == "alt" then
    -- Sets character A as an alt of character B
    if args == "" then
      print(NoobDKP_color .. "No characters found to set alt!")
      print(NoobDKP_color .. syntax)
    else
      NoobDKP_AltRoster(args)
    end
  elseif cmd == "set" then
    -- sets all EPGP values of a charcter directly
    if args == "" then
      print(NoobDKP_color .. "No values found for set!")
      print(NoobDKP_color .. syntax)
    else
      NoobDKP_SetRoster(args)
    end
  elseif cmd == "epgp" then
    -- sets the EPGP values of a charcter directly
    if args == "" then
      print(NoobDKP_color .. "No values found for set!")
      print(NoobDKP_color .. syntax)
    else
      local _, _, char, ep, gp = string.find(args, "%s?(%w+)%s?(-?%d+)%s?(-?%d+)")
      NoobDKP_SetEPGP(char, ep, gp)
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
  NOOBDKP_g_options["last_update"] = date("%b %d, %Y %H:%M")
  getglobal("noobDKP_page1_last_update"):SetText(NOOBDKP_g_options["last_update"])
  NoobDKP_UpdateRoster()
end

-- add a character to the roster as an external
function NoobDKP_AddRoster(name)
  name = NoobDKP_FixName(name)
  print(NoobDKP_color .. "Add member: " .. name)
  if NOOBDKP_g_roster[name] == nil then
    print(NoobDKP_color .. "Not found! adding...")
    NOOBDKP_g_roster[name] = {"*external*", "unknown", ""}
  else
    print(NoobDKP_color .. "Found! skipping...")
  end
end

-- remove a character from the roster (should only be used on externals)
function NoobDKP_RemoveRoster(name)
  name = NoobDKP_FixName(name)
  print(NoobDKP_color .. "Removing member: " .. name)
  NOOBDKP_g_roster[name] = nil
end

-- set a character as an alt of another character
function NoobDKP_AltRoster(args)
  local _, _, alt, main = string.find(args, "%s?(%w+)%s?(.*)")
  alt = NoobDKP_FixName(alt)
  main = NoobDKP_FixName(main)
  print(NoobDKP_color .. "Alt: " .. alt .. ", Main: " .. main)
  if NOOBDKP_g_roster[alt] == nil then
    print(NoobDKP_color .. "Unable to find alt: " .. alt)
  elseif NOOBDKP_g_roster[main] == nil then
    print(NoobDKP_color .. "Unable to find main: " .. main)
  else
    NOOBDKP_g_roster[alt][3] = main
  end
end

function NoobDKP_SetRoster(args)
  local _, _, char, net, total = string.find(args, "%s?(%w+)%s?(-?%d+)%s?(-?%d+)")
  char = NoobDKP_FixName(char)
  print(NoobDKP_color .. "Char: " .. char .. ", Net: " .. net .. ", Total: " .. total)

  local main = NOOBDKP_find_main(char)
  if main ~= "" then
    print(NoobDKP_color .. "Found main of " .. char .. " is " .. main .. ". Setting values...")
    NOOBDKP_g_roster[main][3] = "N:" .. net .. " T:" .. total
  else
    print(NoobDKP_color .. "Can't find main of " .. char)
  end
end

function NoobDKP_RosterItemOnClick(self)
  local my_name = getglobal(self:GetName() .. "_name"):GetText()
  local menu = getglobal("roster_menu")

  if my_name == nil or my_name == "" then
    menu:Hide()
    return 
  end

  local menu_name = getglobal("roster_menu_name")
  menu:ClearAllPoints()
  menu:SetPoint("LEFT", self, "LEFT", 30, -30)

  menu_name:SetText(my_name)
  getglobal("roster_menu_ep_value"):SetText("")
  getglobal("roster_menu_gp_value"):SetText("")

  if (NOOBDKP_g_events ~= nil) and (roster_type == 2) then
    if NOOBDKP_g_events["virtual"] == true then
      getglobal("roster_menu_button_add_virtual"):Hide()
    end
  else
    getglobal("roster_menu_button_add_virtual"):Show()
  end

  menu:Show()
end

function NoobDKP_RosterContext()
  local menu = getglobal("roster_menu")
  local name = getglobal("roster_menu_name"):GetText()
  local ep = getglobal("roster_menu_ep_value"):GetText()
  local gp = getglobal("roster_menu_gp_value"):GetText()

  if ep == "" or ep == nil then
    ep = 0
  end

  if gp == "" or gp == nil then
    gp = 0
  end

  local _, _, alt, main = string.find(name, "(%w+) %((%w+)%)")

  if main ~= "" and main ~= nil then
    name = main
  end

  local chars = { name }
  NoobDKP_Event_AddEntry(ep, gp, "Manual Setting", chars, 0)
  print(NoobDKP_color .. "Manual Setting EP: " .. ep .. " GP: " .. gp)

  local old_score, old_ep, old_gp = NoobDKP_GetEPGP(name)
  ep = old_ep + ep
  gp = old_gp + gp
  NoobDKP_SetEPGP(name, ep, gp)

  NoobDKP_UpdateRoster()
  menu:Hide()
end

function NoobDKP_RosterContextRemove()
  getglobal("roster_menu"):Hide()
  local name = getglobal("roster_menu_name"):GetText()

  if (NOOBDKP_g_events ~= nil) and (roster_type == 1) and (NOOBDKP_g_events["virtual"] == true) then
    NOOBDKP_g_raid_roster[name] = nil
  else
    NoobDKP_RemoveRoster(name)
  end

  NoobDKP_UpdateRoster()
end

function NoobDKP_RosterContextAddVirtual()
  if (NOOBDKP_g_events ~= nil) and NOOBDKP_g_events["virtual"] == true then
    local name = NoobDKP_ParseNameText(getglobal("roster_menu_name"):GetText())
    local score, ep, gp = NoobDKP_GetEPGP(name)
    local t = {"", score, ep, gp}
    NOOBDKP_g_raid_roster[name] = t
    getglobal("roster_menu"):Hide()
  else
    print(NoobDKP_color .. "Error: not in a virtual raid!!")
  end
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

function NoobDKP_RosterVerticalScroll(offset)
  offset = offset * NOOBDKP_g_options["scroll_scale"]

  roster_index = roster_index + offset

  local whichRoster

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

  local tableSize = getTableSize(whichRoster)

  if roster_index > (tableSize - 14) then
    roster_index = tableSize - 14
  end

  if roster_index < 1 then
    roster_index = 1
  end

  NoobDKP_UpdateRoster()
end

function NoobDKP_UpdateRaidRoster()
  if (NOOBDKP_g_events == nil) or (NOOBDKP_g_events["virtual"] ~= true) then
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
          score, ep, gp = NoobDKP_GetEPGP(name)
        end

        NOOBDKP_g_raid_roster[name] = {"", score, ep, gp}
      end
    end
  end

  roster_type = 1
  roster_index = 1
  NoobDKP_UpdateRoster()
end

function NoobDKP_UpdateGuildRoster()
  roster_type = 0
  roster_index = 1
  NoobDKP_UpdateRoster()
end

function NoobDKP_UpdateMainRoster()
  roster_type = 2
  roster_index = 1
  NoobDKP_UpdateRoster()
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
  local unique = {}

  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end
  if NOOBDKP_g_events["virtual"] == true then
    getglobal("noobDKP_page1_virtual"):Show()
  end

  if roster_type == 0 then
    whichRoster = NOOBDKP_g_roster
  elseif roster_type == 1 then
    if NOOBDKP_g_raid_roster == nil then
      NOOBDKP_g_raid_roster = {}
    end
    whichRoster = NOOBDKP_g_raid_roster
  else
    whichRoster = NOOBDKP_g_roster
  end

  for key, value in pairs(whichRoster) do
    local nameText = key
    local skip = false
    local main

    -- don't add main/alt on the Main Roster
    if roster_type ~= 2 then
      main = NOOBDKP_find_main(key)
      if main ~= nil and main ~= "" and main ~= key then
        nameText = nameText .. " (" .. main .. ")"
      end
    else
      main = NOOBDKP_find_main(key)
      nameText = main
    end

    if roster_type ~= 2 then
      local rank = NOOBDKP_g_roster[key][1]
      local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[key][2])
      local score, ep, gp = NoobDKP_GetEPGP(key)
      local t = {nameText, r, g, b, a, rank, score, ep, gp}
      table.insert(sorted, t)
    else
      if main ~= nil and main ~= "" and unique[main] ~= 1 then
        local rank = NOOBDKP_g_roster[main][1]
        local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[main][2])
        local score, ep, gp = NoobDKP_GetEPGP(main)
        local t = {nameText, r, g, b, a, rank, score, ep, gp}
        table.insert(sorted, t)
        unique[main] = 1
      end
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
      nameFrame = getglobal("noobDKP_page1_entry" .. pos .. "_name")
      nameFrame:SetText(value[1])
      nameFrame:SetVertexColor(value[2], value[3], value[4], value[5])
      rankFrame = getglobal("noobDKP_page1_entry" .. pos .. "_rank")
      rankFrame:SetText(value[6])
      scoreFrame = getglobal("noobDKP_page1_entry" .. pos .. "_score")
      scoreFrame:SetText(value[7])
      EPFrame = getglobal("noobDKP_page1_entry" .. pos .. "_EP")
      EPFrame:SetText(value[8])
      GPFrame = getglobal("noobDKP_page1_entry" .. pos .. "_GP")
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
      nameFrame = getglobal("noobDKP_page1_entry" .. j .. "_name")
      nameFrame:SetText("")
      rankFrame = getglobal("noobDKP_page1_entry" .. j .. "_rank")
      rankFrame:SetText("")
      scoreFrame = getglobal("noobDKP_page1_entry" .. j .. "_score")
      scoreFrame:SetText("")
      EPFrame = getglobal("noobDKP_page1_entry" .. j .. "_EP")
      EPFrame:SetText("")
      GPFrame = getglobal("noobDKP_page1_entry" .. j .. "_GP")
      GPFrame:SetText("")
    end
  end

  getglobal("roster_menu"):Hide()
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

  -- set rank to external if no longer in the guild
  for key, value in pairs(NOOBDKP_g_roster) do
    if value[1] ~= "*external*" then
      if tempTable[key] ~= 1 then
        print(NoobDKP_color .. "Found " .. key .. " left the guild!")
        NOOBDKP_g_roster[key][1] = "*external*"
      end
    end
  end

  SetGuildRosterShowOffline(false)
  NoobDKP_UpdateRoster()
end

-- This function scans through the roster and removes people with no values
function NoobDKP_PurgeNoEPRoster()
  for key, value in pairs(NOOBDKP_g_roster) do
    local score, ep, gp = NoobDKP_GetEPGP(key)

    score = tonumber(score)
    ep = tonumber(ep)
    gp = tonumber(gp)

    if (ep == nil or ep == 0) and (gp == nil or gp == 0) then
      print(NoobDKP_color .. "Purging " .. key .. " for having no values!")
      NOOBDKP_g_roster[key] = nil
    end
  end
end

-- This function pushes all values in the addon to the guild officer notes
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
  NOOBDKP_g_options["last_update"] = date("%b %d, %Y %H:%M")
  getglobal("noobDKP_page1_last_update"):SetText(NOOBDKP_g_options["last_update"])
end

-- This function performs the decay function.
-- It will scan through the roster, ignore anyone with no EP or GP,
-- ignore alts (so the decay is only applied once rather than once per alt)
-- and reduce EP by the percentage and GP by the percentage
function NoobDKP_Decay()
  if NOOBDKP_g_options["decay_percent"] ~= nil and NOOBDKP_g_options["decay_percent"] ~= 0 and NOOBDKP_g_options["decay_percent"] ~= "" then
    local decay = tonumber(NOOBDKP_g_options["decay_percent"])
    print(NoobDKP_color .. "NoobDKP Decaying Roster by " .. decay .. "%")
    for key, value in pairs(NOOBDKP_g_roster) do
      local main = NOOBDKP_find_main(key)
      -- ignore alts so the calculation is only done once per player
      if main == key then
        local t, n = NoobDKP_ParseNote(value[3])
        -- ignore people with no values
        if (t ~= 0 and t ~= "") or (n ~= 0 and n ~= "") then
          local _, ep, gp = NoobDKP_GetEPGP(key)
          print(NoobDKP_color .. "Found score for " .. key .. " ep = " .. ep .. " gp = " .. gp)
          ep = math.floor(ep - (ep * (decay / 100)) + 0.5)
          gp = math.floor(gp - (gp * (decay / 100)) + 0.5)
          print(NoobDKP_color .. "Decayed to ep = " .. ep .. " gp = " .. gp)
          NoobDKP_SetEPGP(key, ep, gp)
        end
      end
    end
  end
end
