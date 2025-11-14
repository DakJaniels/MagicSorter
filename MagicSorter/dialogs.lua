---@diagnostic disable: undefined-field, param-type-mismatch
---@class MagicSorterDialogs
MagicSorterDialogs = {}

-- Animation Update Functions
---@param animation AnimationTimeline
function MagicSorterDialogs.LogoAnimation_OnStop(animation)
    if not animation:GetAnimatedControl():IsHidden() then
        animation:GetTimeline():PlayFromStart()
    end
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.LogoAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local logo, logo1, logo2, logo3 = control.logo, control.logo1, control.logo2, control.logo3
    local base, coeff = 0.5, 20
    local interval

    interval = zo_lerp(0, 1, 4 * progress)
    if interval >= 0 and 1 >= interval then
        interval = zo_sin(interval * 2 * ZO_PI)
        logo1:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, base + coeff * interval)
        logo1:SetVertexColors(1 + 4, 0.5, 1, 1, 0.1 * interval)
        logo1:SetVertexColors(2 + 8, 0.5, 1, 1, 0)
        logo1:SetHidden(false)
    else
        logo1:SetHidden(true)
    end

    interval = zo_lerp(0, 1, -0.13 + 4 * progress)
    if interval >= 0 and 1 >= interval then
        interval = zo_sin(interval * 2 * ZO_PI)
        logo2:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, base + coeff * interval)
        logo2:SetAlpha(0.1 * interval)
        logo2:SetHidden(false)
        logo:SetAlpha(1 - interval)
    else
        logo2:SetHidden(true)
        logo:SetAlpha(1)
    end

    interval = zo_lerp(0, 1, -0.26 + 4 * progress)
    if interval >= 0 and 1 >= interval then
        interval = zo_sin(interval * 2 * ZO_PI)
        logo3:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, base + coeff * interval)
        logo3:SetVertexColors(2 + 8, 1, 0.5, 1, 0.1 * interval)
        logo3:SetVertexColors(1 + 4, 1, 0.5, 1, 0)
        logo3:SetHidden(false)
    else
        logo3:SetHidden(true)
    end
end

---@param animation MagicSorter_DragTagHighlightAnimation
---@param progress number
function MagicSorterDialogs.DragTagHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local backdrop = control:GetNamedChild("LabelBackdrop")
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 1 + 0.5 * progress)
end

---@param animation MagicSorter_RemoveButtonHighlightAnimation
---@param progress number
function MagicSorterDialogs.RemoveButtonHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    control:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 1 + 0.7 * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.ButtonHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local backdrop = control:GetNamedChild("Backdrop")
    local color = zo_lerp(0.5, 0.75, progress)
    backdrop:SetColor(0.75 * color, color, color, 1)
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 2 + 0.5 * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.ToggleHoverAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    local backdrop = animation:GetAnimatedControl().backdrop
    ---@cast backdrop TextureControl
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 2 + 0.6 * progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.ToggleSelectAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    local control = animation:GetAnimatedControl()
    local r = zo_lerp(0.75, 1, progress)
    control.label:SetColor(r, 1, 1, 1)
    r = zo_lerp(0.0625, 1, progress)
    local g = zo_lerp(0.3125, 1, progress)
    control.backdrop:SetColor(r, g, 0.3125, 1)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.TabButtonHighlightAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    local backdrop = control:GetNamedChild("Backdrop")
    local color1 = zo_lerp(0.25, 0.5, progress)
    local color2 = zo_lerp(0.5, 0.75, progress)
    backdrop:SetColor(color2, color1, color2, 1)
    backdrop:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 1 + progress)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.OptionButtonHighlightAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    local r = zo_lerp(0, 0, progress)
    local g = zo_lerp(0, 1, progress)
    local b = zo_lerp(0, 1, progress)
    local c = zo_lerp(0.75, 1, progress)
    local desat = zo_lerp(1, 0, progress)
    local weight = zo_lerp(1, 2.25, progress)

    local control = animation:GetAnimatedControl()
    local backdropTexture = control:GetNamedChild("Backdrop")
    local iconTexture = control:GetNamedChild("Icon")

    backdropTexture:SetColor(r, g, b, 1)
    backdropTexture:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, weight)
    iconTexture:SetColor(c, c, c, 1)
    iconTexture:SetDesaturation(desat)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.OptionButtonHoverAnimation_UpdateFunction(animation, progress)
    progress = ZO_EaseInCubic(progress)
    animation:GetAnimatedControl():GetNamedChild("Icon"):SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 1 + 0.5 * progress)
end

---@param timeline AnimationTimeline
function MagicSorterDialogs.TopLevelBackdropAnimation_OnStop(timeline)
    local control = timeline:GetAnimation(1):GetAnimatedControl()
    if not timeline:IsPlaying() and control and not control:IsHidden() then
        timeline:PlayFromStart(1)
    end
end

---@param animation AnimationTimeline
---@param completedPlaying boolean
function MagicSorterDialogs.TopLevelBackdropAnimation_OnPlay(animation, completedPlaying)
    local control = animation:GetAnimatedControl()
    local underlay1 = control:GetNamedChild("Underlay1")
    local underlay2 = control:GetNamedChild("Underlay2")
    local texture0 = control:GetNamedChild("Ring1")
    local texture1 = control:GetNamedChild("Ring2")
    local texture2 = control:GetNamedChild("Ring3")

    texture0:SetBlendMode(TEX_BLEND_MODE_COLOR_DODGE)
    texture1:SetBlendMode(TEX_BLEND_MODE_COLOR_DODGE)
    texture2:SetBlendMode(TEX_BLEND_MODE_COLOR_DODGE)

    underlay1:SetVertexColors(1, 0.0, 1.0, 1.0, 1)
    underlay1:SetVertexColors(2, 0.2, 0.8, 1.0, 1)
    underlay1:SetVertexColors(4, 0.8, 0.2, 1.0, 1)
    underlay1:SetVertexColors(8, 1.0, 0.2, 0.8, 1)
    underlay1:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 1.8)

    underlay2:SetVertexColors(8, 0.4, 1.0, 1.0, 0.5)
    underlay2:SetVertexColors(4, 0.0, 0.8, 1.0, 0.5)
    underlay2:SetVertexColors(2, 0.8, 0.4, 1.0, 0.5)
    underlay2:SetVertexColors(1, 1.0, 0.0, 0.8, 0.5)
    underlay2:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, 1.4)

    texture0:SetAlpha(0)
    texture1:SetAlpha(0)
    texture2:SetAlpha(0)
end

---@param animation AnimationTimeline
---@param progress number
function MagicSorterDialogs.TopLevelBackdropAnimation_UpdateFunction(animation, progress)
    local control = animation:GetAnimatedControl()
    if control:IsHidden() then
        control.backdropAnimation:Stop()
    else
        local PI = ZO_PI
        local PI2 = ZO_TWO_PI

        local underlay1 = control:GetNamedChild("Underlay1")
        local underlay2 = control:GetNamedChild("Underlay2")
        local texture0 = control:GetNamedChild("Ring1")
        local texture1 = control:GetNamedChild("Ring2")
        local texture2 = control:GetNamedChild("Ring3")

        local angleu = (progress * PI2) % PI2
        MAGIC_SORTER:RotateTexture(underlay1, angleu)
        MAGIC_SORTER:RotateTexture(underlay2, PI2 - angleu)

        local alphau = 0.5 * (1 + zo_sin(PI2 * 6 * progress))
        underlay1:SetAlpha(0.5 + 0.3 * alphau)
        underlay2:SetAlpha(0.5 + 0.3 * (1 - alphau))

        progress = (11 * progress) % 1
        local interval0 = progress
        local interval1 = (progress + 0.18) % 1
        local interval2 = (progress + 0.30) % 1

        local angle0 = PI2 * interval0
        local angle1 = PI2 * -interval1
        local angle2 = PI2 * interval2

        local loop0 = zo_sin(PI * interval0)
        local loop1 = zo_sin(PI * interval1)
        local loop2 = zo_sin(PI * interval2)

        local scale0 = 0.6 + 3 * (1 - interval0)
        local scale1 = 0.6 + 3 * (1 - interval1)
        local scale2 = 0.6 + 3 * (1 - interval2)

        MAGIC_SORTER:RotateTexture(texture0, angle0, 0.5, 0.5, scale0, scale0)
        MAGIC_SORTER:RotateTexture(texture1, angle1, 0.5, 0.5, scale1, scale1)
        MAGIC_SORTER:RotateTexture(texture2, angle2, 0.5, 0.5, scale2, scale2)

        texture0:SetVertexColors(2 + 4, 0.4, 0.8, 1, 0.2 * zo_min(1, 1.5 * loop0))
        texture0:SetVertexColors(1 + 8, 0.2, 1, 1, 0.2 * zo_min(1, 2 * loop0))

        texture1:SetVertexColors(2 + 4, 0.8, 0.2, 1, 0.2 * zo_min(1, 2 * loop1))
        texture1:SetVertexColors(1 + 8, 1, 0.2, 0.8, 0.2 * zo_min(1, 1.6 * loop1))

        texture2:SetVertexColors(1 + 4, 0.4, 0.1, 0.8, 0.2 * zo_min(1, 1.8 * loop2))
        texture2:SetVertexColors(2 + 8, 0.6, 0.1, 1, 0.2 * zo_min(1, 1.7 * loop2))

        texture0:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, loop0 * 12)
        texture1:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, loop1 * 12)
        texture2:SetTextureSampleProcessingWeight(TEX_SAMPLE_PROCESSING_RGB, loop2 * 12)
    end
