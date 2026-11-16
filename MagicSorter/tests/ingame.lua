if not Taneth then
    return
end

Taneth("MagicSorter", function()
    describe("settings", function()
        it("formats the addon version below 1000 as Version N", function()
            local version = MAGIC_SORTER:GetVersion()
            assert.is_true(version < 1000)
            assert.equals("Version " .. tostring(version), MAGIC_SORTER:GetVersionString())
        end)

        it("reads a saved lightsOffEnabled as turn off", function()
            local config = MAGIC_SORTER:GetConfig()
            local savedMode = config.lightsMode
            local savedLegacy = config.lightsOffEnabled
            config.lightsMode = nil
            config.lightsOffEnabled = true
            local lightsMode = MAGIC_SORTER:GetLightsMode()
            config.lightsMode = savedMode
            config.lightsOffEnabled = savedLegacy
            assert.equals("off", lightsMode)
        end)

        it("cycles lights from leave alone to off to on", function()
            local config = MAGIC_SORTER:GetConfig()
            local savedMode = MAGIC_SORTER:GetLightsMode()
            local savedLegacy = config.lightsOffEnabled
            MAGIC_SORTER:SetLightsMode("none")
            MAGIC_SORTER:CycleLightsMode()
            local turnedOff = MAGIC_SORTER:GetLightsMode()
            MAGIC_SORTER:CycleLightsMode()
            local turnedOn = MAGIC_SORTER:GetLightsMode()
            MAGIC_SORTER:CycleLightsMode()
            local leftAlone = MAGIC_SORTER:GetLightsMode()
            MAGIC_SORTER:SetLightsMode(savedMode)
            config.lightsOffEnabled = savedLegacy
            assert.equals("off", turnedOff)
            assert.equals("on", turnedOn)
            assert.equals("none", leftAlone)
        end)

        it("clamps the vault threshold to 2 through 50", function()
            local savedThreshold = MAGIC_SORTER:GetVaultThreshold()
            MAGIC_SORTER:SetVaultThreshold(1)
            local lowThreshold = MAGIC_SORTER:GetVaultThreshold()
            MAGIC_SORTER:SetVaultThreshold(99)
            local highThreshold = MAGIC_SORTER:GetVaultThreshold()
            MAGIC_SORTER:SetVaultThreshold(savedThreshold)
            assert.equals(MAGIC_SORTER.MinVaultThreshold, lowThreshold)
            assert.equals(MAGIC_SORTER.MaxVaultThreshold, highThreshold)
        end)
    end)

    describe("light variation names", function()
        local function SortManager()
            return MAGIC_SORTER:GetSortManager()
        end

        it("recognizes the off word in every client language", function()
            local sortManager = SortManager()
            local offNames = { "Off", "Aus", "Non", "Apagado", "Неактивно", "关", "オフ", "Lamp Off" }
            for nameIndex = 1, #offNames do
                assert.is_true(sortManager:IsLightOffVariationName(offNames[nameIndex]))
                assert.is_false(sortManager:IsLightOnVariationName(offNames[nameIndex]))
            end
        end)

        it("recognizes the on word in every client language", function()
            local sortManager = SortManager()
            local onNames = { "On", "Ein", "Oui", "Encendido", "Активно", "开", "オン", "Lamp On" }
            for nameIndex = 1, #onNames do
                assert.is_true(sortManager:IsLightOnVariationName(onNames[nameIndex]))
                assert.is_false(sortManager:IsLightOffVariationName(onNames[nameIndex]))
            end
        end)
    end)

    describe("item links", function()
        it("reads the item id back out of the link it built", function()
            local inventoryManager = MAGIC_SORTER:GetInventoryManager()
            local itemId = 120410
            local itemLink = inventoryManager:GetItemIdLink(itemId)
            assert.equals(itemId, inventoryManager:GetItemLinkItemId(itemLink))
        end)
    end)

    describe("house", function()
        it("vault free slots equal usable minus used", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local freeSlots = GetNumBagFreeSlots(BAG_FURNITURE_VAULT)
            local usedSlots = GetNumBagUsedSlots(BAG_FURNITURE_VAULT)
            local usableSlots = GetBagUseableSize(BAG_FURNITURE_VAULT)
            assert.equals(usableSlots - usedSlots, freeSlots)
        end)

        it("starting a sort leaves Retrieve To on the player's bag", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local sortManager = MAGIC_SORTER:GetSortManager()
            assert.is_false(sortManager:IsRunning())
            local originalBagId = HousingEditorGetRetrieveToBag()
            local otherBagId = nil
            for _, bagId in ipairs(ZO_HOUSING_FURNITURE_RETRIEVE_TO_BAGS) do
                if bagId ~= BAG_BACKPACK and ZO_HousingFurnitureRetrieveToBag:New(bagId):IsEnabled() then
                    otherBagId = bagId
                    break
                end
            end
            assert.is_not_nil(otherBagId)
            HousingEditorSetRetrieveToBag(otherBagId)
            sortManager:SetIsRunning(true)
            local bagIdWhileRunning = HousingEditorGetRetrieveToBag()
            sortManager:SetIsRunning(false)
            local bagIdAfterStop = HousingEditorGetRetrieveToBag()
            HousingEditorSetRetrieveToBag(originalBagId)
            assert.equals(otherBagId, bagIdWhileRunning)
            assert.equals(otherBagId, bagIdAfterStop)
        end)

        it("reads Retrieve To back in the same call", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local savedBagId = HousingEditorGetRetrieveToBag()
            HousingEditorSetRetrieveToBag(BAG_BACKPACK)
            local immediateBagId = HousingEditorGetRetrieveToBag()
            HousingEditorSetRetrieveToBag(savedBagId)
            local restoredBagId = HousingEditorGetRetrieveToBag()
            assert.equals(BAG_BACKPACK, immediateBagId)
            assert.equals(savedBagId, restoredBagId)
        end)

        it("spaces housing actions by 800ms and does not use the patch waits", function()
            local sortManager = MAGIC_SORTER:GetSortManager()
            assert.equals(800, sortManager.SwapIntervalMS)
            assert.is_nil(sortManager.RetrieveToSettleMS)
            assert.is_nil(sortManager.HousingRequestTimeoutMS)
            assert.is_nil(sortManager.HousingRequestSettleMS)
            assert.is_nil(sortManager.MaxPlacementRefusals)
            assert.is_nil(sortManager.GetStageableItems)
        end)

        it("vault room for a new item follows free slots", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local sortManager = MAGIC_SORTER:GetSortManager()
            local inventoryManager = MAGIC_SORTER:GetInventoryManager()
            local itemId = 1
            local _, _, _, _, vaultCount = GetItemLinkStacks(inventoryManager:GetItemIdLink(itemId))
            local freeSlots = GetNumBagFreeSlots(BAG_FURNITURE_VAULT)
            local hasRoom = sortManager:DoesVaultHaveRoomFor(itemId)
            if (vaultCount or 0) > 0 then
                assert.is_true(hasRoom)
            else
                assert.equals(freeSlots > 0, hasRoom)
            end
        end)

        it("Rough Cup counts match the bag slots and GetItemLinkStacks", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local roughCupItemId = 120410
            local sortManager = MAGIC_SORTER:GetSortManager()
            local itemLink = MAGIC_SORTER:GetInventoryManager():GetItemIdLink(roughCupItemId)
            local function SumBag(bagId)
                local stackTotal = 0
                for slotIndex in ZO_IterateBagSlots(bagId) do
                    if GetItemId(bagId, slotIndex) == roughCupItemId then
                        stackTotal = stackTotal + (GetSlotStackSize(bagId, slotIndex) or 0)
                    end
                end
                return stackTotal
            end
            local backpackStacks, _, _, _, furnitureVaultStacks = GetItemLinkStacks(itemLink)
            local backpackCount = sortManager:CountItemCopies(BAG_BACKPACK, roughCupItemId)
            local vaultCount = sortManager:CountItemCopies(BAG_FURNITURE_VAULT, roughCupItemId)
            assert.equals(SumBag(BAG_BACKPACK), backpackCount)
            assert.equals(SumBag(BAG_FURNITURE_VAULT), vaultCount)
            assert.equals(backpackStacks or 0, backpackCount)
            assert.equals(furnitureVaultStacks or 0, vaultCount)
            if backpackCount + vaultCount == 0 then
                assert.fail("Rough Cup 120410 is not in the backpack or the Furniture Vault")
            end
        end)

        it("a vault put-away waits until that item's backpack count is empty", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local sortManager = MAGIC_SORTER:GetSortManager()
            assert.is_true(sortManager:IsVaultModeActive())
            sortManager:GetAndValidateConfiguration()
            local roughCupItemId = 120410
            local backpackCount = sortManager:CountItemCopies(BAG_BACKPACK, roughCupItemId)
            local removeList = sortManager:GetOutboundFurnitureList()
            local vaultRemoval = sortManager:GetNextVaultRemoval(removeList)
            if vaultRemoval then
                assert.equals(0, sortManager:CountItemCopies(sortManager.InventoryBag, vaultRemoval.itemId))
            end
            if backpackCount > 0 then
                if vaultRemoval and zo_abs(vaultRemoval.itemId) == roughCupItemId then
                    assert.fail(string.format("Rough Cup would be put in the vault while the backpack still has %d", backpackCount))
                end
            end
        end)

        it("vault staging needs room for the backpack and vault copies together", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local sortManager = MAGIC_SORTER:GetSortManager()
            assert.is_true(sortManager:IsVaultModeActive())
            local roughCupItemId = 120410
            local itemLink = MAGIC_SORTER:GetInventoryManager():GetItemIdLink(roughCupItemId)
            local backpackCount = sortManager:CountItemCopies(BAG_BACKPACK, roughCupItemId)
            local vaultCount = sortManager:CountItemCopies(BAG_FURNITURE_VAULT, roughCupItemId)
            if backpackCount == 0 or vaultCount == 0 then
                assert.fail(string.format("Rough Cup needs copies in both bags to test this. backpack %d, vault %d", backpackCount, vaultCount))
                return
            end
            local itemTotals = sortManager:GetItemTotals()
            local totalCopies = itemTotals and itemTotals[roughCupItemId] or 0
            local vaultThreshold = sortManager:GetVaultThreshold()
            if sortManager.vaultFailedItemIds and sortManager.vaultFailedItemIds[roughCupItemId] then
                assert.fail(string.format("Rough Cup was already marked vault-failed. backpack %d, vault %d", backpackCount, vaultCount))
                return
            end
            if totalCopies < vaultThreshold then
                assert.fail(string.format("Rough Cup has %d counted copies, under the vault threshold of %d. backpack %d, vault %d", totalCopies, vaultThreshold, backpackCount, vaultCount))
                return
            end
            local furnitureDataId = GetItemLinkFurnitureDataId(itemLink)
            local _, _, _, limitType = GetFurnitureDataInfo(furnitureDataId)
            local copiesToStage = backpackCount + vaultCount
            local remaining = sortManager:GetHouseCapacity(sortManager:GetHouseId(), limitType) or 0
            if remaining <= copiesToStage then
                assert.fail(string.format("the house does not have room for the backpack and vault copies together. remaining %d, backpack %d, vault %d", remaining, backpackCount, vaultCount))
            end
        end)

        it.async("a backpack Rough Cup placement consumes one vault copy and leaves the backpack", function(done)
            assert.is_true(IsOwnerOfCurrentHouse())
            local roughCupItemId = 120410
            local sortManager = MAGIC_SORTER:GetSortManager()
            local itemLink = MAGIC_SORTER:GetInventoryManager():GetItemIdLink(roughCupItemId)
            local function CountBag(bagId)
                local countType = bagId == BAG_FURNITURE_VAULT and INVENTORY_COUNT_BAG_OPTION_FURNITURE or INVENTORY_COUNT_BAG_OPTION_BACKPACK
                local count = GetItemLinkInventoryCount(itemLink, countType) or 0
                local firstSlotIndex = nil
                for slotIndex in ZO_IterateBagSlots(bagId) do
                    if GetItemId(bagId, slotIndex) == roughCupItemId then
                        firstSlotIndex = slotIndex
                        break
                    end
                end
                return count, firstSlotIndex
            end
            local backpackBefore, backpackSlotIndex = CountBag(BAG_BACKPACK)
            local vaultBefore = CountBag(BAG_FURNITURE_VAULT)
            if backpackSlotIndex == nil or vaultBefore == 0 then
                assert.fail(string.format("Rough Cup needs a backpack slot and a vault copy. backpack %d, vault %d", backpackBefore, vaultBefore))
                return
            end
            local furnitureDataId = GetItemLinkFurnitureDataId(itemLink)
            local _, _, _, limitType = GetFurnitureDataInfo(furnitureDataId)
            local remaining = sortManager:GetHouseCapacity(sortManager:GetHouseId(), limitType) or 0
            if remaining <= 1 then
                assert.fail(string.format("the house has %d slots left for this furnishing, so this test will not place", remaining))
                return
            end
            local worldX, worldY, worldZ, heading = sortManager:GetPlacementLocation()
            local sine, cosine = zo_sin(heading), zo_cos(heading)
            local offsetX, offsetZ = -800 * sine, -800 * cosine
            local result = HousingEditorRequestItemPlacement(BAG_BACKPACK, backpackSlotIndex, worldX + offsetX, worldY, worldZ + offsetZ, 0, heading, 0)
            if result ~= HOUSING_REQUEST_RESULT_SUCCESS then
                local resultText = GetString("SI_HOUSINGREQUESTRESULT", result)
                assert.fail(string.format("placement returned %s %s", tostring(result), resultText or ""))
                return
            end
            EVENT_MANAGER:RegisterForEvent("MagicSorterTanethRoughCup", EVENT_HOUSING_FURNITURE_PLACED, function()
                EVENT_MANAGER:UnregisterForEvent("MagicSorterTanethRoughCup", EVENT_HOUSING_FURNITURE_PLACED)
                zo_callLater(function()
                    local backpackAfter = CountBag(BAG_BACKPACK)
                    local vaultAfter = CountBag(BAG_FURNITURE_VAULT)
                    local counts = string.format("backpack %d -> %d, vault %d -> %d", backpackBefore, backpackAfter, vaultBefore, vaultAfter)
                    if vaultAfter ~= vaultBefore - 1 or backpackAfter ~= backpackBefore then
                        assert.fail("a backpack placement did not consume one vault copy first. " .. counts)
                        return
                    end
                    done()
                end, 1000)
            end)
        end, 8000)

        it.async("one placement reports a furnishing cap and does not request a second item", function(done)
            assert.is_true(IsOwnerOfCurrentHouse())
            local playerDeactivated = false
            local function OnPlayerLeft()
                playerDeactivated = true
            end
            EVENT_MANAGER:RegisterForEvent("MagicSorterTanethLimitDeactivate", EVENT_PLAYER_DEACTIVATED, OnPlayerLeft)
            EVENT_MANAGER:RegisterForEvent("MagicSorterTanethLimitLogout", EVENT_LOGOUT_DEFERRED, OnPlayerLeft)
            local function Finish(failureMessage)
                EVENT_MANAGER:UnregisterForEvent("MagicSorterTanethLimitDeactivate", EVENT_PLAYER_DEACTIVATED)
                EVENT_MANAGER:UnregisterForEvent("MagicSorterTanethLimitLogout", EVENT_LOGOUT_DEFERRED)
                EVENT_MANAGER:UnregisterForEvent("MagicSorterTanethLimitPlaced", EVENT_HOUSING_FURNITURE_PLACED)
                if playerDeactivated then
                    assert.fail("player deactivated")
                    return
                end
                if failureMessage then
                    assert.fail(failureMessage)
                    return
                end
                assert.is_true(IsOwnerOfCurrentHouse())
                done()
            end
            local roughCupItemId = 120410
            local itemLink = MAGIC_SORTER:GetInventoryManager():GetItemIdLink(roughCupItemId)
            local sourceBagId, sourceSlotIndex
            for _, bagId in ipairs({ BAG_BACKPACK, BAG_FURNITURE_VAULT }) do
                for slotIndex in ZO_IterateBagSlots(bagId) do
                    if GetItemId(bagId, slotIndex) == roughCupItemId then
                        sourceBagId, sourceSlotIndex = bagId, slotIndex
                        break
                    end
                end
                if sourceSlotIndex then
                    break
                end
            end
            if not sourceSlotIndex then
                Finish("Rough Cup 120410 is not in the backpack or the Furniture Vault")
                return
            end
            local worldX, worldY, worldZ, heading = MAGIC_SORTER:GetSortManager():GetPlacementLocation()
            local sine, cosine = zo_sin(heading), zo_cos(heading)
            local offsetX, offsetZ = -800 * sine, -800 * cosine
            local result = HousingEditorRequestItemPlacement(sourceBagId, sourceSlotIndex, worldX + offsetX, worldY, worldZ + offsetZ, 0, heading, 0)
            local resultText = GetString("SI_HOUSINGREQUESTRESULT", result)
            if result == HOUSING_REQUEST_RESULT_LOW_IMPACT_ITEM_PLACE_LIMIT or result == HOUSING_REQUEST_RESULT_HIGH_IMPACT_ITEM_PLACE_LIMIT then
                Finish(resultText ~= "" and resultText or string.format("placement returned %s", tostring(result)))
                return
            end
            if result ~= HOUSING_REQUEST_RESULT_SUCCESS then
                Finish(string.format("placement returned %s %s", tostring(result), resultText or ""))
                return
            end
            EVENT_MANAGER:RegisterForEvent("MagicSorterTanethLimitPlaced", EVENT_HOUSING_FURNITURE_PLACED, function()
                EVENT_MANAGER:UnregisterForEvent("MagicSorterTanethLimitPlaced", EVENT_HOUSING_FURNITURE_PLACED)
                zo_callLater(function()
                    Finish()
                end, 1000)
            end)
        end, 8000)

        it("lists variation names for one placed multi-state furnishing", function()
            assert.is_true(IsOwnerOfCurrentHouse())
            local furnitureId = GetNextPlacedHousingFurnitureId()
            local multiStateFurnitureId = nil
            while furnitureId do
                if GetPlacedHousingFurnitureNumObjectStates(furnitureId) > 1 then
                    multiStateFurnitureId = furnitureId
                    break
                end
                furnitureId = GetNextPlacedHousingFurnitureId(furnitureId)
            end
            assert.is_not_nil(multiStateFurnitureId)
            local numStates = GetPlacedHousingFurnitureNumObjectStates(multiStateFurnitureId)
            local variationNames = {}
            for variationIndex = 1, numStates do
                variationNames[variationIndex] = GetPlacedFurniturePreviewVariationDisplayName(multiStateFurnitureId, variationIndex) or ""
            end
            assert.equals(numStates, #variationNames)
            assert.is_true(variationNames[1] ~= "")
        end)
    end)
end)
