-- This function receives messages from other people with the addon
-- v = version message
-- auction = auction message
-- item = auction started
-- winner = auction finished
-- event = event message
-- epgp = EPGP message
-- roster = roster message
-- table = tables message
function NoobDKP_HandleSyncMessage(sender, text)
  local me = UnitName("player")
  if me == sender then return end -- ignore messages we sent ourself

  print(NoobDKP_color .. sender .. " sent: " .. text)

  local _, _, cmd, args = string.find(text, "%s?(%w+)%s?(.*)")
  local main = NOOBDKP_find_main(sender)
  if main == "" or main == nil then main = sender end

  if cmd == "v" then
    if NOOBDKP_g_syncs[main] == nil then
      NOOBDKP_g_syncs[main] = {}
    end
    local _, _, version, sync_time = string.find(args, "(.*) # (.*)")
    NOOBDKP_g_syncs[main]["version"] = version
    NOOBDKP_g_syncs[main]["sync_time"] = sync_time
  elseif (cmd == "auction") and (NOOBDKP_g_options["ignore_others"] == false) then
    local _, _, name, bid, ep, gp = string.find(args, "%s?(%w*)%s(%w*)%s(%d*)%s(%d*)")
    print(NoobDKP_color .. "auction handler name:" .. name .. " bid: " .. bid .. " ep: " .. ep .. " gp: " .. gp )
    NoobDKP_SetEPGP(name, ep, gp)
    NoobDKP_HandleAddBid(name, bid)
    NoobDKP_HandleUpdateAuction()
  elseif cmd == "item" then
    local _, _, item = string.find(args, "%s?(.*)")
    print(NoobDKP_color .. "item handler: " .. item)
    NoobDKP_HandleItemAuction(item)
  elseif cmd == "winner" then
    local _, _, name = string.find(args, "%s?(%w+)%s?")
    NoobDKP_HandleFinishAuction(name)
  elseif (cmd == "epgp") and (NOOBDKP_g_options["ignore_others"] ~= true) then
    local _, _, name, ep, gp = string.find(args, "%s?(%w+)%s(%d+)%s(%d+)")
    local char = NOOBDKP_find_main(name)
    if (char == "") then char = name end
    print(NoobDKP_color .. "epgp handler: " .. name .. " -> " .. char .. " (" .. ep .. "/" .. gp .. ")")
    NoobDKP_SetEPGP(char, ep, gp)
  elseif cmd == "alt" then
    local _, _, alt, main = string.find(args, "%s?(%w+)%s(%w+)")
    print(NoobDKP_color .. "alt handler: " .. alt .. " " .. main)
    NoobDKP_Add2Roster(alt, main)
  elseif cmd == "sync" then
    print(NoobDKP_color .. "Request sync detected from: " .. sender)
    NoobDKP_HandleRequestSync(sender)
  elseif cmd == "addevent" then
    print(NoobDKP_color .. "Request add event detected from: " .. sender)
    NoobDKP_HandleSyncAddEvent(args)
  elseif cmd == "evententry" then
    local _, _, timestamp, entry = string.find(args, "%s?(%d+)%s(.*)")
    print(NoobDKP_color .. "Event entry found: " .. timestamp .. ": " .. entry)
    NoobDKP_HandleSyncEventEntry(timestamp, entry)
  end

  NoobDKP_HandleRefreshSyncs()
  NoobDKP_HandleUpdateAuction()
  NoobDKP_UpdateRoster()
end

-- handles sending sync messages when addon is loaded (sends a hello message)
function NoobDKP_HandleSyncOnLoad()
  -- setup Addon channel stuff
  local update = NOOBDKP_g_options["last_update"]
  if update == nil or update == "" then
    NOOBDKP_g_options["last_update"] = date("%b %d, %Y %H:%M")
    update = NOOBDKP_g_options["last_update"]
  end
  local msg = "v " .. noobversion .. " # " .. update
  SendAddonMessage("NoobDKP", msg, "GUILD", 0)
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

-- handles removing all known syncs
function NoobDKP_HandleClearSyncs()
  NOOBDKP_g_syncs = {}
  NoobDKP_HandleRefreshSyncs()
end

-- handles sending the sync message when an auction is created for an item
function NoobDKP_SyncAuctionItem(item)
  local msg = "item " .. item
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

-- handles sending the sync message when a bid is made
function NoobDKP_SyncAuctionBid(name, bid)
  local score, ep, gp = NoobDKP_GetEPGP(name)
  local msg = "auction " .. name .. " " .. bid .. " " .. ep .. " " .. gp
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

-- handles sending the sync message when an auction is finished
function NoobDKP_HandleSyncAuctionFinish(name)
  local msg = "winner " .. name
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

function NoobDKP_HandleSyncEPGP(name, ep, gp)
  local msg = "epgp " .. name .. " " .. ep .. " " .. gp
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

function NoobDKP_SyncAddEvent(desc, time)
  local msg = "addevent " .. time .. " " .. desc
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

function NoobDKP_HandleSyncAddEvent(text)
  local _, _, timestamp, desc = string.find(text, "%s?(%d*)%s(.*)")
  print("adding event: " .. desc .. " " .. timestamp)
  NoobDKP_Add2Event(desc, timestamp)
