
function NoobDKPHandleAuction(msg)
    local syntax = "auction\n-create [item]: creates an auction for item\n-cancel: cancels the active auction\n-finish ([character]): finishes the active auction, optionally overriding the default winner\n-bid [character] need|greed: adds a bid for character as need or greed"
    print("Handle Auction: " .. msg)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if cmd == "create" then
        if args == "" then
            print("No item found to create an auction!")
            print(NoobDKP_color .. syntax)
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
        print(NoobDKP_color .. syntax)
    end
end

function NoobDKP_CreateAuction(args)
    print("Create auction: " .. args)
    local _, _, item = string.find(args, "%s?(.*)")
    if NOOBDKP_g_auction ~= nil then
        print("Auction already in progress! Cancel first!")
    else
      NoobDKP_ShiftClickItem(item)
    end    
end

function NoobDKP_CancelAuction()
    if NOOBDKP_g_auction ~= nil then
        NOOBDKP_g_auction = nil
        print(NoobDKP_color .. "Auction Cancelled!")
    else
        print(NoobDKP_color .. "No auction in progress to cancel!")
    end
    getglobal("myTabPage3_Auction_Winner"):SetText("No Winner")
    NoobDKP_ShowAuctionTab()
end

function NoobDKP_FinishAuction(args)
  print("Finishing Auction... " .. args)
    local _, _, char = string.find(args, "%s?(%w+)%s?")
    char = NoobDKP_FixName(char)
    print(" for char: " .. char)
    if NOOBDKP_g_auction == nil then
        print("No auction in progress to finish!")
    elseif char ~= nil and char ~= "" then
        print("Overriding " .. char .. " as the winner!")
        NOOBDKP_g_auction[winner] = char
    else
        local chars = 0
        for key, value in pairs(NOOBDKP_g_auction) do
            if key ~= "_item" and key ~= "_winner" then
                chars = chars + 1
            end
        end
        if chars == 0 then
          SendChatMessage("NoobDKP: No bids detected", "RAID")
        else
            local win_char, num_winners = NoobDKP_FindWinner()
            if num_winners > 1 then
              SendChatMessage("NoobDKP: Breaking tie...", "RAID")
                win_char = NOOBDKP_break_tie(win_char)
            end
            SendChatMessage("NoobDKP: " .. win_char[1] .. " wins the bid for " .. NOOBDKP_g_auction["_item"] .. " with a score of " .. NOOBDKP_g_auction[win_char[1] ]["_score"], "RAID")
            NOOBDKP_g_auction["_winner"] = win_char[1]
            getglobal("myTabPage3_Auction_Winner"):SetText(win_char[1])
            local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[win_char[1] ][2])
            getglobal("myTabPage3_Auction_Winner"):SetVertexColor(r, g, b, a)
        end
        getglobal("myTabPage3_AuctionAddGP"):Enable()
      end
end

function NoobDKP_AddAuction(name, bid)
  if name == "" or name == nil or bid == "" or bid == nil then return end

  local score, ep, gp = NoobDKP_GetEPGP(name)
  NOOBDKP_g_auction[name] = {}
  NOOBDKP_g_auction[name]["_score"] = score

  if tonumber(ep) < NOOBDKP_g_options["min_EP"] and bid == "need" then
    bid = "greed"
    SendChatMessage("NoobDKP: " .. name .. " does not have " .. NOOBDKP_g_options["min_EP"] .. " EP, setting to greed bid", "RAID")
  end

  NOOBDKP_g_auction[name]["_type"] = bid
  SendChatMessage("NoobDKP: Bid " .. name .. " " .. bid .. " for " .. score .. " accepted " .. ep .. "/" .. gp, "RAID")
  getglobal("myTabPage3_Auction_finishAuction"):Enable()
  NoobDKP_UpdateAuction()
end

