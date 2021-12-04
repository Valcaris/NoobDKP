local noobcolor = "|cfff0ba3c"

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
        print(noobcolor .. syntax)
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
