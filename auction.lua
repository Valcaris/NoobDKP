
local noobcolor = "|cfff0ba3c"

function NoobDKPHandleAuction(msg)
    local syntax = "auction\n-create [item]: creates an auction for item\n-cancel: cancels the active auction\n-finish ([character]): finishes the active auction, optionally overriding the default winner\n-bid [character] need|greed: adds a bid for character as need or greed"
    print("Handle Auction: " .. msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if cmd == "create" then
        if args == "" then
            print("No item found to create an auction!")
            print(noobcolor .. syntax)
        else
            NoobDKP_CreateAuction(args)
        end
    elseif cmd == "cancel" then
        NoobDKP_CancelAuction()
    elseif cmd == "finish" then
        NoobDKP_FinishAuction(args)
    elseif cmd == "bid" then
        if args == nil or args == "" then
            print("No bid found!")
            print(noobcolor .. syntax)
        else
            NoobDKP_BidAuction(args)
        end
    else
        print(noobcolor .. syntax)
    end
end

function NoobDKP_CreateAuction(args)
    print("Create auction: " .. args)
    local _, _, item = string.find(args, "%s?(.*)")
    if NOOBDKP_g_auction ~= nil then
        print("Auction already in progress! Cancel first!")
    else
        NOOBDKP_g_auction = {_item = item}
    end
end

function NoobDKP_CancelAuction()
    print("Cancel auction")
    if NOOBDKP_g_auction ~= nil then
        NOOBDKP_g_auction = nil
    else
        print("No auction in progress to cancel!")
    end
end

function NoobDKP_FinishAuction(args)
    print("Finish auction: " .. args)
    local _, _, char = string.find(args, "%s?(%w+)%s?")
    if NOOBDKP_g_auction == nil then
        print("No auction in progress to finish!")
    elseif char ~= nil then
        print("Overriding " .. char .. " as the winner!")
        NOOBDKP_g_auction[winner] = char
    else
        print("Determining winner...")
        local chars = 0
        for key, value in pairs(NOOBDKP_g_auction) do
            if key ~= "_item" and key ~= "_winner" then
                chars = chars + 1
            end
        end
        if chars == 0 then
            print("No bidding characters detected!")
        else
            print("Finding winner...")
            local win_char, num_winners = NoobDKP_FindWinner()
            print("Found " .. num_winners .. " winners!")
            if num_winners > 1 then
                print("Breaking tie...")
                win_char = NOOBDKP_break_tie(win_char)
            end
            print("Winner is " .. win_char[1])
            NOOBDKP_g_auction["_winner"] = win_char[1]
        end
    end
end

function NoobDKP_BidAuction(args)
    print("Bid auction: " .. args)
    local _, _, char, val = string.find(args, "%s?(%w+)%s?(.*)")
    if NOOBDKP_g_auction == nil then
        print("No auction in progress to bid!")
    elseif char == "" or char == nil or val == "" or val == nil then
        print("Invalid character or value")
    elseif val ~= "need" and val ~= "greed" then
        print("Invalid bid! Must be need or greed!")
    else
        local main = NOOBDKP_find_main(char)
        if main ~= "" then
            print("Found main is: " .. main)
            local _, _, n, t = string.find(NOOBDKP_g_roster[main][3], "N:(%d+) T:(%d+)")
            if n ~= nil and n ~= "" and t ~= nil and t ~= "" then
                local EP = t
                local GP = t - n
                local score = ceil(((t + NoobDKP_base_EP) * NoobDKP_scale_EP) / (GP + NoobDKP_base_GP))
                print("EP: " .. EP .. " GP: " .. GP .. " score: " .. score)
                NOOBDKP_g_auction[char] = score
            end
        end
    end
end

function NoobDKP_FindWinner()
    local max_bid = 0
    local winners = {}
    local num_winners = 0;

    print("Finding high bid...")
    -- find what the high bid was
    for key, value in pairs(NOOBDKP_g_auction) do
        if key ~= "_item" and key ~= "_winner" then
            print("Checking " .. key .. " -- " .. value)
            if value > max_bid then
                max_bid = value
            end
        end
    end

    print("High bid was " .. max_bid)
    -- now find who had the high bid
    for key, value in pairs(NOOBDKP_g_auction) do
        if key ~= "_item" and key ~= "_winner" then
            if value == max_bid then
                table.insert(winners, key)
                num_winners = num_winners + 1
            end
        end
    end

    print("Found " .. num_winners .. " winners!")
    return winners, num_winners
end

function NOOBDKP_break_tie(char_list)
    local rolls = {}
    local winners = {}
    local num_winners = 0
    local high_roll = 0

    local s = ""
    for key, value in pairs(char_list) do
        s = s .. " " .. value
    end
    print("Rolling off for: " .. s)

    -- give every character in the list a random roll
    for key, value in pairs(char_list) do
        rolls[value] = random(1, 100)
    end

    print("Rolls are:")
    for key, value in pairs(rolls) do
        print(key .. " = " .. value)
    end

    print("rolls complete. looking for high roll...")
    -- determine which roll is the highest
    for key, value in pairs(rolls) do
        if value > high_roll then
            high_roll = value
        end
    end

    print("high roll is: " .. high_roll)

    print("high roll found. looking for who has it...")
    -- determine how many characters have the high roll (in case of another tie)
    for key, value in pairs(rolls) do
        if value == high_roll then
            table.insert(winners, key)
            num_winners = num_winners + 1
        end
    end

    -- if only one character had the high roll, we're done
    if num_winners == 1 then
        print("one winner found: " .. winners[1])
        return winners
    else
        print("tie detected. Rolling again...")
        -- otherwise, take all the high rollers and roll again
        return NOOBDKP_break_tie(winners)
    end
end