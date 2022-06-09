function NoobDKP_HandleSyncMessage(sender, text)
  print(NoobDKP_color .. sender .. " sent: " .. text)
  local _, _, cmd, args = string.find(text, "%s?(%w+)%s?(.*)")
  if cmd == "v" then
    if NOOBDKP_g_syncs[sender] == nil then
      NOOBDKP_g_syncs[sender] = {}
    end
    print(NoobDKP_color .. " cmd: " .. cmd .. " args: " .. args)
    local _, _, version, sync_time = string.find(args, "(.*) # (.*)")
    NOOBDKP_g_syncs[sender]["version"] = version
    NOOBDKP_g_syncs[sender]["sync_time"] = sync_time
    print(NoobDKP_color .. " version: " .. version .. " sync time: " .. sync_time)
  end
  NoobDKP_HandleRefreshSyncs()
end

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

function NoobDKP_HandleRefreshSyncs()
  local name, sync_time, version
  local pos = 1 -- index into the frame list

  --print(NoobDKP_color .. "Enter NoobDKP_HandleRefreshSyncs")

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

  --print(NoobDKP_color .. "Exit NoobDKP_HandleRefreshSyncs")

end