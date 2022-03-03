local event_index = 1
local event_container_index = 1

function NoobDKPHandleEvents(msg)
  print(NoobDKP_color .. "Handle Events: " .. msg)
  local syntax =
    "/noob event\n-add [timestamp][description]: adds an event/raid by the name of description created at timestamp. Creates new if not found. Timestamp defaults to now if creating. Find first raid if no timestamp and multiple same descriptions are found.\n-remove [description]: deletes an event/raid with the name description\n-raid [dkp]([description]): applies dkp to the raid (can be negative) with an optional description\n-char [dkp][name]([description]): applies dkp to a character (can be negative) with an optional description (can be an item ID)"

  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "add" then
    if args == "" then
      print(NoobDKP_color .. "No description found!")
    else
      NoobDKP_AddEvent(args)
    end
  elseif cmd == "remove" and args ~= "" then
    NoobDKP_RemoveEvent(args)
  elseif cmd == "raid" and args ~= "" then
    NoobDKP_RaidEvent(args)
  elseif cmd == "char" and args ~= "" then
    NoobDKP_CharEvent(args)
  else
    print(NoobDKP_color .. syntax)
  end
end

function NoobDKP_AddEvent(msg)
  local _, _, desc = string.find(msg, "%s?(.*)")
  local timestamp = time()
  print(NoobDKP_color .. "Add Event: " .. desc .. ", " .. timestamp)

  if NOOBDKP_g_options["admin_mode"] then
    SendChatMessage("NoobDKP has started a new raid. Whisper me \"noob help\" for options!", "RAID")
  end

  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end

  NOOBDKP_g_events[timestamp] = {description = desc}
  NOOBDKP_g_events["active_raid"] = timestamp
end

function NoobDKP_RemoveEvent(msg)
  local a = NOOBDKP_g_events["active_raid"]
  local _, _, desc = string.find(msg, "%s?(.*)")
  print(NoobDKP_color .. "Remove event: " .. desc)
  for key, value in pairs(NOOBDKP_g_events) do
    print(NoobDKP_color .. "Found " .. key)
    if value ~= nil and value["description"] == desc then
      print(NoobDKP_color .. "Found and removing " .. key)
      NOOBDKP_g_events[key] = nil
    end
    if a == key then
      NOOBDKP_g_events["active_raid"] = nil
    end
  end
end

function NoobDKP_CloseEvent()
  NOOBDKP_g_events["active_raid"] = nil
  NoobDKP_ShowEventTab()
end

function NoobDKP_RaidEvent(msg)
  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end
  local _, _, d, desc = string.find(msg, "%s?(-?%d+)%s?(.*)")
  print(NoobDKP_color .. "Raid event: " .. d .. " " .. desc)
  local a = NOOBDKP_g_events["active_raid"]
  print(NoobDKP_color .. " active raid: " .. a)
  local t = {char = "raid", dkp = d, description = desc}
  table.insert(NOOBDKP_g_events[a], t)
end

function NoobDKP_CharEvent(msg)
  print(NoobDKP_color .. "Char event " .. msg)
  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end
  local _, _, d, c, desc = string.find(msg, "%s?(-?%d+)%s?(%w+)%s?(.*)")
  c = NoobDKP_FixName(c)
  print(NoobDKP_color .. "Character event: " .. d .. " " .. c .. " " .. desc)
  local a = NOOBDKP_g_events["active_raid"]
  print(NoobDKP_color .. " active raid: " .. a)
  local t = {char = c, dkp = d, description = desc}
  table.insert(NOOBDKP_g_events[a], t)
end

function NoobDKP_Event_AddGP(char, GP, reason)
  local raid = NOOBDKP_g_events["active_raid"]
  if raid ~= nil then
    local s = char .. " was awarded " .. GP .. " GP for " .. reason
    table.insert(NOOBDKP_g_events[raid], s)
    NoobDKP_HandleUpdateFullEvent()
  end
end

