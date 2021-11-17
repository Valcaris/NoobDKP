local noobversion = GetAddOnMetadata("NoobDKP", "Version")
local noobcolor = "|cfff0ba3c"

print(noobcolor .. "NoobDKP v" .. noobversion)

local function NoobDKP_OnLoad()
    message("Loadry")
end

local function NoobDKPAddonCommands(msg, editbox)
    -- handle nil tables
    if NOOBDKP_g_roster == nil then
        NOOBDKP_g_roster = {}
    end
    if NOOBDKP_g_events == nil then
        NOOBDKP_g_events = {}
    end

    local syntax =
        "NoobDKP Syntax\n-help: This text\n-version\n-member add | remove | alt | scan \n-event open | remove | award | loot\n-options\n-sync\n-report guild | event | member\n-value add | set"
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if cmd == "version" then
        -- prints the current addon's version
        print("NoobDKP Version: " .. noobversion)
    elseif cmd == "member" then
        -- member roster manipulation
        NoobDKPHandleMember(args)
    elseif cmd == "event" then
        -- event manipulation
        NoobDKPHandleEvents(args)
    elseif cmd == "options" then
        -- options dialog
        print("Options")
    elseif cmd == "sync" then
        -- attempts to sync this data with other found addons
        print("Sync")
    elseif cmd == "report" and args ~= "" then
        -- creates various reports
        print("Report, args: " .. args)
    elseif cmd == "value" and args ~= "" then
        -- manipulates DKP values directly
        print("Values, args: " .. args)
    elseif cmd == "show" then
        print("show")
        --DBMBossHealthBarTemplate:Show()
        NoobDKP_Frame:Show();
    else
        -- prints the help syntax to the user
        print("|cff0000ff" .. syntax)
    end
end

SLASH_NOOBDKP1 = "/noob"
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands
