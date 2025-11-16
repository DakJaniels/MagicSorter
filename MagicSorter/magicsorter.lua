---@class MSorter : ZO_InitializingObject
local MSorter = ZO_InitializingObject:Subclass()

EVENT_MANAGER:RegisterForEvent("MagicSorter", EVENT_ADD_ONS_LOADED, function (event)
    EVENT_MANAGER:UnregisterForEvent("MagicSorter", EVENT_ADD_ONS_LOADED)
    MAGIC_SORTER = MSorter:New()
end)

function MSorter:Initialize()
    if not self.initialized then
        self.initialized = true
        self.quickSortMode = false
        self:InitializeStaticData()
        self:InitializeSavedVariables()
        self:InitializeManagers()
        self:InitializeDialogs()
        self:InitializeEventHandlers()
    end
end

function MSorter:InitializeStaticData()
    self.AddonVersion = 25
    self.AddonName = "MagicSorter"
    self.AddonDev = "Architectura"
    self.EventDescriptor = "magicsorter"
    self.KeybindButtons =
    {
        alignment = KEYBIND_STRIP_ALIGN_CENTER,
        {
            name = "Magic Sorter",
            keybind = "UI_SHORTCUT_REPORT_PLAYER",
            callback = GenerateFlatClosure(self.StartStorageWizard, self),
            visible = function ()
                return true
            end,
        },
    }
    self.KeybindId = "MAGIC_SORTER"
    self.MaxHouseId = 300
    self.MaxKeybind = 4
    self.MinKeybind = 1
    self.SavedVarsDefaults = { Data = { HouseCategories = {} } }
    self.SavedVarsFilename = "MagicSorter"
    self.SavedVarsVersion = 1

    self.InvalidParentCategoryIds =
    {
        [16] = true, -- Mounts
        [25] = true, -- Services
        [33] = true, -- Non-combat Pets
    }
    self.InvalidSubcategoryIds =
    {
        ["9_90"] = true,  -- Gallery, Undaunted Busts
        ["9_157"] = true, -- Gallery, Undaunted Trophies
        ["9_184"] = true, -- Gallery, ESO Plus
    }
    -- Sentinel values for uncategorized furniture (items without valid category/subcategory)
    self.FURNITURE_NEEDS_CATEGORIZATION_CATEGORY_ID = 0
    self.FURNITURE_NEEDS_CATEGORIZATION_SUBCATEGORY_ID = 0
end

function MSorter:CleanSavedVariables()
    local data = self:GetData()
    -- Remove any references to the master "Furniture" category.
    local houses = self:GetStorageHouses()
    for _, house in pairs(houses) do
        if house.assignedCategoryIds then
            house.assignedCategoryIds[1] = nil
        end
    end
end

function MSorter:InitializeSavedVariables()
    if not self.Vars then
        self.Vars = ZO_SavedVars:NewAccountWide(self.SavedVarsFilename, self.SavedVarsVersion, nil, self.SavedVarsDefaults)
        if not self.Vars.Config then
            self.Vars.Config = {}
        end
        if not self.Vars.Data then
            self.Vars.Data = {}
        end
        self:CleanSavedVariables()
    end
end

function MSorter:InitializeManagers()
    if not self.inventoryManager then
        self.inventoryManager = InstantiateMagicInventoryManager(self)
    end
    if not self.sortManager then
        self.sortManager = InstantiateMagicSortManager(self)
    end
end

