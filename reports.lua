function NoobDKP_GenerateFullReport()
  local text = "Full Report:\n | Name | Rank | Class | EP | GP | Score |\n |---|---|---|---|---|---|"
  local i = 0

  for key, value in pairs(NOOBDKP_g_roster) do
    local char = key
    local main = NOOBDKP_find_main(char)
    if main == nil or main == "" then
      NOOBDKP_g_roster[char][3] = ""
      main = char
    end
    local score, ep, gp = NoobDKP_ParseOfficerNote(NOOBDKP_g_roster[main][3])
    if ep ~= 0 then
      if main ~= char and main ~= "" and main ~= nil then
        char = char .. "(" .. main .. ")"
      end
      text =
        text ..
        "\n | " ..
          char .. " | " .. value[1] .. " | " .. value[2] .. " | " .. ep .. " | " .. gp .. " | " .. score .. " |"
      i = i + 1
    end
  end

  getglobal("noobDKP_page4_text"):SetText(text)
end

function briefCompare(a, b)
  return a[1] < b[1]
end

function NoobDKP_GenerateBriefReport()
  local sorted = {}
  for key, value in pairs(NOOBDKP_g_roster) do
    local main = NOOBDKP_find_main(key)
    local score, ep, gp = NoobDKP_GetEPGP(key)
    if ep ~= 0 and ep ~= "" and main == key then
      local t = {key, value[1], value[2], ep, gp, score}
      table.insert(sorted, t)
    end
  end

  table.sort(sorted, briefCompare)

  local text = "Brief Report:\n | Name | Rank | Class | EP | GP | Score |\n |---|---|---|---|---|---|"
  for key, value in ipairs(sorted) do
    local a = value[1]
    local b = value[2]
    local c = value[3]
    local d = value[4]
    local e = value[5]
    local f = value[6]
    if a == nil or a == "" then
      a = 0
    end
    if b == nil or b == "" then
      b = 0
    end
    if c == nil or c == "" then
      c = 0
    end
    if d == nil or d == "" then
      d = 0
    end
    if e == nil or e == "" then
      e = 0
    end
    if f == nil or f == "" then
      f = 0
    end
    text = text .. "\n | " .. a .. " | " .. b .. " | " .. c .. " | " .. d .. " | " .. e .. " | " .. f .. " |"
  end

  getglobal("noobDKP_page4_text"):SetText(text)
end

function altCompare(a, b)
  return a[2] < b[2]
end

function NoobDKP_GenerateAltReport()
  local text =
    "Alt Report:\n | Main | Alts |\n |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"

  local sorted = {}
  for key, value in pairs(NOOBDKP_g_roster) do
    local t, n = NoobDKP_ParseNote(value[3])
    if (n == nil or n == "") and value[3] ~= "" then
      local t = {key, value[3]}
      table.insert(sorted, t)
    end
  end

  table.sort(sorted, altCompare)
  local main = ""

  for key, value in ipairs(sorted) do
    if value[2] == main then
      text = text .. value[1] .. " | "
    else
      text = text .. "\n | " .. value[2] .. " | " .. value[1] .. " | "
      main = value[2]
    end
  end
  getglobal("noobDKP_page4_text"):SetText(text)
end

function NoobDKP_GenerateEventReport()
  local text = "Event Report:\n"
  for s, t in pairs(NOOBDKP_g_events) do
    if s ~= "active_raid" and s ~= "virtual" then
      text = text .. "\nEvent: " .. t["description"]
      for g, h in pairs(t) do
        if g ~= "description" and g ~= "last_id" then
          text = text .. "\n\t" .. NoobDKP_Event_EntryToString(g, h)
        end
      end
    end
  end
  getglobal("noobDKP_page4_text"):SetText(text)
end