function NoobDKP_BidAuction(args)
  if NOOBDKP_g_options["admin_mode"] == nil then return end

    print("Bid auction: " .. args)
    local _, _, char, val = string.find(args, "%s?(%w+)%s?(.*)")
    char = NoobDKP_FixName(char)
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
            local t, n = NoobDKP_ParseNote(NOOBDKP_g_roster[main][3])
            print("Note is: " .. t .. " " .. n)
            if n ~= nil and n ~= "" and t ~= nil and t ~= "" then
                local EP = t
                local GP = t - n
                local score = NoobDKP_calculateScore(EP, GP)
                print("EP: " .. EP .. " GP: " .. GP .. " score: " .. score)
                NOOBDKP_g_auction[char] = {}
                NOOBDKP_g_auction[char]["_score"] = score
                if tonumber(EP) < NOOBDKP_g_options["min_EP"] and val == "need" then
                  val = "greed"
                  SendChatMessage("NoobDKP: " .. char .. " does not have " .. NOOBDKP_g_options["min_EP"] .. " EP, setting to greed bid", "RAID")
                end
                NOOBDKP_g_auction[char]["_type"] = val
                SendChatMessage("NoobDKP: Bid " .. char .. " " .. val .. " for " .. score .. " accepted " .. EP .. "/" .. GP, "RAID")
              else
                local score = NoobDKP_calculateScore(0, 0)
                NOOBDKP_g_auction[char] = {}
                NOOBDKP_g_auction[char]["_score"] = score
                if 0 < NOOBDKP_g_options["min_EP"] and val == "need" then
                  val = "greed"
                  SendChatMessage("NoobDKP: " .. char .. " does not have " .. NOOBDKP_g_options["min_EP"] .. " EP, setting to greed bid", "RAID")
                end
                NOOBDKP_g_auction[char]["_type"] = val
                SendChatMessage("NoobDKP: Bid " .. char .. " " .. val .. " for " .. score .. " accepted " .. EP .. "/" .. GP, "RAID")
              end
          end
    end
    NoobDKP_UpdateAuction()
end

function NoobDKP_FindWinner()
  print("Finding winner...")
    local max_bid = 0
    local winners = {}
    local num_winners = 0;

    -- find what the high bid was
    for key, value in pairs(NOOBDKP_g_auction) do
        if key ~= "_item" and key ~= "_winner" then
            if value["_score"] > max_bid then
                max_bid = value["_score"]
            end
        end
    end

    -- now find who had the high bid
    for key, value in pairs(NOOBDKP_g_auction) do
        if key ~= "_item" and key ~= "_winner" then
            if value["_score"] == max_bid then
                table.insert(winners, key)
                num_winners = num_winners + 1
            end
        end
    end

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

    -- give every character in the list a random roll
    for key, value in pairs(char_list) do
        rolls[value] = random(1, 100)
    end

--    SendChatMessage("NoobDKP: Rolls are:", "RAID")
    for key, value in pairs(rolls) do
--        SendChatMessage(key .. " = " .. value, "RAID")
        NoobDKP_HandleAuctionResponse("roll", key, value)
    end

    -- determine which roll is the highest
    for key, value in pairs(rolls) do
        if value > high_roll then
            high_roll = value
        end
    end

    -- determine how many characters have the high roll (in case of another tie)
    for key, value in pairs(rolls) do
        if value == high_roll then
            table.insert(winners, key)
            num_winners = num_winners + 1
        end
    end

    -- if only one character had the high roll, we're done
    if num_winners == 1 then
        return winners
    else
      NoobDKP_HandleAuctionResponse("repeat")
--      SendChatMessage("NoobDKP: Tie detected. Rolling again...", "RAID")
        -- otherwise, take all the high rollers and roll again
        return NOOBDKP_break_tie(winners)
    end
end

function NoobDKP_ShowAuctionTab()
    local emptyAuction = getglobal("myTabPage3_emptyAuction")
    local fullAuction = getglobal("myTabPage3_Auction")
    if NOOBDKP_g_auction == nil then
        fullAuction:Hide()
        emptyAuction:Show()
        getglobal("myTabPage3_AuctionAddGP"):Disable()
        getglobal("myTabPage3_Auction_finishAuction"):Disable()
        if NOOBDKP_g_options["admin_mode"] then
          getglobal("myTabPage3_emptyAuction_createAuction"):Enable()
        else
          getglobal("myTabPage3_emptyAuction_createAuction"):Disable()
        end
    else
        (getglobal("myTabPage3_Auction_Item")):SetText("Auction for: " .. NOOBDKP_g_auction["_item"])
        NoobDKP_UpdateAuction()
        emptyAuction:Hide()
        fullAuction:Show()
    end