end

-- Control Initialization Functions
---@param control MagicSorter_DataRow
function MagicSorterDialogs.DataRow_OnInitialized(control)
    control.label1 = control:GetNamedChild("Label1")
    control.label2 = control:GetNamedChild("Label2")
    control.label3 = control:GetNamedChild("Label3")
    control.label4 = control:GetNamedChild("Label4")
    control.SetupRow = function (self, rowWidth, rowHeight, columnWidths)
        rowWidth, rowHeight = rowWidth or 800, rowHeight or 28
        self:SetDimensions(rowWidth, rowHeight)
        self.label1:SetText("")
        self.label2:SetText("")
        self.label3:SetText("")
        self.label4:SetText("")
        if columnWidths then
            local numColumns = #columnWidths
            self.label1:SetHidden(1 > numColumns)
            self.label2:SetHidden(2 > numColumns)
            self.label3:SetHidden(3 > numColumns)
            self.label4:SetHidden(4 > numColumns)
            if tonumber(columnWidths[1]) then self.label1:SetDimensions(columnWidths[1], rowHeight) end
            if tonumber(columnWidths[2]) then self.label2:SetDimensions(columnWidths[2], rowHeight) end
            if tonumber(columnWidths[3]) then self.label3:SetDimensions(columnWidths[3], rowHeight) end
            if tonumber(columnWidths[4]) then self.label4:SetDimensions(columnWidths[4], rowHeight) end
        end
    end
    control.UpdateColumns = function (self, values)
        if values then
            self.label1:SetText(values[1] or "")
            self.label2:SetText(values[2] or "")
            self.label3:SetText(values[3] or "")
            self.label4:SetText(values[4] or "")
        end
    end
end

---@param control MagicSorter_Label
function MagicSorterDialogs.Label_OnInitialized(control)
    control:GetParent():SetDimensions(control:GetDimensions())
end

---@param control TextureControl
function MagicSorterDialogs.LabelBackdrop_OnInitialized(control)
    control:SetVertexColors(1, 0, 1, 1, 0)
    control:SetVertexColors(2, 1, 0, 1, 1)
    control:SetVertexColors(4, 0, 1, 1, 1)
    control:SetVertexColors(8, 1, 0, 1, 0)
end

---@param control TextureControl
function MagicSorterDialogs.LabelBackdrop_OnTextureLoaded(control)
    control:SetVertexColors(1, 0, 1, 1, 0)
    control:SetVertexColors(2, 1, 0, 1, 1)
    control:SetVertexColors(4, 0, 1, 1, 1)
    control:SetVertexColors(8, 1, 0, 1, 0)
end

---@param control MagicSorter_Button
function MagicSorterDialogs.Button_OnInitialized(control)
    control.highlightAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_ButtonHighlightAnimation", control)
end

---@param control MagicSorter_Button
function MagicSorterDialogs.Button_OnMouseEnter(control)
    if control then
        control.highlightAnimation:PlayFromStart()
        if control.tooltip then
            ZO_Tooltips_ShowTextTooltip(control, BOTTOM, control.tooltip)
        end
    end
end

---@param control MagicSorter_Button
function MagicSorterDialogs.Button_OnMouseExit(control)
    if control then
        control.highlightAnimation:PlayFromEnd()
        if control.tooltip then
            ZO_Tooltips_HideTextTooltip()
        end
    end
end

---@param control MagicSorter_Toggle
function MagicSorterDialogs.Toggle_OnInitialized(control)
    control.isSelected = false
    control.backdrop = control:GetNamedChild("Backdrop")
    control.label = control:GetNamedChild("Label")
    control.highlightAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_ToggleHoverAnimation", control)
    control.toggleAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_ToggleSelectAnimation", control)
    control.IsSelected = function (self)
        return self.isSelected == true
    end
    control.SetLabel = function (self, text)
        self.label:SetText(text)
    end
    control.UserToggle = function (self)
        self:Toggle()
        if self.onToggled then
            self:onToggled()
        end
    end
    control.Toggle = function (self, selected)
        if nil ~= selected then
            self.isSelected = selected
        else
            self.isSelected = not self.isSelected
        end
        if self.isSelected then
            self.toggleAnimation:PlayForward()
        else
            self.toggleAnimation:PlayBackward()
        end
    end
end

---@param control MagicSorter_Toggle
function MagicSorterDialogs.Toggle_OnMouseEnter(control)
    control.highlightAnimation:PlayFromStart()
end

---@param control MagicSorter_Toggle
function MagicSorterDialogs.Toggle_OnMouseExit(control)
    control.highlightAnimation:PlayFromEnd()
end

---@param control MagicSorter_Toggle
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.Toggle_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:UserToggle()
end

---@param control MagicSorter_TabButton
function MagicSorterDialogs.TabButton_OnInitialized(control)
    control.active = false
    control.backdrop = control:GetNamedChild("Backdrop")
    control.label = control:GetNamedChild("Label")
    control.highlightAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TabButtonHighlightAnimation", control)
    control.SetInactive = function (self)
        self.active = false
        self.label:SetColor(1, 1, 1, 1)
    end
    control.SetActive = function (self)
        self.active = true
        self.label:SetColor(0.4, 1, 1, 1)
    end
end

---@param control MagicSorter_TabButton
function MagicSorterDialogs.TabButton_OnMouseEnter(control)
    control.highlightAnimation:PlayFromStart()
end

---@param control MagicSorter_TabButton
function MagicSorterDialogs.TabButton_OnMouseExit(control)
    control.highlightAnimation:PlayFromEnd()
end

---@param control MagicSorter_TabButton
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.TabButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:SetActive()
    if control.onMouseDown then
        control:onMouseDown()
    end
end

---@param control MagicSorter_OptionButton
function MagicSorterDialogs.OptionButton_OnInitialized(control)
    control.highlightAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_OptionButtonHighlightAnimation", control)
    control.hoverAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_OptionButtonHoverAnimation", control)
    control.backdropInset = control:GetNamedChild("BackdropInset")
    control.icon = control:GetNamedChild("Icon")
    control.label = control:GetNamedChild("Label")
    control.overlay = control:GetNamedChild("Overlay")
    control.overlayLabel = control:GetNamedChild("OverlayLabel")
    control.IsSelected = function ()
        return control.isSelected == true
    end
    control.Toggle = function (self, isSelected)
        if nil ~= isSelected then
            self.isSelected = isSelected
        else
            self.isSelected = not self.isSelected
        end
        self:Refresh()
        if self.onToggled then
            self:onToggled()
        end
    end
    control.Refresh = function ()
        if control:IsSelected() then
            control.highlightAnimation:PlayForward()
        else
            control.highlightAnimation:PlayBackward()
        end
    end
    control:Refresh()
end

---@param control MagicSorter_OptionButton
function MagicSorterDialogs.OptionButton_OnMouseEnter(control)
    control.hoverAnimation:PlayForward()
end

---@param control MagicSorter_OptionButton
function MagicSorterDialogs.OptionButton_OnMouseExit(control)
    control.hoverAnimation:PlayBackward()
end

---@param control MagicSorter_OptionButton
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.OptionButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:Toggle()
end

---@param control TextureControl
function MagicSorterDialogs.OptionButtonOverlay_OnMouseEnter(control)
    if control.tooltip then
        ZO_Tooltips_ShowTextTooltip(control, RIGHT, control.tooltip)
    end
end

---@param control TextureControl
function MagicSorterDialogs.OptionButtonOverlay_OnMouseExit(control)
    if control.tooltip then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control TextureControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.OptionButtonOverlay_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:GetParent():Toggle()
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemBackdrop_OnInitialized(control)
    control:SetVertexColors(2 + 8, 0.9, 0.9, 0.9, 1)
    control:SetVertexColors(1 + 4, 0, 0.7, 0.8, 1)
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemBackdrop_OnTextureLoaded(control)
    control:SetVertexColors(2 + 8, 0.9, 0.9, 0.9, 1)
    control:SetVertexColors(1 + 4, 0, 0.7, 0.8, 1)
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemRemoveButton_OnInitialized(control)
    control.highlightAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_RemoveButtonHighlightAnimation", control)
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemRemoveButton_OnMouseEnter(control)
    control.highlightAnimation:PlayForward()
end

