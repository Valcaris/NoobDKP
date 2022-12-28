-- Slash command handler for auction commands
function NoobDKPHandleAuction(msg)
  local syntax =
    "auction\n-create [item]: creates an auction for item\n-cancel: cancels the active auction\n-finish ([character]): finishes the active auction, optionally overriding the default winner\n-bid [character] need|greed: adds a bid for character as need or greed"
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "create" then
    if args == "" then
      print(NoobDKP_color .. "No item found to create an auction!")
      print(NoobDKP_color .. syntax)
    else
      NoobDKP_CreateAuction(args)
    end
  elseif cmd == "cancel" then
    NoobDKP_HandleCloseAuction()
  elseif cmd == "finish" then
    NoobDKP_FinishAuction(args)
  elseif cmd == "bid" then
    if args == nil or args == "" then
      print(NoobDKP_color .. "No bid found!")
      print(NoobDKP_color .. syntax)
    else
      NoobDKP_BidAuction(args)
    end
  else
    print(NoobDKP_color .. syntax)
  end
end

-- Creates an auction
-- args = item text
function NoobDKP_CreateAuction(args)
  local _, _, item = string.find(args, "%s?(.*)")
  if NOOBDKP_g_auction ~= nil then
    print(NoobDKP_color .. "Auction already in progress! Cancel first!")
  else
    NoobDKP_ShiftClickItem(item)
  end
end

-- handles closing an auction
function NoobDKP_HandleCloseAuction()
  NOOBDKP_g_auction = nil
  NoobDKP_HandleAuctionTab()
end

-- Finishes an auction (declares a winner)
-- args = char to override the winner (optional)
function NoobDKP_FinishAuction(args)
  local _, _, char = string.find(args, "%s?(%w+)%s?")
  NoobDKP_HandleFinishAuction(char)

  local win_char = NOOBDKP_g_auction["_winner"]
  if win_char == "" then
    return
  end
  local score, ep, gp = NoobDKP_GetEPGP(win_char)
  NoobDKP_HandleAuctionResponse("win", win_char, NOOBDKP_g_auction["_item"], score)
  NoobDKP_HandleSyncAuctionFinish(win_char)
  NoobDKP_PrePopulateGP(NOOBDKP_g_auction["_item"])
end

function NoobDKP_HandleFinishAuction(char)
  char = NoobDKP_FixName(char)
  if NOOBDKP_g_auction == nil then
    print(NoobDKP_color .. "No auction in progress to finish!")
    return
  elseif char ~= nil and char ~= "" then
    print(NoobDKP_color .. "Overriding " .. char .. " as the winner!")
    NOOBDKP_g_auction["_winner"] = char
  else
    NoobDKP_FindTheWinner()
  end

  local win_char = NOOBDKP_g_auction["_winner"]
  if win_char == "" then
    return
  end
  local score, ep, gp = NoobDKP_GetEPGP(win_char)
  getglobal("noobDKP_page3_auction_Winner"):SetText(win_char)
  local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[win_char][2])
  getglobal("noobDKP_page3_auction_Winner"):SetVertexColor(r, g, b, a)
  getglobal("noobDKP_page3_auctionAddGP"):Enable()
end

-- handles declaring a winner for an auction
function NoobDKP_HandleDeclareWinner()
  NoobDKP_FindTheWinner()
  local win_char = NOOBDKP_g_auction["_winner"]
  if win_char == "" then
    print(NoobDKP_color .. "NoobDKP: No winner found!")
    return
  end
  local score, ep, gp = NoobDKP_GetEPGP(win_char)
  NoobDKP_HandleSyncAuctionFinish(win_char)
  NoobDKP_HandleAuctionResponse("win", win_char, NOOBDKP_g_auction["_item"], score)
  getglobal("noobDKP_page3_auction_Winner"):SetText(win_char)
  local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[win_char][2])
  getglobal("noobDKP_page3_auction_Winner"):SetVertexColor(r, g, b, a)
  getglobal("noobDKP_page3_auctionAddGP"):Enable()
end

