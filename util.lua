function NOOBDKP_find_main(char)

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