---@param control TextureControl
function MagicSorterDialogs.RemovableItemRemoveButton_OnMouseExit(control)
    control.highlightAnimation:PlayBackward()
end

---@param control MagicSorter_DropBox
function MagicSorterDialogs.DropBox_OnInitialized(control)
    control.overlay = control:GetNamedChild("Overlay")
    control.overlayLabel = control.overlay:GetNamedChild("Label")
end

---@param control TextureControl
function MagicSorterDialogs.DropBoxTile_OnInitialized(control)
    control:SetVertexColors(1 + 4, 0, 0, 0, 0.8)
    control:SetVertexColors(2 + 8, 1, 1, 1, 0.8)
end

---@param control TextureControl
function MagicSorterDialogs.DropBoxOverlay_OnMouseEnter(control)
    if control.tooltip then
        ZO_Tooltips_ShowTextTooltip(control, RIGHT, control.tooltip)
    end
end

---@param control TextureControl
function MagicSorterDialogs.DropBoxOverlay_OnMouseExit(control)
    if control.tooltip then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.AssignThemesButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MagicSorter_ThemeAssignment:SetHouse(control:GetParent():GetParent().house)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
    MAGIC_SORTER:SetDialogHidden("ThemeAssignment", false)
end

---@param control LabelControl
function MagicSorterDialogs.AssignThemesButton_OnMouseEnter(control)
    control:SetColor(1, 1, 0.5, 1)
    control:GetNamedChild("Backdrop"):SetColor(0.05, 0.05, 0.05, 1)
end

---@param control LabelControl
function MagicSorterDialogs.AssignThemesButton_OnMouseExit(control)
    control:SetColor(1, 1, 1, 1)
    control:GetNamedChild("Backdrop"):SetColor(0, 0, 0, 1)
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ThemeAssignments_OnMouseDown(control, button, ctrl, alt, shift, command)
    MagicSorter_ThemeAssignment:SetHouse(control:GetParent():GetParent().house)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
    MAGIC_SORTER:SetDialogHidden("ThemeAssignment", false)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnInitialized(control)
    control.highlightAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_DragTagHighlightAnimation", control)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMoveStart(control)
    if not control.originalParent then
        control.originalParent = control:GetParent()
    end
    control:SetParent(MagicSorter_DragTopLevel)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMoveStop(control)
    MAGIC_SORTER:OnDropCategoryTag(control)
    if control.originalParent then
        control:SetParent(control.originalParent)
    end
    zo_callLater(function ()
                     control:ClearAnchors()
                     control:SetAnchor(TOPLEFT, control:GetOwningWindow().categoryScrollContents, TOPLEFT, control.originalX, control.originalY)
                 end, 100)
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMouseEnter(control)
    control.highlightAnimation:PlayForward()
    if control.tooltip then
        ZO_Tooltips_ShowTextTooltip(control, LEFT, control.tooltip)
    end
end

---@param control MagicSorter_DragTag
function MagicSorterDialogs.DragTag_OnMouseExit(control)
    control.highlightAnimation:PlayBackward()
    if control.tooltip then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control TextureControl
function MagicSorterDialogs.DragTagLabelBackdrop_OnInitialized(control)
    control:SetVertexColors(2 + 8, 0.9, 0.9, 0.9, 1)
    control:SetVertexColors(1 + 4, 0, 0.7, 0.8, 1)
end

---@param control TextureControl
function MagicSorterDialogs.DragTagLabelBackdrop_OnTextureLoaded(control)
    control:SetVertexColors(2 + 8, 0.9, 0.9, 0.9, 1)
    control:SetVertexColors(1 + 4, 0, 0.7, 0.8, 1)
end

---@param control MagicSorter_StatusDetailRow
function MagicSorterDialogs.StatusDetailRow_OnInitialized(control)
    control.backdrop = control:GetNamedChild("Backdrop")
    control.houseName = control:GetNamedChild("HouseName")
    control.houseCapacity = control:GetNamedChild("HouseCapacity")
    control.houseStatus = control:GetNamedChild("HouseStatus")
    control.SetHouse = function (self, houseId, houseName)
        self.houseId = houseId
        self.name = houseName
        self.houseName:SetText(houseName)
    end
    control.SetCapacity = function (self, capacity)
        self.houseCapacity:SetText(capacity)
    end
    control.SetStatus = function (self, status)
        self.houseStatus:SetText(status)
    end
    control.SetHeaderRow = function (self)
        self:SetHeight(56)
        self.backdrop:SetVertexColors(1 + 4, 0, 0.4, 0.4, 1.0)
        self.backdrop:SetVertexColors(2 + 8, 0.2, 0.8, 0.8, 1.0)
        self.houseName:SetColor(1, 1, 1, 1)
        self.houseName:SetMaxLineCount(2)
        self.houseCapacity:SetColor(1, 1, 1, 1)
        self.houseCapacity:SetMaxLineCount(2)
        self.houseStatus:SetColor(1, 1, 1, 1)
        self.houseStatus:SetMaxLineCount(2)
    end
    control.SetComplete = function (self, complete)
        if self.houseId == GetCurrentZoneHouseId() then
            self.backdrop:SetVertexColors(1 + 4, 0.2, 0.8, 0.8, 0.8)
            self.backdrop:SetVertexColors(2 + 8, 0.8, 0.2, 0.8, 0.8)
            self.houseName:SetColor(1, 1, 1, 1)
            self.houseCapacity:SetColor(1, 1, 1, 1)
            self.houseStatus:SetColor(1, 1, 1, 1)
        else
            if complete then
                self.backdrop:SetVertexColors(1 + 4, 0.0, 0.1, 0.1, 0.6)
                self.backdrop:SetVertexColors(2 + 8, 0.1, 0.0, 0.1, 0.6)
                self.houseName:SetColor(0.7, 0.7, 0.7, 1)
                self.houseCapacity:SetColor(0.7, 0.7, 0.7, 1)
                self.houseStatus:SetColor(0.7, 0.7, 0.7, 1)
            else
                self.backdrop:SetVertexColors(1 + 4, 0.0, 0.4, 0.4, 0.6)
                self.backdrop:SetVertexColors(2 + 8, 0.4, 0.0, 0.4, 0.6)
                self.houseName:SetColor(1, 1, 1, 1)
                self.houseCapacity:SetColor(1, 1, 1, 1)
                self.houseStatus:SetColor(1, 1, 1, 1)
            end
        end
    end
end

---@param control MagicSorter_StatusDetailRow
function MagicSorterDialogs.StatusDetailRow_OnMouseEnter(control)
    if control.houseId and control.houseId > 0 then
        local sortManager = MAGIC_SORTER:GetSortManager()
        local categories = MAGIC_SORTER:GetHouseCategoryAssigmentsString(control.houseId) or "No categories assigned"
        local capacityTraditional = tostring(sortManager:GetHouseCapacity(control.houseId, HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM) or "Unknown")
        local capacitySpecial = tostring(sortManager:GetHouseCapacity(control.houseId, HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM) or "Unknown")
        local tooltip = string.format("|cffff00%s\n\n|cffffffAvailable Slots\nTraditional: |c00ffff%s|cffffff\nSpecial: |c00ffff%s|cffffff\n\nAssigned Categories:\n|c00ffff%s|cffffff", control.name or "", capacityTraditional, capacitySpecial, categories)
        ZO_Tooltips_ShowTextTooltip(control, RIGHT, tooltip)
    end
end

---@param control MagicSorter_StatusDetailRow
function MagicSorterDialogs.StatusDetailRow_OnMouseExit(control)
    if control.houseId and control.houseId > 0 then
        ZO_Tooltips_HideTextTooltip()
    end
end

---@param control MagicSorter_TopLevelStandardLogoFooter
function MagicSorterDialogs.LogoFooter_OnInitialized(control)
    local height1, height2, height3 = 52 / 256, 138 / 256, 220 / 256
    control.logo = control:GetNamedChild("Logo")
    control.logo1 = control:GetNamedChild("Logo1")
    control.logo2 = control:GetNamedChild("Logo2")
    control.logo3 = control:GetNamedChild("Logo3")
    control.logo:SetVertexColors(1 + 4, 0, 1, 1, 1)
    control.logo:SetVertexColors(2 + 8, 1, 0, 1, 1)
    control.logo:SetTextureCoords(0, 1, height2 - height1, height2)
    control.logo1:SetTextureCoords(0, 1, 0, height1)
    control.logo2:SetTextureCoords(0, 1, height2 - height1, height2)
    control.logo3:SetTextureCoords(0, 1, height3 - height1, height3)
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_LogoAnimation", control)
end

---@param control MagicSorter_TopLevelStandardLogoFooter
---@param hidden boolean
function MagicSorterDialogs.LogoFooter_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control Control
---@param hidden boolean
function MagicSorterDialogs.LogoFooter_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control Control
function MagicSorterDialogs.Logo_OnTextureLoaded(control)
    control:SetVertexColors(1 + 4, 0, 1, 1, 1)
    control:SetVertexColors(2 + 8, 1, 0, 1, 1)