-- Adds a bid to an auction (GUI version)
function NoobDKP_AddAuction(name, bid)
  if name == "" or name == nil or bid == "" or bid == nil then
    return
  end

  local score, ep, gp = NoobDKP_GetEPGP(name)
  NOOBDKP_g_auction[name] = {}
  NOOBDKP_g_auction[name]["_score"] = score

  if tonumber(ep) < NOOBDKP_g_options["min_EP"] and bid == "need" then
    bid = "greed"
    SendChatMessage(
      "NoobDKP: " .. name .. " does not have " .. NOOBDKP_g_options["min_EP"] .. " EP, setting to greed bid",
      "RAID"
    )
  end

  NOOBDKP_g_auction[name]["_type"] = bid
  SendChatMessage("NoobDKP: Bid " .. name .. " " .. bid .. " for " .. score .. " accepted " .. ep .. "/" .. gp, "RAID")
  getglobal("noobDKP_page3_auction_finishAuction"):Enable()
  NoobDKP_HandleUpdateAuction()
end

-- Adds a bid to an auction (chat handler version)
-- args = character + their bid ("need" or "greed")
function NoobDKP_BidAuction(args)
  if NOOBDKP_g_options["admin_mode"] == nil then
    return
  end

  local _, _, char, val = string.find(args, "%s?(%w+)%s?(.*)")
  char = NoobDKP_FixName(char)
  NoobDKP_AddAuction(char, val)
end

-- determines an auction winner
function NoobDKP_FindTheWinner()
  local numWinner = 0
  local winList = {}
  NOOBDKP_g_auction["_winner"] = ""

  -- first find all needs
  for key, value in pairs(NOOBDKP_g_auction) do
    if key ~= "_item" and key ~= "_winner" and value["_type"] == "need" then
      if value["DQ"] then
      else
        table.insert(winList, key)
        numWinner = numWinner + 1
      end
    end
  end

  -- if no needs, find all greeds
  if numWinner == 0 then
    for key, value in pairs(NOOBDKP_g_auction) do
      if key ~= "_item" and key ~= "_winner" and value["_type"] == "greed" then
        if value["DQ"] then
        else
          table.insert(winList, key)
          numWinner = numWinner + 1
        end
      end
    end
  end

  local max_bid = 0
  local max_bidders = {}
  local num_max_bidders = 0
  local max_bid_char = ""
  for _, char in pairs(winList) do
    local bid = NOOBDKP_g_auction[char]["_score"]
    if bid > max_bid then
      max_bid = bid
      max_bid_char = char
      max_bidders = {char}
      num_max_bidders = 1
    elseif bid == max_bid then
      table.insert(max_bidders, char)
      num_max_bidders = num_max_bidders + 1
    end
  end

  if num_max_bidders == 1 then
    NOOBDKP_g_auction["_winner"] = max_bid_char
  elseif num_max_bidders > 1 then
    max_bidders = NOOBDKP_break_tie(max_bidders)
    NOOBDKP_g_auction["_winner"] = max_bidders[1]
  end
end

-- Takes a list of characters that tied and does a /roll to break the tie
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

  for key, value in pairs(rolls) do
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
    -- otherwise, take all the high rollers and roll again
    return NOOBDKP_break_tie(winners)
  end
end

function auctionCompare(a, b)
  return a[1] > b[1]
end

-- Reorders the bidder list according to need then greed, then by score
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

-- Sends a reply when someone asks for their EPGP information
function NoobDKP_QueryReply(name)
  name = NoobDKP_FixName(name)
  local score, ep, gp = NoobDKP_GetEPGP(name)
  SendChatMessage(
    "NoobDKP: You have " .. ep .. " EP and " .. gp .. " GP for a score of " .. score,
    "WHISPER",
    nil,
    name
  )
end

-- Sends a reply when someone asks for EPGP help
function NoobDKP_HelpReply(name)
  name = NoobDKP_FixName(name)
  SendChatMessage(
    "NoobDKP: Whsiper me \"noob\" for your EPGP information. When a bid starts, say in raid chat \"need\" or \"greed\". You can say \"pass\" to clear your bid",
    "WHISPER",
    nil,
    name
  )
end