end

function NoobDKP_UpdateAuction()
    local nameFrame, priorityFrame, scoreFrame, EPFrame, GPFrame
    local pos = 1 -- index into the frame list

    local sortedList = NoobDKP_SortAuction()    

    for key, value in pairs(sortedList) do
        local name = value[2]
        local priority = NOOBDKP_g_auction[ value[2] ]["_type"]
        local score = NOOBDKP_g_auction[ value[2] ]["_score"]
        if key ~= "_item" and key ~= "_winner" then
            nameFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_name")
            nameFrame:SetText(name)
            local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[name][2])
            nameFrame:SetVertexColor(r, g, b, a)
            priorityFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_rank")
            priorityFrame:SetText(priority)
            scoreFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_score")
            scoreFrame:SetText(score)
            local score, ep, gp = NoobDKP_GetEPGP(name)
            EPFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_EP")
            EPFrame:SetText(ep)
            GPFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_GP")
            GPFrame:SetText(gp)
            pos = pos + 1
        end
    end

    if pos <= 10 then
        for j = pos, 10 do
            nameFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_name")
            nameFrame:SetText("")
            rankFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_rank")
            rankFrame:SetText("")
            scoreFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_score")
            scoreFrame:SetText("")
            EPFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_EP")
            EPFrame:SetText("")
            GPFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_GP")
            GPFrame:SetText("")
        end
    end

    if NOOBDKP_g_options["admin_mode"] then
      if pos >= 2 then -- if a bid is detected, allow finishing the auction
        getglobal("myTabPage3_Auction_finishAuction"):Enable()
        getglobal("myTabPage3_Auction_Amount"):Enable()
        getglobal("myTabPage3_AuctionAddGP"):Enable()
      end
    else
      getglobal("myTabPage3_Auction_finishAuction"):Disable()
      getglobal("myTabPage3_Auction_Amount"):Disable()
      getglobal("myTabPage3_AuctionAddGP"):Disable()
    end

end

function auctionCompare(a, b)
    return a[1] > b[1]
end

function NoobDKP_SortAuction()
    local sortedList = {}
    local needList = {}
    local greedList = {}

    -- find all need rolls and insert into needList
    for key, value in pairs(NOOBDKP_g_auction) do
        if key ~= "_item" and key ~= "_winner" and value["_type"] == "need" then
            local t = {value["_score"], key}
            table.insert(needList, t)
        end
    end
    -- sort needList by score
    table.sort(needList, auctionCompare)

    -- insert sorted needList into sortedList
    for key, value in pairs(needList) do
        table.insert(sortedList, value)
    end

    -- find all greed rolls and insert into greedList
    for key, value in pairs(NOOBDKP_g_auction) do
        if key ~= "_item" and key ~= "_winner" and value["_type"] == "greed" then
            local t = {value["_score"], key}
            table.insert(greedList, t)
        end
    end
    -- sort greedList by score
    table.sort(greedList, auctionCompare)

    -- insert sorted greedList into sortedList
    for key, value in pairs(greedList) do
        table.insert(sortedList, value)
    end

    return sortedList
end

function NoobDKP_GPtoWinner()
  local winner = NOOBDKP_g_auction["_winner"]
  local wingp = getglobal("myTabPage3_Auction_Amount"):GetText()
  if wingp == nil then
    wingp = NOOBDKP_g_options["defaultGP"]
  end

  SendChatMessage("NoobDKP: GP " .. wingp .. " to " .. winner, "RAID")
  local score, ep, gp = NoobDKP_GetEPGP(winner)
  gp = gp + wingp
  NoobDKP_SetOfficerNote(winner, ep, gp)
  NoobDKP_UpdateAuction()
  getglobal("myTabPage3_Auction_Amount"):ClearFocus()
end

function NoobDKP_QueryReply(name)
  name = NoobDKP_FixName(name)
  local score, ep, gp = NoobDKP_GetEPGP(name)
  SendChatMessage("NoobDKP: You have " .. ep .. " EP and " .. gp .. " GP for a score of " .. score, "WHISPER", nil, name)
