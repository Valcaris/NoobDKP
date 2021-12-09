
function NoobDKPHandleEvents(msg)
    print("Handle Events: " .. msg)
    local syntax = "/noob event\n-add [timestamp][description]: adds an event/raid by the name of description created at timestamp. Creates new if not found. Timestamp defaults to now if creating. Find first raid if no timestamp and multiple same descriptions are found.\n-remove [description]: deletes an event/raid with the name description\n-raid [dkp]([description]): applies dkp to the raid (can be negative) with an optional description\n-char [dkp][name]([description]): applies dkp to a character (can be negative) with an optional description (can be an item ID)"

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
    local _, _, desc  = string.find(msg, "%s?(.*)")
    local timestamp = time()
    print("Add Event: " .. desc .. ", " .. timestamp)
    NOOBDKP_g_events[timestamp] = { description = desc }
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
    local _, _, d, desc = string.find(msg, "%s?(-?%d+)%s?(.*)")
    print("Raid event: " .. d .. " " .. desc)
    local a = NOOBDKP_g_events["active_raid"]
    print(" active raid: " .. a)
    local t = { char = "raid", dkp = d, description = desc}
    table.insert(NOOBDKP_g_events[a], t)
end

function NoobDKP_CharEvent(msg)
    print("Char event " .. msg)
    local _, _, d, c, desc = string.find(msg, "%s?(-?%d+)%s?(%w+)%s?(.*)")
    print("Character event: " .. d .. " " .. c .. " " .. desc)
    local a = NOOBDKP_g_events["active_raid"]
    print(" active raid: " .. a)
    local t = { char = c, dkp = d, description = desc}
    table.insert(NOOBDKP_g_events[a], t)
end

function NoobDKP_ShowEventTab()
  local emptyFrame = getglobal("myTabPage2_emptyEvent")
  local fullFrame = getglobal("myTabPage2_Event")
  if NOOBDKP_g_events == nil or NOOBDKP_g_events["active_raid"] == nil then
    fullFrame:Hide()
      emptyFrame:Show()
  else
    local activeRaid = NOOBDKP_g_events["active_raid"]
    local eventName = NOOBDKP_g_events[activeRaid]["description"]
    getglobal("myTabPage2_Event_Name"):SetText("Event: " .. eventName)
    emptyFrame:Hide()
    fullFrame:Show()
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
    value[2] = ceil(((ep + NoobDKP_base_EP) * NoobDKP_scale_EP) / (gp + NoobDKP_base_GP))
    NoobDKP_SetOfficerNote(key, ep, gp)
  end
  getglobal("myTabPage2_Amount"):ClearFocus()
  getglobal("myTabPage2_Reason"):ClearFocus()
  NoobDKP_UpdateRoster()
  NoobDKP_UpdateAuction()
end