function NoobDKP_Event_AddEP(EP, reason)
  local raid = NOOBDKP_g_events["active_raid"]
  if raid ~= nil then
    local s = "Raid was awarded " .. EP .. " EP for " .. reason
    table.insert(NOOBDKP_g_events[raid], s)
    NoobDKP_HandleUpdateFullEvent()
    end
end

function NoobDKP_ShowEventTab()
  local emptyFrame = getglobal("noobDKP_page2_empty_event")
  local fullFrame = getglobal("noobDKP_page2_event")
  if NOOBDKP_g_events == nil or NOOBDKP_g_events["active_raid"] == nil then
    if NOOBDKP_g_options["admin_mode"] then
      getglobal("noobDKP_page2_empty_event_create_event"):Enable()
      getglobal("noobDKP_page2_add_EP"):Enable()
      --getglobal("noobDKP_page2_empty_event_event_location"):Enable()
      --getglobal("noobDKP_page2_amount"):Enable()
      --getglobal("noobDKP_page2_reason"):Enable()
    else
      getglobal("noobDKP_page2_empty_event_create_event"):Disable()
      getglobal("noobDKP_page2_add_EP"):Disable()
      --getglobal("noobDKP_page2_empty_event_event_location"):Disable()
      --getglobal("noobDKP_page2_amount"):Disable()
      --getglobal("noobDKP_page2_reason"):Disable()
    end

    fullFrame:Hide()
    emptyFrame:Show()
    NoobDKP_HandleUpdateEmptyEvent()
  else
    local activeRaid = NOOBDKP_g_events["active_raid"]
    local eventName = NOOBDKP_g_events[activeRaid]["description"]
    getglobal("noobDKP_page2_event_name"):SetText("Event: " .. eventName)
    emptyFrame:Hide()
    fullFrame:Show()
    NoobDKP_HandleUpdateFullEvent()
  end
end

function NoobDKP_AddRaidEP()
  local amount = getglobal("noobDKP_page2_amount"):GetText()
  local reason = getglobal("noobDKP_page2_reason"):GetText()
  local multiplier = getglobal("noobDKP_page2_multiplier"):GetText()
  if reason == nil or reason == "" then
    reason = "no reason"
  end
  if tonumber(multiplier) == nil or tonumber(multiplier) == 0 then
    multiplier = 1
  end

  amount = amount * multiplier
  if NOOBDKP_g_options["admin_mode"] then
    SendChatMessage("NoobDKP: EP Adding " .. amount .. " EP to the raid for " .. reason, "RAID")
  end
  for key, value in pairs(NOOBDKP_g_raid_roster) do
    local ep = value[3] + amount
    local gp = value[4]
    value[3] = ep
    value[2] = NoobDKP_calculateScore(ep, gp)
    NoobDKP_SetOfficerNote(key, ep, gp)
  end
  getglobal("noobDKP_page2_amount"):ClearFocus()
  getglobal("noobDKP_page2_reason"):ClearFocus()
  NoobDKP_UpdateRoster()
  NoobDKP_HandleUpdateAuction()
  NoobDKP_Event_AddEP(amount, reason)
end

function event_helper(i, pos)
  local raid = NOOBDKP_g_events["active_raid"]
  local widget
  for s, t in pairs(NOOBDKP_g_events[raid]) do
    if s ~= "description" then
      if i >= event_index then
        widget = getglobal("noobDKP_page2_event_event_" .. pos .. "_text")
        widget:SetText(t)
        pos = pos + 1
        if pos > 10 then
          break
        end
      end
      i = i + 1
    end
  end
  return pos
end

function NoobDKP_HandleUpdateEmptyEvent()
  local i = 1 -- index into the table
  local pos = 1 -- index into the frame list
  local widget

  for s, t in pairs(NOOBDKP_g_events) do
    if s ~= "active_raid" then
      if i >= event_container_index then
        widget = getglobal("noobDKP_page2_empty_event_" .. pos)
        widget:Show()
        widget = getglobal("noobDKP_page2_empty_event_" .. pos .. "_text")
        widget:SetText(t["description"])
        pos = pos + 1
        if pos > 10 then
          break
        end
      end
      i = i + 1
    end
  end

  if pos <= 10 then
    for j = pos, 10 do
      widget = getglobal("noobDKP_page2_empty_event_" .. j)
      widget:Hide()
    end
  end
