function NOOBDKP_find_main(char)
    print("Find main for " .. char)
    -- if no note, this is a main char that hasn't had values set
    if NOOBDKP_g_roster[3] == nil or NOOBDKP_g_roster[3] == "" then
        return char
    end
    local _, _, n, t = string.find(NOOBDKP_g_roster[char][3], "N:(%d+) T:(%d+)")
    if n == nil or n == "" or t == nil or t == "" then
        -- values not found, so this is an alt, find the main
        print("Alt detected, looking for main...")
        local main = NOOBDKP_g_roster[char][3]
        if main ~= nil and main ~= "" then
            return NOOBDKP_find_main(main)
        else
            print("Can't find main for " .. char)
            return ""
        end
    else
        -- values found, so this is a main character
        print("Character " .. char .. " was a main")
        return char
    end

end

function NoobDKP_ParseOfficerNote(note)
    local _, _, n, t = string.find(note, "N:(%d+) T:(%d+)")
    if n == nil or n == "" or t == nil or t == "" then
        local newnote = NOOBDKP_g_roster[note][3]
        _, _, n, t = string.find(newnote, "N:(%d+) T:(%d+)")
    end

    local EP = t
    local GP = t - n
    local score = ceil(((t + NoobDKP_base_EP) * NoobDKP_scale_EP) / (GP + NoobDKP_base_GP))

    return score, EP, GP
end