end

---@param control MagicSorter_TopLevelMovable
function MagicSorterDialogs.TopLevelMovable_OnShow(control)
    MAGIC_SORTER:OnDialogShow(control)
end

---@param control MagicSorter_TopLevelMovable
function MagicSorterDialogs.TopLevelMovable_OnMoveStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
end

-- House Selection Dialog
---@param control MagicSorter_HouseSelection
function MagicSorterDialogs.HouseSelection_OnInitialized(control)
    local topLevel = control
    control.optionButtons = {}
    local function OnSelectionChanged()
        topLevel:RefreshCount()
    end
    control.GetNumColumns = function ()
        local width = control.scrollPanel:GetWidth()
        local columns = zo_max(1, zo_floor((width - 10) / 160))
        return columns
    end
    control.GetOptionButtonPosition = function (self, optionIndex)
        local columns = self:GetNumColumns()
        local x, y = 10 + ((optionIndex - 1) % columns) * 160, 10 + zo_floor((optionIndex - 1) / columns) * 160
        return x, y
    end
    control.CreateOptionButton = function ()
        local optionIndex = #control.optionButtons + 1
        local x, y = control:GetOptionButtonPosition(optionIndex)
        local optionButton = CreateControlFromVirtual("HouseOptionButton", control.scrollContents, "MagicSorter_OptionButton", optionIndex)
        optionButton:SetDimensions(152, 152)
        optionButton:SetAnchor(TOPLEFT, control.scrollContents, TOPLEFT, x, y)
        optionButton.onToggled = OnSelectionChanged
        control.optionButtons[optionIndex] = optionButton
        return optionButton
    end
    control.RefreshCount = function ()
        local houses = control:GetSelectedHouses()
        local count = 0
        if houses then
            count = #houses
        end
        control.countLabel:SetText(string.format("%d house%s selected", count, count == 1 and "" or "s"))
    end
    control.Refresh = function ()
        local houses = MAGIC_SORTER:GetOwnedHouses()
        local optionIndex = 0
        for houseIndex, house in ipairs(houses) do
            local houseStats = MAGIC_SORTER:GetInventoryManager():GetHouseStatistics(house.houseId)
            local optionButton = control.optionButtons[houseIndex]
            if not optionButton then
                optionButton = control:CreateOptionButton()
            end
            optionIndex = optionIndex + 1
            local x, y = control:GetOptionButtonPosition(optionIndex)
            optionButton:ClearAnchors()
            optionButton:SetAnchor(TOPLEFT, control.scrollContents, TOPLEFT, x, y)
            local icon = optionButton:GetNamedChild("Icon")
            local label = optionButton:GetNamedChild("Label")
            icon:SetTexture(house.houseImage)
            icon:SetTextureCoords(0.1, 0.5, 0, 0.7)
            icon:SetDimensions(128, 102)
            label:SetText(house.houseName)
            if houseStats then
                local lastUpdate = MAGIC_SORTER:GetInventoryManager():GetLastHouseUpdate(house.houseId) or 0
                local unknown = lastUpdate == 0
                local age = GetTimeStamp() - lastUpdate
                local ageHours = zo_min(zo_floor(age / 60 / 60), 48)
                local isOld = ageHours >= 24
                local lowImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or 0
                local lowImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or 0
                local highImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or 0
                local highImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or 0
                optionButton.overlayLabel:SetText(string.format("%d/%d%s", lowImpactUsed, lowImpactLimit, isOld and "*" or ""))
                if isOld then
                    optionButton.overlayLabel:SetColor(0.8, 0.8, 0.6, 1)
                else
                    optionButton.overlayLabel:SetColor(1, 1, 1, 1)
                end
                optionButton.overlay.tooltip = string.format("Furnishing Limit Usage\n%d of %d Traditional Used\n%d of %d Special Used%s", lowImpactUsed, lowImpactLimit, highImpactUsed, highImpactLimit, unknown and "\n\n* Current figures are unknown" or isOld and string.format("\n\n* Figures from %d+ hours ago", ageHours) or "")
                optionButton.overlay:SetHidden(false)
            else
                optionButton.overlay:SetHidden(true)
            end
            optionButton.house = house
            optionButton.isSelected = nil ~= MAGIC_SORTER:GetStorageHouse(house.houseId)
            optionButton:SetHidden(false)
            optionButton:Refresh()
        end
        local numHouses = #houses
        for index = numHouses + 1, #control.optionButtons do
            control.optionButtons[index]:SetHidden(true)
            control.optionButtons[index].house = nil
        end
        local columns = control:GetNumColumns()
        local maxY = zo_floor((numHouses - 1) / columns) * 160
        control.scrollSlider:SetMinMax(0, maxY)
        control:RefreshCount()
    end
    control.GetSelectedHouses = function ()
        local houses = {}
        for houseIndex, optionButton in ipairs(control.optionButtons) do
            if optionButton.house and optionButton:IsSelected() then
                table.insert(houses, optionButton.house)
            end
        end
        return houses
    end
    control.Submit = function ()
        local houses = control:GetSelectedHouses()
        return MAGIC_SORTER:OnSubmitStorageHouses(houses)
    end
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_HouseSelection
---@param hidden boolean
function MagicSorterDialogs.HouseSelection_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_HouseSelection
---@param hidden boolean
function MagicSorterDialogs.HouseSelection_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_HouseSelection
function MagicSorterDialogs.HouseSelection_OnResizeStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
    control:Refresh()
end

---@param control ScrollControl
function MagicSorterDialogs.HouseSelectionScrollPanel_OnInitialized(control)
    control:GetOwningWindow().scrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseSelectionScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().scrollSlider
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 150))
end

---@param control Control
function MagicSorterDialogs.HouseSelectionScrollContents_OnInitialized(control)
    control:GetOwningWindow().scrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.HouseSelectionScrollSlider_OnInitialized(control)
    control:GetOwningWindow().scrollSlider = control
    control:SetValue(1)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.HouseSelectionScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().scrollPanel:SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseSelectionCloseButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("HouseSelection", true)
end

---@param control MagicSorter_CenterLabel
function MagicSorterDialogs.HouseSelectionCountLabel_OnInitialized(control)
    control:GetOwningWindow().countLabel = control:GetNamedChild("Label")
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseSelectionNextButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if control:GetOwningWindow():Submit() then
        MAGIC_SORTER:SetDialogHidden("HouseSelection", true)
        MAGIC_SORTER:SetDialogHidden("CategoryAssignment", false)
    end
end

