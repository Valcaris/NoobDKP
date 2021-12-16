
function NoobDKP_GenerateFullReport()
  local text = " | Name | Rank | Class | EP | GP | Score |\n |---|---|---|---|---|---|"
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
      text = text .. "\n | " .. char .. " | " .. value[1] .. " | " .. value[2] .. " | " .. ep .. " | " .. gp .. " | " .. score .. " |"
      i = i + 1
    end
  end

  getglobal("myTabPage4_Text"):SetText(text)
end

function briefCompare(a, b)
  return a[1] < b[1]
end

function NoobDKP_GenerateBriefReport()

  local sorted = {}
  for key, value in pairs(NOOBDKP_g_roster) do 
    local t, n = NoobDKP_ParseNote(value[3])
    local score, ep, gp = NoobDKP_ParseOfficerNote(NOOBDKP_g_roster[key][3])
    if n ~= nil and n ~= "" and t ~= nil and t ~= "" then
      local t = {key, value[1], value[2], ep, gp, score}
      table.insert(sorted, t)
    end
  end

  table.sort(sorted, briefCompare)

  local text = " | Name | Rank | Class | EP | GP | Score |\n |---|---|---|---|---|---|"
  for key, value in ipairs(sorted) do
    text = text .. "\n | " .. value[1] .. " | " .. value[2] .. " | " .. value[3] .. " | " .. value[4] .. " | " .. value[5] .. " | " .. value[6] .. " |"
  end

  getglobal("myTabPage4_Text"):SetText(text)
end

function altCompare(a, b)
  return a[2] < b[2]
end

function NoobDKP_GenerateAltReport()
  local text = "| Main | Alts |\n|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"

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
      text = text .. "\n| " .. value[2] .. " | " .. value[1] .. " | "
      main = value[2]
    end
  end
  getglobal("myTabPage4_Text"):SetText(text)
end