-- handles switching between an empty and an active auction tab in the GUI
function NoobDKP_HandleAuctionTab()
  local emptyAuction = getglobal("noobDKP_page3_empty_auction")
  local fullAuction = getglobal("noobDKP_page3_auction")
  if NOOBDKP_g_auction == nil then
    fullAuction:Hide()
    emptyAuction:Show()
    getglobal("noobDKP_page3_auctionAddGP"):Disable()
    getglobal("noobDKP_page3_auction_finishAuction"):Disable()
    getglobal("noobDKP_page3_auction_Winner"):SetText("No Winner")
    if NOOBDKP_g_options["admin_mode"] then
      getglobal("noobDKP_page3_empty_auction_create_auction"):Enable()
    else
      getglobal("noobDKP_page3_empty_auction_create_auction"):Disable()
    end
  else
    if NOOBDKP_g_auction ~= nil and NOOBDKP_g_auction["_item"] ~= nil then
    (getglobal("noobDKP_page3_auction_Item")):SetText("Auction for: " .. NOOBDKP_g_auction["_item"])
    emptyAuction:Hide()
    fullAuction:Show()
    end
  end
end

-- handles adding a bid to the auction
function NoobDKP_HandleAddBid(name, bid)
  if name == "" or name == nil or bid == "" or bid == nil then
    return
  end

  if bid == "pass" then
    NOOBDKP_g_auction[name] = {}
    return
  end

  if NOOBDKP_g_auction == nil then
    NOOBDKP_g_auction = {}
  end

  local score, ep, gp = NoobDKP_GetEPGP(name)
  NOOBDKP_g_auction[name] = {}
  NOOBDKP_g_auction[name]["_score"] = score
  NOOBDKP_g_auction[name]["_type"] = bid
end

-- handles if an item is indicated to be heroic
-- This allows for minimum EP bids on heroics
function NoobDKP_HandleHeroicItemBid(name, bid)
  print(NoobDKP_color .. "Handling Heroic Item Bid...")
  local box = getglobal("noobDKP_page3_auctionIsHeroic")
  if box:GetChecked() then
    local score, ep, gp = NoobDKP_GetEPGP(name)
    local hero = NOOBDKP_g_options["min_EP_heroics"]
    -- check that the config value is valid and non zero,
    -- that the bidder doesn't have enough EP,
    -- and that they tried to bid need.
    -- If so, force the bid to greed.
    if hero ~= nil and hero ~= 0 and tonumber(ep) < hero and bid == "need" then
      bid = "greed"
      NoobDKP_HandleAuctionResponse("force_greed", name)
      NOOBDKP_g_auction[name]["_type"] = bid
    end
  end
  return bid
end

-- handles adding GP to the winner of an auction
function NoobDKP_HandleAuctionGP()
  local winner = NOOBDKP_g_auction["_winner"]
  local wingp = getglobal("noobDKP_page3_auction_amount"):GetText()
  if wingp == nil or wingp == "" then
    wingp = NOOBDKP_g_options["defaultGP"]
  end
  wingp = tonumber(wingp)

  local score, ep, gp = NoobDKP_GetEPGP(winner)
  gp = gp + wingp
  NoobDKP_SetEPGP(winner, ep, gp)
  NoobDKP_HandleUpdateAuction()
  getglobal("noobDKP_page3_auction_amount"):ClearFocus()
  NoobDKP_HandleAuctionResponse("gp", winner, wingp)
  NoobDKP_HandleSyncEPGP(winner, ep, gp)
  local item = NOOBDKP_g_auction["_item"]

  local chars = { winner }
  NoobDKP_Event_AddEntry(0, wingp, item, chars, 0)
end