-- Category Assignment Dialog
---@param control MagicSorter_CategoryAssignment
function MagicSorterDialogs.CategoryAssignment_OnInitialized(control)
    local topLevel = control
    local function AssignedCategoryComparer(catA, catB)
        return catB.name > catA.name
    end
    local function HouseNameComparer(houseA, houseB)
        return houseB.houseName > houseA.houseName
    end
    local assignedCategoryControls = {}
    control.assignedCategoryPool = ZO_ControlPool:New("MagicSorter_RemovableItem", MagicSorter_CategoryAssignment)
    control.ResetAssignedCategoryControlPool = function ()
        control.assignedCategoryPool:ReleaseAllObjects()
        for _, controlItem in ipairs(assignedCategoryControls) do
            controlItem:SetHidden(true)
            controlItem:ClearAnchors()
            controlItem:SetParent(GuiRoot)
        end
        assignedCategoryControls = {}
    end
    control.CreateAssignedCategory = function (self, parentControl, houseId, categoryId, categoryName, offsetX, offsetY, width, height)
        local controlItem, key = self.assignedCategoryPool:AcquireObject()
        table.insert(assignedCategoryControls, controlItem)
        controlItem.poolKey = key
        controlItem.houseId = houseId
        controlItem.categoryId = categoryId
        controlItem:SetDimensions(width or 300, height or 40)
        controlItem:ClearAnchors()
        controlItem:SetParent(parentControl)
        controlItem:SetSimpleAnchorParent(offsetX, offsetY)
        local removeButton = controlItem:GetNamedChild("RemoveButton")
        removeButton:SetHandler("OnMouseDown", function ()
            MAGIC_SORTER:UnassignCategoryFromHouse(houseId, categoryId)
            topLevel:Refresh()
        end)
        removeButton:SetDrawTier(DT_MEDIUM)
        removeButton:SetDrawLayer(DL_TEXT)
        removeButton:SetDrawLevel(10)
        controlItem:GetNamedChild("Label"):SetText(categoryName)
        controlItem:SetHidden(false)
        return controlItem
    end
    control.categoryTags = {}
    control.CreateCategoryTag = function (self, category)
        local categoryId = category.id
        local categoryTag = CreateControlFromVirtual("CategoryTag", self.categoryScrollContents, "MagicSorter_DragTag", categoryId)
        self.categoryTags[categoryId] = categoryTag
        categoryTag.category = category
        categoryTag:SetParent(self.categoryScrollContents)
        categoryTag:GetNamedChild("Label"):SetText(category.displayName)
        return categoryTag
    end
    control.CreateHouseBox = function (self, house)
        local houseId = house.houseId
        local houseBox = CreateControlFromVirtual("HouseBox", self.houseScrollContents, "MagicSorter_DropBox", houseId)
        self.houseBoxes[houseId] = houseBox
        houseBox.house = house
        houseBox:SetParent(self.houseScrollContents)
        houseBox:SetDimensions(400, 100)
        houseBox:GetNamedChild("Label"):SetText(house.houseName)
        houseBox:GetNamedChild("TileBackdrop"):SetTexture(house.houseImage)
        houseBox:GetNamedChild("TileBackdrop"):SetTextureCoords(0, 0.68, 0.2, 0.45)
        return houseBox
    end
    control.RefreshScrollSlider = function ()
        local containerHeight = control.houseScrollPanel:GetHeight()
        local houseHeight = control.houseScrollContents:GetHeight()
        local houseViewHeight = houseHeight - containerHeight
        control.houseScrollSlider:SetMinMax(0, zo_max(1, houseViewHeight))
        local categoryHeight = control.categoryScrollContents:GetHeight()
        local categoryViewHeight = categoryHeight - containerHeight
        control.categoryScrollSlider:SetMinMax(0, zo_max(1, categoryViewHeight))
    end
    control.RefreshScrollContents = function ()
        local _, minY, _, maxY = control.houseScrollPanel:GetScreenRect()
        local numVisible = 0
        for _, houseBox in pairs(control.houseBoxes) do
            local y1, y2 = houseBox:GetTop(), houseBox:GetBottom()
            if houseBox.active and ((y1 >= minY and maxY >= y1) or (y2 >= minY and maxY >= y2)) then
                houseBox:SetHidden(false)
                numVisible = numVisible + 1
            else
                houseBox:SetHidden(true)
            end
        end
    end
    control.Refresh = function ()
        control:ResetAssignedCategoryControlPool()
        if not control.houseBoxes then
            control.houseBoxes = {}
        end
        local houses = MAGIC_SORTER:GetStorageHouses()
        local activeHouses = {}
        for houseId, house in pairs(houses) do
            local houseBox = control.houseBoxes[house.houseId]
            if not houseBox then
                houseBox = control:CreateHouseBox(house)
            end
            houseBox.active = true
            activeHouses[houseId] = true
        end
        for houseId, houseBox in pairs(control.houseBoxes) do
            if not activeHouses[houseId] then
                houseBox:SetHidden(true)
                houseBox.active = false
            end
        end
        local sortedBoxes = {}
        for _, houseBox in pairs(control.houseBoxes) do
            table.insert(sortedBoxes, houseBox)
        end
        table.sort(sortedBoxes, function (boxA, boxB) return boxB.house.houseName > boxA.house.houseName end)
        local houseY = 6
        local tagY
        for houseIndex, houseBox in ipairs(sortedBoxes) do
            local houseId = houseBox.house.houseId
            houseBox:ClearAnchors()
            if activeHouses[houseId] then
                local themes = houseBox.house.assignedThemeIds or {}
                local themeCount = NonContiguousCount(themes)
                local themeCountText = themeCount == 0 and "All" or tostring(themeCount)
                local houseStats = MAGIC_SORTER:GetInventoryManager():GetHouseStatistics(houseId)
                if houseStats then
                    local lastUpdate = MAGIC_SORTER:GetInventoryManager():GetLastHouseUpdate(houseId) or 0
                    local unknown = lastUpdate == 0
                    local age = GetTimeStamp() - lastUpdate
                    local ageHours = zo_min(zo_floor(age / 60 / 60), 48)
                    local isOld = ageHours >= 24
                    local lowImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or 0
                    local lowImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM] or 0
                    local highImpactUsed = houseStats.limits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or 0
                    local highImpactLimit = houseStats.maxLimits[HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM] or 0
                    local limitText = string.format("%d/%d%s", lowImpactUsed, lowImpactLimit, isOld and "*" or "")
                    houseBox.overlayLabel:SetText(limitText)
                    if isOld then
                        houseBox.overlayLabel:SetColor(0.8, 0.8, 0.6, 1)
                    else
                        houseBox.overlayLabel:SetColor(1, 1, 1, 1)
                    end
                    local tooltipLimits = string.format("Furnishing Limit Usage\n%d of %d Traditional Used\n%d of %d Special Used%s", lowImpactUsed, lowImpactLimit, highImpactUsed, highImpactLimit, unknown and "\n\n* Current figures are unknown" or isOld and string.format("\n\n* Figures from %d+ hours ago", ageHours) or "")
                    local tooltipThemes
                    if themes then
                        local themeNames = MAGIC_SORTER:GetSortManager().FurnitureThemes
                        local themeList = {}
                        for themeId in pairs(themes) do
                            table.insert(themeList, themeNames[themeId] or "")
                        end
                        table.sort(themeList)
                        if #themeList > 0 then
                            tooltipThemes = table.concat(themeList, "\n")
                        end
                    end
                    houseBox.overlay.tooltip = string.format("%s%s", tooltipLimits, tooltipThemes and string.format("\n\n%s", tooltipThemes) or "")
                    houseBox.overlay:SetHidden(false)
                else
                    houseBox.overlay:SetHidden(true)
                end
                houseBox:GetNamedChild("AssignThemes"):GetNamedChild("ThemeAssignments"):SetText(string.format("(%s assigned)", themeCountText))
                local houseHeight = 112
                houseBox:SetSimpleAnchorParent(0, houseY)
                tagY = houseHeight
                local assignedCategories = MAGIC_SORTER:GetHouseCategoryAssignments(houseId)
                local assignedParentCategories = {}
                local assignedCategoryTable = {}
                for _, category in ipairs(assignedCategories) do
                    table.insert(assignedCategoryTable, category)
                    if category.parentId == 0 then
                        assignedParentCategories[category.id] = true
                    end
                end
                if #assignedCategoryTable ~= 0 then
                    table.sort(assignedCategoryTable, AssignedCategoryComparer)
                    for index, category in ipairs(assignedCategoryTable) do
                        if not assignedParentCategories[category.parentId] then
                            control:CreateAssignedCategory(houseBox, houseId, category.id, category.displayName, 8, tagY, 360, 28)
                            tagY = tagY + 32
                            houseHeight = houseHeight + 32
                        end
                    end
                end
                houseHeight = houseHeight + 14
                houseBox:SetHeight(houseHeight)
                houseBox:SetHidden(false)
                houseY = houseY + houseHeight + 10
            end
        end
        control.houseScrollContents:SetDimensions(380, houseY)

        if not control.categoryTags then
            control.categoryTags = {}
        end
        local categories = MAGIC_SORTER:GetFurnitureCategories()
        for categoryId, category in pairs(categories) do
            local categoryTag = control.categoryTags[categoryId]
            if not categoryTag then
                categoryTag = control:CreateCategoryTag(category)
            end
            local assignments = MAGIC_SORTER:GetCategoryHouseAssignments(categoryId)
            local numAssignments = #assignments
            local tooltip
            categoryTag:GetNamedChild("AssignmentsLabel"):SetText(numAssignments == 0 and "" or string.format("%d house%s", numAssignments, 1 == numAssignments and "" or "s"))
            if numAssignments > 0 then
                table.sort(assignments, HouseNameComparer)
                tooltip = string.format("Assigned House%s:|cffffff", numAssignments == 1 and "" or "s")
                for index, house in ipairs(assignments) do
                    tooltip = string.format("%s\n%s", tooltip, house.houseName)
                end
            end
            categoryTag.tooltip = tooltip
        end
        local sortedTags = {}
        for _, categoryTag in pairs(control.categoryTags) do
            table.insert(sortedTags, categoryTag)
        end
        table.sort(sortedTags, function (tagA, tagB) return tagB.category.displayName > tagA.category.displayName end)
        tagY = 4
        for tagIndex, categoryTag in ipairs(sortedTags) do
            local offsetX, width
            if categoryTag.category.parentId == 0 then
                offsetX, width = 0, 350
            else
                offsetX, width = 22, 328
            end
            categoryTag:ClearAnchors()
            categoryTag:SetAnchor(TOPLEFT, control.categoryScrollContents, TOPLEFT, offsetX, tagY)
            categoryTag:SetDimensions(width, 32)
            categoryTag.originalX = offsetX
            categoryTag.originalY = tagY
            tagY = tagY + 36
        end
        control.categoryScrollContents:SetDimensions(380, tagY)

        control:RefreshScrollSlider()
    end
    control.Submit = function ()
        return MAGIC_SORTER:OnSubmitCategoryAssignments()
    end
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_CategoryAssignment
---@param hidden boolean
function MagicSorterDialogs.CategoryAssignment_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_CategoryAssignment
---@param hidden boolean
function MagicSorterDialogs.CategoryAssignment_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_CategoryAssignment
function MagicSorterDialogs.CategoryAssignment_OnResizeStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
    control:Refresh()