end

function NoobDKP_HandleAuctionTab()
  local emptyAuction = getglobal("myTabPage3_emptyAuction")
  local fullAuction = getglobal("myTabPage3_Auction")
  if NOOBDKP_g_auction == nil then
      fullAuction:Hide()
      emptyAuction:Show()
  else
    (getglobal("myTabPage3_Auction_Item")):SetText("Auction for: " .. NOOBDKP_g_auction["_item"])
    emptyAuction:Hide()
      fullAuction:Show()
  end
end

function NoobDKP_HandleCreateAuction(item)
  print("Creating Auction for: " .. item)
  NOOBDKP_g_auction = nil
  NOOBDKP_g_auction = {_item = item}

  --[[
    local name, _, _, iLvl, _, _, _, _, iSlot = GetItemInfo(item)
    if name == nil then name = "" end
    if iLvl == nil then iLvl = "" end
    if iSlot == nil then iSlot = "" end
    print("name: " .. name .. " iLvl: " .. iLvl .. " slot: " .. iSlot)
  ]]
end

function NoobDKP_HandleAddBid(name, bid)
  if name == "" or name == nil or bid == "" or bid == nil then return end

  local score, ep, gp = NoobDKP_GetEPGP(name)
  NOOBDKP_g_auction[name] = {}
  NOOBDKP_g_auction[name]["_score"] = score

  if tonumber(ep) < NOOBDKP_g_options["min_EP"] and bid == "need" then
    bid = "greed"
    NoobDKP_HandleAuctionResponse("force_greed", name)
  end

  NOOBDKP_g_auction[name]["_type"] = bid
end

function NoobDKP_HandleDeclareWinner()
  local win_char, num_winners = NoobDKP_FindWinner()
  if num_winners > 1 then
    NoobDKP_HandleAuctionResponse("tie")
    win_char = NOOBDKP_break_tie(win_char)
  end
  NOOBDKP_g_auction["_winner"] = win_char[1]
  local score, ep, gp = NoobDKP_GetEPGP(win_char[1])
  NoobDKP_HandleAuctionResponse("win", win_char[1], NOOBDKP_g_auction["_item"], score)
  getglobal("myTabPage3_Auction_Winner"):SetText(win_char[1])
  local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[win_char[1] ][2])
  getglobal("myTabPage3_Auction_Winner"):SetVertexColor(r, g, b, a)
  getglobal("myTabPage3_AuctionAddGP"):Enable()
end

function NoobDKP_HandleAuctionGP()
  local winner = NOOBDKP_g_auction["_winner"]
  local wingp = getglobal("myTabPage3_Auction_Amount"):GetText()
  if wingp == nil or wingp == "" then wingp = NOOBDKP_g_options["defaultGP"] end

  local score, ep, gp = NoobDKP_GetEPGP(winner)
  gp = gp + wingp
  NoobDKP_SetEPGP(winner, ep, gp)
  NoobDKP_HandleUpdateAuction()
  getglobal("myTabPage3_Auction_Amount"):ClearFocus()
  NoobDKP_HandleAuctionResponse("gp", winner, gp)
end

function NoobDKP_HandleCloseAuction()
  NOOBDKP_g_auction = nil
  NoobDKP_HandleUpdateAuction()
  NoobDKP_HandleAuctionTab()
end

function NoobDKP_HandleAuctionResponse(type, ...)
  if NOOBDKP_g_options["admin_mode"] then
    print("HandleAuctionResponse for " .. type)
    if type == "item" then
      local item = ...
      SendChatMessage("NoobDKP: Auction starting for item " .. item, "RAID")
    elseif type =="force_greed" then
      local name = ...
      SendChatMessage("NoobDKP: " .. name .. " does not have " .. NOOBDKP_g_options["min_EP"] .. " EP, setting to greed bid", "RAID")
    elseif type == "bid" then
      local name, bid, score, ep, gp = ...
      SendChatMessage("NoobDKP: Bid " .. name .. " " .. bid .. " for " .. score .. " accepted " .. ep .. "/" .. gp, "RAID")
    elseif type == "tie" then
      SendChatMessage("NoobDKP: Breaking tie! Rolls are:", "RAID")
    elseif type == "roll" then
      local name, roll = ...
      SendChatMessage(name .. " = " .. roll, "RAID")
    elseif type == "repeat" then
      SendChatMessage("NoobDKP: Tie detected. Rolling again...", "RAID")
    elseif type == "win" then
      local name, item, score = ...
      SendChatMessage("NoobDKP: " .. name .. " wins the bid for " .. item .. " with a score of " .. score, "RAID")
    elseif type == "gp" then
      local name, gp = ...
      SendChatMessage("NoobDKP: GP " .. gp .. " to " .. name, "RAID")
    end
  end