-- handles sending messages to the raid during an auction
function NoobDKP_HandleAuctionResponse(type, ...)
  if NOOBDKP_g_options["admin_mode"] then
    if type == "item" then
      local item = ...
      SendChatMessage("NoobDKP: Auction starting for item " .. item, "RAID_WARNING")
      SendChatMessage("NoobDKP: Auction starting for item " .. item, "RAID")
      if NOOBDKP_g_loot_table[item] ~= nil and NOOBDKP_g_options["loot_need_greed"] then
        local need = NOOBDKP_g_loot_table[item]["need"]
        if need ~= nil and need ~= "" then
          SendChatMessage("NoobDKP: Need = " .. need, "RAID")
        end
        local greed = NOOBDKP_g_loot_table[item]["greed"]
        if greed ~= nil and greed ~= "" then
          SendChatMessage("NoobDKP: Greed = " .. greed, "RAID")
        end
      end
    elseif type == "force_greed" then
      local name = ...
      SendChatMessage(
        "NoobDKP: " .. name .. " does not have " .. NOOBDKP_g_options["min_EP_heroics"] .. " EP, setting to greed bid",
        "RAID"
      )
    elseif type == "bid_pass" then
      local name = ...
      SendChatMessage(
        "NoobDKP: Pass " .. name .. " is passing this roll",
        "RAID"
      )
    elseif type == "bid" then
      local name, bid, score, ep, gp = ...
      SendChatMessage(
        "NoobDKP: Bid " .. name .. " " .. bid .. " for " .. score .. " accepted " .. ep .. "/" .. gp,
        "RAID"
      )
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
      SendChatMessage("NoobDKP: " .. gp .. " GP added to " .. name, "RAID")
    elseif type == "DQ" then
      local name = ...
      if NOOBDKP_g_auction[name]["DQ"] then
        SendChatMessage("NoobDKP: " .. name .. " is disqualified from this bid", "RAID")
      else
        SendChatMessage("NoobDKP: " .. name .. " is qualified again for this bid", "RAID")
      end
    end
  end
end

-- handles updating the auction GUI
function NoobDKP_HandleUpdateAuction()
  local nameFrame, priorityFrame, scoreFrame, EPFrame, GPFrame, DQBox
  local pos = 1 -- index into the frame list

  -- Add a warning if no event is active. May not want to do auctions without an event.
  if NOOBDKP_g_events == nil or NOOBDKP_g_events["active_raid"] == nil then
    getglobal("noobDKP_page3_warning"):Show()
  else
    getglobal("noobDKP_page3_warning"):Hide()
  end

  local sortedList = NoobDKP_SortAuction()

  for key, value in pairs(sortedList) do
    if pos < 10 then
    local name = value[2]
    local priority = NOOBDKP_g_auction[value[2]]["_type"]
    local score = NOOBDKP_g_auction[value[2]]["_score"]
    if key ~= "_item" and key ~= "_winner" then
      nameFrame = getglobal("noobDKP_page3_auction_entry" .. pos .. "_name")
      nameFrame:SetText(name)
      local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[name][2])
      nameFrame:SetVertexColor(r, g, b, a)
      priorityFrame = getglobal("noobDKP_page3_auction_entry" .. pos .. "_rank")
      priorityFrame:SetText(priority)
      scoreFrame = getglobal("noobDKP_page3_auction_entry" .. pos .. "_score")
      scoreFrame:SetText(score)
      local score, ep, gp = NoobDKP_GetEPGP(name)
      EPFrame = getglobal("noobDKP_page3_auction_entry" .. pos .. "_EP")
      EPFrame:SetText(ep)
      GPFrame = getglobal("noobDKP_page3_auction_entry" .. pos .. "_GP")
      GPFrame:SetText(gp)
      DQBox = getglobal("noobDKP_page3_auction_entry" .. pos .. "_DQ")
      if NOOBDKP_g_auction[name]["DQ"] then
        DQBox:SetChecked(true)
      else
        DQBox:SetChecked(false)
      end
      DQBox:Show()
      pos = pos + 1
    end
    end
  end

  if pos <= 10 then
    for j = pos, 10 do
      nameFrame = getglobal("noobDKP_page3_auction_entry" .. j .. "_name")
      nameFrame:SetText("")
      rankFrame = getglobal("noobDKP_page3_auction_entry" .. j .. "_rank")
      rankFrame:SetText("")
      scoreFrame = getglobal("noobDKP_page3_auction_entry" .. j .. "_score")
      scoreFrame:SetText("")
      EPFrame = getglobal("noobDKP_page3_auction_entry" .. j .. "_EP")
      EPFrame:SetText("")
      GPFrame = getglobal("noobDKP_page3_auction_entry" .. j .. "_GP")
      GPFrame:SetText("")
      DQBox = getglobal("noobDKP_page3_auction_entry" .. j .. "_DQ")
      DQBox:Hide()
    end
  end

  -- if a bid is detected, allow finishing the auction
  if NOOBDKP_g_options["admin_mode"] and pos >= 2 then
    getglobal("noobDKP_page3_auction_finishAuction"):Enable()
    getglobal("noobDKP_page3_auctionAddGP"):Enable()
    if NOOBDKP_g_auction["_winner"] ~= "" and NOOBDKP_g_auction["_winner"] ~= nil then
      local winner = NOOBDKP_g_auction["_winner"]
      getglobal("noobDKP_page3_auction_Winner"):SetText(winner)
      local r, g, b, a = NoobDKP_getClassColor(NOOBDKP_g_roster[winner][2])
      getglobal("noobDKP_page3_auction_Winner"):SetVertexColor(r, g, b, a)
    end
  else
    getglobal("noobDKP_page3_auction_finishAuction"):Disable()
    getglobal("noobDKP_page3_auction_amount"):ClearFocus()
    getglobal("noobDKP_page3_auctionAddGP"):Disable()
  end
