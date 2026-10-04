local addonName, ns = ...

ProfessionScraperDB = ProfessionScraperDB or {}

SLASH_PROFSCRAPE1 = "/pscrape"
SlashCmdList["PROFSCRAPE"] = function(msg)
    ns.ScrapeActiveProfession()
end

function ns.ScrapeActiveProfession()
    local charName = UnitName("player")
    local realmName = GetRealmName()
    local profName, count = nil, 0

    ProfessionScraperDB[realmName] = ProfessionScraperDB[realmName] or {}
    ProfessionScraperDB[realmName][charName] = ProfessionScraperDB[realmName][charName] or {}

    -- Check TradeSkillFrame (Alchemy, Blacksmithing, Tailoring, etc.)
    if TradeSkillFrame and TradeSkillFrame:IsShown() then
        profName = GetTradeSkillLine()
        if profName and profName ~= "UNKNOWN" then
            ProfessionScraperDB[realmName][charName][profName] = {}

            local numSkills = GetNumTradeSkills()
            for i = 1, numSkills do
                local skillName, skillType = GetTradeSkillInfo(i)
                if skillName and skillType ~= "header" then
                    local link = GetTradeSkillRecipeLink(i)
                    local recipeId = ""
                    if link then
                        recipeId = link:match("enchant:(%d+)") or link:match("item:(%d+)") or ""
                    end

                    local matsList = {}
                    local numReagents = GetTradeSkillNumReagents(i)
                    for r = 1, numReagents do
                        local reagentName, _, reagentCount = GetTradeSkillReagentInfo(i, r)
                        if reagentName then
                            table.insert(matsList, reagentName .. " (" .. reagentCount .. ")")
                        end
                    end
                    local matsString = table.concat(matsList, ", ")

                    ProfessionScraperDB[realmName][charName][profName][skillName] = {
                        id = recipeId,
                        mats = matsString
                    }
                    count = count + 1
                end
            end
        end

    -- Check CraftFrame (Enchanting)
    elseif CraftFrame and CraftFrame:IsShown() then
        profName = GetCraftName()
        if profName and profName ~= "UNKNOWN" then
            ProfessionScraperDB[realmName][charName][profName] = {}

            local numCrafts = GetNumCrafts()
            for i = 1, numCrafts do
                local skillName, _, craftType = GetCraftInfo(i)
                if skillName and craftType ~= "header" then
                    local link = GetCraftRecipeLink(i)
                    local recipeId = ""
                    if link then
                        recipeId = link:match("enchant:(%d+)") or link:match("item:(%d+)") or ""
                    end

                    local matsList = {}
                    local numReagents = GetCraftNumReagents(i)
                    for r = 1, numReagents do
                        local reagentName, _, reagentCount = GetCraftReagentInfo(i, r)
                        if reagentName then
                            table.insert(matsList, reagentName .. " (" .. reagentCount .. ")")
                        end
                    end
                    local matsString = table.concat(matsList, ", ")

                    ProfessionScraperDB[realmName][charName][profName][skillName] = {
                        id = recipeId,
                        mats = matsString
                    }
                    count = count + 1
                end
            end
        end
    end

    if profName and count > 0 then
        print(string.format("|cff00ff00[ProfessionScraper]|r Successfully scraped %d recipes for %s (%s). Opening export window...", count, profName, charName))
        ns.ShowExportWindow()
    else
        print("|cffff0000[ProfessionScraper]|r No open profession window detected, or 0 recipes found.")
        ns.ShowExportWindow()
    end
end

function ns.ShowExportWindow()
    if not ns.exportFrame then
        local f = CreateFrame("Frame", "ProfessionScraperExportFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(750, 450)
        f:SetPoint("CENTER")
        f:SetMovable(true)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f:Hide()

        f.title = f:CreateFontString(nil, "OVERLAY")
        f.title:SetFontObject("GameFontHighlight")
        f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0)
        f.title:SetText("Profession Scraper - Google Sheets Export")

        local sf = CreateFrame("ScrollFrame", "ProfessionScraperScrollFrame", f, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -32)
        sf:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 12)

        local eb = CreateFrame("EditBox", nil, sf)
        eb:SetMultiLine(true)
        eb:SetMaxLetters(999999)
        eb:SetFontObject("ChatFontNormal")
        eb:SetWidth(700)
        eb:SetAutoFocus(false)
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        
        f.editBox = eb
        ns.exportFrame = f
    end

    local textLines = {}
    -- Header row removed completely

    for realmName, chars in pairs(ProfessionScraperDB) do
        if type(chars) == "table" then
            for charName, profs in pairs(chars) do
                if type(profs) == "table" then
                    for profName, recipes in pairs(profs) do
                        if type(recipes) == "table" then
                            for recipeName, data in pairs(recipes) do
                                if type(data) == "table" then
                                    table.insert(textLines, string.format("%s\t%s\t%s\t%s\t%s\t%s", charName, realmName, profName, recipeName, data.id or "", data.mats or ""))
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    ns.exportFrame.editBox:SetText(table.concat(textLines, "\n"))
    ns.exportFrame:Show()
    ns.exportFrame.editBox:HighlightText()
end