end

function NoobDKP_HandleUpdateAuction()
  print("HandleUpdateAuction enter...")
  local nameFrame, priorityFrame, scoreFrame, EPFrame, GPFrame
  local pos = 1 -- index into the frame list

  local sortedList = NoobDKP_SortAuction()    

  for key, value in pairs(sortedList) do
      local name = value[2]
      local priority = NOOBDKP_g_auction[ value[2] ]["_type"]
      local score = NOOBDKP_g_auction[ value[2] ]["_score"]
      if key ~= "_item" and key ~= "_winner" then
          nameFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_name")
          nameFrame:SetText(name)
          local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[name][2])
          nameFrame:SetVertexColor(r, g, b, a)
          priorityFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_rank")
          priorityFrame:SetText(priority)
          scoreFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_score")
          scoreFrame:SetText(score)
          local score, ep, gp = NoobDKP_GetEPGP(name)
          EPFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_EP")
          EPFrame:SetText(ep)
          GPFrame = getglobal("myTabPage3_Auction_entry" .. pos .. "_GP")
          GPFrame:SetText(gp)
          pos = pos + 1
      end
  end

  if pos <= 10 then
      for j = pos, 10 do
          nameFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_name")
          nameFrame:SetText("")
          rankFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_rank")
          rankFrame:SetText("")
          scoreFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_score")
          scoreFrame:SetText("")
          EPFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_EP")
          EPFrame:SetText("")
          GPFrame = getglobal("myTabPage3_Auction_entry" .. j .. "_GP")
          GPFrame:SetText("")
      end
  end

  print("HandleUpdateAuction fixing buttons...")
  -- if a bid is detected, allow finishing the auction
  if NOOBDKP_g_options["admin_mode"] and pos >= 2 then 
    print("enabling...")
    getglobal("myTabPage3_Auction_finishAuction"):Enable()
    --    getglobal("myTabPage3_Auction_Amount"):Enable()
    getglobal("myTabPage3_AuctionAddGP"):Enable()
  else
    print("disabling 1...")
    getglobal("myTabPage3_Auction_finishAuction"):Disable()
    print("disabling 2...")
    --    getglobal("myTabPage3_Auction_Amount"):Disable()
    getglobal("myTabPage3_Auction_Amount"):ClearFocus()
    print("disabling 3...")
    getglobal("myTabPage3_AuctionAddGP"):Disable()
    print("disabling 4...")
  end
  print("HandleUpdateAuction exit!")
end

function NoobDKP_ShiftClickItem(item)
  NoobDKP_HandleCreateAuction(item)
  NoobDKP_HandleUpdateAuction()
  NoobDKP_HandleAuctionTab()
  NoobDKP_HandleAuctionResponse("item", item)

  --[[
  print("Starting auction for: " .. item)
  NOOBDKP_g_auction = nil
--  if NOOBDKP_g_auction == nil then
    NOOBDKP_g_auction = {_item = item}
    NoobDKP_ShowAuctionTab()

    local name, _, _, iLvl, _, _, _, _, iSlot = GetItemInfo(item)
    if name == nil then name = "" end
    if iLvl == nil then iLvl = "" end
    if iSlot == nil then iSlot = "" end
    print("name: " .. name .. " iLvl: " .. iLvl .. " slot: " .. iSlot)
    -- todo: construct option name, get from option table, set GP

    if NOOBDKP_g_options["admin_mode"] then
      SendChatMessage("NoobDKP: Auction starting for item " .. item, "RAID")
    end
 -- end
 ]]
end

hooksecurefunc("ChatEdit_InsertLink",NoobDKP_ShiftClickItem)
