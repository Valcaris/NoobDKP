print("NoobDKP v0.0.1")

local helpString = "NoobDKP Syntax\n-help: This text\n-version\n-member add | remove | alt\n-event start | stop | load\n-options\n-sync\n-report guild | event | member\n-value add | set"

local function NoobDKPAddonCommands(msg, editbox)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")

    if cmd == "version" then
        print("NoobDKP Version: 0.0.1")
    elseif cmd == "member" and args ~= "" then
        print("Member, args: " .. args)
    elseif cmd == "event" and args ~= "" then
        print("Event, args: " .. args)
    elseif cmd == "options" then
        print("Options")
    elseif cmd == "sync" then
        print("Sync")
    elseif cmd == "report" and args ~= "" then
        print("Report, args: " .. args)
    elseif cmd == "value" and args ~= "" then
        print("Values, args: " .. args)
    else
        print(helpString)
    end
end

SLASH_NOOBDKP1 = '/noob'
SlashCmdList["NOOBDKP"] = NoobDKPAddonCommands