end

---@param control ScrollControl
function MagicSorterDialogs.CategoryScrollPanel_OnInitialized(control)
    control:GetOwningWindow().categoryScrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CategoryScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().categoryScrollSlider
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 150))
end

---@param control Control
function MagicSorterDialogs.CategoryScrollContents_OnInitialized(control)
    control:GetOwningWindow().categoryScrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.CategoryScrollSlider_OnInitialized(control)
    control:GetOwningWindow().categoryScrollSlider = control
    control:SetValue(1)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.CategoryScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().categoryScrollPanel:SetVerticalScroll(value)
end

---@param control ScrollControl
function MagicSorterDialogs.HouseScrollPanel_OnInitialized(control)
    control:GetOwningWindow().houseScrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.HouseScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().houseScrollSlider
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 150))
end

---@param control Control
function MagicSorterDialogs.HouseScrollContents_OnInitialized(control)
    control:GetOwningWindow().houseScrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.HouseScrollSlider_OnInitialized(control)
    control:GetOwningWindow().houseScrollSlider = control
    control:SetValue(1)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.HouseScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().houseScrollPanel:SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CategoryAssignmentBackButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
    MAGIC_SORTER:SetDialogHidden("HouseSelection", false)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CategoryAssignmentNextButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if control:GetOwningWindow():Submit() then
        MAGIC_SORTER:SetDialogHidden("CategoryAssignment", true)
        MAGIC_SORTER:SetDialogHidden("Disclaimer", false)
    end
end

-- Theme Assignment Dialog
---@param control MagicSorter_ThemeAssignment
function MagicSorterDialogs.ThemeAssignment_OnInitialized(control)
    local buttonWidth, buttonHeight = 120, 54
    local topLevel = control
    control.subtitle = control:GetNamedChild("BodySubtitleLabel")
    control.optionButtons = {}
    local function OnSelectionChanged(controlItem)
        topLevel:Submit(controlItem)
        topLevel:Refresh()
    end
    control.GetHouse = function ()
        local house = MAGIC_SORTER:GetStorageHouse(control.house.houseId)
        house.assignedThemeIds = house.assignedThemeIds or {}
        return house
    end
    control.SetHouse = function (self, house)
        self.house = house
    end
    control.GetNumColumns = function ()
        local width = control.scrollPanel:GetWidth()
        local columns = zo_max(1, zo_floor((width - 10) / buttonWidth))
        return columns
    end
    control.GetOptionButtonPosition = function (self, optionIndex)
        local columns = self:GetNumColumns()
        local x, y = 10 + ((optionIndex - 1) % columns) * buttonWidth, 10 + zo_floor((optionIndex - 1) / columns) * buttonHeight
        return x, y
    end
    control.CreateOptionButton = function ()
        local optionIndex = #control.optionButtons + 1
        local optionButton = CreateControlFromVirtual("ThemeOptionButton", control.scrollContents, "MagicSorter_Toggle", optionIndex)
        optionButton:ClearAnchors()
        optionButton:SetDimensions(buttonWidth - 8, buttonHeight - 8)
        optionButton.onToggled = OnSelectionChanged
        control.optionButtons[optionIndex] = optionButton
        local x, y = control:GetOptionButtonPosition(optionIndex)
        optionButton:SetAnchor(TOPLEFT, control.scrollContents, TOPLEFT, x, y)
        return optionButton
    end
    control.RefreshCount = function ()
        local house = control:GetHouse()
        local themes = house.assignedThemeIds
        local countString = "All"
        local count = NonContiguousCount(themes)
        if themes and count > 0 then
            countString = tostring(count)
        end
        control.countLabel:SetText(string.format("%s selected", countString))
    end
    control.Refresh = function ()
        local themes = MAGIC_SORTER:GetSortManager().FurnitureThemeList
        local house = control:GetHouse()
        local assigned = house.assignedThemeIds
        local allSelected = NonContiguousCount(assigned) == 0
        control.subtitle:SetText(house.houseName)
        if #control.optionButtons == 0 then
            for _, theme in ipairs(themes) do
                local optionButton = control:CreateOptionButton()
                optionButton.theme = theme
                optionButton:SetLabel(theme.name)
                optionButton:SetHidden(false)
            end
        end
        for _, optionButton in ipairs(control.optionButtons) do
            local theme = optionButton.theme
            local selected
            if theme.id == 0 then
                selected = allSelected
            else
                selected = true == assigned[theme.id] and not allSelected
            end
            optionButton:Toggle(selected)
        end
        local columns = control:GetNumColumns()
        local maxY = zo_floor(#themes / columns) * buttonHeight
        control.scrollSlider:SetMinMax(0, maxY)
        control:RefreshCount()
    end
    control.GetSelectedThemes = function ()
        local themes = {}
        for _, optionButton in ipairs(control.optionButtons) do
            if optionButton:IsSelected() then
                if optionButton.theme.id == 0 then
                    themes = {}
                    break
                else
                    themes[optionButton.theme.id] = true
                end
            else
                themes[optionButton.theme.id] = nil
            end
        end
        return themes
    end
    control.Submit = function (self, optionButton)
        local house = self:GetHouse()
        if optionButton then
            local selected = optionButton:IsSelected()
            local themeId = optionButton.theme.id
            if themeId == 0 and selected then
                for _, optionButtonItem in ipairs(self.optionButtons) do
                    if optionButtonItem.theme.id ~= 0 then
                        optionButtonItem:Toggle(false)
                    end
                end
            elseif themeId ~= 0 and selected then
                for _, optionButtonItem in ipairs(self.optionButtons) do
                    if optionButtonItem.theme.id == 0 then
                        optionButtonItem:Toggle(false)
                    end
                end
            end
        end
        house.assignedThemeIds = self:GetSelectedThemes()
        MAGIC_SORTER:OnSettingsChanged()
        return true
    end
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_ThemeAssignment
---@param hidden boolean
function MagicSorterDialogs.ThemeAssignment_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    control:Refresh()
end

---@param control MagicSorter_ThemeAssignment
---@param hidden boolean
function MagicSorterDialogs.ThemeAssignment_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_ThemeAssignment
function MagicSorterDialogs.ThemeAssignment_OnResizeStop(control)
    MAGIC_SORTER:OnDialogMoved(control)
    control:Refresh()
end

---@param control ScrollControl
function MagicSorterDialogs.ThemeScrollPanel_OnInitialized(control)
    control:GetOwningWindow().scrollPanel = control
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ThemeScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetOwningWindow().scrollSlider
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 60))
end

---@param control Control
function MagicSorterDialogs.ThemeScrollContents_OnInitialized(control)
    control:GetOwningWindow().scrollContents = control
end

---@param control SliderControl
function MagicSorterDialogs.ThemeScrollSlider_OnInitialized(control)
    control:GetOwningWindow().scrollSlider = control
    control:SetValue(1)
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.ThemeScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetOwningWindow().scrollPanel:SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ThemeAssignmentSaveButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("ThemeAssignment", true)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", false)
end

---@param control MagicSorter_CenterLabel
function MagicSorterDialogs.ThemeAssignmentCountLabel_OnInitialized(control)
    control:GetOwningWindow().countLabel = control:GetNamedChild("Label")
end

-- Disclaimer Dialog
---@param control MagicSorter_Disclaimer
function MagicSorterDialogs.Disclaimer_OnInitialized(control)
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
    local body = control:GetNamedChild("Body")
    body:GetNamedChild("StartQuickSort").tooltip = "Sorts your storage homes using Magic Sorter's furniture tracking " ..
        "data in order to avoid visits to homes that are already sorted. " ..
        "Note that a full scan will be required if you have changed any sort options.\n\n" ..
        "Only use this option if you have the Magic Sorter add-on enabled for all of your characters; " ..
        "otherwise, Magic Sorter's furniture tracking data may not be accurate."
    body:GetNamedChild("StartFullSort").tooltip = "Performs a thorough sort of all of your storage homes."
end

---@param control MagicSorter_Disclaimer
---@param hidden boolean
function MagicSorterDialogs.Disclaimer_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    zo_callLater(function () MAGIC_SORTER:SetUIMode(true) end, 300)
end

---@param control MagicSorter_Disclaimer
---@param hidden boolean
function MagicSorterDialogs.Disclaimer_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control MagicSorter_OptionButton
---@param hidden boolean
function MagicSorterDialogs.DisclaimerManageLayout_OnEffectivelyShown(control, hidden)
    control.onToggled = function (self)
        if MAGIC_SORTER then
            MAGIC_SORTER:SetOrganizationEnabled(self:IsSelected())
        end
    end
    local icon = control:GetNamedChild("Icon")
    icon:SetTexture("MagicSorter/media/button-stack-furniture.dds")
    icon:SetDimensions(116, 116)
    local label = control:GetNamedChild("Label")
    label:SetFont("$(GAMEPAD_MEDIUM_FONT)|$(GP_20)")
    label:SetText("Organize Furniture")
    control:Toggle(MAGIC_SORTER:IsOrganizationEnabled())