function MSorter:InitializeEventHandlers()
    if not self.initializedEventHandlers then
        self.initializedEventHandlers = true
        EVENT_MANAGER:RegisterForEvent(self.EventDescriptor, EVENT_PLAYER_ACTIVATED, GenerateClosure(self.OnPlayerActivated, self))
        local function OnSceneStateChange(oldState, newState)
            if newState == "shown" then
                self:UpdateKeybindStrip(true)
            elseif newState == "hidden" then
                self:UpdateKeybindStrip(false)
            end
        end
        local inventoryScene = SCENE_MANAGER:GetScene("inventory")
        if inventoryScene then
            inventoryScene:RegisterCallback("StateChange", OnSceneStateChange)
        end
        local keyboardHousingScene = SCENE_MANAGER:GetScene("keyboard_housing_furniture_scene")
        if keyboardHousingScene then
            keyboardHousingScene:RegisterCallback("StateChange", OnSceneStateChange)
        end
        local gamepadHousingScene = SCENE_MANAGER:GetScene("gamepad_housing_furniture_scene")
        if gamepadHousingScene then
            gamepadHousingScene:RegisterCallback("StateChange", OnSceneStateChange)
        end
        local function OnFurnitureChanged(...)
            local manager = self:GetSortManager()
            if manager then
                manager:OnFurnitureChanged(...)
            end
        end
        local function OnActivityFinderStatusUpdate(event, status)
            if self:IsAutomaticStorageRunning() and status == ACTIVITY_FINDER_STATUS_READY_CHECK then
                self:SuspendAutomaticStorage()
                self:GetSortManager():LogAction("Ready check initiated; suspending sort operation.")
            end
        end
        EVENT_MANAGER:RegisterForEvent(self.EventDescriptor, EVENT_HOUSING_FURNITURE_PLACED, OnFurnitureChanged)
        EVENT_MANAGER:RegisterForEvent(self.EventDescriptor, EVENT_HOUSING_FURNITURE_REMOVED, OnFurnitureChanged)
        EVENT_MANAGER:RegisterForEvent(self.EventDescriptor, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
    end
end

function MSorter:InitializeKeybinds()
    if not self.initializedKeybinds then
        self.initializedKeybinds = true
        KEYBINDING_MANAGER.IsChordingAlwaysEnabled = function ()
            return true
        end
        ZO_CreateStringId("SI_BINDING_NAME_" .. self.KeybindId, "Magic Sorter")
        self:CreateKeybind(self.KeybindId, KEY_F10, 0, 0, 0, 0)
    end
end

function MSorter:GetVersion()
    return self.AddonVersion
end

function MSorter:GetConfig()
    return self.Vars.Config
end

function MSorter:GetData()
    return self.Vars.Data
end

function MSorter:SetQuickSortMode(enabled)
    self.quickSortMode = true == enabled
end

function MSorter:IsQuickSortMode()
    return true == self.quickSortMode and not self:HaveSettingsChanged()
end

function MSorter:RotateTexture(texture, angle, centerX, centerY, scaleX, scaleY)
    angle, centerX, centerY, scaleX, scaleY = angle or 0, centerX or 0.5, centerY or 0.5, scaleX or 1, scaleY or 1
    local cosine, sine = zo_cos(angle), zo_sin(angle)
    local x1, y1 = -0.5 * sine + -0.5 * cosine, -0.5 * cosine - -0.5 * sine
    local x2, y2 = -0.5 * sine + 0.5 * cosine, -0.5 * cosine - 0.5 * sine
    local x3, y3 = 0.5 * sine + -0.5 * cosine, 0.5 * cosine - -0.5 * sine
    local x4, y4 = 0.5 * sine + 0.5 * cosine, 0.5 * cosine - 0.5 * sine
    texture:SetVertexUV(1, centerX + scaleX * x1, centerY + scaleY * y1)
    texture:SetVertexUV(2, centerX + scaleX * x2, centerY + scaleY * y2)
    texture:SetVertexUV(4, centerX + scaleX * x3, centerY + scaleY * y3)
    texture:SetVertexUV(8, centerX + scaleX * x4, centerY + scaleY * y4)
end

function MSorter:CreateKeybind(binding, key, modifier1, modifier2, modifier3, modifier4)
    local layer, category, action = GetActionIndicesFromName(binding)
    if GetBindingIndicesFromKeys(layer, key, modifier1, modifier2, modifier3, modifier4) then
        return
    end
    for keybind = self.MinKeybind, self.MaxKeybind do
        if GetActionBindingInfo(layer, category, action, keybind) ~= KEY_INVALID then
            return
        end
    end
    if IsProtectedFunction("BindKeyToAction") then
        CallSecureProtected("BindKeyToAction", layer, category, action, self.MinKeybind, key, modifier1, modifier2, modifier3, modifier4)
    else
        BindKeyToAction(layer, category, action, self.MinKeybind, key, modifier1, modifier2, modifier3, modifier4)
    end
end

function MSorter:InitializeDialogs()
    self.dialogs = {}
    self.dialogs["HouseSelection"] = { control = GetControl("MagicSorter_HouseSelection") }
    self.dialogs["CategoryAssignment"] = { control = GetControl("MagicSorter_CategoryAssignment") }
    self.dialogs["ThemeAssignment"] = { control = GetControl("MagicSorter_ThemeAssignment") }
    self.dialogs["Disclaimer"] = { control = GetControl("MagicSorter_Disclaimer") }
    self.dialogs["StorageProgress"] = { control = GetControl("MagicSorter_StorageProgress") }
    self.dialogs["Complete"] = { control = GetControl("MagicSorter_Complete") }
    self.dialogs["ReportInventory"] = { control = GetControl("MagicSorter_ReportInventory") }
    local version = string.format("Version %.1f", self:GetVersion())
    for dialogName, dialog in pairs(self.dialogs) do
        dialog.name = dialogName
        local versionLabel = dialog.control:GetNamedChild("Version")
        if versionLabel then
            versionLabel:SetText(version)
        end
    end
end

function MSorter:GetDialog(dialogName)
    return self.dialogs[dialogName]
end

function MSorter:GetDialogControl(dialogName)
    return self:GetDialog(dialogName).control
end

function MSorter:GetDialogsByVisibility(isHidden)
    local dialogs = {}
    for dialogName, dialog in pairs(self.dialogs) do
        if dialog.control:IsHidden() == isHidden then
            table.insert(dialogs, dialog)
        end
    end
    return dialogs
end

function MSorter:GetDialogName(control)
    for dialogName, dialog in pairs(self.dialogs) do
        if dialog.control == control then
            return dialogName
        end
    end
    return nil
end

function MSorter:GetDialogSettings(dialogName)
    if not dialogName or dialogName == "" then
        return nil
    end

    local settings = self:GetConfig().DialogSettings
    if not settings then
        settings = {}
        self:GetConfig().DialogSettings = settings
    end

    local dialogSettings = settings[dialogName]
    if not dialogSettings then
        dialogSettings = {}
        settings[dialogName] = dialogSettings
    end

    return dialogSettings
end

function MSorter:IsDialogHidden(dialogName)
    local control = self:GetDialogControl(dialogName)
    return control:IsHidden()
end

function MSorter:SetAllDialogsHidden()
    for dialogName, dialog in pairs(self.dialogs) do
        dialog.control:SetHidden(true)
    end
end

function MSorter:SetupAndDockReportSummaryToDialog(report, control)
    local summary = GetControl("MagicSorter_ReportSummary")
    local panel = summary.panel
    local slider = summary.slider
    local message = summary.message
    local container = message:GetParent()
    local reportLines = {}
    for lineIndex, line in ipairs(report) do
        if line == "" then
            break
        end
        table.insert(reportLines, line)
    end
    message:SetText(table.concat(reportLines, "\n"))
    summary:ClearAnchors()
    summary:SetAnchor(RIGHT, control, LEFT, -15)
    summary:SetHidden(false)
    zo_callLater(GenerateClosure(self.UpdateReportSummaryLayout, self, message, container, slider, panel), 400)
end

function MSorter:UpdateReportSummaryLayout(message, container, slider, panel)
    local height = message:GetTextHeight()
    container:SetHeight(height)
    slider:SetMinMax(0, zo_max(0, height - panel:GetHeight()))
end

function MSorter:RefreshReportSummaryHiddenState()
    local summary = GetControl("MagicSorter_ReportSummary")
    local sortManager = self:GetSortManager()
    if sortManager then
        local report = sortManager:GetLastReport()
        if "table" == type(report) and #report > 0 then
            for dialogName, dialog in pairs(self.dialogs) do
                if dialogName == "HouseSelection" or dialogName == "CategoryAssignment" then
                    if not dialog.control:IsHidden() then
                        self:SetupAndDockReportSummaryToDialog(report, dialog.control)
                        return
                    end
                end
            end
        end
    end
    summary:SetHidden(true)
    summary:ClearAnchors()
end

function MSorter:SetDialogHidden(dialogName, isHidden)
    local control = self:GetDialogControl(dialogName)
    if not isHidden then
        if control.Refresh then
            control:Refresh()
        end
        if control.backdropAnimation then
            control.backdropAnimation:PlayForward()
        end
        self:SetUIMode(true)
    end
    control:SetHidden(isHidden)
    self:RefreshReportSummaryHiddenState()
end

function MSorter:ToggleDialogHidden(dialogName)
    local hide = not self:IsDialogHidden(dialogName)
    if hide then
        self:SetDialogHidden(dialogName, true)
    else
        SCENE_MANAGER:Show("hud")
        HousingEditorRequestModeChange(HOUSING_EDITOR_MODE_DISABLED)
        local visibleDialogs = self:GetDialogsByVisibility(false)
        if ZO_IsTableEmpty(visibleDialogs) then
            self:SetDialogHidden(dialogName, false)
        end
    end
    self:RefreshReportSummaryHiddenState()
end

function MSorter:SetUIMode(enabled)
    if enabled then
        zo_callLater(GenerateFlatClosure(self.EnableUIMode, self), 50)
    else
        zo_callLater(GenerateFlatClosure(self.DisableUIMode, self), 50)
    end
end

function MSorter:EnableUIMode()
    if not IsGameCameraUIModeActive() then
        SetGameCameraUIMode(true)
    end
end

function MSorter:DisableUIMode()
    if IsGameCameraUIModeActive() then
        SetGameCameraUIMode(false)
    end
end

function MSorter:ShowCompleteDialog()
    if self:GetData().showCompleteDialog then
        self:SetDialogHidden("Complete", false)
    end
end

function MSorter:StartStorageWizard()
    local visibleDialogs = self:GetDialogsByVisibility(false)
    if visibleDialogs and #visibleDialogs > 0 and not self:IsAutomaticStorageRunning() then
        self:SetAllDialogsHidden()
    else
        self:ToggleDialogHidden("HouseSelection")
    end
end

function MSorter:OnDialogMoved(control)
    --self:SaveDialogSettings(control)
end

function MSorter:OnDialogShow(control)
    --self:RestoreDialogSettings(control)
end

function MSorter:OnSettingsChanged()
    self:GetConfig().dirty = true
end

function MSorter:OnSortCompleted(report)
    self:GetData().lastReport = report
    self:GetConfig().dirty = false
end

function MSorter:HaveSettingsChanged()
    return true == self:GetConfig().dirty
end

function MSorter:SaveDialogSettings(control)
    local settings = self:GetDialogSettings(self:GetDialogName(control))
    if settings then
        local left, top, right, bottom = control:GetScreenRect()
        settings.left = left or settings.left
        settings.top = top or settings.top
        settings.right = right or settings.right
        settings.bottom = bottom or settings.bottom
    end
end

function MSorter:RestoreDialogSettings(control)
    if not control.restoredDialogSettings then
        control.restoredDialogSettings = true
        local settings = self:GetDialogSettings(self:GetDialogName(control))
        if settings then
            local left, top, right, bottom = control:GetScreenRect()
            left = settings.left or left
            top = settings.top or top
            right = settings.right or right
            bottom = settings.bottom or bottom
            local width, height = right - left, bottom - top
            control:ClearAnchors()
            control:SetDimensions(width, height)
            control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
            if control.Refresh then
                control:Refresh()
            end
        end
    end
end

function MSorter:GetMouseOverControl(controls)
    local mouseX, mouseY = GetUIMousePosition()
    for key, control in pairs(controls) do
        if not control:IsHidden() then
            local minX, minY, maxX, maxY = control:GetScreenRect()
            if mouseX >= minX and mouseX <= maxX and mouseY >= minY and mouseY <= maxY then
                return control, key
            end
        end
    end
    return nil
end

function MSorter:SetOrganizationEnabled(enabled)
    if nil ~= enabled then
        self:GetConfig().isOrganizationEnabled = enabled
    end
end

function MSorter:IsOrganizationEnabled()
    local enabled = self:GetConfig().isOrganizationEnabled
    if nil == enabled then
        return true
    else
        return enabled
    end
end

function MSorter:GetOwnedHouses()
    local houses = {}
    for houseId = 1, self.MaxHouseId do
        local collectibleId = GetCollectibleIdForHouse(houseId)
        local owned = IsCollectibleUnlocked(collectibleId)
        if owned then
            local houseName = GetCollectibleName(collectibleId)
            local houseNameCleaned = ZO_CachedStrFormat("<<C:1>>", houseName)
            local _, _, houseIcon = GetCollectibleInfo(collectibleId)
            local houseImage = GetHousePreviewBackgroundImage(houseId)
            local house = { collectibleId = collectibleId, houseId = houseId, houseName = houseNameCleaned, houseIcon = houseIcon, houseImage = houseImage, assignedCategoryIds = {}, assignedThemeIds = {} }
            table.insert(houses, house)
        end
    end
    table.sort(houses, function (houseA, houseB)
        return houseA.houseName < houseB.houseName
    end)
    return houses
end

function MSorter:SetStorageHouses(houses)
    if houses then
        local previousHouses = {}
        for houseId in pairs(self:GetData().StorageHouses or {}) do
            previousHouses[houseId] = true
        end
        local houseData = {}
        for _, house in pairs(houses) do
            houseData[house.houseId] = house
        end
        self:GetData().StorageHouses = houseData
        local changed = false
        for houseId in pairs(houseData) do
            if not previousHouses[houseId] then
                changed = true
                break
            end
            previousHouses[houseId] = nil
        end
        if changed or not ZO_IsTableEmpty(previousHouses) then
            self:OnSettingsChanged()
        end
        return true
    end
    return false
end

function MSorter:GetStorageHouses()
    local houses = self:GetData().StorageHouses
    if not houses then
        houses = {}
        self:GetData().StorageHouses = houses
    end
    return houses
end

function MSorter:GetStorageHouse(houseId)
    return self:GetStorageHouses()[houseId]
end

function MSorter:OnSubmitStorageHouses(houses)
    local storageHouses = {}
    local numHouses = 0
    for _, house in ipairs(houses) do
        local storageHouse = self:GetStorageHouse(house.houseId)
        if not storageHouse then
            storageHouse = house
        end
        storageHouses[house.houseId] = storageHouse
        numHouses = numHouses + 1
    end
    if numHouses == 0 then
        return nil
    end
    return self:SetStorageHouses(storageHouses)
end

function MSorter:OnSubmitCategoryAssignments()
    for _, house in pairs(self:GetStorageHouses()) do
        if house.assignedCategoryIds and not ZO_IsTableEmpty(house.assignedCategoryIds) then
            return true
        end
    end
    return false
end

function MSorter:AddFurnitureCategory(categoryId, parentCategoryId, parentCategoryName)
    -- Handle "Needs Categorization" fake category
    if categoryId == self.FURNITURE_NEEDS_CATEGORIZATION_CATEGORY_ID then
        local category = self.furnitureCategories[categoryId]
        if category then
            return category
        else
            category = { 
                id = categoryId, 
                parentId = 0, 
                name = "Needs Categorization", 
                displayName = "Needs Categorization", 
                assignedHouseIds = {} 
            }
            self.furnitureCategories[categoryId] = category
            return category
        end
    end
    
    -- Ignore the master "Furniture" category.
    if categoryId and categoryId ~= 0 and categoryId ~= 1 then
        local category = self.furnitureCategories[categoryId]
        if category then
            return category
        else
            local categoryName = GetFurnitureCategoryName(categoryId)
            local displayName
            if parentCategoryId and parentCategoryName then
                displayName = string.format("%s, %s", parentCategoryName, categoryName)
            else
                displayName = string.format("%s, All", categoryName)
            end
            category = { id = categoryId, parentId = parentCategoryId or 0, name = categoryName, displayName = displayName, assignedHouseIds = {} }
            self.furnitureCategories[categoryId] = category
            return category
        end
    end
end

function MSorter:IsValidFurnitureCategory(categoryId, subcategoryId)
    if not subcategoryId then
        return not self.InvalidParentCategoryIds[categoryId]
    else
        return not self.InvalidSubcategoryIds[string.format("%d_%d", categoryId, subcategoryId)]
    end
end

function MSorter:GetFurnitureCategories()
    if not self.furnitureCategories then
        self.furnitureCategories = {}
        -- Add "Needs Categorization" fake category first
        self:AddFurnitureCategory(self.FURNITURE_NEEDS_CATEGORIZATION_CATEGORY_ID)
        
        local numCategories = GetNumFurnitureCategories()
        for categoryIndex = 1, numCategories do
            local categoryId = GetFurnitureCategoryId(categoryIndex)
            if self:IsValidFurnitureCategory(categoryId) then
                local category = self:AddFurnitureCategory(categoryId)
                if category then
                    local parentCategoryId = category.id
                    local categoryName = category.name
                    local numSubcategories = GetNumFurnitureSubcategories(categoryIndex)
                    for subcategoryIndex = 1, numSubcategories do
                        local subcategoryId = GetFurnitureSubcategoryId(categoryIndex, subcategoryIndex)
                        if self:IsValidFurnitureCategory(parentCategoryId, subcategoryId) then
                            self:AddFurnitureCategory(subcategoryId, parentCategoryId, categoryName)
                        end
                    end
                end
            end
        end
    end
    return self.furnitureCategories
end

function MSorter:GetFurnitureSubcategories(categoryId)
    local categories = self:GetFurnitureCategories()
    local subcategories = {}
    for _, category in pairs(categories) do
        if category.parentId == categoryId then
            table.insert(subcategories, category)
        end
    end
    return subcategories
end

function MSorter:GetFurnitureCategory(categoryId)
    local categories = self:GetFurnitureCategories()
    return categories[categoryId]
end

function MSorter:GetCategoryHouseAssignments(categoryId)
    local assignedHouses = {}
    local houses = self:GetStorageHouses()
    for _, house in pairs(houses) do
        if house.assignedCategoryIds and house.assignedCategoryIds[categoryId] then
            table.insert(assignedHouses, house)
        end
    end
    return assignedHouses
end

function MSorter:GetNumCategoryHouseAssignments(categoryId)
    local assignedHouses = self:GetCategoryHouseAssignments(categoryId)
    return #assignedHouses
end

function MSorter:GetHouseCategoryAssignments(houseId)
    local categories = self:GetFurnitureCategories()
    local assignedCategories = {}
    local house = self:GetStorageHouse(houseId)
    if house and house.assignedCategoryIds then
        for categoryId in pairs(house.assignedCategoryIds) do
            local category = categories[categoryId]
            if category then
                table.insert(assignedCategories, category)
            end
        end
    end
    return assignedCategories
end

function MSorter:GetHouseCategoryAssigmentsString(houseId)
    local list = {}
    local houseCategories = self:GetHouseCategoryAssignments(houseId)
    if houseCategories then
        local categoryIds = {}
        local categories = ZO_DeepTableCopy(houseCategories)
        table.sort(categories, function (categoryA, categoryB)
            return categoryA.parentId < categoryB.parentId
        end)
        for _, category in ipairs(categories) do
            categoryIds[category.id] = true
            if category.parentId == 0 or not categoryIds[category.parentId] then
                table.insert(list, category.displayName)
            end
        end
        table.sort(list)
    end
    return table.concat(list, "\n")
end

function MSorter:AssignCategoryToHouse(houseId, category)
    local house = self:GetStorageHouse(houseId)
    if not house or not category then
        return false
    end
    if not house.assignedCategoryIds then
        house.assignedCategoryIds = {}
    end
    house.assignedCategoryIds[category.id] = true
    -- "Needs Categorization" is a special fake category with no real subcategories - don't auto-assign subcategories for it
    if category.id ~= self.FURNITURE_NEEDS_CATEGORIZATION_CATEGORY_ID then
        local subcategories = self:GetFurnitureSubcategories(category.id)
        for _, subcategory in pairs(subcategories) do
            house.assignedCategoryIds[subcategory.id] = true
        end
    end
    self:OnSettingsChanged()
    return true
end

function MSorter:UnassignCategoryFromHouse(houseId, categoryId)
    local house = self:GetStorageHouse(houseId)
    if not house or not categoryId then
        return false
    end
    if not house.assignedCategoryIds then
        house.assignedCategoryIds = {}
    end
    house.assignedCategoryIds[categoryId] = nil
    -- "Needs Categorization" is a special fake category with no real subcategories - don't auto-unassign subcategories for it
    if categoryId ~= self.FURNITURE_NEEDS_CATEGORIZATION_CATEGORY_ID then
        local subcategories = self:GetFurnitureSubcategories(categoryId)
        for _, subcategory in pairs(subcategories) do
            house.assignedCategoryIds[subcategory.id] = nil
        end
    end
    self:OnSettingsChanged()
    return true
end

function MSorter:GetInventoryManager()
    return self.inventoryManager
end

function MSorter:GetSortManager()
    return self.sortManager
end

function MSorter:IsAutomaticStorageRunning()
    return self:GetSortManager():IsRunning()
end

function MSorter:StartAutomaticStorage()
    self:GetSortManager():Start()
end

function MSorter:CancelAutomaticStorage()
    self:GetSortManager():Cancel()
end

function MSorter:SuspendAutomaticStorage()
    self:GetSortManager():Suspend()
end

function MSorter:ResumeAutomaticStorage()
    self:GetSortManager():Resume()
end

function MSorter:UpdateKeybindStrip(addKeybinds)
    if addKeybinds then
        KEYBIND_STRIP:AddKeybindButtonGroup(self.KeybindButtons)
    else
        KEYBIND_STRIP:RemoveKeybindButtonGroup(self.KeybindButtons)
    end
end

function MSorter:OnSortManagerStateChanged(eventType, event, eventMessage)
    local sortProgress = GetControl("MagicSorter_StorageProgress")
    local isRunning = self:IsAutomaticStorageRunning()
    sortProgress:SetMessage(eventMessage)
    sortProgress:SetState(isRunning)
    if eventType == "STATE" then
        if event == "COMPLETE" then
            sortProgress:SetComplete(true)
        else
            sortProgress:SetComplete(false)
        end
    end
end

function MSorter:OnDropCategoryTag(control)
    local houseBoxes = GetControl("MagicSorter_CategoryAssignment").houseBoxes
    local dropTargetControl = self:GetMouseOverControl(houseBoxes)
    if control and control.category and dropTargetControl and dropTargetControl.house then
        self:AssignCategoryToHouse(dropTargetControl.house.houseId, control.category)
        GetControl("MagicSorter_CategoryAssignment"):Refresh()
    end
end

function MSorter:OnPlayerActivated(...)
    self:InitializeKeybinds()
    self:GetSortManager():OnPlayerActivated(...)
    self:ShowCompleteDialog()
end

--[[
function MSorter:AutoConfigure()
	local categoryCounts = {}
	local houses = self:GetOwnedHouses()
	for _, house in ipairs(houses) do
		
	end
end

SLASH_COMMANDS["/automagic"] = function()
	MAGIC_SORTER:AutoConfigure()
end
]]
-- /script MagicSorter_ReportInventory:ShowReport( { { "Conservatory", "Boulders", "125" } } )

SLASH_COMMANDS["/resetmagicsort"] = function ()
    MAGIC_SORTER:GetConfig().dirty = false
    MAGIC_SORTER_DEBUG_LOGGER:Info("Quick Sort mode is now ready.")
end

SLASH_COMMANDS["/debugfurniture"] = function ()
    local houseId = MAGIC_SORTER:GetSortManager():GetHouseId()
    if houseId == 0 then
        MAGIC_SORTER_DEBUG_LOGGER:Warn("Not in a house.")
        return
    end

    local houseName = GetCollectibleName(GetCollectibleIdForHouse(houseId))
    local furnitureData = {}
    local categoryCounts = {}
    local subcategoryCounts = {}

    local furnitureId = GetNextPlacedHousingFurnitureId()
    local itemCount = 0
    while furnitureId do
        itemCount = itemCount + 1
        local itemName, _, furnitureDataId = GetPlacedHousingFurnitureInfo(furnitureId)
        local categoryId, subcategoryId, themeId, limitId = GetFurnitureDataInfo(furnitureDataId)

        local categoryName = GetFurnitureCategoryName(categoryId) or "Unknown"
        local subcategoryName = GetFurnitureCategoryName(subcategoryId) or "Unknown"

        local entry =
        {
            furnitureId = Id64ToString(furnitureId),
            itemName = itemName or "Unknown",
            categoryId = categoryId or 0,
            subcategoryId = subcategoryId or 0,
            categoryName = categoryName,
            subcategoryName = subcategoryName,
            themeId = themeId or 0,
            limitId = limitId or 0,
        }

        table.insert(furnitureData, entry)

        local catKey = string.format("%d_%s", categoryId or 0, categoryName)
        categoryCounts[catKey] = (categoryCounts[catKey] or 0) + 1

        local subcatKey = string.format("%d_%d_%s_%s", categoryId or 0, subcategoryId or 0, categoryName, subcategoryName)
        subcategoryCounts[subcatKey] = (subcategoryCounts[subcatKey] or 0) + 1

        furnitureId = GetNextPlacedHousingFurnitureId(furnitureId)
    end

    if not MAGIC_SORTER:GetData().debugFurniture then
        MAGIC_SORTER:GetData().debugFurniture = {}
    end

    local debugEntry =
    {
        houseId = houseId,
        houseName = houseName,
        timestamp = GetTimeStamp(),
        itemCount = itemCount,
        furniture = furnitureData,
        categoryCounts = categoryCounts,
        subcategoryCounts = subcategoryCounts,
    }

    MAGIC_SORTER:GetData().debugFurniture[houseId] = debugEntry

    MAGIC_SORTER_DEBUG_LOGGER:Info("Debug: Dumped %d furniture items from %s (House ID: %d)", itemCount, houseName, houseId)
    MAGIC_SORTER_DEBUG_LOGGER:Info("Data saved to saved variables.")

    local sortManager = MAGIC_SORTER:GetSortManager()
    local house = MAGIC_SORTER:GetStorageHouse(houseId)
    if house then
        MAGIC_SORTER_DEBUG_LOGGER:Info("Storage house: Yes")
        if house.assignedCategoryIds then
            local numCategories = 0
            for _ in pairs(house.assignedCategoryIds) do
                numCategories = numCategories + 1
            end
            MAGIC_SORTER_DEBUG_LOGGER:Info("Assigned categories: %d", numCategories)
        else
            MAGIC_SORTER_DEBUG_LOGGER:Warn("Assigned categories: NONE")
        end
    else
        MAGIC_SORTER_DEBUG_LOGGER:Warn("Storage house: No")
    end

    MAGIC_SORTER_DEBUG_LOGGER:Info("Use /dumpfurniture to see detailed output")
end

SLASH_COMMANDS["/dumpfurniture"] = function ()
    local houseId = MAGIC_SORTER:GetSortManager():GetHouseId()
    if houseId == 0 then
        MAGIC_SORTER_DEBUG_LOGGER:Warn("Not in a house.")
        return
    end

    local debugData = MAGIC_SORTER:GetData().debugFurniture
    if not debugData or not debugData[houseId] then
        MAGIC_SORTER_DEBUG_LOGGER:Warn("No debug data for this house. Run /debugfurniture first.")
        return
    end

    local entry = debugData[houseId]
    MAGIC_SORTER_DEBUG_LOGGER:Info("=== Furniture Debug: %s (House ID: %d) ===", entry.houseName, houseId)
    MAGIC_SORTER_DEBUG_LOGGER:Info("Total items: %d", entry.itemCount)
    MAGIC_SORTER_DEBUG_LOGGER:Info("--- Category Counts ---")

    local sortedCategories = {}
    for key, count in pairs(entry.categoryCounts) do
        table.insert(sortedCategories, { key = key, count = count })
    end
    table.sort(sortedCategories, function (a, b)
        return a.count > b.count
    end)

    for _, cat in ipairs(sortedCategories) do
        MAGIC_SORTER_DEBUG_LOGGER:Info("  %s: %d", cat.key, cat.count)
    end

    MAGIC_SORTER_DEBUG_LOGGER:Info("--- Subcategory Counts ---")
    local sortedSubcats = {}
    for key, count in pairs(entry.subcategoryCounts) do
        table.insert(sortedSubcats, { key = key, count = count })
    end
    table.sort(sortedSubcats, function (a, b)
        return a.count > b.count
    end)

    for _, subcat in ipairs(sortedSubcats) do
        MAGIC_SORTER_DEBUG_LOGGER:Info("  %s: %d", subcat.key, subcat.count)
    end

    MAGIC_SORTER_DEBUG_LOGGER:Info("--- First 20 Items ---")
    for i = 1, zo_min(20, #entry.furniture) do
        local item = entry.furniture[i]
        MAGIC_SORTER_DEBUG_LOGGER:Info("  %s: %s / %s (cat:%d subcat:%d)", item.itemName, item.categoryName, item.subcategoryName, item.categoryId, item.subcategoryId)
    end

    if #entry.furniture > 20 then
        MAGIC_SORTER_DEBUG_LOGGER:Info("... and %d more items", #entry.furniture - 20)
    end
end

SLASH_COMMANDS["/debugcategories"] = function ()
    local sortManager = MAGIC_SORTER:GetSortManager()
    -- Initialize configuration if needed
    if not sortManager.categories then
        if not sortManager:GetAndValidateConfiguration() then
            MAGIC_SORTER_DEBUG_LOGGER:Warn("Failed to initialize configuration. Check storage houses.")
            return
        end
    end

    local houseId = sortManager:GetHouseId()
    if houseId == 0 then
        MAGIC_SORTER_DEBUG_LOGGER:Warn("Not in a house.")
        return
    end

    local house = MAGIC_SORTER:GetStorageHouse(houseId)
    if not house then
        MAGIC_SORTER_DEBUG_LOGGER:Warn("Current house is not a storage house.")
        return
    end

    local houseName = GetCollectibleName(GetCollectibleIdForHouse(houseId))
    MAGIC_SORTER_DEBUG_LOGGER:Info("=== Category Debug for %s (House %d) ===", houseName, houseId)

    -- Initialize saved vars
    if not MAGIC_SORTER:GetData().debugCategories then
        MAGIC_SORTER:GetData().debugCategories = {}
    end

    local debugData =
    {
        houseId = houseId,
        houseName = houseName,
        timestamp = GetTimeStamp(),
        assignedCategoryIds = {},
        categoriesTable = {},
        testResults = {},
        removableCount = 0,
        outboundCount = 0,
    }

    -- Check assigned categories
    if house.assignedCategoryIds then
        for catId in pairs(house.assignedCategoryIds) do
            table.insert(debugData.assignedCategoryIds, catId)
        end
        table.sort(debugData.assignedCategoryIds)
        MAGIC_SORTER_DEBUG_LOGGER:Info("Assigned category IDs: %s", table.concat(debugData.assignedCategoryIds, ", "))
    else
        MAGIC_SORTER_DEBUG_LOGGER:Warn("No categories assigned to this house")
    end

    -- Check categories table
    if sortManager.categories then
        MAGIC_SORTER_DEBUG_LOGGER:Info("--- Categories Table ---")
        local catCount = 0
        for catId, houses in pairs(sortManager.categories) do
            catCount = catCount + 1
            local houseList = {}
            for hId in pairs(houses) do
                table.insert(houseList, tostring(hId))
            end
            local catName = GetFurnitureCategoryName(catId) or "Unknown"
            local entry =
            {
                categoryId = catId,
                categoryName = catName,
                houseIds = houseList,
            }
            table.insert(debugData.categoriesTable, entry)
            MAGIC_SORTER_DEBUG_LOGGER:Info("  Category %d (%s): houses %s", catId, catName, table.concat(houseList, ", "))
        end
        MAGIC_SORTER_DEBUG_LOGGER:Info("Total categories in table: %d", catCount)
    else
        MAGIC_SORTER_DEBUG_LOGGER:Warn("Categories table not initialized")
    end

    -- Test multiple items from the debug data
    MAGIC_SORTER_DEBUG_LOGGER:Info("--- Testing Item Removal Logic ---")
    local testItems =
    {
        { categoryId = 12, subcategoryId = 152, themeId = 13, name = "Boulders and Large Rocks (Daedric)", },
        { categoryId = 12, subcategoryId = 150, themeId = 13, name = "Giant Trees (Daedric)",              },
        { categoryId = 12, subcategoryId = 149, themeId = 1,  name = "Ferns (Generic)",                    },
        { categoryId = 13, subcategoryId = 185, themeId = 9,  name = "Buildings (Orc)",                    },
        { categoryId = 25, subcategoryId = 31,  themeId = 0,  name = "Banking Assistants",                 },
    }

    for _, testItem in ipairs(testItems) do
        local testResult =
        {
            categoryId = testItem.categoryId,
            subcategoryId = testItem.subcategoryId,
            themeId = testItem.themeId,
            name = testItem.name,
        }

        local placeable = sortManager:IsFurniturePlaceableInHouse(houseId, testItem.categoryId, testItem.subcategoryId, testItem.themeId)
        testResult.isPlaceableInHouse = placeable

        local placeableAny = sortManager:IsFurniturePlaceableInAnyHouse(houseId, testItem.categoryId, testItem.subcategoryId, testItem.themeId)
        testResult.isPlaceableInAnyHouse = placeableAny

        local targetHouses = sortManager:GetHousesByFurnitureCategoryAndTheme(testItem.subcategoryId, testItem.themeId)
        testResult.targetHouseIds = {}
        for _, hId in ipairs(targetHouses) do
            table.insert(testResult.targetHouseIds, hId)
        end

        table.insert(debugData.testResults, testResult)

        MAGIC_SORTER_DEBUG_LOGGER:Info("  %s:", testItem.name)
        MAGIC_SORTER_DEBUG_LOGGER:Info("    IsFurniturePlaceableInHouse: %s", tostring(placeable))
        MAGIC_SORTER_DEBUG_LOGGER:Info("    IsFurniturePlaceableInAnyHouse: %s", tostring(placeableAny))
        MAGIC_SORTER_DEBUG_LOGGER:Info("    Target houses: %s", table.concat(testResult.targetHouseIds, ", "))
    end

    local removableList = sortManager:GetRemovableFurnitureList()
    debugData.removableCount = #removableList
    MAGIC_SORTER_DEBUG_LOGGER:Info("  GetRemovableFurnitureList: %d items", #removableList)

    local outboundList = sortManager:GetOutboundFurnitureList()
    debugData.outboundCount = #outboundList
    MAGIC_SORTER_DEBUG_LOGGER:Info("  GetOutboundFurnitureList: %d items", #outboundList)

    -- Save to SV
    MAGIC_SORTER:GetData().debugCategories[houseId] = debugData
    MAGIC_SORTER_DEBUG_LOGGER:Info("Data saved to saved variables.")
end

SLASH_COMMANDS["/re"] = ReloadUI