end

function NoobDKP_HandleUpdateFullEvent()
  local i = 1 -- index into the table
  local pos = 1 -- index into the frame list

  -- Something weird happens when we try to iterate through the event table. Probably something
  -- with the description (though the description itself processes fine). So instead, we
  -- iterate through the table in a protected call (pcall). Since we don't care if we error
  -- out or not, just get the final position when done, then blank out remaining lines.
  _, pos = pcall(event_helper, i, pos)

  if pos <= 10 then
    for j = pos, 10 do
      widget = getglobal("noobDKP_page2_event_event_" .. j .. "_text")
      widget:SetText("")
    end
  end
end

function NoobDKP_FullEventVerticalScroll(offset)
  local raid = NOOBDKP_g_events["active_raid"]
  offset = offset * NOOBDKP_g_options["scroll_scale"]

  event_index = event_index + offset

  local tableSize = getTableSize(NOOBDKP_g_events[raid])

  if event_index > (tableSize - 10) then
    event_index = tableSize - 10
  end

  if event_index < 1 then
    event_index = 1
  end

  NoobDKP_HandleUpdateFullEvent()
end

function NoobDKP_EmptyEventVerticalScroll(offset)
  offset = offset * NOOBDKP_g_options["scroll_scale"]

  event_container_index = event_container_index + offset

  local tableSize = getTableSize(NOOBDKP_g_events)
  if NOOBDKP_g_events["active_raid"] ~= nil then
    tableSize = tableSize - 1
  end

  if event_container_index > (tableSize - 10) then
    event_container_index = tableSize - 10
  end

  if event_container_index < 1 then
    event_container_index = 1
  end

  NoobDKP_HandleUpdateEmptyEvent()
end

function NoobDKP_HandleOpenEvent(button)
  local _, _, i = string.find(button:GetName(), "noobDKP_page2_empty_event_(%w+)(.*)")
  local text = getglobal("noobDKP_page2_empty_event_" .. i .. "_text"):GetText()
  local newactive = ""
  for s, t in pairs(NOOBDKP_g_events) do
    if s ~= "active raid" and t["description"] == text then
      newactive = s
      break
    end
  end
  
  if newactive ~= "" then 
    NOOBDKP_g_events["active_raid"] = newactive
  end
  NoobDKP_ShowEventTab()
end

function NoobDKP_HandleDeleteEvent(button)
  local _, _, i = string.find(button:GetName(), "noobDKP_page2_empty_event_(%w+)(.*)")
  local text = getglobal("noobDKP_page2_empty_event_" .. i .. "_text"):GetText()
  local target = ""
  for s, t in pairs(NOOBDKP_g_events) do
    if s ~= "active raid" and t["description"] == text then
      NOOBDKP_g_events[s] = nil
      break
    end
  end
  NoobDKP_HandleUpdateEmptyEvent()
end

function NoobDKP_GenerateEventName()
  local name = GetInstanceInfo()
  local d = date("%b %d, %Y %H:%M")
  local text = name .. " on " .. d
  getglobal("noobDKP_page2_empty_event_event_location"):SetText(text)
end

function NoobDKP_CombatLog(subEvent, name)
  if subEvent == "UNIT_DIED" and name then
    print(NoobDKP_color .. "NoobDKP_CombatLog: " .. name)    

    if NOOBDKP_g_boss_table[name] ~= nil then
      print(NoobDKP_color .. "Found boss kill: " .. name)
      getglobal("noobDKP_page2_amount"):SetText(NOOBDKP_g_boss_table[name])
      getglobal("noobDKP_page2_reason"):SetText("Boss kill: " .. name)
    end
  end
end