end

---@param control Control
function MagicSorterDialogs.DisclaimerManageLayout_OnMouseEnter(control)
    ZO_Tooltips_ShowTextTooltip(control, RIGHT, "When this option is enabled your stored furnishings will automatically be placed neatly in stacks.\n\n" ..
        "Disable this option if you would prefer to organize your stored furnishings manually; when this option is disabled all furnishings will " ..
        "be placed in a single stack.")
end

---@param control Control
function MagicSorterDialogs.DisclaimerManageLayout_OnMouseExit(control)
    ZO_Tooltips_HideTextTooltip()
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DisclaimerBackButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("Disclaimer", true)
    MAGIC_SORTER:SetDialogHidden("CategoryAssignment", false)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DisclaimerStartQuickSort_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetQuickSortMode(true)
    MAGIC_SORTER:SetDialogHidden("Disclaimer", true)
    MAGIC_SORTER:SetDialogHidden("StorageProgress", false)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DisclaimerStartFullSort_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetQuickSortMode(false)
    MAGIC_SORTER:SetDialogHidden("Disclaimer", true)
    MAGIC_SORTER:SetDialogHidden("StorageProgress", false)
end

-- Storage Progress Dialog
---@param control MagicSorter_StorageProgress
function MagicSorterDialogs.StorageProgress_OnInitialized(control)
    control.statusDetailRows = {}
    control.Refresh = function ()
        control.isActive = true
        control.suspendButton = control:GetNamedChild("Body"):GetNamedChild("SuspendButton")
        control.suspendButtonLabel = control.suspendButton:GetNamedChild("Label")
        control.cancelButton = control:GetNamedChild("Body"):GetNamedChild("CancelButton")
        control.showDetailsButton = control:GetNamedChild("Body"):GetNamedChild("ShowDetailsButton")
        control.hideDetailsButton = control:GetNamedChild("Body"):GetNamedChild("HideDetailsButton")
        MAGIC_SORTER:StartAutomaticStorage()
        control:RefreshStatus()
    end
    control.RefreshStatus = function ()
        control.statusLabel:SetText(control.message)
        control.suspendButtonLabel:SetText(control.isActive and "Suspend" or "Resume")
        control.activeWarning:SetHidden(not control.isActive)
        EVENT_MANAGER:RegisterForUpdate(MAGIC_SORTER.EventDescriptor .. "RefreshStatusDetail", 2800, MagicSorter_StorageProgressDetail.RefreshStatusDetail)
    end
    control.SetMessage = function (self, message)
        self.message = message
        self:RefreshStatus()
    end
    control.SetState = function (self, isActive)
        self.isActive = isActive
        self:RefreshStatus()
    end
    control.SetComplete = function (self, isComplete)
        if isComplete then
            MAGIC_SORTER:SetDialogHidden("StorageProgress", true)
            MAGIC_SORTER:SetDialogHidden("Complete", false)
            EVENT_MANAGER:RegisterForUpdate(MAGIC_SORTER.EventDescriptor .. "AutoReload", 60000, function ()
                EVENT_MANAGER:UnregisterForUpdate(MAGIC_SORTER.EventDescriptor .. "AutoReload")
                MAGIC_SORTER:GetData().showCompleteDialog = true
                ReloadUI("ingame")
            end)
        end
    end
    control.OnExpandCollapseDetails = function ()
        control.detailsCollapsed = not control.detailsCollapsed
        MagicSorter_StorageProgressDetail:SetHidden(control.detailsCollapsed)
        if control.showDetailsButton then
            control.showDetailsButton:SetHidden(not control.detailsCollapsed)
            control.hideDetailsButton:SetHidden(control.detailsCollapsed)
        end
    end
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
end

---@param control MagicSorter_StorageProgress
---@param hidden boolean
function MagicSorterDialogs.StorageProgress_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    if not control.detailsCollapsed then
        MagicSorter_StorageProgressDetail:SetHidden(false)
    end
end

---@param control MagicSorter_StorageProgress
---@param hidden boolean
function MagicSorterDialogs.StorageProgress_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
    MagicSorter_StorageProgressDetail:SetHidden(true)
end

---@param control MagicSorter_CenterSubtitle
function MagicSorterDialogs.StorageProgressStatus_OnInitialized(control)
    local label = control:GetNamedChild("Label")
    label:SetMaxLineCount(2)
    control:GetOwningWindow().statusLabelBox = control
    control:GetOwningWindow().statusLabel = label
end

---@param control LabelControl
function MagicSorterDialogs.StorageProgressActiveWarning_OnInitialized(control)
    control:GetOwningWindow().activeWarning = control
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressSuspendButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if MAGIC_SORTER:IsAutomaticStorageRunning() then
        MAGIC_SORTER:SuspendAutomaticStorage()
    else
        MAGIC_SORTER:ResumeAutomaticStorage()
    end
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressCancelButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    if MAGIC_SORTER:IsAutomaticStorageRunning() then
        MAGIC_SORTER:CancelAutomaticStorage()
    end
    MAGIC_SORTER:SetDialogHidden("StorageProgress", true)
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressShowDetailsButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:GetOwningWindow():OnExpandCollapseDetails()
end

---@param control LabelControl
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.StorageProgressHideDetailsButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    control:GetOwningWindow():OnExpandCollapseDetails()
end

-- Storage Progress Detail Dialog
---@param control MagicSorter_StorageProgressDetail
function MagicSorterDialogs.StorageProgressDetail_OnInitialized(control)
    control.previousHouseIndex = nil
    control.statusDetailRows = {}
    control.actionLogScrollContainer = control:GetNamedChild("LogScrollContainer")
    control.actionLogScrollSlider = control.actionLogScrollContainer:GetNamedChild("LogScrollSlider")
    control.detailScrollContainer = control:GetNamedChild("DetailScrollContainer")
    control.detailPanel = control:GetNamedChild("DetailScrollContainer"):GetNamedChild("DetailScrollPanel")
    control.detailScrollContents = control.detailPanel:GetNamedChild("DetailScrollContents")
    control.detailScrollSlider = control:GetNamedChild("DetailScrollContainer"):GetNamedChild("DetailScrollSlider")
    local detailTabButton = control:GetNamedChild("DetailTabButton")
    local logTabButton = control:GetNamedChild("LogTabButton")
    local myself = control
    detailTabButton.onMouseDown = function (self)
        detailTabButton:SetActive()
        logTabButton:SetInactive()
        myself.actionLogScrollContainer:SetHidden(true)
        myself.detailScrollContainer:SetHidden(false)
    end
    logTabButton.onMouseDown = function (self)
        detailTabButton:SetInactive()
        logTabButton:SetActive()
        myself.actionLogScrollContainer:SetHidden(false)
        myself.detailScrollContainer:SetHidden(true)
    end
    detailTabButton:SetActive()
    local headerRow = control:GetNamedChild("DetailScrollContainer"):GetNamedChild("HeaderRow")
    control.headerRow = headerRow
    headerRow:SetHouse(-1, "Storage House")
    headerRow:SetCapacity("Traditional/\nSpecial Slots")
    headerRow:SetStatus("Pending Items\nOutbound/Inbound")
    headerRow:SetHeaderRow()
    ---@diagnostic disable-next-line: missing-parameter
    headerRow:SetAnchor(TOPLEFT)
    headerRow:SetHidden(false)
    control.RefreshStatusDetail = function ()
        EVENT_MANAGER:UnregisterForUpdate(MAGIC_SORTER.EventDescriptor .. "RefreshStatusDetail")
        if control.detailPanel:IsHidden() then
            return
        end
        local houses = {}
        local sortManager = MAGIC_SORTER:GetSortManager()
        for _, house in pairs(MAGIC_SORTER:GetStorageHouses()) do
            local houseId = house.houseId
            local removables = sortManager:GetHouseRemovables(houseId)
            local removableCount = removables and #removables or nil
            local placeables = sortManager:GetPlaceableFurnitureListForHouse(houseId)
            local placeableCount = 0
            if placeables then
                for _, placeable in ipairs(placeables) do
                    placeableCount = placeableCount + (placeable.stackSize or 1)
                end
            end
            local status = { houseId = houseId, houseName = house.houseName, placeable = placeableCount, removable = removableCount }
            table.insert(houses, status)
        end
        table.sort(houses, function (houseA, houseB) return houseB.houseName > houseA.houseName end)
        local currentHouseId = GetCurrentZoneHouseId()
        local currentHouseIndex
        for index = 1, #houses do
            if houses[index].houseId == currentHouseId then
                currentHouseIndex = index
                break
            end
        end
        local previousRow
        local maxIndex = 0
        for index, house in ipairs(houses) do
            local controlItem = control.statusDetailRows[index]
            if not controlItem then
                controlItem = WINDOW_MANAGER:CreateControlFromVirtual("MagicSorter_StorageProgressStatusDetailRow", control.detailScrollContents, "MagicSorter_StatusDetailRow", index)
                if previousRow then
                    controlItem:SetAnchor(TOPLEFT, previousRow, BOTTOMLEFT)
                else
                    controlItem:SetAnchor(TOPLEFT, previousRow, TOPLEFT)
                end
                control.statusDetailRows[index] = controlItem
            end
            controlItem:SetHouse(house.houseId, house.houseName)
            local capacityTraditional = sortManager:GetHouseCapacity(house.houseId, HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM)
            local capacitySpecial = sortManager:GetHouseCapacity(house.houseId, HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM)
            if capacityTraditional and capacitySpecial then
                controlItem:SetCapacity(string.format("%d/%d available", capacityTraditional, capacitySpecial))
            else
                controlItem:SetCapacity("-/-")
            end
            if house.removable and house.placeable then
                local placeableColor = house.placeable ~= 0 and "|c99ffff" or "|cdddddd"
                local removableColor = house.removable ~= 0 and "|c99ffff" or "|cdddddd"
                controlItem:SetStatus(string.format("%s%d|cffffff item%s/%s%d|cffffff item%s", removableColor, house.removable, house.removable == 1 and "" or "s", placeableColor, house.placeable, house.placeable == 1 and "" or "s"))
            else
                controlItem:SetStatus("Assessing")
            end
            controlItem:SetComplete(house.removable and house.removable == 0 and house.placeable and house.placeable == 0)
            controlItem:SetHidden(false)
            previousRow = controlItem
            maxIndex = index
        end
        local height = 4 + maxIndex * 30
        control.detailScrollContents:SetDimensions(540, height)
        control.detailScrollSlider:SetMinMax(0, height)
        for index = maxIndex + 1, #control.statusDetailRows do
            control.statusDetailRows[index]:SetHidden(true)
        end
        if currentHouseIndex and currentHouseIndex ~= control.previousHouseIndex then
            control.detailScrollSlider:SetValue(zo_max(0, 30 * (currentHouseIndex - 2)))
            control.previousHouseIndex = currentHouseIndex
        end
    end
    control.RefreshActionLog = function (self)
        local actions = MAGIC_SORTER:GetSortManager():GetActionLog()
        if actions and #actions ~= 0 then
            local slider = self.actionLogScrollSlider
            local panel = self:GetNamedChild("LogScrollContainerLogScrollPanel")
            local logContainer = self:GetNamedChild("LogScrollContainerLogScrollPanelLogScrollContents")
            local logControl = self:GetNamedChild("LogScrollContainerLogScrollPanelLogScrollContentsActionLog")
            logControl:SetText(table.concat(actions, "\n"))
            zo_callLater(function ()
                             local height = logControl:GetTextHeight()
                             logContainer:SetDimensions(520, height)
                             height = height - panel:GetHeight()
                             height = zo_max(0, height)
                             slider:SetMinMax(0, height)
                         end, 100)
        end
    end
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.DetailScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("DetailScrollSlider")
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 60))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.DetailScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("DetailScrollPanel"):SetVerticalScroll(value)
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.LogScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("LogScrollSlider")
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 60))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.LogScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("LogScrollPanel"):SetVerticalScroll(value)
end