end

function NoobDKP_SyncEventEntry(timestamp, entry)
  local msg = "evententry " .. timestamp .. " " .. entry
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

function NoobDKP_HandleSyncEventEntry(timestamp, entry)
  local _, _, id, ep, gp, text, chars = string.find(entry, "%s?(%d+). (%d+) EP and (%d+) GP for (.*) to (.*)")

  -- chars at this point is a text string, need to convert to a table
  local t = {}
  local _, _, name, remainder = string.find(chars, ",?%s?(%w+)(.*)")
  while (name ~= nil) do
    table.insert(t, name)
    if(remainder ~= nil and remainder ~= "") then
      _, _, name, remainder = string.find(remainder, ",?%s?(%w+)(.*)")
    else
      break
    end
  end

  NoobDKP_Event_Add2Entry(timestamp, id, ep, gp, text, t)
end

function NoobDKP_SyncAddEP(ep, who, reason)
  local msg = "addep " .. ep .. " " .. who .. " " .. reason
  SendAddonMessage("NoobDKP", msg, "RAID", 0)
  print(NoobDKP_color .. "Sent addon message: " .. msg)
end

function NoobDKP_HandleSyncAddEP(text)
  local _, _, ep, who, reason = string.find(text, "%s?(%d*)%s(%w*)%s(.*)")
  print("adding EP: " .. ep .. " " .. who .. " " .. reason)
  NoobDKP_AddEP(desc, timestamp)
end

g_player = ""
g_update_count = 0

function NoobDKP_HandleRequestSync(player)
  local i = 0
  -- populate message queue with sync results
  for key, value in pairs(NOOBDKP_g_roster) do
    local char = key
    local main = NOOBDKP_find_main(char)
    if main == char then
      -- send EPGP of mains
      local score, ep, gp =NoobDKP_GetEPGP(main)
      local msg = "epgp " .. main .. " " .. ep .. " " .. gp
      print(NoobDKP_color .. "Queued message: " .. msg)
      g_NoobDKP_MessageQueue.push(msg)
    else
      -- send alts with link to main
      local msg = "alt " .. char .. " " .. main
      print(NoobDKP_color .. "Queued message: " .. msg)
      g_NoobDKP_MessageQueue.push(msg)
    end
  end

  -- drain the queue several messages at a time so they don't get throttled
  g_player = player
  g_update_count = 1
end

function NoobDKP_RequestSync(player)
  local msg = "sync"
  SendAddonMessage("NoobDKP", msg, "WHISPER", player)
  print(NoobDKP_color .. "Sent addon message: " .. msg .. " to " .. player)
end

function NoobDKP_SyncOnUpdate()
  if g_update_count > 1 then
    g_update_count = g_update_count - 1
  elseif g_update_count == 1 then
    g_update_count = 150
    print(NoobDKP_color .. "SyncOnUpdate!")
    for i = 1, 15 do
      msg = g_NoobDKP_MessageQueue.pop()
      if msg ~= "" then
        SendAddonMessage("NoobDKP", msg, "WHISPER", g_player)
        print(NoobDKP_color .. "Sent addon message: " .. msg)
      else
        g_update_count = 0
        print(NoobDKP_color .. "Queue emptied!")
        break
      end
    end
  end
end

-- handles refreshing all known syncs
function NoobDKP_HandleRefreshSyncs()
  local name, sync_time, version
  local pos = 1 -- index into the frame list

  -- populate the list with entries
  for key, value in pairs(NOOBDKP_g_syncs) do
    if pos <= 10 then
      name = key
      sync_time = value["sync_time"]
      if sync_time == nil then sync_time = "" end
      version = value["version"]
      nameFrame = getglobal("noobDKP_page5_entry" .. pos .. "_name")
      nameFrame:SetText(name)
      if NOOBDKP_g_roster == nil or NOOBDKP_g_roster[name] == nil then
        r, g, b, a = NoobDKP_getClassColor("unknown")
      else
        r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[name][2])
      end
      nameFrame:SetVertexColor(r, g, b, a)
      versionFrame = getglobal("noobDKP_page5_entry" .. pos .. "_version")
      versionFrame:SetText(version)
      syncFrame = getglobal("noobDKP_page5_entry" .. pos .. "_sync_time")
      syncFrame:SetText(sync_time)
      requestButton = getglobal("noobDKP_page5_entry" .. pos .. "_button_request_sync")
      requestButton:Show()
    end
    pos = pos + 1
  end

  -- blank out unused list items
  if pos <= 10 then
    for j = pos, 10 do
      nameFrame = getglobal("noobDKP_page5_entry" .. j .. "_name")
      nameFrame:SetText("")
      versionFrame = getglobal("noobDKP_page5_entry" .. j .. "_version")
      versionFrame:SetText("")
      syncFrame = getglobal("noobDKP_page5_entry" .. j .. "_sync_time")
      syncFrame:SetText("")
      requestButton = getglobal("noobDKP_page5_entry" .. j .. "_button_request_sync")
      requestButton:Hide()
    end
  end
end
