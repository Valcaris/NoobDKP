
function NoobDKP_GenerateReport()
  local text = " | Name | Rank | Class | Officer Note |\n |---|---|---|---|"
  for key, value in pairs(NOOBDKP_g_roster) do
    local char = key
    local main = NOOBDKP_find_main(char)
    if main ~= char and main ~= "" and main ~= nil then
      char = char .. "(" .. main .. ")"
    end
    text = text .. "\n | " .. char .. " | " .. value[1] .. " | " .. value[2] .. " | " .. value[3] .. " | "
  end
  getglobal("myTabPage4_Text"):SetText(text)
end