-- Complete Dialog
---@param control MagicSorter_Complete
function MagicSorterDialogs.Complete_OnInitialized(control)
    control.backdropAnimation = ANIMATION_MANAGER:CreateTimelineFromVirtual("MagicSorter_TopLevelBackdropAnimation", control)
    if not control:IsHidden() then
        control.backdropAnimation:PlayFromStart()
    end
    control.Refresh = function (self)
        local report = MAGIC_SORTER:GetSortManager():GetLastReport()
        local slider = self:GetNamedChild("ScrollContainerScrollSlider")
        local panel = self:GetNamedChild("ScrollContainerScrollPanel")
        local container = self:GetNamedChild("ScrollContainerScrollPanelScrollContents")
        local controlItem = self:GetNamedChild("ScrollContainerScrollPanelScrollContentsMessage")
        local reportText = table.concat(report or {}, "\n")
        controlItem:SetText(reportText)
        zo_callLater(function ()
                         local height = controlItem:GetTextHeight()
                         container:SetDimensions(665, height)
                         height = zo_max(0, height - panel:GetHeight())
                         slider:SetMinMax(0, height)
                     end, 400)
    end
end

---@param control MagicSorter_Complete
---@param hidden boolean
function MagicSorterDialogs.Complete_OnEffectivelyShown(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:PlayFromStart()
    end
    control:Refresh()
end

---@param control MagicSorter_Complete
---@param hidden boolean
function MagicSorterDialogs.Complete_OnEffectivelyHidden(control, hidden)
    if control.backdropAnimation then
        control.backdropAnimation:Stop()
    end
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CompleteScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("ScrollSlider")
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 60))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.CompleteScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("ScrollPanel"):SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.CompleteCloseButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    EVENT_MANAGER:UnregisterForUpdate(MAGIC_SORTER.EventDescriptor .. "AutoReload")
    MAGIC_SORTER:SetDialogHidden("Complete", true)
    MAGIC_SORTER:GetData().showCompleteDialog = false
end

-- Report Summary Dialog
---@param control MagicSorter_ReportSummary
function MagicSorterDialogs.ReportSummary_OnInitialized(control)
    control.panel = control:GetNamedChild("ScrollContainerScrollPanel")
    control.slider = control:GetNamedChild("ScrollContainerScrollSlider")
    control.message = control.panel:GetNamedChild("ScrollContentsMessage")
    control.visibleHeight = 300
    control:SetDimensions(360, control.visibleHeight)
    control.hideShowButton = control:GetNamedChild("HideShowButton")
    control.hideShowButton.nextState = "hide"
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportSummaryScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("ScrollSlider")
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 60))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.ReportSummaryScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("ScrollPanel"):SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportSummaryHideShowButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    local window = control:GetOwningWindow()
    local scroll = window:GetNamedChild("ScrollContainer")
    local label = control:GetNamedChild("Label")
    local nextState = control.nextState or "hide"
    if nextState == "show" then
        control.nextState = "hide"
        label:SetText("Hide Report")
        scroll:SetHidden(false)
        window:SetHeight(window.visibleHeight)
    else
        control.nextState = "show"
        label:SetText("Show Report")
        scroll:SetHidden(true)
        window:SetHeight(0)
    end
end

-- Report Inventory Dialog
---@param control MagicSorter_ReportInventory
function MagicSorterDialogs.ReportInventory_OnInitialized(control)
    control.caption = control:GetNamedChild("Caption")
    control.panel = control:GetNamedChild("ScrollContainerScrollPanel")
    control.slider = control:GetNamedChild("ScrollContainerScrollSlider")
    control.contents = control.panel:GetNamedChild("ScrollContents")
    control.visibleHeight = 600
    control:SetDimensions(800, control.visibleHeight)
    control.rowControlPool = ZO_ControlPool:New("MagicSorter_DataRow", control.contents)
    control.ShowReport = function (self, caption, rows)
        local columns = { 180, 180, 180, 180 }
        self.caption:SetText(caption or "Report")
        self.rowControlPool:ReleaseAllObjects()
        if "table" == type(rows) then
            local predecessor
            for rowIndex, rowData in ipairs(rows) do
                local rowControl, key = self.rowControlPool:AcquireObject()
                rowControl.key = key
                rowControl:ClearAnchors()
                rowControl:SetupRow(nil, nil, columns)
                rowControl:UpdateColumns(rowData)
                if not predecessor then
                    rowControl:SetAnchor(TOPLEFT, self.contents, TOPLEFT)
                else
                    rowControl:SetAnchor(TOPLEFT, predecessor, BOTTOMLEFT)
                end
                rowControl:SetHidden(false)
                predecessor = rowControl
            end
        end
    end
end

---@param control ScrollControl
---@param delta number
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportInventoryScrollPanel_OnMouseWheel(control, delta, ctrl, alt, shift, command)
    local slider = control:GetParent():GetNamedChild("ScrollSlider")
    local value = slider:GetValue()
    if value == 0 then
        value = 1
    end
    slider:SetValue(value - (delta * 60))
end

---@param control SliderControl
---@param value number
---@param eventReason number
function MagicSorterDialogs.ReportInventoryScrollSlider_OnValueChanged(control, value, eventReason)
    control:GetParent():GetNamedChild("ScrollPanel"):SetVerticalScroll(value)
end

---@param control MagicSorter_Button
---@param button MouseButtonIndex
---@param ctrl boolean
---@param alt boolean
---@param shift boolean
---@param command boolean
function MagicSorterDialogs.ReportInventoryCloseButton_OnMouseDown(control, button, ctrl, alt, shift, command)
    MAGIC_SORTER:SetDialogHidden("ReportInventory", true)
end