end

-- handles adding an item to the loot table (see Populate Loot Table in Options tab)
function NoobDKP_PopulateLootTable(item)
  if NOOBDKP_g_loot_table[item] == nil or NOOBDKP_g_loot_table[item] == "" then
    print(NoobDKP_color .. "Populating Loot Table with " .. item)
    NOOBDKP_g_loot_table[item] = {}
    NOOBDKP_g_loot_table[item]["need"] = {}
    NOOBDKP_g_loot_table[item]["greed"] = {}
  end
end

-- sets a character as disqualified, for this auction only
function NoobDKP_Disqualify(button)
  local _, _, index = string.find(button:GetName(), "%s?noobDKP_page3_auction_entry(%w)_DQ")
  local char = getglobal("noobDKP_page3_auction_entry" .. index .. "_name"):GetText()
  NOOBDKP_g_auction[char]["DQ"] = button:GetChecked()
  NoobDKP_HandleAuctionResponse("DQ", char)
end

function NoobDKP_PrePopulateGP(item)
  local _, _, _, _, _, itemType, itemSubType, _, equipLoc = GetItemInfo(item)

  -- determine if the item is a mark. Note this is probably not the best
  -- method, but it seems to work since looking at a miscellaneous
  -- item type may be a lot of things.
  if equipLoc == nil or equipLoc == "" and itemType == "Miscellaneous" then
    equipLoc = "MARK"
  end

  -- determine if item is heroic version. Would be nice if there was a
  -- way to get this from the item or WoW, but having the user handle it
  -- seems to work for now
  if getglobal("noobDKP_page3_auctionIsHeroic"):GetChecked() then
    equipLoc = "HC_" .. equipLoc
  end

  local gp = NOOBDKP_g_options[equipLoc]

  if gp == nil then
    gp = ""
  end

  local win_char = NOOBDKP_g_auction["_winner"]

  if(win_char ~= nil
  and (NOOBDKP_g_auction[win_char]["_type"] == "greed")
  and (NOOBDKP_g_options["greed_discount"])) then
    local discount = tonumber(NOOBDKP_g_options["greed_discount_percent"])
    gp = gp * (1 - (discount / 100))
    print(NoobDKP_color .. "Greed discount applied!")
  end

  getglobal("noobDKP_page3_auction_amount"):SetText(gp)
end

function NoobDKP_IsHeroicChanged()
  local item = NOOBDKP_g_auction["_item"]
  NoobDKP_PrePopulateGP(item)
end

function NoobDKP_IsGreedDiscountChanged()
  local value = getglobal("noobDKP_page3_auctionIsGreedDiscount"):GetChecked()
  NOOBDKP_g_options["greed_discount"] = value
end

-- handler when an item is shift-clicked (creates auction if valid)
function NoobDKP_ShiftClickItem(item)
  if getglobal("noobMainFrame"):IsShown() then
    NoobDKP_HandleItemAuction(item)
    NoobDKP_HandleAuctionResponse("item", item)
    NoobDKP_SyncAuctionItem(item)
  end
  if NOOBDKP_g_options["loot_table"] then
    NoobDKP_PopulateLootTable(item)
  end
end

-- helper function for handling when an item is added to an auction
function NoobDKP_HandleItemAuction(item)
  NOOBDKP_g_auction = nil
  NOOBDKP_g_auction = {}
  NOOBDKP_g_auction["_item"] = item
  NoobDKP_HandleUpdateAuction()
  NoobDKP_HandleAuctionTab()
  NoobDKP_PrePopulateGP(item)
end

hooksecurefunc("ChatEdit_InsertLink", NoobDKP_ShiftClickItem)
