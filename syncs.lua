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
    print(NoobDKP_color .. " cmd: " .. cmd .. " args: " .. args)
    local _, _, version, sync_time = string.find(args, "(.*) # (.*)")
    NOOBDKP_g_syncs[main]["version"] = version
    NOOBDKP_g_syncs[main]["sync_time"] = sync_time
    print(NoobDKP_color .. " version: " .. version .. " sync time: " .. sync_time)
  elseif cmd == "auction" then
    print(NoobDKP_color .. " cmd: " .. cmd .. " args: " .. args)
    local _, _, name, bid, ep, gp = string.find(args, "%s?(%w*)%s(%w*)%s(%d*)%s(%d*)")
    NoobDKP_SetEPGP(name, ep, gp)
    NoobDKP_HandleAddBid(name, bid)
    NoobDKP_HandleUpdateAuction()
  elseif cmd == "item" then
    local _, _, item = string.find(args, "%s?(.*)")
    NoobDKP_HandleItemAuction(item)
  elseif cmd == "winner" then
    local _, _, name = string.find(args, "%s?(%w+)%s?")
    NoobDKP_HandleFinishAuction(name)
  end
  NoobDKP_HandleRefreshSyncs()
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
  
-- handles refreshing all known syncs
function NoobDKP_HandleRefreshSyncs()
  local name, sync_time, version
  local pos = 1 -- index into the frame list

  -- populate the list with entries
  for key, value in pairs(NOOBDKP_g_syncs) do
    if pos < 10 then
      name = key
      sync_time = value["sync_time"]
      if sync_time == nil then sync_time = "" end
      version = value["version"]
      nameFrame = getglobal("noobDKP_page5_entry" .. pos .. "_name")
      nameFrame:SetText(name)
      local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[name][2])
      nameFrame:SetVertexColor(r, g, b, a)
      versionFrame = getglobal("noobDKP_page5_entry" .. pos .. "_version")
      versionFrame:SetText(version)
      syncFrame = getglobal("noobDKP_page5_entry" .. pos .. "_sync_time")
      syncFrame:SetText(sync_time)
      eventFrame = getglobal("noobDKP_page5_entry" .. pos .. "_events")
      eventFrame:SetText("...")
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
      eventFrame = getglobal("noobDKP_page5_entry" .. j .. "_events")
      eventFrame:SetText("")
    end
  end
end