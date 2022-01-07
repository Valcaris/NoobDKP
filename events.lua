local event_index = 1
local event_container_index = 1

function NoobDKPHandleEvents(msg)
  print("Handle Events: " .. msg)
  local syntax =
    "/noob event\n-add [timestamp][description]: adds an event/raid by the name of description created at timestamp. Creates new if not found. Timestamp defaults to now if creating. Find first raid if no timestamp and multiple same descriptions are found.\n-remove [description]: deletes an event/raid with the name description\n-raid [dkp]([description]): applies dkp to the raid (can be negative) with an optional description\n-char [dkp][name]([description]): applies dkp to a character (can be negative) with an optional description (can be an item ID)"

  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "add" then
    if args == "" then
      print("No description found!")
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
  print("Add Event: " .. desc .. ", " .. timestamp)

  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end

  NOOBDKP_g_events[timestamp] = {description = desc}
  NOOBDKP_g_events["active_raid"] = timestamp
end

function NoobDKP_RemoveEvent(msg)
  local a = NOOBDKP_g_events["active_raid"]
  local _, _, desc = string.find(msg, "%s?(.*)")
  print("Remove event: " .. desc)
  for key, value in pairs(NOOBDKP_g_events) do
    print("Found " .. key)
    if value ~= nil and value["description"] == desc then
      print("Found and removing " .. key)
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
  print("Raid event: " .. d .. " " .. desc)
  local a = NOOBDKP_g_events["active_raid"]
  print(" active raid: " .. a)
  local t = {char = "raid", dkp = d, description = desc}
  table.insert(NOOBDKP_g_events[a], t)
end

function NoobDKP_CharEvent(msg)
  print("Char event " .. msg)
  if NOOBDKP_g_events == nil then
    NOOBDKP_g_events = {}
  end
  local _, _, d, c, desc = string.find(msg, "%s?(-?%d+)%s?(%w+)%s?(.*)")
  c = NoobDKP_FixName(c)
  print("Character event: " .. d .. " " .. c .. " " .. desc)
  local a = NOOBDKP_g_events["active_raid"]
  print(" active raid: " .. a)
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
  local emptyFrame = getglobal("myTabPage2_emptyEvent")
  local fullFrame = getglobal("myTabPage2_Event")
  if NOOBDKP_g_events == nil or NOOBDKP_g_events["active_raid"] == nil then
    print("event tab empty show")
    if NOOBDKP_g_options["admin_mode"] then
      getglobal("myTabPage2_emptyEvent_createEvent"):Enable()
      getglobal("myTabPage2AddEP"):Enable()
      --getglobal("myTabPage2_emptyEvent_EventLocation"):Enable()
      --getglobal("myTabPage2_Amount"):Enable()
      --getglobal("myTabPage2_Reason"):Enable()
    else
      getglobal("myTabPage2_emptyEvent_createEvent"):Disable()
      getglobal("myTabPage2AddEP"):Disable()
      --getglobal("myTabPage2_emptyEvent_EventLocation"):Disable()
      --getglobal("myTabPage2_Amount"):Disable()
      --getglobal("myTabPage2_Reason"):Disable()
    end

    fullFrame:Hide()
    emptyFrame:Show()
    NoobDKP_HandleUpdateEmptyEvent()
    print("end event tab empty show")
  else
    print("event tab full show")
    local activeRaid = NOOBDKP_g_events["active_raid"]
    local eventName = NOOBDKP_g_events[activeRaid]["description"]
    getglobal("myTabPage2_Event_Name"):SetText("Event: " .. eventName)
    emptyFrame:Hide()
    fullFrame:Show()
    NoobDKP_HandleUpdateFullEvent()
  end
end

function NoobDKP_AddRaidEP()
  local amount = getglobal("myTabPage2_Amount"):GetText()
  local reason = getglobal("myTabPage2_Reason"):GetText()
  if reason == nil or reason == "" then
    reason = "no reason"
  end
  SendChatMessage("NoobDKP: Adding " .. amount .. " EP to the raid for " .. reason, "RAID")
  for key, value in pairs(NOOBDKP_g_raid_roster) do
    local ep = value[3] + amount
    local gp = value[4]
    value[3] = ep
    value[2] = NoobDKP_calculateScore(ep, gp)
    NoobDKP_SetOfficerNote(key, ep, gp)
  end
  getglobal("myTabPage2_Amount"):ClearFocus()
  getglobal("myTabPage2_Reason"):ClearFocus()
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
        widget = getglobal("myTabPage2_Event_event_" .. pos .. "_text")
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
        widget = getglobal("myTabPage2_emptyEvent_" .. pos)
        widget:Show()
        widget = getglobal("myTabPage2_emptyEvent_" .. pos .. "_text")
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
      widget = getglobal("myTabPage2_emptyEvent_" .. j)
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
      widget = getglobal("myTabPage2_Event_event_" .. j .. "_text")
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
  local _, _, i = string.find(button:GetName(), "myTabPage2_emptyEvent_(%w+)(.*)")
  local text = getglobal("myTabPage2_emptyEvent_" .. i .. "_text"):GetText()
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
  local _, _, i = string.find(button:GetName(), "myTabPage2_emptyEvent_(%w+)(.*)")
  local text = getglobal("myTabPage2_emptyEvent_" .. i .. "_text"):GetText()
  local target = ""
  for s, t in pairs(NOOBDKP_g_events) do
    if s ~= "active raid" and t["description"] == text then
      NOOBDKP_g_events[s] = nil
      break
    end
  end
  NoobDKP_HandleUpdateEmptyEvent()
end