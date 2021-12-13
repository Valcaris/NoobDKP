function NOOBDKP_find_main(char)
    --print("Find main for " .. char)

    if NOOBDKP_g_roster[char] == nil then
      return ""
    end

    -- if no note, this is a main char that hasn't had values set
    if NOOBDKP_g_roster[char][3] == nil or NOOBDKP_g_roster[char][3] == "" then
        return char
    end
    local _, _, n, t = string.find(NOOBDKP_g_roster[char][3], "N:(-?%d+) T:(%d+)")
    if n == nil or n == "" or t == nil or t == "" then
        -- values not found, so this is an alt, find the main
        --print("Alt detected, looking for main...")
        local main = NOOBDKP_g_roster[char][3]
        if main ~= nil and main ~= "" then
            return NOOBDKP_find_main(main)
        else
            --print("Can't find main for " .. char)
            return ""
        end
    else
        -- values found, so this is a main character
        --print("Character " .. char .. " was a main")
        return char
    end

end

function NoobDKP_ParseOfficerNote(note)
    if note == nil or note == "" then
      return 100, 0, 0
    end
    local _, _, n, t = string.find(note, "N:(-?%d+) T:(%d+)")
    if n == nil or n == "" or t == nil or t == "" then
      -- did not find values, should be the main character
      -- so go to the main character for the values
      -- if the main is in the note but not in the roster, reset to zeros
      if NOOBDKP_g_roster[note] == nil then
        n = 0
        t = 0
      else
        local newnote = NOOBDKP_g_roster[note][3]
        _, _, n, t = string.find(newnote, "N:(-?%d+) T:(%d+)")
        if n == nil or n == "" or t == nil or t == "" then
            t = 0
            n = 0
        end
      end
    end

    local EP = t
    local GP = t - n
    local score = ceil(((EP + NoobDKP_base_EP) * NoobDKP_scale_EP) / (GP + NoobDKP_base_GP))

    return score, EP, GP
end

function NoobDKP_SetOfficerNote(char, ep, gp)
  local note = "N:" .. (ep - gp) .. " T:" .. ep
  local main = NOOBDKP_find_main(char)
  NOOBDKP_g_roster[main][3] = note
end

function getTableSize(t)
    local i = 0
    for key, value in pairs(t) do
        i = i + 1
    end
    return i
end

function NoobDKP_getClassColor(class)
  if class == "Death Knight" or class == "death knight" then
    return 0.77, 0.12, 0.23, 1.0
  elseif class == "Druid" or class == "druid" then
    return 1.00, 0.49, 0.04, 1.0
  elseif class == "Hunter" or class == "hunter" then
    return 0.67, 0.83, 0.45, 1.0
  elseif class == "Mage" or class == "mage" then
    return 0.25, 0.78, 0.92, 1.0
  elseif class == "Paladin" or class == "paladin" then
    return 0.96, 0.55, 0.73, 1.0
  elseif class == "Priest" or class == "priest" then
    return 1.0, 1.0, 1.0, 1.0
  elseif class == "Rogue" or class == "rogue" then
    return 1.00, 0.96, 0.41, 1.0
  elseif class == "Shaman" or class == "shaman" then
    return 0.0, 0.44, 0.87, 1.0
  elseif class == "Warlock" or class == "warlock" then
    return 0.53, 0.53, 0.93, 1.0
  elseif class == "Warrior" or class == "warrior" then
    return 0.78, 0.61, 0.43, 1.0
  end

    return 0.0, 1.0, 0.0, 1.0
end