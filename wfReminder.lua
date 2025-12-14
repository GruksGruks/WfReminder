-- wfReminder by Gruks
-- /wfReminder              -> prints "hi, I'm made by Gruks"
-- /wfReminder haswf          -> prints "yes" or "no" depending on weapon enchant
-- /wfReminder wftest on|off  -> manually show/hide test frame
-- Automatically checks every 5s and shows frame if no imbue (starts on login)

local wfFrame
local updateFrame
local lastCheck = 0

-------------------------------------------------
-- Create the WF frame
-------------------------------------------------
local function CreateWFFrame()
    if wfFrame then return end

    wfFrame = CreateFrame("Frame", "wfReminderWFFrame", UIParent)
    wfFrame:SetWidth(40)
    wfFrame:SetHeight(40)
    wfFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)

    wfFrame.texture = wfFrame:CreateTexture(nil, "BACKGROUND")
    wfFrame.texture:SetAllPoints(wfFrame)
    wfFrame.texture:SetTexture(0, 0, 0, 1)

    wfFrame.text = wfFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    wfFrame.text:SetText("WF")
    wfFrame.text:SetTextColor(1, 0, 0, 1)
    wfFrame.text:SetPoint("CENTER", wfFrame, "CENTER", 0, 0)

    wfFrame:Hide()
end

-------------------------------------------------
-- Check if weapon has an enchant
-------------------------------------------------
local function CheckWeaponEnchant()
    local hasMain, _, _, hasOff, _, _ = GetWeaponEnchantInfo()
    if wfFrame then
        if hasMain or hasOff then
            wfFrame:Hide()
        else
            wfFrame:Show()
        end
    end
end

-------------------------------------------------
-- Periodic check (every 5s)
-------------------------------------------------
local function StartWFCheckTimer()
    if updateFrame then return end

    updateFrame = CreateFrame("Frame", "wfReminderWFUpdateFrame", UIParent)
    updateFrame:SetScript("OnUpdate", function()
        local now = GetTime()
        if now - lastCheck >= 5 then
            lastCheck = now
            CheckWeaponEnchant()
        end
    end)
end

-------------------------------------------------
-- Slash command handler
-------------------------------------------------
local function WfReminderTestHandler(msg)
    msg = string.lower(msg or "")
    CreateWFFrame()
    StartWFCheckTimer()

    if msg == "haswf" then
        local hasMain, _, _, hasOff, _, _ = GetWeaponEnchantInfo()
        if hasMain or hasOff then
            DEFAULT_CHAT_FRAME:AddMessage("yes")
        else
            DEFAULT_CHAT_FRAME:AddMessage("no")
        end
        return
    end

    if msg == "wftest on" then
        wfFrame:Show()
        DEFAULT_CHAT_FRAME:AddMessage("WF frame shown")
        return
    elseif msg == "wftest off" then
        wfFrame:Hide()
        DEFAULT_CHAT_FRAME:AddMessage("WF frame hidden")
        return
    end

    DEFAULT_CHAT_FRAME:AddMessage("hi, I'm made by Gruks")
end

SlashCmdList = SlashCmdList or {}
SlashCmdList["WFREMINDER"] = WfReminderTestHandler
SLASH_WFREMINDER1 = "/wfReminder"

-------------------------------------------------
-- Auto-start on login
-------------------------------------------------
local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function()
    CreateWFFrame()
    StartWFCheckTimer()
    DEFAULT_CHAT_FRAME:AddMessage("WfReminder loaded - monitoring weapon imbues every 5s.")
end)